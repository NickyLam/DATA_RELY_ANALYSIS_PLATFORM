/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbgoldreq
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
drop table ${iol_schema}.ifms_tbgoldreq_ex purge;
alter table ${iol_schema}.ifms_tbgoldreq add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ifms_tbgoldreq truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ifms_tbgoldreq_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbgoldreq where 0=1;

insert /*+ append */ into ${iol_schema}.ifms_tbgoldreq_ex(
    serial_no -- 
    ,ex_serial -- 
    ,bank_no -- 
    ,term_no -- 
    ,oper_no -- 
    ,auth_oper -- 
    ,branch_no -- 
    ,channel -- 
    ,gold_date -- 
    ,trans_date -- 
    ,trans_time -- 
    ,client_manager -- 
    ,trans_type -- 
    ,asso_serial -- 
    ,trans_code -- 
    ,gold_client_no -- 
    ,area_code -- 
    ,center_code -- 
    ,transfer_type -- 
    ,client_name -- 
    ,id_type -- 
    ,id_code -- 
    ,in_client_no -- 
    ,client_no -- 
    ,client_type -- 
    ,bank_acc -- 
    ,liqu_status -- 
    ,curr_type -- 
    ,cash_flag -- 
    ,check_date -- 
    ,amt -- 
    ,gold_account -- 
    ,targ_bank_acc -- 
    ,host_trans_code -- 
    ,to_host_serial -- 
    ,host_date -- 
    ,host_serial -- 
    ,host_err_code -- 
    ,host_err_msg -- 
    ,err_code -- 
    ,err_msg -- 
    ,status -- 
    ,amt1 -- 
    ,reserve1 -- 
    ,reserve2 -- 
    ,reserve3 -- 
    ,reserve4 -- 
    ,reserve5 -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    serial_no -- 
    ,ex_serial -- 
    ,bank_no -- 
    ,term_no -- 
    ,oper_no -- 
    ,auth_oper -- 
    ,branch_no -- 
    ,channel -- 
    ,gold_date -- 
    ,trans_date -- 
    ,trans_time -- 
    ,client_manager -- 
    ,trans_type -- 
    ,asso_serial -- 
    ,trans_code -- 
    ,gold_client_no -- 
    ,area_code -- 
    ,center_code -- 
    ,transfer_type -- 
    ,client_name -- 
    ,id_type -- 
    ,id_code -- 
    ,in_client_no -- 
    ,client_no -- 
    ,client_type -- 
    ,bank_acc -- 
    ,liqu_status -- 
    ,curr_type -- 
    ,cash_flag -- 
    ,check_date -- 
    ,amt -- 
    ,gold_account -- 
    ,targ_bank_acc -- 
    ,host_trans_code -- 
    ,to_host_serial -- 
    ,host_date -- 
    ,host_serial -- 
    ,host_err_code -- 
    ,host_err_msg -- 
    ,err_code -- 
    ,err_msg -- 
    ,status -- 
    ,amt1 -- 
    ,reserve1 -- 
    ,reserve2 -- 
    ,reserve3 -- 
    ,reserve4 -- 
    ,reserve5 -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ifms_tbgoldreq
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ifms_tbgoldreq exchange partition p_${batch_date} with table ${iol_schema}.ifms_tbgoldreq_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbgoldreq to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ifms_tbgoldreq_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbgoldreq',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);