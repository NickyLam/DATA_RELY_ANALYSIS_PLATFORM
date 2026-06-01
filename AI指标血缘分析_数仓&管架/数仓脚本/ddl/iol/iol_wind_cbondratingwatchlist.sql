/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondratingwatchlist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondratingwatchlist
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondratingwatchlist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondratingwatchlist(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,ann_dt varchar2(12) -- 公告日期
    ,b_event_hapdate varchar2(12) -- 发生日期
    ,b_event_categorycode number(9,0) -- 事件类型代码
    ,b_event_category varchar2(120) -- 事件类型名称
    ,b_event_title varchar2(750) -- 事件标题
    ,b_ann_abstract varchar2(4000) -- 公告摘要
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
grant select on ${iol_schema}.wind_cbondratingwatchlist to ${iml_schema};
grant select on ${iol_schema}.wind_cbondratingwatchlist to ${icl_schema};
grant select on ${iol_schema}.wind_cbondratingwatchlist to ${idl_schema};
grant select on ${iol_schema}.wind_cbondratingwatchlist to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondratingwatchlist is '债券信用评级观察名单明细';
comment on column ${iol_schema}.wind_cbondratingwatchlist.object_id is '对象ID';
comment on column ${iol_schema}.wind_cbondratingwatchlist.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_cbondratingwatchlist.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_cbondratingwatchlist.b_event_hapdate is '发生日期';
comment on column ${iol_schema}.wind_cbondratingwatchlist.b_event_categorycode is '事件类型代码';
comment on column ${iol_schema}.wind_cbondratingwatchlist.b_event_category is '事件类型名称';
comment on column ${iol_schema}.wind_cbondratingwatchlist.b_event_title is '事件标题';
comment on column ${iol_schema}.wind_cbondratingwatchlist.b_ann_abstract is '公告摘要';
comment on column ${iol_schema}.wind_cbondratingwatchlist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_cbondratingwatchlist.etl_timestamp is 'ETL处理时间戳';
