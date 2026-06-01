/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_ca_risk_record_item
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_ca_risk_record_item
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_ca_risk_record_item purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_ca_risk_record_item(
    id varchar2(75) -- 主键ID
    ,risk_record_id varchar2(75) -- 关联风评记录主键ID
    ,paper_id varchar2(75) -- 关联问卷主键
    ,question_id varchar2(75) -- 关联问题主键
    ,paper_no varchar2(15) -- 问卷编号
    ,version varchar2(75) -- 问卷版本号
    ,question_no varchar2(75) -- 问题编号
    ,question_type varchar2(3) -- 问题类型
    ,risk_option varchar2(30) -- 选择项
    ,question varchar2(4000) -- 题目内容
    ,subject varchar2(4000) -- 选择项内容
    ,score number(18,2) -- 分数
    ,mut_risk_option varchar2(30) -- 多选选择项
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
grant select on ${iol_schema}.nfss_ca_risk_record_item to ${iml_schema};
grant select on ${iol_schema}.nfss_ca_risk_record_item to ${icl_schema};
grant select on ${iol_schema}.nfss_ca_risk_record_item to ${idl_schema};
grant select on ${iol_schema}.nfss_ca_risk_record_item to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_ca_risk_record_item is '客户风险评估选项详细记录表';
comment on column ${iol_schema}.nfss_ca_risk_record_item.id is '主键ID';
comment on column ${iol_schema}.nfss_ca_risk_record_item.risk_record_id is '关联风评记录主键ID';
comment on column ${iol_schema}.nfss_ca_risk_record_item.paper_id is '关联问卷主键';
comment on column ${iol_schema}.nfss_ca_risk_record_item.question_id is '关联问题主键';
comment on column ${iol_schema}.nfss_ca_risk_record_item.paper_no is '问卷编号';
comment on column ${iol_schema}.nfss_ca_risk_record_item.version is '问卷版本号';
comment on column ${iol_schema}.nfss_ca_risk_record_item.question_no is '问题编号';
comment on column ${iol_schema}.nfss_ca_risk_record_item.question_type is '问题类型';
comment on column ${iol_schema}.nfss_ca_risk_record_item.risk_option is '选择项';
comment on column ${iol_schema}.nfss_ca_risk_record_item.question is '题目内容';
comment on column ${iol_schema}.nfss_ca_risk_record_item.subject is '选择项内容';
comment on column ${iol_schema}.nfss_ca_risk_record_item.score is '分数';
comment on column ${iol_schema}.nfss_ca_risk_record_item.mut_risk_option is '多选选择项';
comment on column ${iol_schema}.nfss_ca_risk_record_item.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nfss_ca_risk_record_item.etl_timestamp is 'ETL处理时间戳';
