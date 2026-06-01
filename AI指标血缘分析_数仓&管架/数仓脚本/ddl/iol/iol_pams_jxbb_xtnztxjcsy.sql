/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_xtnztxjcsy
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_xtnztxjcsy
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_xtnztxjcsy purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_xtnztxjcsy(
    tjrq number(38,0) -- 统计日期
    ,pjhm varchar2(300) -- 票据号码
    ,zpqj varchar2(300) -- 子票区间
    ,gsjg varchar2(300) -- 归属机构
    ,fhmc varchar2(300) -- 分行名称
    ,jgkhdxdh number(38,0) -- 机构考核对象代号
    ,pmje number(25,4) -- 票面金额
    ,pjjxdqr number(38,0) -- 到期日期
    ,xtrmcr number(38,0) -- 系统内卖出日
    ,txll number(25,4) -- 贴现利率
    ,mclv number(25,4) -- 卖出利率
    ,jcsr number(25,4) -- 利息收入
    ,khh varchar2(90) -- 客户号
    ,khmc varchar2(600) -- 客户名称
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
grant select on ${iol_schema}.pams_jxbb_xtnztxjcsy to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_xtnztxjcsy to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_xtnztxjcsy to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_xtnztxjcsy to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_xtnztxjcsy is '绩效报表-分行系统内转贴现价差损益-回流';
comment on column ${iol_schema}.pams_jxbb_xtnztxjcsy.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_xtnztxjcsy.pjhm is '票据号码';
comment on column ${iol_schema}.pams_jxbb_xtnztxjcsy.zpqj is '子票区间';
comment on column ${iol_schema}.pams_jxbb_xtnztxjcsy.gsjg is '归属机构';
comment on column ${iol_schema}.pams_jxbb_xtnztxjcsy.fhmc is '分行名称';
comment on column ${iol_schema}.pams_jxbb_xtnztxjcsy.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_xtnztxjcsy.pmje is '票面金额';
comment on column ${iol_schema}.pams_jxbb_xtnztxjcsy.pjjxdqr is '到期日期';
comment on column ${iol_schema}.pams_jxbb_xtnztxjcsy.xtrmcr is '系统内卖出日';
comment on column ${iol_schema}.pams_jxbb_xtnztxjcsy.txll is '贴现利率';
comment on column ${iol_schema}.pams_jxbb_xtnztxjcsy.mclv is '卖出利率';
comment on column ${iol_schema}.pams_jxbb_xtnztxjcsy.jcsr is '利息收入';
comment on column ${iol_schema}.pams_jxbb_xtnztxjcsy.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_xtnztxjcsy.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_xtnztxjcsy.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_xtnztxjcsy.etl_timestamp is 'ETL处理时间戳';
