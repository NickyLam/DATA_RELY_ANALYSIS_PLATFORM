/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_rule_configuration
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_rule_configuration
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_rule_configuration purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_rule_configuration(
    rc_id varchar2(30) -- 规则ID
    ,rule_type varchar2(30) -- 规则类型
    ,level_type varchar2(30) -- 级别类型
    ,last_updated_stamp timestamp -- 最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事务时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事务时间
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.eifs_rule_configuration to ${iml_schema};
grant select on ${iol_schema}.eifs_rule_configuration to ${icl_schema};
grant select on ${iol_schema}.eifs_rule_configuration to ${idl_schema};
grant select on ${iol_schema}.eifs_rule_configuration to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_rule_configuration is '客户评级信息表';
comment on column ${iol_schema}.eifs_rule_configuration.rc_id is '规则ID';
comment on column ${iol_schema}.eifs_rule_configuration.rule_type is '规则类型';
comment on column ${iol_schema}.eifs_rule_configuration.level_type is '级别类型';
comment on column ${iol_schema}.eifs_rule_configuration.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.eifs_rule_configuration.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.eifs_rule_configuration.created_stamp is '创建时间';
comment on column ${iol_schema}.eifs_rule_configuration.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.eifs_rule_configuration.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_rule_configuration.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_rule_configuration.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_rule_configuration.etl_timestamp is 'ETL处理时间戳';
