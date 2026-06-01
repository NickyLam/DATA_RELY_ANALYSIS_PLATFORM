/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_vtrd_set_instruction_cash
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_vtrd_set_instruction_cash_ex purge;
alter table ${iol_schema}.ibms_vtrd_set_instruction_cash add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ibms_vtrd_set_instruction_cash;

-- 2.3 insert data to ex table
create table ${iol_schema}.ibms_vtrd_set_instruction_cash_ex nologging
compress
as
select * from ${iol_schema}.ibms_vtrd_set_instruction_cash where 0=1;

insert /*+ append */ into ${iol_schema}.ibms_vtrd_set_instruction_cash_ex(
    cash_inst_id -- 
    ,inst_id -- 
    ,cash_inst_grp_id -- 
    ,biz_type -- 
    ,direction -- 
    ,cash_acct_id -- 
    ,ext_cash_acct_id -- 
    ,currency -- 
    ,amount -- 
    ,freeze_amount -- 
    ,set_date -- 
    ,set_finish_date -- 
    ,transfer_type -- 
    ,acct_code -- 
    ,acct_name -- 
    ,bank_code -- 
    ,bank_name -- 
    ,party_acct_code -- 
    ,party_acct_name -- 
    ,party_bank_code -- 
    ,party_bank_name -- 
    ,create_time -- 
    ,update_time -- 
    ,update_user -- 
    ,account_time -- 
    ,account_user -- 
    ,memo -- 
    ,blc_state -- 
    ,acctg_state -- 
    ,opr_state -- 
    ,cash_inst_setgrp_id -- 
    ,acctg_inst_id -- 
    ,cancel_flag -- 
    ,is_theory_blc -- 
    ,nostro_ref_cash_inst_id -- 
    ,pending_flow_no -- 
    ,pending_date -- 
    ,is_theory_acct -- 
    ,mid_bank_acct_code -- 
    ,mid_bank_name -- 
    ,mid_swift_code -- 
    ,swift_code -- 
    ,party_swift_code -- 
    ,party_mid_bank_acct_code -- 
    ,party_mid_bank_name -- 
    ,party_mid_swift_code -- 
    ,cl_status -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    cash_inst_id -- 
    ,inst_id -- 
    ,cash_inst_grp_id -- 
    ,biz_type -- 
    ,direction -- 
    ,cash_acct_id -- 
    ,ext_cash_acct_id -- 
    ,currency -- 
    ,amount -- 
    ,freeze_amount -- 
    ,set_date -- 
    ,set_finish_date -- 
    ,transfer_type -- 
    ,acct_code -- 
    ,acct_name -- 
    ,bank_code -- 
    ,bank_name -- 
    ,party_acct_code -- 
    ,party_acct_name -- 
    ,party_bank_code -- 
    ,party_bank_name -- 
    ,create_time -- 
    ,update_time -- 
    ,update_user -- 
    ,account_time -- 
    ,account_user -- 
    ,memo -- 
    ,blc_state -- 
    ,acctg_state -- 
    ,opr_state -- 
    ,cash_inst_setgrp_id -- 
    ,acctg_inst_id -- 
    ,cancel_flag -- 
    ,is_theory_blc -- 
    ,nostro_ref_cash_inst_id -- 
    ,pending_flow_no -- 
    ,pending_date -- 
    ,is_theory_acct -- 
    ,mid_bank_acct_code -- 
    ,mid_bank_name -- 
    ,mid_swift_code -- 
    ,swift_code -- 
    ,party_swift_code -- 
    ,party_mid_bank_acct_code -- 
    ,party_mid_bank_name -- 
    ,party_mid_swift_code -- 
    ,cl_status -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ibms_vtrd_set_instruction_cash
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ibms_vtrd_set_instruction_cash exchange partition p_${batch_date} with table ${iol_schema}.ibms_vtrd_set_instruction_cash_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_vtrd_set_instruction_cash to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ibms_vtrd_set_instruction_cash_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_vtrd_set_instruction_cash',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);