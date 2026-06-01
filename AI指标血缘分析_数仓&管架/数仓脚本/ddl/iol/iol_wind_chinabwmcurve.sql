/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_chinabwmcurve
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_chinabwmcurve
whenever sqlerror continue none;
drop table ${iol_schema}.wind_chinabwmcurve purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_chinabwmcurve(
    object_id varchar2(150) -- 对象ID
    ,trade_dt varchar2(12) -- 日期
    ,code number(9,0) -- 理财产品收益率曲线代码
    ,name varchar2(120) -- 曲线名称
    ,term varchar2(30) -- 曲线期限
    ,yield number(20,4) -- 预期平均年收益率(%)
    ,issuername varchar2(150) -- 发行银行
    ,crncy_code varchar2(15) -- 币种
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
grant select on ${iol_schema}.wind_chinabwmcurve to ${iml_schema};
grant select on ${iol_schema}.wind_chinabwmcurve to ${icl_schema};
grant select on ${iol_schema}.wind_chinabwmcurve to ${idl_schema};
grant select on ${iol_schema}.wind_chinabwmcurve to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_chinabwmcurve is '中国银行理财产品收益率曲线';
comment on column ${iol_schema}.wind_chinabwmcurve.object_id is '对象ID';
comment on column ${iol_schema}.wind_chinabwmcurve.trade_dt is '日期';
comment on column ${iol_schema}.wind_chinabwmcurve.code is '理财产品收益率曲线代码';
comment on column ${iol_schema}.wind_chinabwmcurve.name is '曲线名称';
comment on column ${iol_schema}.wind_chinabwmcurve.term is '曲线期限';
comment on column ${iol_schema}.wind_chinabwmcurve.yield is '预期平均年收益率(%)';
comment on column ${iol_schema}.wind_chinabwmcurve.issuername is '发行银行';
comment on column ${iol_schema}.wind_chinabwmcurve.crncy_code is '币种';
comment on column ${iol_schema}.wind_chinabwmcurve.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_chinabwmcurve.etl_timestamp is 'ETL处理时间戳';
