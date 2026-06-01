/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_cdkhzb_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_cdkhzb_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_cdkhzb_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_cdkhzb_recal(
    tjrq number(22) -- 统计日期
    ,recal_dt number(22) -- 重算日期
    ,khdxdh number(22) -- 考核对象代号
    ,pm number(22) -- 排名
    ,xm varchar2(150) -- 项目
    ,ye number(25,4) -- 余额
    ,yrj number(25,4) -- 月日均
    ,nrj number(25,4) -- 年日均
    ,bz varchar2(9) -- 币种
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
grant select on ${iol_schema}.pams_jxbb_cdkhzb_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_cdkhzb_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_cdkhzb_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_cdkhzb_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_cdkhzb_recal is '绩效报表_存贷款汇总表_重算';
comment on column ${iol_schema}.pams_jxbb_cdkhzb_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_cdkhzb_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_jxbb_cdkhzb_recal.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxbb_cdkhzb_recal.pm is '排名';
comment on column ${iol_schema}.pams_jxbb_cdkhzb_recal.xm is '项目';
comment on column ${iol_schema}.pams_jxbb_cdkhzb_recal.ye is '余额';
comment on column ${iol_schema}.pams_jxbb_cdkhzb_recal.yrj is '月日均';
comment on column ${iol_schema}.pams_jxbb_cdkhzb_recal.nrj is '年日均';
comment on column ${iol_schema}.pams_jxbb_cdkhzb_recal.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_cdkhzb_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_cdkhzb_recal.etl_timestamp is 'ETL处理时间戳';
