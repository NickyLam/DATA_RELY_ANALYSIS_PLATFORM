/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondamount
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondamount
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondamount purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondamount(
    s_info_windcode varchar2(60) -- Wind代码
    ,s_info_enddate varchar2(12) -- 截止日期
    ,b_info_changereason number(9,0) -- 变动原因
    ,b_info_outstandingbalance number(20,8) -- 债券份额(亿元)
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
grant select on ${iol_schema}.wind_cbondamount to ${iml_schema};
grant select on ${iol_schema}.wind_cbondamount to ${icl_schema};
grant select on ${iol_schema}.wind_cbondamount to ${idl_schema};
grant select on ${iol_schema}.wind_cbondamount to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondamount is '中国债券份额变动';
comment on column ${iol_schema}.wind_cbondamount.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_cbondamount.s_info_enddate is '截止日期';
comment on column ${iol_schema}.wind_cbondamount.b_info_changereason is '变动原因';
comment on column ${iol_schema}.wind_cbondamount.b_info_outstandingbalance is '债券份额(亿元)';
comment on column ${iol_schema}.wind_cbondamount.start_dt is '开始时间';
comment on column ${iol_schema}.wind_cbondamount.end_dt is '结束时间';
comment on column ${iol_schema}.wind_cbondamount.id_mark is '增删标志';
comment on column ${iol_schema}.wind_cbondamount.etl_timestamp is 'ETL处理时间戳';
