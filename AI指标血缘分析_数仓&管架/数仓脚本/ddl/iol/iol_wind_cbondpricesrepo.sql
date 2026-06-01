/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondpricesrepo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondpricesrepo
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondpricesrepo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondpricesrepo(
    object_id varchar2(150) -- 记录ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,trade_dt varchar2(12) -- 交易日期
    ,s_dq_open number(20,4) -- 开盘(%)
    ,s_dq_high number(20,4) -- 最高(%)
    ,s_dq_low number(20,4) -- 最低(%)
    ,s_dq_close number(20,4) -- 收盘(%)
    ,s_dq_avgprice number(20,4) -- 加权平均(%)
    ,s_dq_volume number(20,4) -- 成交量(手)
    ,s_dq_amount number(20,4) -- 成交金额(千元)
    ,opdate date -- 
    ,opmode varchar2(2) -- 
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
grant select on ${iol_schema}.wind_cbondpricesrepo to ${iml_schema};
grant select on ${iol_schema}.wind_cbondpricesrepo to ${icl_schema};
grant select on ${iol_schema}.wind_cbondpricesrepo to ${idl_schema};
grant select on ${iol_schema}.wind_cbondpricesrepo to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondpricesrepo is '中国债券存款机构间回购行情';
comment on column ${iol_schema}.wind_cbondpricesrepo.object_id is '记录ID';
comment on column ${iol_schema}.wind_cbondpricesrepo.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_cbondpricesrepo.trade_dt is '交易日期';
comment on column ${iol_schema}.wind_cbondpricesrepo.s_dq_open is '开盘(%)';
comment on column ${iol_schema}.wind_cbondpricesrepo.s_dq_high is '最高(%)';
comment on column ${iol_schema}.wind_cbondpricesrepo.s_dq_low is '最低(%)';
comment on column ${iol_schema}.wind_cbondpricesrepo.s_dq_close is '收盘(%)';
comment on column ${iol_schema}.wind_cbondpricesrepo.s_dq_avgprice is '加权平均(%)';
comment on column ${iol_schema}.wind_cbondpricesrepo.s_dq_volume is '成交量(手)';
comment on column ${iol_schema}.wind_cbondpricesrepo.s_dq_amount is '成交金额(千元)';
comment on column ${iol_schema}.wind_cbondpricesrepo.opdate is '';
comment on column ${iol_schema}.wind_cbondpricesrepo.opmode is '';
comment on column ${iol_schema}.wind_cbondpricesrepo.start_dt is '开始时间';
comment on column ${iol_schema}.wind_cbondpricesrepo.end_dt is '结束时间';
comment on column ${iol_schema}.wind_cbondpricesrepo.id_mark is '增删标志';
comment on column ${iol_schema}.wind_cbondpricesrepo.etl_timestamp is 'ETL处理时间戳';
