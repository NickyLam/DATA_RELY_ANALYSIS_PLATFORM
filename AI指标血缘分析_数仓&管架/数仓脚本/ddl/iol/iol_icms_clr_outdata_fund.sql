/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_outdata_fund
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_outdata_fund
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_outdata_fund purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_outdata_fund(
    dateno date -- 期次
    ,fundno varchar2(60) -- 基金代码
    ,fundname varchar2(200) -- 基金名称
    ,newprice number(24,6) -- 最新净值 指基金当日净值（元）
    ,volatility number(24,6) -- 涨跌幅 指基金当日净值较昨日净值的增长幅度（百分比）
    ,lastdayprice number(24,6) -- 上期净值 指基金昨日净值（元）
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
grant select on ${iol_schema}.icms_clr_outdata_fund to ${iml_schema};
grant select on ${iol_schema}.icms_clr_outdata_fund to ${icl_schema};
grant select on ${iol_schema}.icms_clr_outdata_fund to ${idl_schema};
grant select on ${iol_schema}.icms_clr_outdata_fund to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_outdata_fund is '基金信息表（外部数据）';
comment on column ${iol_schema}.icms_clr_outdata_fund.dateno is '期次';
comment on column ${iol_schema}.icms_clr_outdata_fund.fundno is '基金代码';
comment on column ${iol_schema}.icms_clr_outdata_fund.fundname is '基金名称';
comment on column ${iol_schema}.icms_clr_outdata_fund.newprice is '最新净值 指基金当日净值（元）';
comment on column ${iol_schema}.icms_clr_outdata_fund.volatility is '涨跌幅 指基金当日净值较昨日净值的增长幅度（百分比）';
comment on column ${iol_schema}.icms_clr_outdata_fund.lastdayprice is '上期净值 指基金昨日净值（元）';
comment on column ${iol_schema}.icms_clr_outdata_fund.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_outdata_fund.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_outdata_fund.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_outdata_fund.etl_timestamp is 'ETL处理时间戳';
