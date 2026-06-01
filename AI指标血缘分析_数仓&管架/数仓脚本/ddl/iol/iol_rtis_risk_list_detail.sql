/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rtis_risk_list_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rtis_risk_list_detail
whenever sqlerror continue none;
drop table ${iol_schema}.rtis_risk_list_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rtis_risk_list_detail(
    detail_id number(20) -- 内部ID
    ,list_id number(20) -- 风险档案号，外键关联（预警号）
    ,rule_name varchar2(4000) -- 触发规则名称
    ,rule_package_name varchar2(255) -- 规则描述(规则包)
    ,score number(10) -- 分值
    ,risk_type varchar2(255) -- 风险类型
    ,remark varchar2(255) -- 备注
    ,rule_id varchar2(255) -- 规则ID
    ,rule_code varchar2(255) -- 规则代码
    ,create_at timestamp -- 创建时间
    ,update_at timestamp -- 更新时间
    ,risk_list_status number(8) -- 预警状态
    ,rule_level number(8) -- 规则风险等级
    ,rule_type varchar2(20) -- 触发风险类型
    ,rule_seq varchar2(64) -- 规则顺序
    ,rule_status number(8) -- 规则状态,试运行或其他
    ,policy_names varchar2(512) -- 规则配置的策略
    ,org varchar2(20) -- 所属机构
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rtis_risk_list_detail to ${iml_schema};
grant select on ${iol_schema}.rtis_risk_list_detail to ${icl_schema};
grant select on ${iol_schema}.rtis_risk_list_detail to ${idl_schema};
grant select on ${iol_schema}.rtis_risk_list_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.rtis_risk_list_detail is '交易触发规则明细';
comment on column ${iol_schema}.rtis_risk_list_detail.detail_id is '内部ID';
comment on column ${iol_schema}.rtis_risk_list_detail.list_id is '风险档案号，外键关联（预警号）';
comment on column ${iol_schema}.rtis_risk_list_detail.rule_name is '触发规则名称';
comment on column ${iol_schema}.rtis_risk_list_detail.rule_package_name is '规则描述(规则包)';
comment on column ${iol_schema}.rtis_risk_list_detail.score is '分值';
comment on column ${iol_schema}.rtis_risk_list_detail.risk_type is '风险类型';
comment on column ${iol_schema}.rtis_risk_list_detail.remark is '备注';
comment on column ${iol_schema}.rtis_risk_list_detail.rule_id is '规则ID';
comment on column ${iol_schema}.rtis_risk_list_detail.rule_code is '规则代码';
comment on column ${iol_schema}.rtis_risk_list_detail.create_at is '创建时间';
comment on column ${iol_schema}.rtis_risk_list_detail.update_at is '更新时间';
comment on column ${iol_schema}.rtis_risk_list_detail.risk_list_status is '预警状态';
comment on column ${iol_schema}.rtis_risk_list_detail.rule_level is '规则风险等级';
comment on column ${iol_schema}.rtis_risk_list_detail.rule_type is '触发风险类型';
comment on column ${iol_schema}.rtis_risk_list_detail.rule_seq is '规则顺序';
comment on column ${iol_schema}.rtis_risk_list_detail.rule_status is '规则状态,试运行或其他';
comment on column ${iol_schema}.rtis_risk_list_detail.policy_names is '规则配置的策略';
comment on column ${iol_schema}.rtis_risk_list_detail.org is '所属机构';
comment on column ${iol_schema}.rtis_risk_list_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rtis_risk_list_detail.etl_timestamp is 'ETL处理时间戳';
