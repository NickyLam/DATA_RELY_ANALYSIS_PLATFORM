/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_doc_paid_dtl_ncbsi1
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
drop table ${iml_schema}.evt_doc_paid_dtl_ncbsi1_tm purge;
alter table ${iml_schema}.evt_doc_paid_dtl add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_doc_paid_dtl modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_doc_paid_dtl_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,aldy_paid_dtl_seq_num -- 已还明细序号
    ,tran_dt -- 交易日期
    ,rpbl_dtl_seq_num -- 应还明细序号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,advise_odd_no -- 通知单号
    ,amt_type_cd -- 金额类型代码
    ,tran_cd -- 交易码
    ,stl_acct_flg -- 结算账户标识符
    ,stl_cust_acct_num -- 结算客户账号
    ,stl_acct_prod_id -- 结算账户产品编号
    ,stl_acct_curr_cd -- 结算账户币种代码
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,aldy_paid_amt -- 已还金额
    ,callbk_num -- 回收号
    ,tran_ref_no -- 交易参考号
    ,revs_flg -- 冲正标志
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_doc_paid_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_cl_invoice_repay_detail-1
insert into ${iml_schema}.evt_doc_paid_dtl_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,aldy_paid_dtl_seq_num -- 已还明细序号
    ,tran_dt -- 交易日期
    ,rpbl_dtl_seq_num -- 应还明细序号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,advise_odd_no -- 通知单号
    ,amt_type_cd -- 金额类型代码
    ,tran_cd -- 交易码
    ,stl_acct_flg -- 结算账户标识符
    ,stl_cust_acct_num -- 结算客户账号
    ,stl_acct_prod_id -- 结算账户产品编号
    ,stl_acct_curr_cd -- 结算账户币种代码
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,aldy_paid_amt -- 已还金额
    ,callbk_num -- 回收号
    ,tran_ref_no -- 交易参考号
    ,revs_flg -- 冲正标志
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101027'||P1.REPAY_SEQ_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.REPAY_SEQ_NO -- 已还明细序号
    ,P1.TRAN_DATE -- 交易日期
    ,P1.PAY_FROM_SEQ_NO -- 应还明细序号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.INVOICE_TRAN_NO -- 通知单号
    ,P1.AMT_TYPE -- 金额类型代码
    ,P1.TRAN_TYPE -- 交易码
    ,P1.SETTLE_ACCT_INTERNAL_KEY -- 结算账户标识符
    ,P1.SETTLE_BASE_ACCT_NO -- 结算客户账号
    ,P1.SETTLE_PROD_TYPE -- 结算账户产品编号
    ,P1.SETTLE_ACCT_CCY -- 结算账户币种代码
    ,P1.SETTLE_ACCT_SEQ_NO -- 结算账户子账号
    ,P1.PAID_AMT -- 已还金额
    ,P1.RECEIPT_NO -- 回收号
    ,P1.REFERENCE -- 交易参考号
    ,DECODE(P1.REVERSAL,'Y','1','N','0') -- 冲正标志
    ,P1.USER_ID -- 交易柜员编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_invoice_repay_detail' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_invoice_repay_detail p1
where  1 = 1 
    and P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_doc_paid_dtl truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_doc_paid_dtl exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_doc_paid_dtl_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_doc_paid_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_doc_paid_dtl_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_doc_paid_dtl', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);