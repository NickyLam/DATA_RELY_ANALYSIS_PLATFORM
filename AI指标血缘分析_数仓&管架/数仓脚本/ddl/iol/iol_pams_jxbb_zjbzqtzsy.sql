/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_zjbzqtzsy
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_zjbzqtzsy
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_zjbzqtzsy purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_zjbzqtzsy(
    tjrq number(22) -- 统计日期
    ,zqdm varchar2(900) -- 债券代码
    ,jxdxdh number(22) -- 绩效对象代号
    ,jgdh varchar2(30) -- 机构代号
    ,jgmc varchar2(300) -- 机构名称
    ,ldpz varchar2(6) -- 联动品种
    ,khh varchar2(90) -- 客户号
    ,khmc varchar2(1500) -- 客户名称
    ,tzsy number(25,4) -- 调整收益
    ,tzsyylj number(25,4) -- 调整收益月累计
    ,tzsyjlj number(25,4) -- 调整收益季累计
    ,tzsynlj number(25,4) -- 调整收益年累计
    ,khjlgh varchar2(60) -- 客户经理工号
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
grant select on ${iol_schema}.pams_jxbb_zjbzqtzsy to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_zjbzqtzsy to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_zjbzqtzsy to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_zjbzqtzsy to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_zjbzqtzsy is '绩效报表-资金债券调整收益';
comment on column ${iol_schema}.pams_jxbb_zjbzqtzsy.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_zjbzqtzsy.zqdm is '债券代码';
comment on column ${iol_schema}.pams_jxbb_zjbzqtzsy.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_zjbzqtzsy.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxbb_zjbzqtzsy.jgmc is '机构名称';
comment on column ${iol_schema}.pams_jxbb_zjbzqtzsy.ldpz is '联动品种';
comment on column ${iol_schema}.pams_jxbb_zjbzqtzsy.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_zjbzqtzsy.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_zjbzqtzsy.tzsy is '调整收益';
comment on column ${iol_schema}.pams_jxbb_zjbzqtzsy.tzsyylj is '调整收益月累计';
comment on column ${iol_schema}.pams_jxbb_zjbzqtzsy.tzsyjlj is '调整收益季累计';
comment on column ${iol_schema}.pams_jxbb_zjbzqtzsy.tzsynlj is '调整收益年累计';
comment on column ${iol_schema}.pams_jxbb_zjbzqtzsy.khjlgh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_zjbzqtzsy.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_zjbzqtzsy.etl_timestamp is 'ETL处理时间戳';
