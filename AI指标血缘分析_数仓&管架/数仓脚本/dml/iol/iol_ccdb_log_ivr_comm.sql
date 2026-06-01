/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ccdb_log_ivr_comm
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
drop table ${iol_schema}.ccdb_log_ivr_comm_ex purge;
alter table ${iol_schema}.ccdb_log_ivr_comm add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ccdb_log_ivr_comm truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ccdb_log_ivr_comm_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ccdb_log_ivr_comm where 0=1;

insert /*+ append */ into ${iol_schema}.ccdb_log_ivr_comm_ex(
    id -- 
    ,ivrchan_no -- 
    ,cti_connection_id -- 
    ,receive_no -- 
    ,trunk_id -- 
    ,call_time -- 
    ,holder_type -- 
    ,holder_no -- 
    ,paper_id -- 
    ,paper_type -- 
    ,menu_no -- 
    ,update_date -- 
    ,status -- 
    ,version -- 
    ,menu_no_cn -- 
    ,call_in_time -- 
    ,cust_name -- 
    ,is_to_agent -- 0挂机  1转人工
    ,skill_group -- 技能组编码
    ,skill_group_name -- 技能组
    ,language -- cn中文,en英文
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 
    ,ivrchan_no -- 
    ,cti_connection_id -- 
    ,receive_no -- 
    ,trunk_id -- 
    ,call_time -- 
    ,holder_type -- 
    ,holder_no -- 
    ,paper_id -- 
    ,paper_type -- 
    ,menu_no -- 
    ,update_date -- 
    ,status -- 
    ,version -- 
    ,menu_no_cn -- 
    ,call_in_time -- 
    ,cust_name -- 
    ,is_to_agent -- 0挂机  1转人工
    ,skill_group -- 技能组编码
    ,skill_group_name -- 技能组
    ,language -- cn中文,en英文
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ccdb_log_ivr_comm
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ccdb_log_ivr_comm exchange partition p_${batch_date} with table ${iol_schema}.ccdb_log_ivr_comm_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ccdb_log_ivr_comm to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ccdb_log_ivr_comm_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ccdb_log_ivr_comm',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);