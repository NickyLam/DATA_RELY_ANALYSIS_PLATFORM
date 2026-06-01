/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rsts_cpr_rating_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rsts_cpr_rating_detail
whenever sqlerror continue none;
drop table ${iol_schema}.rsts_cpr_rating_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_cpr_rating_detail(
    uuid varchar2(64) -- 评级明细ID
    ,serial_no varchar2(128) -- 评级流水号
    ,rating_id varchar2(100) -- 评级记录ID
    ,index_type varchar2(32) -- 指标类型
    ,index_code varchar2(64) -- 指标标识
    ,index_grade varchar2(256) -- 指标分档
    ,financial_index_value varchar2(32) -- 财务指标值
    ,index_score varchar2(32) -- 指标得分
    ,index_value varchar2(1024) -- 指标值
    ,index_name varchar2(256) -- 指标名称
    ,formula varchar2(1024) -- 计算公式
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
grant select on ${iol_schema}.rsts_cpr_rating_detail to ${iml_schema};
grant select on ${iol_schema}.rsts_cpr_rating_detail to ${icl_schema};
grant select on ${iol_schema}.rsts_cpr_rating_detail to ${idl_schema};
grant select on ${iol_schema}.rsts_cpr_rating_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.rsts_cpr_rating_detail is '评级明细表';
comment on column ${iol_schema}.rsts_cpr_rating_detail.uuid is '评级明细ID';
comment on column ${iol_schema}.rsts_cpr_rating_detail.serial_no is '评级流水号';
comment on column ${iol_schema}.rsts_cpr_rating_detail.rating_id is '评级记录ID';
comment on column ${iol_schema}.rsts_cpr_rating_detail.index_type is '指标类型';
comment on column ${iol_schema}.rsts_cpr_rating_detail.index_code is '指标标识';
comment on column ${iol_schema}.rsts_cpr_rating_detail.index_grade is '指标分档';
comment on column ${iol_schema}.rsts_cpr_rating_detail.financial_index_value is '财务指标值';
comment on column ${iol_schema}.rsts_cpr_rating_detail.index_score is '指标得分';
comment on column ${iol_schema}.rsts_cpr_rating_detail.index_value is '指标值';
comment on column ${iol_schema}.rsts_cpr_rating_detail.index_name is '指标名称';
comment on column ${iol_schema}.rsts_cpr_rating_detail.formula is '计算公式';
comment on column ${iol_schema}.rsts_cpr_rating_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rsts_cpr_rating_detail.etl_timestamp is 'ETL处理时间戳';
