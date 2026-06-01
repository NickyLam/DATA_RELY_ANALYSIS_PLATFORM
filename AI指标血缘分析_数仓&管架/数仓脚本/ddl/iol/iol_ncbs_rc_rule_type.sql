/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rc_rule_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rc_rule_type
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rc_rule_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rc_rule_type(
    restraint_type varchar2(3) -- 限制类型
    ,term_type varchar2(1) -- 期限单位
    ,company varchar2(20) -- 法人
    ,deal_flow varchar2(1) -- 处理方式
    ,rule_desc varchar2(100) -- 规则描述
    ,rule_id varchar2(50) -- 检查规则编号
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_rc_rule_type to ${iml_schema};
grant select on ${iol_schema}.ncbs_rc_rule_type to ${icl_schema};
grant select on ${iol_schema}.ncbs_rc_rule_type to ${idl_schema};
grant select on ${iol_schema}.ncbs_rc_rule_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rc_rule_type is '黑灰名单限制规则参数表';
comment on column ${iol_schema}.ncbs_rc_rule_type.restraint_type is '限制类型';
comment on column ${iol_schema}.ncbs_rc_rule_type.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_rc_rule_type.company is '法人';
comment on column ${iol_schema}.ncbs_rc_rule_type.deal_flow is '处理方式';
comment on column ${iol_schema}.ncbs_rc_rule_type.rule_desc is '规则描述';
comment on column ${iol_schema}.ncbs_rc_rule_type.rule_id is '检查规则编号';
comment on column ${iol_schema}.ncbs_rc_rule_type.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rc_rule_type.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rc_rule_type.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rc_rule_type.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rc_rule_type.etl_timestamp is 'ETL处理时间戳';
