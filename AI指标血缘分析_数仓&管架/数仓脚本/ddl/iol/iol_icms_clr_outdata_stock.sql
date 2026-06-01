/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_outdata_stock
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_outdata_stock
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_outdata_stock purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_outdata_stock(
    dateno date -- 期次
    ,interestno varchar2(60) -- 股票代码
    ,interestname varchar2(200) -- 股票名称
    ,newprice number(24,6) -- 最新发行价（元）
    ,volatility number(24,6) -- 涨跌幅（百分比）
    ,lastdayprice number(24,6) -- 昨日收盘价（元）
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
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
grant select on ${iol_schema}.icms_clr_outdata_stock to ${iml_schema};
grant select on ${iol_schema}.icms_clr_outdata_stock to ${icl_schema};
grant select on ${iol_schema}.icms_clr_outdata_stock to ${idl_schema};
grant select on ${iol_schema}.icms_clr_outdata_stock to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_outdata_stock is '股票信息表（外部数据）';
comment on column ${iol_schema}.icms_clr_outdata_stock.dateno is '期次';
comment on column ${iol_schema}.icms_clr_outdata_stock.interestno is '股票代码';
comment on column ${iol_schema}.icms_clr_outdata_stock.interestname is '股票名称';
comment on column ${iol_schema}.icms_clr_outdata_stock.newprice is '最新发行价（元）';
comment on column ${iol_schema}.icms_clr_outdata_stock.volatility is '涨跌幅（百分比）';
comment on column ${iol_schema}.icms_clr_outdata_stock.lastdayprice is '昨日收盘价（元）';
comment on column ${iol_schema}.icms_clr_outdata_stock.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_outdata_stock.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_outdata_stock.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_outdata_stock.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_outdata_stock.etl_timestamp is 'ETL处理时间戳';
