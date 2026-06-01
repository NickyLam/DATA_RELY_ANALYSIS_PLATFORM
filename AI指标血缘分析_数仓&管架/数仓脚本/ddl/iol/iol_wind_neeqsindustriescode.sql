/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_neeqsindustriescode
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_neeqsindustriescode
whenever sqlerror continue none;
drop table ${iol_schema}.wind_neeqsindustriescode purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_neeqsindustriescode(
    object_id varchar2(150) -- 对象ID
    ,industriescode varchar2(57) -- 板块代码
    ,industriesname varchar2(75) -- 板块名称
    ,levelnum number(1,0) -- 级数
    ,used number(1,0) -- 是否使用
    ,industriesalias varchar2(18) -- 板块别名
    ,sequence1 number(4,0) -- 展示序号
    ,memo varchar2(150) -- [内部]备注
    ,chinesedefinition varchar2(900) -- 板块中文定义
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
grant select on ${iol_schema}.wind_neeqsindustriescode to ${iml_schema};
grant select on ${iol_schema}.wind_neeqsindustriescode to ${icl_schema};
grant select on ${iol_schema}.wind_neeqsindustriescode to ${idl_schema};
grant select on ${iol_schema}.wind_neeqsindustriescode to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_neeqsindustriescode is '股转系统行业代码';
comment on column ${iol_schema}.wind_neeqsindustriescode.object_id is '对象ID';
comment on column ${iol_schema}.wind_neeqsindustriescode.industriescode is '板块代码';
comment on column ${iol_schema}.wind_neeqsindustriescode.industriesname is '板块名称';
comment on column ${iol_schema}.wind_neeqsindustriescode.levelnum is '级数';
comment on column ${iol_schema}.wind_neeqsindustriescode.used is '是否使用';
comment on column ${iol_schema}.wind_neeqsindustriescode.industriesalias is '板块别名';
comment on column ${iol_schema}.wind_neeqsindustriescode.sequence1 is '展示序号';
comment on column ${iol_schema}.wind_neeqsindustriescode.memo is '[内部]备注';
comment on column ${iol_schema}.wind_neeqsindustriescode.chinesedefinition is '板块中文定义';
comment on column ${iol_schema}.wind_neeqsindustriescode.start_dt is '开始时间';
comment on column ${iol_schema}.wind_neeqsindustriescode.end_dt is '结束时间';
comment on column ${iol_schema}.wind_neeqsindustriescode.id_mark is '增删标志';
comment on column ${iol_schema}.wind_neeqsindustriescode.etl_timestamp is 'ETL处理时间戳';
