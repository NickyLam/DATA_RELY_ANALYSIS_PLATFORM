/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_data_dic
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_data_dic
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_data_dic purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_data_dic(
    id number(22) -- 
    ,data_type_no number(22) -- 
    ,data_no varchar2(30) -- 
    ,data_type_name varchar2(90) -- 
    ,data_no_len number(22) -- 
    ,data_name varchar2(150) -- 
    ,limit_flag varchar2(2) -- 
    ,high_limit varchar2(30) -- 
    ,low_limit varchar2(30) -- 
    ,effect_date varchar2(12) -- 
    ,expire_date varchar2(12) -- 
    ,timestamps varchar2(30) -- 
    ,miscflgs varchar2(30) -- 
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
grant select on ${iol_schema}.bdps_data_dic to ${iml_schema};
grant select on ${iol_schema}.bdps_data_dic to ${icl_schema};
grant select on ${iol_schema}.bdps_data_dic to ${idl_schema};
grant select on ${iol_schema}.bdps_data_dic to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_data_dic is '';
comment on column ${iol_schema}.bdps_data_dic.id is '';
comment on column ${iol_schema}.bdps_data_dic.data_type_no is '';
comment on column ${iol_schema}.bdps_data_dic.data_no is '';
comment on column ${iol_schema}.bdps_data_dic.data_type_name is '';
comment on column ${iol_schema}.bdps_data_dic.data_no_len is '';
comment on column ${iol_schema}.bdps_data_dic.data_name is '';
comment on column ${iol_schema}.bdps_data_dic.limit_flag is '';
comment on column ${iol_schema}.bdps_data_dic.high_limit is '';
comment on column ${iol_schema}.bdps_data_dic.low_limit is '';
comment on column ${iol_schema}.bdps_data_dic.effect_date is '';
comment on column ${iol_schema}.bdps_data_dic.expire_date is '';
comment on column ${iol_schema}.bdps_data_dic.timestamps is '';
comment on column ${iol_schema}.bdps_data_dic.miscflgs is '';
comment on column ${iol_schema}.bdps_data_dic.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_data_dic.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_data_dic.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_data_dic.etl_timestamp is 'ETL处理时间戳';
