/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_heps_hep_house_detail
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
drop table ${iol_schema}.heps_hep_house_detail_ex purge;
alter table ${iol_schema}.heps_hep_house_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.heps_hep_house_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.heps_hep_house_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.heps_hep_house_detail where 0=1;

insert /*+ append */ into ${iol_schema}.heps_hep_house_detail_ex(
    id -- id
    ,flow_id -- 业务流水号
    ,status -- 状态
    ,question_id -- 问题id序号
    ,question -- 问题
    ,answer -- 答案
    ,customer_manager_id -- 客户经理号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- id
    ,flow_id -- 业务流水号
    ,status -- 状态
    ,question_id -- 问题id序号
    ,question -- 问题
    ,answer -- 答案
    ,customer_manager_id -- 客户经理号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.heps_hep_house_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.heps_hep_house_detail exchange partition p_${batch_date} with table ${iol_schema}.heps_hep_house_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.heps_hep_house_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.heps_hep_house_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'heps_hep_house_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);