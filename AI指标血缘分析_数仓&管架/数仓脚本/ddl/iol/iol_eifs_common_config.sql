/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_common_config
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_common_config
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_common_config purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_common_config(
    common_config_id varchar2(90) -- 
    ,config_name varchar2(90) -- 
    ,state varchar2(383) -- 
    ,locale_string varchar2(383) -- 
    ,type_id varchar2(90) -- 
    ,description varchar2(383) -- 
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
grant select on ${iol_schema}.eifs_common_config to ${iml_schema};
grant select on ${iol_schema}.eifs_common_config to ${icl_schema};
grant select on ${iol_schema}.eifs_common_config to ${idl_schema};
grant select on ${iol_schema}.eifs_common_config to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_common_config is '通用参数配置项';
comment on column ${iol_schema}.eifs_common_config.common_config_id is '';
comment on column ${iol_schema}.eifs_common_config.config_name is '';
comment on column ${iol_schema}.eifs_common_config.state is '';
comment on column ${iol_schema}.eifs_common_config.locale_string is '';
comment on column ${iol_schema}.eifs_common_config.type_id is '';
comment on column ${iol_schema}.eifs_common_config.description is '';
comment on column ${iol_schema}.eifs_common_config.last_updated_stamp is '';
comment on column ${iol_schema}.eifs_common_config.last_updated_tx_stamp is '';
comment on column ${iol_schema}.eifs_common_config.created_stamp is '';
comment on column ${iol_schema}.eifs_common_config.created_tx_stamp is '';
comment on column ${iol_schema}.eifs_common_config.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_common_config.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_common_config.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_common_config.etl_timestamp is 'ETL处理时间戳';
