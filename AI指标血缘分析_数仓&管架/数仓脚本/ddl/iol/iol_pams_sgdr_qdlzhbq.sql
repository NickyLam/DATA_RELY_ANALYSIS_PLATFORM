/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_sgdr_qdlzhbq
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_sgdr_qdlzhbq
whenever sqlerror continue none;
drop table ${iol_schema}.pams_sgdr_qdlzhbq purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_sgdr_qdlzhbq(
    tjrq number(22) -- 统计日期
    ,khh varchar2(75) -- 客户号
    ,kh varchar2(75) -- 账户号
    ,zhdh varchar2(75) -- 账户id
    ,qdzhflbs varchar2(15) -- 渠道账户分类标识
    ,bqsccjsj varchar2(75) -- 标签首次创建时间
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
grant select on ${iol_schema}.pams_sgdr_qdlzhbq to ${iml_schema};
grant select on ${iol_schema}.pams_sgdr_qdlzhbq to ${icl_schema};
grant select on ${iol_schema}.pams_sgdr_qdlzhbq to ${idl_schema};
grant select on ${iol_schema}.pams_sgdr_qdlzhbq to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_sgdr_qdlzhbq is '手工导入_渠道类账户标签';
comment on column ${iol_schema}.pams_sgdr_qdlzhbq.tjrq is '统计日期';
comment on column ${iol_schema}.pams_sgdr_qdlzhbq.khh is '客户号';
comment on column ${iol_schema}.pams_sgdr_qdlzhbq.kh is '账户号';
comment on column ${iol_schema}.pams_sgdr_qdlzhbq.zhdh is '账户id';
comment on column ${iol_schema}.pams_sgdr_qdlzhbq.qdzhflbs is '渠道账户分类标识';
comment on column ${iol_schema}.pams_sgdr_qdlzhbq.bqsccjsj is '标签首次创建时间';
comment on column ${iol_schema}.pams_sgdr_qdlzhbq.start_dt is '开始时间';
comment on column ${iol_schema}.pams_sgdr_qdlzhbq.end_dt is '结束时间';
comment on column ${iol_schema}.pams_sgdr_qdlzhbq.id_mark is '增删标志';
comment on column ${iol_schema}.pams_sgdr_qdlzhbq.etl_timestamp is 'ETL处理时间戳';
