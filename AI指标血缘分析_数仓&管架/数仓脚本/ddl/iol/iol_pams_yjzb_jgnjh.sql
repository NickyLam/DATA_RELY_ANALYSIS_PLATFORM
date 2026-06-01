/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_yjzb_jgnjh
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_yjzb_jgnjh
whenever sqlerror continue none;
drop table ${iol_schema}.pams_yjzb_jgnjh purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_yjzb_jgnjh(
    khnf number(22,0) -- 考核年份
    ,khzbdh number(22,0) -- 考核指标代号
    ,khdxdh number(22,0) -- 考核对象代号
    ,jhz number(25,4) -- 计划值
    ,lzz number(25,4) -- 力争值
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
grant select on ${iol_schema}.pams_yjzb_jgnjh to ${iml_schema};
grant select on ${iol_schema}.pams_yjzb_jgnjh to ${icl_schema};
grant select on ${iol_schema}.pams_yjzb_jgnjh to ${idl_schema};
grant select on ${iol_schema}.pams_yjzb_jgnjh to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_yjzb_jgnjh is '业绩指标-机构年计划';
comment on column ${iol_schema}.pams_yjzb_jgnjh.khnf is '考核年份';
comment on column ${iol_schema}.pams_yjzb_jgnjh.khzbdh is '考核指标代号';
comment on column ${iol_schema}.pams_yjzb_jgnjh.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_yjzb_jgnjh.jhz is '计划值';
comment on column ${iol_schema}.pams_yjzb_jgnjh.lzz is '力争值';
comment on column ${iol_schema}.pams_yjzb_jgnjh.start_dt is '开始时间';
comment on column ${iol_schema}.pams_yjzb_jgnjh.end_dt is '结束时间';
comment on column ${iol_schema}.pams_yjzb_jgnjh.id_mark is '增删标志';
comment on column ${iol_schema}.pams_yjzb_jgnjh.etl_timestamp is 'ETL处理时间戳';
