/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_pjjzkhmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_pjjzkhmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_pjjzkhmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_pjjzkhmx(
    tjrq number(22) -- 统计日期
    ,khh varchar2(90) -- 客户号
    ,khmc varchar2(1500) -- 客户名称
    ,fhdh varchar2(30) -- 所属分行代号
    ,fhmc varchar2(300) -- 所属分行名称
    ,jgdh varchar2(30) -- 所属机构代号
    ,jgmc varchar2(300) -- 所属机构名称
    ,hydh varchar2(36) -- 所属行员代号
    ,hymc varchar2(300) -- 所属行员名称
    ,cknrj number(25,4) -- 存款年日均
    ,ckljsy number(25,4) -- 存款FTP净收益
    ,sxfljsy number(25,4) -- 承兑手续费收入
    ,dktxljsy number(25,4) -- 直贴FTP净收益
    ,fhfpsy number(25,4) -- 总分联动直贴业务收益
    ,pjjcsy number(25,4) -- 系统内票据转贴现价差损益
    ,nljsy number(25,4) -- 年化收益
    ,sfjzkh varchar2(30) -- 是否价值客户:Y-是,N-否
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
grant select on ${iol_schema}.pams_jxbb_pjjzkhmx to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_pjjzkhmx to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_pjjzkhmx to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_pjjzkhmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_pjjzkhmx is '绩效报表_票据价值客户明细';
comment on column ${iol_schema}.pams_jxbb_pjjzkhmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_pjjzkhmx.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_pjjzkhmx.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_pjjzkhmx.fhdh is '所属分行代号';
comment on column ${iol_schema}.pams_jxbb_pjjzkhmx.fhmc is '所属分行名称';
comment on column ${iol_schema}.pams_jxbb_pjjzkhmx.jgdh is '所属机构代号';
comment on column ${iol_schema}.pams_jxbb_pjjzkhmx.jgmc is '所属机构名称';
comment on column ${iol_schema}.pams_jxbb_pjjzkhmx.hydh is '所属行员代号';
comment on column ${iol_schema}.pams_jxbb_pjjzkhmx.hymc is '所属行员名称';
comment on column ${iol_schema}.pams_jxbb_pjjzkhmx.cknrj is '存款年日均';
comment on column ${iol_schema}.pams_jxbb_pjjzkhmx.ckljsy is '存款FTP净收益';
comment on column ${iol_schema}.pams_jxbb_pjjzkhmx.sxfljsy is '承兑手续费收入';
comment on column ${iol_schema}.pams_jxbb_pjjzkhmx.dktxljsy is '直贴FTP净收益';
comment on column ${iol_schema}.pams_jxbb_pjjzkhmx.fhfpsy is '总分联动直贴业务收益';
comment on column ${iol_schema}.pams_jxbb_pjjzkhmx.pjjcsy is '系统内票据转贴现价差损益';
comment on column ${iol_schema}.pams_jxbb_pjjzkhmx.nljsy is '年化收益';
comment on column ${iol_schema}.pams_jxbb_pjjzkhmx.sfjzkh is '是否价值客户:Y-是,N-否';
comment on column ${iol_schema}.pams_jxbb_pjjzkhmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_pjjzkhmx.etl_timestamp is 'ETL处理时间戳';
