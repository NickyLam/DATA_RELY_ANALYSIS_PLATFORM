/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_myrzftp_hqckmx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal(
    tjrq number(22) -- 统计日期
    ,recal_dt number(22) -- 重算窗口日期
    ,khh varchar2(75) -- 客户号
    ,khmc varchar2(150) -- 客户名称
    ,jgdh varchar2(30) -- 机构代号
    ,jgmc varchar2(75) -- 机构名称
    ,gyllxmc_list varchar2(750) -- 供应链类型名称列表
    ,glhxqykhmc varchar2(150) -- 核心企业客户名称
    ,hqckye number(25,4) -- 活期存款余额
    ,hqckyrj number(25,4) -- 活期存款月日均
    ,hqckjrj number(25,4) -- 活期存款季日均
    ,hqcknrj number(25,4) -- 活期存款年日均
    ,dghqckye number(25,4) -- 对公活期存款余额
    ,dghqckyrj number(25,4) -- 对公活期存款月日均
    ,dghqckjrj number(25,4) -- 对公活期存款季日均
    ,dghqcknrj number(25,4) -- 对公活期存款年日均
    ,bzjckye number(25,4) -- 对公活期保证金存款余额
    ,bzjckyrj number(25,4) -- 对公活期保证金存款月日均
    ,bzjckjrj number(25,4) -- 对公活期保证金存款季日均
    ,bzjcknrj number(25,4) -- 对公活期保证金存款年日均
    ,xdckye number(25,4) -- 协定存款余额
    ,xdckyrj number(25,4) -- 协定存款月日均
    ,xdckjrj number(25,4) -- 协定存款季日均
    ,xdcknrj number(25,4) -- 协定存款年日均
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
grant select on ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal is '绩效报表_供应链活期存款明细_重算';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.recal_dt is '重算窗口日期';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.jgmc is '机构名称';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.gyllxmc_list is '供应链类型名称列表';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.glhxqykhmc is '核心企业客户名称';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.hqckye is '活期存款余额';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.hqckyrj is '活期存款月日均';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.hqckjrj is '活期存款季日均';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.hqcknrj is '活期存款年日均';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.dghqckye is '对公活期存款余额';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.dghqckyrj is '对公活期存款月日均';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.dghqckjrj is '对公活期存款季日均';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.dghqcknrj is '对公活期存款年日均';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.bzjckye is '对公活期保证金存款余额';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.bzjckyrj is '对公活期保证金存款月日均';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.bzjckjrj is '对公活期保证金存款季日均';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.bzjcknrj is '对公活期保证金存款年日均';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.xdckye is '协定存款余额';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.xdckyrj is '协定存款月日均';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.xdckjrj is '协定存款季日均';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.xdcknrj is '协定存款年日均';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_myrzftp_hqckmx_recal.etl_timestamp is 'ETL处理时间戳';
