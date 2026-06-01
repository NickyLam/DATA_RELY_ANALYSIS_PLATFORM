/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_vtrd_set_instruction
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
drop table ${iol_schema}.ibms_vtrd_set_instruction_ex purge;
alter table ${iol_schema}.ibms_vtrd_set_instruction add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ibms_vtrd_set_instruction;

-- 2.3 insert data to ex table
create table ${iol_schema}.ibms_vtrd_set_instruction_ex nologging
compress
as
select * from ${iol_schema}.ibms_vtrd_set_instruction where 0=1;

insert /*+ append */ into ${iol_schema}.ibms_vtrd_set_instruction_ex(
    inst_id -- 
    ,trade_id -- 
    ,inst_type -- 
    ,inst_grp_id -- 
    ,trd_type -- 
    ,set_type -- 
    ,theory_set_date -- 
    ,real_set_date -- 
    ,h_m_type -- 
    ,h_a_type -- 
    ,h_i_code -- 
    ,party_id -- 
    ,party_name -- 
    ,order_id -- 
    ,is_theory_payment -- 
    ,bj_market -- 
    ,bj_state -- 
    ,ext_ord_id -- 
    ,exe_market -- 
    ,create_time -- 
    ,update_time -- 
    ,update_user -- 
    ,account_time -- 
    ,account_user -- 
    ,memo -- 
    ,update_user_id -- 
    ,cal_date -- 
    ,ref_cash_inst_id -- 
    ,ref_secu_inst_id -- 
    ,inst_setgrp_id -- 
    ,state -- 
    ,operator_id -- 
    ,operator_name -- 
    ,print_times -- 
    ,due_order -- 
    ,due_obj_key -- 
    ,generate_type -- 
    ,ref_inst_id -- 
    ,is_real_acctg -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    inst_id -- 
    ,trade_id -- 
    ,inst_type -- 
    ,inst_grp_id -- 
    ,trd_type -- 
    ,set_type -- 
    ,theory_set_date -- 
    ,real_set_date -- 
    ,h_m_type -- 
    ,h_a_type -- 
    ,h_i_code -- 
    ,party_id -- 
    ,party_name -- 
    ,order_id -- 
    ,is_theory_payment -- 
    ,bj_market -- 
    ,bj_state -- 
    ,ext_ord_id -- 
    ,exe_market -- 
    ,create_time -- 
    ,update_time -- 
    ,update_user -- 
    ,account_time -- 
    ,account_user -- 
    ,memo -- 
    ,update_user_id -- 
    ,cal_date -- 
    ,ref_cash_inst_id -- 
    ,ref_secu_inst_id -- 
    ,inst_setgrp_id -- 
    ,state -- 
    ,operator_id -- 
    ,operator_name -- 
    ,print_times -- 
    ,due_order -- 
    ,due_obj_key -- 
    ,generate_type -- 
    ,ref_inst_id -- 
    ,is_real_acctg -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ibms_vtrd_set_instruction
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ibms_vtrd_set_instruction exchange partition p_${batch_date} with table ${iol_schema}.ibms_vtrd_set_instruction_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_vtrd_set_instruction to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ibms_vtrd_set_instruction_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_vtrd_set_instruction',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);