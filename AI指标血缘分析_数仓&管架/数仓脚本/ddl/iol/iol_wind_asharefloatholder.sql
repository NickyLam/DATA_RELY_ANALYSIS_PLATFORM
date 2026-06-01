/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_asharefloatholder
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_asharefloatholder
whenever sqlerror continue none;
drop table ${iol_schema}.wind_asharefloatholder purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_asharefloatholder(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,ann_dt varchar2(12) -- 公告日期
    ,s_holder_enddate varchar2(12) -- 截止日期
    ,s_holder_holdercategory varchar2(2) -- 股东类型
    ,s_holder_name varchar2(503) -- 持有人
    ,s_holder_quantity number(20,4) -- 数量（股）
    ,s_holder_windname varchar2(300) -- 持有人（容错后）
    ,opdate date -- 
    ,opmode varchar2(2) -- 
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
grant select on ${iol_schema}.wind_asharefloatholder to ${iml_schema};
grant select on ${iol_schema}.wind_asharefloatholder to ${icl_schema};
grant select on ${iol_schema}.wind_asharefloatholder to ${idl_schema};
grant select on ${iol_schema}.wind_asharefloatholder to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_asharefloatholder is '中国a股流通股东';
comment on column ${iol_schema}.wind_asharefloatholder.object_id is '对象ID';
comment on column ${iol_schema}.wind_asharefloatholder.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_asharefloatholder.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_asharefloatholder.s_holder_enddate is '截止日期';
comment on column ${iol_schema}.wind_asharefloatholder.s_holder_holdercategory is '股东类型';
comment on column ${iol_schema}.wind_asharefloatholder.s_holder_name is '持有人';
comment on column ${iol_schema}.wind_asharefloatholder.s_holder_quantity is '数量（股）';
comment on column ${iol_schema}.wind_asharefloatholder.s_holder_windname is '持有人（容错后）';
comment on column ${iol_schema}.wind_asharefloatholder.opdate is '';
comment on column ${iol_schema}.wind_asharefloatholder.opmode is '';
comment on column ${iol_schema}.wind_asharefloatholder.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_asharefloatholder.etl_timestamp is 'ETL处理时间戳';
