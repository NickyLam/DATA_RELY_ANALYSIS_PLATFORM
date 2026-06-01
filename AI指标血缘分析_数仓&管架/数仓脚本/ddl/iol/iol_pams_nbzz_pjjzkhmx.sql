/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_nbzz_pjjzkhmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_nbzz_pjjzkhmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_nbzz_pjjzkhmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_nbzz_pjjzkhmx(
    tjrq number(22) -- 统计日期
    ,jxdxdh number(22) -- 绩效对象代号
    ,khdxdh number(22) -- 考核对象代号
    ,jgkhdxdh number(22) -- 机构考核对象代号
    ,khh varchar2(45) -- 客户号
    ,cknrj number(25,4) -- 存款年日均
    ,nljsy number(25,4) -- 年化收益
    ,ckljsy number(25,4) -- 存款收益
    ,sxfljsy number(25,4) -- 手续费收益
    ,txljsy number(25,4) -- 贴现收益
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
grant select on ${iol_schema}.pams_nbzz_pjjzkhmx to ${iml_schema};
grant select on ${iol_schema}.pams_nbzz_pjjzkhmx to ${icl_schema};
grant select on ${iol_schema}.pams_nbzz_pjjzkhmx to ${idl_schema};
grant select on ${iol_schema}.pams_nbzz_pjjzkhmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_nbzz_pjjzkhmx is '内部总账-票据客户业绩明细';
comment on column ${iol_schema}.pams_nbzz_pjjzkhmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_nbzz_pjjzkhmx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_nbzz_pjjzkhmx.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_nbzz_pjjzkhmx.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_nbzz_pjjzkhmx.khh is '客户号';
comment on column ${iol_schema}.pams_nbzz_pjjzkhmx.cknrj is '存款年日均';
comment on column ${iol_schema}.pams_nbzz_pjjzkhmx.nljsy is '年化收益';
comment on column ${iol_schema}.pams_nbzz_pjjzkhmx.ckljsy is '存款收益';
comment on column ${iol_schema}.pams_nbzz_pjjzkhmx.sxfljsy is '手续费收益';
comment on column ${iol_schema}.pams_nbzz_pjjzkhmx.txljsy is '贴现收益';
comment on column ${iol_schema}.pams_nbzz_pjjzkhmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_nbzz_pjjzkhmx.etl_timestamp is 'ETL处理时间戳';
