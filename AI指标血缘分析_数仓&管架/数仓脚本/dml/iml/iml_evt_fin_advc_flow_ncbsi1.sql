/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_fin_advc_flow_ncbsi1
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
drop table ${iml_schema}.evt_fin_advc_flow_ncbsi1_tm purge;
alter table ${iml_schema}.evt_fin_advc_flow add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_fin_advc_flow modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_fin_advc_flow_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,ova_flow_num -- 全局流水号
    ,tran_ref_no -- 交易参考号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,acct_sub_acct_num -- 账户子账号
    ,acct_name -- 账户名称
    ,tran_dt -- 交易日期
    ,advc_org_id -- 垫款机构编号
    ,tran_org_id -- 交易机构编号
    ,tran_cd -- 交易码
    ,tran_amt -- 交易金额
    ,evt_cate_id -- 事件类别编号
    ,advc_type_cd -- 垫款类型代码
    ,advc_descb -- 垫款描述
    ,cntpty_acct_prod_id -- 对手账户产品编号
    ,cntpty_cust_acct_num -- 对手客户账号
    ,cntpty_acct_curr -- 对手账户币种代码
    ,cntpty_acct_sub_acct_num -- 对手账户子账号
    ,check_entry_code -- 对账编码
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_fin_advc_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_rb_fin_paid_tran_hist-1
insert into ${iml_schema}.evt_fin_advc_flow_ncbsi1_tm(
    evt_id -- 事件编号
    ,ova_flow_num -- 全局流水号
    ,tran_ref_no -- 交易参考号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,acct_sub_acct_num -- 账户子账号
    ,acct_name -- 账户名称
    ,tran_dt -- 交易日期
    ,advc_org_id -- 垫款机构编号
    ,tran_org_id -- 交易机构编号
    ,tran_cd -- 交易码
    ,tran_amt -- 交易金额
    ,evt_cate_id -- 事件类别编号
    ,advc_type_cd -- 垫款类型代码
    ,advc_descb -- 垫款描述
    ,cntpty_acct_prod_id -- 对手账户产品编号
    ,cntpty_cust_acct_num -- 对手客户账号
    ,cntpty_acct_curr -- 对手账户币种代码
    ,cntpty_acct_sub_acct_num -- 对手账户子账号
    ,check_entry_code -- 对账编码
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101054'||P1.CHANNEL_SEQ_NO -- 事件编号
    ,P1.CHANNEL_SEQ_NO -- 全局流水号
    ,P1.REFERENCE -- 交易参考号
    ,'9999' -- 法人编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.BASE_ACCT_NO -- 客户账号
    ,P1.PROD_TYPE -- 账户产品编号
    ,P1.CCY -- 账户币种代码
    ,P1.ACCT_SEQ_NO -- 账户子账号
    ,P1.ACCT_NAME -- 账户名称
    ,P1.TRAN_DATE -- 交易日期
    ,P1.PAID_BRANCH -- 垫款机构编号
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.TRAN_TYPE -- 交易码
    ,P1.TRAN_AMT -- 交易金额
    ,P1.EVENT_TYPE -- 事件类别编号
    ,P1.PAID_TYPE -- 垫款类型代码
    ,P1.PAID_TYPE_DESC -- 垫款描述
    ,P1.OTH_PROD_TYPE -- 对手账户产品编号
    ,P1.OTH_BASE_ACCT_NO -- 对手客户账号
    ,NVL(TRIM(P1.OTH_CCY),0) -- 对手账户币种代码
    ,P1.OTH_ACCT_SEQ_NO -- 对手账户子账号
    ,P1.ACCOUNT_CODE -- 对账编码
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.USER_ID -- 交易柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_fin_paid_tran_hist' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_fin_paid_tran_hist p1
where  1 = 1 
    and P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_fin_advc_flow truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_fin_advc_flow exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_fin_advc_flow_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_fin_advc_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_fin_advc_flow_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_fin_advc_flow', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);