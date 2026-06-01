/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondmainandnoteitems
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondmainandnoteitems
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondmainandnoteitems purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondmainandnoteitems(
    object_id varchar2(57) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,sequence1 number(6,0) -- 顺序编号
    ,accounts_id varchar2(30) -- 科目ID
    ,is_not_null number(1,0) -- 是否非空
    ,is_show number(1,0) -- 是否展示
    ,s_info_typecode number(9,0) -- 报表品种代码
    ,subject_chinese_name varchar2(150) -- 科目中文名
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
grant select on ${iol_schema}.wind_cbondmainandnoteitems to ${iml_schema};
grant select on ${iol_schema}.wind_cbondmainandnoteitems to ${icl_schema};
grant select on ${iol_schema}.wind_cbondmainandnoteitems to ${idl_schema};
grant select on ${iol_schema}.wind_cbondmainandnoteitems to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondmainandnoteitems is '中国债券主营及附注科目构成表';
comment on column ${iol_schema}.wind_cbondmainandnoteitems.object_id is '对象ID';
comment on column ${iol_schema}.wind_cbondmainandnoteitems.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_cbondmainandnoteitems.sequence1 is '顺序编号';
comment on column ${iol_schema}.wind_cbondmainandnoteitems.accounts_id is '科目ID';
comment on column ${iol_schema}.wind_cbondmainandnoteitems.is_not_null is '是否非空';
comment on column ${iol_schema}.wind_cbondmainandnoteitems.is_show is '是否展示';
comment on column ${iol_schema}.wind_cbondmainandnoteitems.s_info_typecode is '报表品种代码';
comment on column ${iol_schema}.wind_cbondmainandnoteitems.subject_chinese_name is '科目中文名';
comment on column ${iol_schema}.wind_cbondmainandnoteitems.start_dt is '开始时间';
comment on column ${iol_schema}.wind_cbondmainandnoteitems.end_dt is '结束时间';
comment on column ${iol_schema}.wind_cbondmainandnoteitems.id_mark is '增删标志';
comment on column ${iol_schema}.wind_cbondmainandnoteitems.etl_timestamp is 'ETL处理时间戳';
