/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_yjzb_hyjjh
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_yjzb_hyjjh
whenever sqlerror continue none;
drop table ${iol_schema}.pams_yjzb_hyjjh purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_yjzb_hyjjh(
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
grant select on ${iol_schema}.pams_yjzb_hyjjh to ${iml_schema};
grant select on ${iol_schema}.pams_yjzb_hyjjh to ${icl_schema};
grant select on ${iol_schema}.pams_yjzb_hyjjh to ${idl_schema};
grant select on ${iol_schema}.pams_yjzb_hyjjh to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_yjzb_hyjjh is '业绩指标-行员季计划';
comment on column ${iol_schema}.pams_yjzb_hyjjh.khnf is '考核年份';
comment on column ${iol_schema}.pams_yjzb_hyjjh.khzbdh is '考核指标代号';
comment on column ${iol_schema}.pams_yjzb_hyjjh.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_yjzb_hyjjh.jhz1 is '计划值1';
comment on column ${iol_schema}.pams_yjzb_hyjjh.lzz1 is '力争值1';
comment on column ${iol_schema}.pams_yjzb_hyjjh.jhz2 is '计划值2';
comment on column ${iol_schema}.pams_yjzb_hyjjh.lzz2 is '力争值2';
comment on column ${iol_schema}.pams_yjzb_hyjjh.jhz3 is '计划值3';
comment on column ${iol_schema}.pams_yjzb_hyjjh.lzz3 is '力争值3';
comment on column ${iol_schema}.pams_yjzb_hyjjh.jhz4 is '计划值4';
comment on column ${iol_schema}.pams_yjzb_hyjjh.lzz4 is '力争值4';
comment on column ${iol_schema}.pams_yjzb_hyjjh.start_dt is '开始时间';
comment on column ${iol_schema}.pams_yjzb_hyjjh.end_dt is '结束时间';
comment on column ${iol_schema}.pams_yjzb_hyjjh.id_mark is '增删标志';
comment on column ${iol_schema}.pams_yjzb_hyjjh.etl_timestamp is 'ETL处理时间戳';
