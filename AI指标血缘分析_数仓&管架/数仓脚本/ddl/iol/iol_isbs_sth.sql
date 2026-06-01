/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_sth
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_sth
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_sth purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_sth(
    tbl varchar2(9) -- 参数代码
    ,codlen number(1,0) -- 参数最大长度
    ,txtlen number(2,0) -- 注释最大长度
    ,srt varchar2(2) -- 排序方式
    ,nam varchar2(60) -- 注释
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
grant select on ${iol_schema}.isbs_sth to ${iml_schema};
grant select on ${iol_schema}.isbs_sth to ${icl_schema};
grant select on ${iol_schema}.isbs_sth to ${idl_schema};
grant select on ${iol_schema}.isbs_sth to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_sth is 'CodeTable关键值';
comment on column ${iol_schema}.isbs_sth.tbl is '参数代码';
comment on column ${iol_schema}.isbs_sth.codlen is '参数最大长度';
comment on column ${iol_schema}.isbs_sth.txtlen is '注释最大长度';
comment on column ${iol_schema}.isbs_sth.srt is '排序方式';
comment on column ${iol_schema}.isbs_sth.nam is '注释';
comment on column ${iol_schema}.isbs_sth.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_sth.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_sth.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_sth.etl_timestamp is 'ETL处理时间戳';
