/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gla_actg_recd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gla_actg_recd
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gla_actg_recd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gla_actg_recd(
    stacid number(9) -- 账套id
    ,trandt varchar2(8) -- 交易日期
    ,recdsq varchar2(60) -- 主键记录
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
grant select on ${iol_schema}.tgls_gla_actg_recd to ${iml_schema};
grant select on ${iol_schema}.tgls_gla_actg_recd to ${icl_schema};
grant select on ${iol_schema}.tgls_gla_actg_recd to ${idl_schema};
grant select on ${iol_schema}.tgls_gla_actg_recd to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gla_actg_recd is '入账记录表';
comment on column ${iol_schema}.tgls_gla_actg_recd.stacid is '账套id';
comment on column ${iol_schema}.tgls_gla_actg_recd.trandt is '交易日期';
comment on column ${iol_schema}.tgls_gla_actg_recd.recdsq is '主键记录';
comment on column ${iol_schema}.tgls_gla_actg_recd.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_gla_actg_recd.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_gla_actg_recd.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_gla_actg_recd.etl_timestamp is 'ETL处理时间戳';
