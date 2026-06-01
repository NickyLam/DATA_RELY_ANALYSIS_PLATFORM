/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_itsm_aim_bpm_flow_register
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
drop table ${iol_schema}.itsm_aim_bpm_flow_register_ex purge;
alter table ${iol_schema}.itsm_aim_bpm_flow_register add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.itsm_aim_bpm_flow_register;

-- 2.3 insert data to ex table
create table ${iol_schema}.itsm_aim_bpm_flow_register_ex nologging
compress
as
select * from ${iol_schema}.itsm_aim_bpm_flow_register where 0=1;

insert /*+ append */ into ${iol_schema}.itsm_aim_bpm_flow_register_ex(
    business_key -- 业务主键
    ,topicname -- 流程主题
    ,username -- 发起人
    ,nickname -- 发起人中文名称
    ,department -- 发起人部门
    ,create_time -- 创建时间
    ,update_time -- 最后修改日期
    ,status -- 状态
    ,category_id -- 模板分类ID
    ,category_name -- 模板分类名称
    ,model_id -- 流程模板ID
    ,model_key -- 流程模板KEY
    ,model_name -- 流程模板中文名称
    ,flowtype -- 流程类型
    ,procdef_id -- 模板部署ID
    ,parent_key -- 父级ID
    ,unique_key -- 外键
    ,source_system -- 流程来源系统
    ,priority -- 优先级
    ,flowsafe -- 是否安全事件
    ,serial_str -- 自定义规则的流水字符串
    ,serial_number -- 自定义规则的流水号
    ,is_delete -- 是否删除
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    business_key -- 业务主键
    ,topicname -- 流程主题
    ,username -- 发起人
    ,nickname -- 发起人中文名称
    ,department -- 发起人部门
    ,create_time -- 创建时间
    ,update_time -- 最后修改日期
    ,status -- 状态
    ,category_id -- 模板分类ID
    ,category_name -- 模板分类名称
    ,model_id -- 流程模板ID
    ,model_key -- 流程模板KEY
    ,model_name -- 流程模板中文名称
    ,flowtype -- 流程类型
    ,procdef_id -- 模板部署ID
    ,parent_key -- 父级ID
    ,unique_key -- 外键
    ,source_system -- 流程来源系统
    ,priority -- 优先级
    ,flowsafe -- 是否安全事件
    ,serial_str -- 自定义规则的流水字符串
    ,serial_number -- 自定义规则的流水号
    ,is_delete -- 是否删除
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.itsm_aim_bpm_flow_register
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.itsm_aim_bpm_flow_register exchange partition p_${batch_date} with table ${iol_schema}.itsm_aim_bpm_flow_register_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.itsm_aim_bpm_flow_register to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.itsm_aim_bpm_flow_register_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'itsm_aim_bpm_flow_register',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);