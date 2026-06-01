/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_sgdr_qdlzhbq_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_sgdr_qdlzhbq_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_sgdr_qdlzhbq_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_sgdr_qdlzhbq_recal(
    tjrq number(22) -- 统计日期
    ,khh varchar2(150) -- 客户号
    ,kh varchar2(150) -- 账户号
    ,zhdh varchar2(150) -- 账户id
    ,qdzhflbs varchar2(30) -- 渠道账户分类标识
    ,bqsccjsj varchar2(150) -- 标签首次创建时间
    ,recal_dt number(22) -- 重算日期
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
grant select on ${iol_schema}.pams_sgdr_qdlzhbq_recal to ${iml_schema};
grant select on ${iol_schema}.pams_sgdr_qdlzhbq_recal to ${icl_schema};
grant select on ${iol_schema}.pams_sgdr_qdlzhbq_recal to ${idl_schema};
grant select on ${iol_schema}.pams_sgdr_qdlzhbq_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_sgdr_qdlzhbq_recal is '手工导入_渠道类账户标签_重算';
comment on column ${iol_schema}.pams_sgdr_qdlzhbq_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_sgdr_qdlzhbq_recal.khh is '客户号';
comment on column ${iol_schema}.pams_sgdr_qdlzhbq_recal.kh is '账户号';
comment on column ${iol_schema}.pams_sgdr_qdlzhbq_recal.zhdh is '账户id';
comment on column ${iol_schema}.pams_sgdr_qdlzhbq_recal.qdzhflbs is '渠道账户分类标识';
comment on column ${iol_schema}.pams_sgdr_qdlzhbq_recal.bqsccjsj is '标签首次创建时间';
comment on column ${iol_schema}.pams_sgdr_qdlzhbq_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_sgdr_qdlzhbq_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_sgdr_qdlzhbq_recal.etl_timestamp is 'ETL处理时间戳';
