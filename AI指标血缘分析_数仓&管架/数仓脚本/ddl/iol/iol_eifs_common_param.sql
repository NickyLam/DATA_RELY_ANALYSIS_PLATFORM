/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_common_param
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_common_param
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_common_param purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_common_param(
    param_id varchar2(30) -- 
    ,param_name varchar2(375) -- 
    ,param_value varchar2(30) -- 
    ,param_type_id varchar2(30) -- 
    ,status varchar2(30) -- 
    ,param_group_id varchar2(30) -- 
    ,description varchar2(30) -- 
    ,last_updated_stamp timestamp -- 
    ,last_updated_tx_stamp timestamp -- 
    ,created_stamp timestamp -- 
    ,created_tx_stamp timestamp -- 
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
grant select on ${iol_schema}.eifs_common_param to ${iml_schema};
grant select on ${iol_schema}.eifs_common_param to ${icl_schema};
grant select on ${iol_schema}.eifs_common_param to ${idl_schema};
grant select on ${iol_schema}.eifs_common_param to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_common_param is '通用参数记录表';
comment on column ${iol_schema}.eifs_common_param.param_id is '';
comment on column ${iol_schema}.eifs_common_param.param_name is '';
comment on column ${iol_schema}.eifs_common_param.param_value is '';
comment on column ${iol_schema}.eifs_common_param.param_type_id is '';
comment on column ${iol_schema}.eifs_common_param.status is '';
comment on column ${iol_schema}.eifs_common_param.param_group_id is '';
comment on column ${iol_schema}.eifs_common_param.description is '';
comment on column ${iol_schema}.eifs_common_param.last_updated_stamp is '';
comment on column ${iol_schema}.eifs_common_param.last_updated_tx_stamp is '';
comment on column ${iol_schema}.eifs_common_param.created_stamp is '';
comment on column ${iol_schema}.eifs_common_param.created_tx_stamp is '';
comment on column ${iol_schema}.eifs_common_param.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_common_param.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_common_param.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_common_param.etl_timestamp is 'ETL处理时间戳';
