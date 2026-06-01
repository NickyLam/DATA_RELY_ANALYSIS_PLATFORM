/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_ope_request_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_ope_request_flow
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_ope_request_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_ope_request_flow(
    orf_flowno varchar2(128) -- 主流水号
    ,orf_date varchar2(8) -- 交易日期
    ,orf_time varchar2(17) -- 交易时间
    ,orf_ecifno varchar2(32) -- 客户号
    ,orf_activeid varchar2(128) -- 活动id
    ,orf_extend1 varchar2(256) -- 拓展字段1
    ,orf_extend2 varchar2(256) -- 拓展字段2
    ,orf_extend3 varchar2(256) -- 拓展字段3
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
grant select on ${iol_schema}.osbs_ope_request_flow to ${iml_schema};
grant select on ${iol_schema}.osbs_ope_request_flow to ${icl_schema};
grant select on ${iol_schema}.osbs_ope_request_flow to ${idl_schema};
grant select on ${iol_schema}.osbs_ope_request_flow to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_ope_request_flow is '活动访问流水表';
comment on column ${iol_schema}.osbs_ope_request_flow.orf_flowno is '主流水号';
comment on column ${iol_schema}.osbs_ope_request_flow.orf_date is '交易日期';
comment on column ${iol_schema}.osbs_ope_request_flow.orf_time is '交易时间';
comment on column ${iol_schema}.osbs_ope_request_flow.orf_ecifno is '客户号';
comment on column ${iol_schema}.osbs_ope_request_flow.orf_activeid is '活动id';
comment on column ${iol_schema}.osbs_ope_request_flow.orf_extend1 is '拓展字段1';
comment on column ${iol_schema}.osbs_ope_request_flow.orf_extend2 is '拓展字段2';
comment on column ${iol_schema}.osbs_ope_request_flow.orf_extend3 is '拓展字段3';
comment on column ${iol_schema}.osbs_ope_request_flow.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.osbs_ope_request_flow.etl_timestamp is 'ETL处理时间戳';
