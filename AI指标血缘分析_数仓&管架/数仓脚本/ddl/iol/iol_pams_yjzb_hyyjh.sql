/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_yjzb_hyyjh
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_yjzb_hyyjh
whenever sqlerror continue none;
drop table ${iol_schema}.pams_yjzb_hyyjh purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_yjzb_hyyjh(
    khnf number(22,0) -- 考核年份
    ,khzbdh number(22,0) -- 考核指标代号
    ,khdxdh number(22,0) -- 考核对象代号
    ,jhz1 number(25,4) -- 计划值1
    ,lzz1 number(25,4) -- 力争值1
    ,jhz2 number(25,4) -- 计划值2
    ,lzz2 number(25,4) -- 力争值2
    ,jhz3 number(25,4) -- 计划值3
    ,lzz3 number(25,4) -- 力争值3
    ,jhz4 number(25,4) -- 计划值4
    ,lzz4 number(25,4) -- 力争值4
    ,jhz5 number(25,4) -- 计划值5
    ,lzz5 number(25,4) -- 力争值5
    ,jhz6 number(25,4) -- 计划值6
    ,lzz6 number(25,4) -- 力争值6
    ,jhz7 number(25,4) -- 计划值7
    ,lzz7 number(25,4) -- 力争值7
    ,jhz8 number(25,4) -- 计划值8
    ,lzz8 number(25,4) -- 力争值8
    ,jhz9 number(25,4) -- 计划值9
    ,lzz9 number(25,4) -- 力争值9
    ,jhz10 number(25,4) -- 计划值10
    ,lzz10 number(25,4) -- 力争值10
    ,jhz11 number(25,4) -- 计划值11
    ,lzz11 number(25,4) -- 力争值11
    ,jhz12 number(25,4) -- 计划值12
    ,lzz12 number(25,4) -- 力争值12
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
grant select on ${iol_schema}.pams_yjzb_hyyjh to ${iml_schema};
grant select on ${iol_schema}.pams_yjzb_hyyjh to ${icl_schema};
grant select on ${iol_schema}.pams_yjzb_hyyjh to ${idl_schema};
grant select on ${iol_schema}.pams_yjzb_hyyjh to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_yjzb_hyyjh is '业绩指标-行员月计划';
comment on column ${iol_schema}.pams_yjzb_hyyjh.khnf is '考核年份';
comment on column ${iol_schema}.pams_yjzb_hyyjh.khzbdh is '考核指标代号';
comment on column ${iol_schema}.pams_yjzb_hyyjh.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_yjzb_hyyjh.jhz1 is '计划值1';
comment on column ${iol_schema}.pams_yjzb_hyyjh.lzz1 is '力争值1';
comment on column ${iol_schema}.pams_yjzb_hyyjh.jhz2 is '计划值2';
comment on column ${iol_schema}.pams_yjzb_hyyjh.lzz2 is '力争值2';
comment on column ${iol_schema}.pams_yjzb_hyyjh.jhz3 is '计划值3';
comment on column ${iol_schema}.pams_yjzb_hyyjh.lzz3 is '力争值3';
comment on column ${iol_schema}.pams_yjzb_hyyjh.jhz4 is '计划值4';
comment on column ${iol_schema}.pams_yjzb_hyyjh.lzz4 is '力争值4';
comment on column ${iol_schema}.pams_yjzb_hyyjh.jhz5 is '计划值5';
comment on column ${iol_schema}.pams_yjzb_hyyjh.lzz5 is '力争值5';
comment on column ${iol_schema}.pams_yjzb_hyyjh.jhz6 is '计划值6';
comment on column ${iol_schema}.pams_yjzb_hyyjh.lzz6 is '力争值6';
comment on column ${iol_schema}.pams_yjzb_hyyjh.jhz7 is '计划值7';
comment on column ${iol_schema}.pams_yjzb_hyyjh.lzz7 is '力争值7';
comment on column ${iol_schema}.pams_yjzb_hyyjh.jhz8 is '计划值8';
comment on column ${iol_schema}.pams_yjzb_hyyjh.lzz8 is '力争值8';
comment on column ${iol_schema}.pams_yjzb_hyyjh.jhz9 is '计划值9';
comment on column ${iol_schema}.pams_yjzb_hyyjh.lzz9 is '力争值9';
comment on column ${iol_schema}.pams_yjzb_hyyjh.jhz10 is '计划值10';
comment on column ${iol_schema}.pams_yjzb_hyyjh.lzz10 is '力争值10';
comment on column ${iol_schema}.pams_yjzb_hyyjh.jhz11 is '计划值11';
comment on column ${iol_schema}.pams_yjzb_hyyjh.lzz11 is '力争值11';
comment on column ${iol_schema}.pams_yjzb_hyyjh.jhz12 is '计划值12';
comment on column ${iol_schema}.pams_yjzb_hyyjh.lzz12 is '力争值12';
comment on column ${iol_schema}.pams_yjzb_hyyjh.start_dt is '开始时间';
comment on column ${iol_schema}.pams_yjzb_hyyjh.end_dt is '结束时间';
comment on column ${iol_schema}.pams_yjzb_hyyjh.id_mark is '增删标志';
comment on column ${iol_schema}.pams_yjzb_hyyjh.etl_timestamp is 'ETL处理时间戳';
