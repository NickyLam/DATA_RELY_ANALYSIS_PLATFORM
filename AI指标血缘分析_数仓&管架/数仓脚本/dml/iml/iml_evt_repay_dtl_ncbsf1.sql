/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_repay_dtl_ncbsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_repay_dtl_ncbsf1_tm purge;
alter table ${iml_schema}.evt_repay_dtl add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_repay_dtl modify partition p_ncbsf1
    add subpartition p_ncbsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_repay_dtl_ncbsf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,callbk_id -- 回收编号
    ,advise_odd_no -- 通知单号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,curr_pd -- 当前期次
    ,amt_type_cd -- 金额类型代码
    ,callbk_curr_cd -- 回收币种代码
    ,callbk_to_cny_exch_rat -- 回收对人民币汇率
    ,callbk_exch_way_cd -- 回收汇兑方式代码
    ,callbk_pric -- 回收金额
    ,open_acct_org_id -- 开户机构编号
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_repay_dtl
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- ncbs_cl_receipt_detail-1
insert into ${iml_schema}.evt_repay_dtl_ncbsf1_tm(
    evt_id -- 事件编号
    ,callbk_id -- 回收编号
    ,advise_odd_no -- 通知单号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,curr_pd -- 当前期次
    ,amt_type_cd -- 金额类型代码
    ,callbk_curr_cd -- 回收币种代码
    ,callbk_to_cny_exch_rat -- 回收对人民币汇率
    ,callbk_exch_way_cd -- 回收汇兑方式代码
    ,callbk_pric -- 回收金额
    ,open_acct_org_id -- 开户机构编号
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101070'||RECEIPT_NO -- 事件编号
    ,P1.RECEIPT_NO -- 回收编号
    ,P1.INVOICE_TRAN_NO -- 通知单号
    ,'9999' -- 法人编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.CLIENT_NO -- 客户账号
    ,P1.STAGE_NO -- 当前期次
    ,nvl(trim(P1.AMT_TYPE),'-')  -- 金额类型代码
    ,nvl(trim(P1.REC_CCY),'-') -- 回收币种代码
    ,P1.REC_XRATE -- 回收对人民币汇率
    ,nvl(trim(P1.REC_XRATE_ID),'-') -- 回收汇兑方式代码
    ,P1.REC_AMT -- 回收金额
    ,P1.ACCT_BRANCH -- 开户机构编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_receipt_detail' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_receipt_detail p1
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_repay_dtl truncate partition p_ncbsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_repay_dtl exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.evt_repay_dtl_ncbsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_repay_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_repay_dtl_ncbsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_repay_dtl', partname => 'p_ncbsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);