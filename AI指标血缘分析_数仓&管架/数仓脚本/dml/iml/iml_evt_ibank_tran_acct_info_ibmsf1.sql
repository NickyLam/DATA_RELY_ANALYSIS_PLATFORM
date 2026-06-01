/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ibank_tran_acct_info_ibmsf1
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
drop table ${iml_schema}.evt_ibank_tran_acct_info_ibmsf1_tm purge;
alter table ${iml_schema}.evt_ibank_tran_acct_info add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_ibank_tran_acct_info modify partition p_ibmsf1
    add subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ibank_tran_acct_info_ibmsf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,apv_odd_no -- 审批单号
    ,cust_acct_id -- 客户账户编号
    ,cust_acct_sub_acct_id -- 客户账户子户号
    ,cust_id -- 客户编号
    ,sav_type_cd -- 储种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ibank_tran_acct_info
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- ibms_vtrd_core_sub_acct-1
insert into ${iml_schema}.evt_ibank_tran_acct_info_ibmsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,apv_odd_no -- 审批单号
    ,cust_acct_id -- 客户账户编号
    ,cust_acct_sub_acct_id -- 客户账户子户号
    ,cust_id -- 客户编号
    ,sav_type_cd -- 储种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '105009'||P1.ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.ORDER_ID -- 审批单号
    ,P1.ACCT -- 客户账户编号
    ,P1.SUB_ACCT -- 客户账户子户号
    ,P1.CUSTOMER_NO -- 客户编号
    ,P1.BUSINESS_TYPE -- 储种代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_vtrd_core_sub_acct' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_vtrd_core_sub_acct p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_ibank_tran_acct_info truncate partition p_ibmsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_ibank_tran_acct_info exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.evt_ibank_tran_acct_info_ibmsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ibank_tran_acct_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_ibank_tran_acct_info_ibmsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ibank_tran_acct_info', partname => 'p_ibmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);