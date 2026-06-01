/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rtis_risk_list_detail
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
drop table ${iol_schema}.rtis_risk_list_detail_ex purge;
alter table ${iol_schema}.rtis_risk_list_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rtis_risk_list_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rtis_risk_list_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rtis_risk_list_detail where 0=1;

insert /*+ append */ into ${iol_schema}.rtis_risk_list_detail_ex(
    detail_id -- 内部ID
    ,list_id -- 风险档案号，外键关联（预警号）
    ,rule_name -- 触发规则名称
    ,rule_package_name -- 规则描述(规则包)
    ,score -- 分值
    ,risk_type -- 风险类型
    ,remark -- 备注
    ,rule_id -- 规则ID
    ,rule_code -- 规则代码
    ,create_at -- 创建时间
    ,update_at -- 更新时间
    ,risk_list_status -- 预警状态
    ,rule_level -- 规则风险等级
    ,rule_type -- 触发风险类型
    ,rule_seq -- 规则顺序
    ,rule_status -- 规则状态,试运行或其他
    ,policy_names -- 规则配置的策略
    ,org -- 所属机构
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    detail_id -- 内部ID
    ,list_id -- 风险档案号，外键关联（预警号）
    ,rule_name -- 触发规则名称
    ,rule_package_name -- 规则描述(规则包)
    ,score -- 分值
    ,risk_type -- 风险类型
    ,remark -- 备注
    ,rule_id -- 规则ID
    ,rule_code -- 规则代码
    ,create_at -- 创建时间
    ,update_at -- 更新时间
    ,risk_list_status -- 预警状态
    ,rule_level -- 规则风险等级
    ,rule_type -- 触发风险类型
    ,rule_seq -- 规则顺序
    ,rule_status -- 规则状态,试运行或其他
    ,policy_names -- 规则配置的策略
    ,org -- 所属机构
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rtis_risk_list_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rtis_risk_list_detail exchange partition p_${batch_date} with table ${iol_schema}.rtis_risk_list_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rtis_risk_list_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rtis_risk_list_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rtis_risk_list_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);