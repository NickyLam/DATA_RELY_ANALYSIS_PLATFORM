/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbacccfm
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
drop table ${iol_schema}.ifms_tbacccfm_ex purge;
alter table ${iol_schema}.ifms_tbacccfm add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ifms_tbacccfm truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ifms_tbacccfm_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbacccfm where 0=1;

insert /*+ append */ into ${iol_schema}.ifms_tbacccfm_ex(
    ta_code -- 
    ,cfm_date -- 
    ,cfm_no -- 
    ,from_flag -- 
    ,trans_date -- 
    ,trans_time -- 
    ,serial_no -- 
    ,trans_code -- 
    ,busin_code -- 
    ,branch_no -- 
    ,open_branch -- 
    ,channel -- 
    ,term_no -- 
    ,oper_no -- 
    ,in_client_no -- 
    ,client_type -- 
    ,asset_acc -- 
    ,bank_no -- 
    ,client_no -- 
    ,bank_acc -- 
    ,ta_client -- 
    ,trans_account_type -- 
    ,trans_account -- 
    ,sex -- 
    ,id_type -- 
    ,id_code -- 
    ,client_name -- 
    ,short_name -- 
    ,birthday -- 
    ,address -- 
    ,post_code -- 
    ,mobile -- 
    ,tel -- 
    ,fax -- 
    ,email -- 
    ,send_freq -- 
    ,send_mode -- 
    ,asso_date -- 
    ,frozen_cause -- 
    ,acc_card_no -- 
    ,summary -- 
    ,asso_serial -- 
    ,client_manager -- 
    ,err_code -- 
    ,err_msg -- 
    ,status -- 
    ,reserve1 -- 
    ,reserve2 -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    ta_code -- 
    ,cfm_date -- 
    ,cfm_no -- 
    ,from_flag -- 
    ,trans_date -- 
    ,trans_time -- 
    ,serial_no -- 
    ,trans_code -- 
    ,busin_code -- 
    ,branch_no -- 
    ,open_branch -- 
    ,channel -- 
    ,term_no -- 
    ,oper_no -- 
    ,in_client_no -- 
    ,client_type -- 
    ,asset_acc -- 
    ,bank_no -- 
    ,client_no -- 
    ,bank_acc -- 
    ,ta_client -- 
    ,trans_account_type -- 
    ,trans_account -- 
    ,sex -- 
    ,id_type -- 
    ,id_code -- 
    ,client_name -- 
    ,short_name -- 
    ,birthday -- 
    ,address -- 
    ,post_code -- 
    ,mobile -- 
    ,tel -- 
    ,fax -- 
    ,email -- 
    ,send_freq -- 
    ,send_mode -- 
    ,asso_date -- 
    ,frozen_cause -- 
    ,acc_card_no -- 
    ,summary -- 
    ,asso_serial -- 
    ,client_manager -- 
    ,err_code -- 
    ,err_msg -- 
    ,status -- 
    ,reserve1 -- 
    ,reserve2 -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ifms_tbacccfm
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ifms_tbacccfm exchange partition p_${batch_date} with table ${iol_schema}.ifms_tbacccfm_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbacccfm to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ifms_tbacccfm_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbacccfm',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);