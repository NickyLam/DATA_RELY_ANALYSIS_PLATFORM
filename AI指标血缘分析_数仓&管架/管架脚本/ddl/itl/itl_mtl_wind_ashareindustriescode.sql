/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl mtl_wind_ashareindustriescode
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.mtl_wind_ashareindustriescode
whenever sqlerror continue none;
drop table ${itl_schema}.mtl_wind_ashareindustriescode purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.mtl_wind_ashareindustriescode(
     etl_dt date -- 数据日期
    ,object_id varchar2(100) -- 对象ID
    ,industriescode varchar2(38)  -- 行业代码
    ,industriesname varchar2(50) -- 行业名称
    ,levelnum number(1) -- 级数  
    ,used number(1) -- 是否有效
    ,industriesalias  varchar2(12) -- 板块别名
    ,sequence1 number(4) -- 展示序号
    ,memo varchar2(100) -- 备注  
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.mtl_wind_ashareindustriescode to ${iol_schema};

-- comment
comment on table ${itl_schema}.mtl_wind_ashareindustriescode is '行业代码表';
comment on column ${itl_schema}.mtl_wind_ashareindustriescode.etl_dt is '数据日期' ;
comment on column ${itl_schema}.mtl_wind_ashareindustriescode.object_id is '对象ID';
comment on column ${itl_schema}.mtl_wind_ashareindustriescode.industriescode is '行业代码';
comment on column ${itl_schema}.mtl_wind_ashareindustriescode.industriesname is '行业名称';
comment on column ${itl_schema}.mtl_wind_ashareindustriescode.levelnum is '级数';
comment on column ${itl_schema}.mtl_wind_ashareindustriescode.used is '是否有效';
comment on column ${itl_schema}.mtl_wind_ashareindustriescode.industriesalias is '板块别名';
comment on column ${itl_schema}.mtl_wind_ashareindustriescode.sequence1 is '展示序号';
comment on column ${itl_schema}.mtl_wind_ashareindustriescode.memo is '备注';
comment on column ${itl_schema}.mtl_wind_ashareindustriescode.start_dt is '开始时间';
comment on column ${itl_schema}.mtl_wind_ashareindustriescode.end_dt is '结束时间';
comment on column ${itl_schema}.mtl_wind_ashareindustriescode.etl_timestamp is 'ETL处理时间戳';
