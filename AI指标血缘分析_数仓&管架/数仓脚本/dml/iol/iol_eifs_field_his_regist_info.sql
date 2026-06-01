/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_field_his_regist_info
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
drop table ${iol_schema}.eifs_field_his_regist_info_ex purge;
alter table ${iol_schema}.eifs_field_his_regist_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.eifs_field_his_regist_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.eifs_field_his_regist_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_field_his_regist_info where 0=1;

insert /*+ append */ into ${iol_schema}.eifs_field_his_regist_info_ex(
    modify_his_id -- 修改历史序列号
    ,party_id -- 参与人ID
    ,cust_num -- 客户号
    ,cust_name -- 客户名称
    ,srv_seq_num -- 全局流水号
    ,glob_seq_num -- 业务流水号
    ,modify_time -- 更新时间
    ,create_te -- 创建柜员
    ,create_org -- 创建机构号
    ,init_system_id -- 创建渠道
    ,init_created_ts -- 源系统创建时间
    ,created_ts -- 进入ECIF的时间
    ,updated_ts -- 在ECIF中失效的时间
    ,last_updated_te -- 最新更新柜员
    ,last_updated_org -- 最新更新机构号
    ,last_system_id -- 最新更新渠道
    ,last_updated_ts -- 最新更新时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    modify_his_id -- 修改历史序列号
    ,party_id -- 参与人ID
    ,cust_num -- 客户号
    ,cust_name -- 客户名称
    ,srv_seq_num -- 全局流水号
    ,glob_seq_num -- 业务流水号
    ,modify_time -- 更新时间
    ,create_te -- 创建柜员
    ,create_org -- 创建机构号
    ,init_system_id -- 创建渠道
    ,init_created_ts -- 源系统创建时间
    ,created_ts -- 进入ECIF的时间
    ,updated_ts -- 在ECIF中失效的时间
    ,last_updated_te -- 最新更新柜员
    ,last_updated_org -- 最新更新机构号
    ,last_system_id -- 最新更新渠道
    ,last_updated_ts -- 最新更新时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.eifs_field_his_regist_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.eifs_field_his_regist_info exchange partition p_${batch_date} with table ${iol_schema}.eifs_field_his_regist_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.eifs_field_his_regist_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.eifs_field_his_regist_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'eifs_field_his_regist_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);