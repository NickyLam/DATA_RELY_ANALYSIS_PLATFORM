/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_ashareindustriescode
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_ashareindustriescode
whenever sqlerror continue none;
drop table ${iol_schema}.wind_ashareindustriescode purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_ashareindustriescode(
    object_id varchar2(150) -- 对象ID
    ,industriescode varchar2(57) -- 行业代码
    ,industriesname varchar2(75) -- 行业名称
    ,levelnum number(1,0) -- 级数
    ,used number(1,0) -- 是否有效
    ,industriesalias varchar2(18) -- 板块别名
    ,sequence number(4,0) -- 展示序号
    ,memo varchar2(150) -- 备注
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
grant select on ${iol_schema}.wind_ashareindustriescode to ${iml_schema};
grant select on ${iol_schema}.wind_ashareindustriescode to ${icl_schema};
grant select on ${iol_schema}.wind_ashareindustriescode to ${idl_schema};
grant select on ${iol_schema}.wind_ashareindustriescode to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_ashareindustriescode is '行业代码';
comment on column ${iol_schema}.wind_ashareindustriescode.object_id is '对象ID';
comment on column ${iol_schema}.wind_ashareindustriescode.industriescode is '行业代码';
comment on column ${iol_schema}.wind_ashareindustriescode.industriesname is '行业名称';
comment on column ${iol_schema}.wind_ashareindustriescode.levelnum is '级数';
comment on column ${iol_schema}.wind_ashareindustriescode.used is '是否有效';
comment on column ${iol_schema}.wind_ashareindustriescode.industriesalias is '板块别名';
comment on column ${iol_schema}.wind_ashareindustriescode.sequence is '展示序号';
comment on column ${iol_schema}.wind_ashareindustriescode.memo is '备注';
comment on column ${iol_schema}.wind_ashareindustriescode.start_dt is '开始时间';
comment on column ${iol_schema}.wind_ashareindustriescode.end_dt is '结束时间';
comment on column ${iol_schema}.wind_ashareindustriescode.id_mark is '增删标志';
comment on column ${iol_schema}.wind_ashareindustriescode.etl_timestamp is 'ETL处理时间戳';
