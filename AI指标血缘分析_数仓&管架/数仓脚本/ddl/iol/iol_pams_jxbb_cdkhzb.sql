/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_cdkhzb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_cdkhzb
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_cdkhzb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_cdkhzb(
    tjrq number(22,0) -- 统计日期
    ,khdxdh number(22,0) -- 考核对象代号
    ,pm number(22,0) -- 排名
    ,xm varchar2(75) -- 项目
    ,ye number(25,4) -- 余额
    ,yrj number(25,4) -- 月日均
    ,nrj number(25,4) -- 年日均
    ,bz varchar2(5) -- 币种
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
grant select on ${iol_schema}.pams_jxbb_cdkhzb to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_cdkhzb to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_cdkhzb to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_cdkhzb to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_cdkhzb is '绩效报表_存贷款汇总表';
comment on column ${iol_schema}.pams_jxbb_cdkhzb.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_cdkhzb.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxbb_cdkhzb.pm is '排名';
comment on column ${iol_schema}.pams_jxbb_cdkhzb.xm is '项目';
comment on column ${iol_schema}.pams_jxbb_cdkhzb.ye is '余额';
comment on column ${iol_schema}.pams_jxbb_cdkhzb.yrj is '月日均';
comment on column ${iol_schema}.pams_jxbb_cdkhzb.nrj is '年日均';
comment on column ${iol_schema}.pams_jxbb_cdkhzb.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_cdkhzb.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxbb_cdkhzb.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxbb_cdkhzb.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxbb_cdkhzb.etl_timestamp is 'ETL处理时间戳';
