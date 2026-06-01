/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_fxrmbmidrate
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_fxrmbmidrate
whenever sqlerror continue none;
drop table ${iol_schema}.wind_fxrmbmidrate purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_fxrmbmidrate(
    object_id varchar2(150) -- 对象ID
    ,crncy_code varchar2(60) -- 货币代码
    ,trade_dt varchar2(12) -- 日期
    ,crncy_midrate number(20,6) -- 中间价
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
grant select on ${iol_schema}.wind_fxrmbmidrate to ${iml_schema};
grant select on ${iol_schema}.wind_fxrmbmidrate to ${icl_schema};
grant select on ${iol_schema}.wind_fxrmbmidrate to ${idl_schema};
grant select on ${iol_schema}.wind_fxrmbmidrate to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_fxrmbmidrate is '中国外汇牌价';
comment on column ${iol_schema}.wind_fxrmbmidrate.object_id is '对象ID';
comment on column ${iol_schema}.wind_fxrmbmidrate.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_fxrmbmidrate.trade_dt is '日期';
comment on column ${iol_schema}.wind_fxrmbmidrate.crncy_midrate is '中间价';
comment on column ${iol_schema}.wind_fxrmbmidrate.start_dt is '开始时间';
comment on column ${iol_schema}.wind_fxrmbmidrate.end_dt is '结束时间';
comment on column ${iol_schema}.wind_fxrmbmidrate.id_mark is '增删标志';
comment on column ${iol_schema}.wind_fxrmbmidrate.etl_timestamp is 'ETL处理时间戳';
