/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_gsjckhmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_gsjckhmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_gsjckhmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_gsjckhmx(
    tjrq number -- 统计日期
    ,hydh varchar2(60) -- 行员代号
    ,hymc varchar2(300) -- 行员名称
    ,jgdh varchar2(60) -- 机构代号
    ,jgmc varchar2(300) -- 机构名称
    ,khh varchar2(150) -- 客户号
    ,khmc varchar2(1500) -- 客户名称
    ,khs number(25,4) -- 客户数
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
grant select on ${iol_schema}.pams_jxbb_gsjckhmx to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_gsjckhmx to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_gsjckhmx to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_gsjckhmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_gsjckhmx is '绩效报表_公司基础客户明细';
comment on column ${iol_schema}.pams_jxbb_gsjckhmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_gsjckhmx.hydh is '行员代号';
comment on column ${iol_schema}.pams_jxbb_gsjckhmx.hymc is '行员名称';
comment on column ${iol_schema}.pams_jxbb_gsjckhmx.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxbb_gsjckhmx.jgmc is '机构名称';
comment on column ${iol_schema}.pams_jxbb_gsjckhmx.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_gsjckhmx.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_gsjckhmx.khs is '客户数';
comment on column ${iol_schema}.pams_jxbb_gsjckhmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_gsjckhmx.etl_timestamp is 'ETL处理时间戳';
