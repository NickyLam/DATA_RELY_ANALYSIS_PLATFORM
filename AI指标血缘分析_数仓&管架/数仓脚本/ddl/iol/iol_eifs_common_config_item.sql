/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_common_config_item
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_common_config_item
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_common_config_item purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_common_config_item(
    common_config_item_id varchar2(90) -- 
    ,common_config_id varchar2(90) -- 
    ,key varchar2(383) -- 
    ,value varchar2(383) -- 
    ,parent_id varchar2(90) -- 
    ,description varchar2(383) -- 
    ,is_encrypt varchar2(90) -- 
    ,seq varchar2(90) -- 
    ,stateitem varchar2(90) -- 
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
grant select on ${iol_schema}.eifs_common_config_item to ${iml_schema};
grant select on ${iol_schema}.eifs_common_config_item to ${icl_schema};
grant select on ${iol_schema}.eifs_common_config_item to ${idl_schema};
grant select on ${iol_schema}.eifs_common_config_item to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_common_config_item is '通用参数配置项';
comment on column ${iol_schema}.eifs_common_config_item.common_config_item_id is '';
comment on column ${iol_schema}.eifs_common_config_item.common_config_id is '';
comment on column ${iol_schema}.eifs_common_config_item.key is '';
comment on column ${iol_schema}.eifs_common_config_item.value is '';
comment on column ${iol_schema}.eifs_common_config_item.parent_id is '';
comment on column ${iol_schema}.eifs_common_config_item.description is '';
comment on column ${iol_schema}.eifs_common_config_item.is_encrypt is '';
comment on column ${iol_schema}.eifs_common_config_item.seq is '';
comment on column ${iol_schema}.eifs_common_config_item.stateitem is '';
comment on column ${iol_schema}.eifs_common_config_item.last_updated_stamp is '';
comment on column ${iol_schema}.eifs_common_config_item.last_updated_tx_stamp is '';
comment on column ${iol_schema}.eifs_common_config_item.created_stamp is '';
comment on column ${iol_schema}.eifs_common_config_item.created_tx_stamp is '';
comment on column ${iol_schema}.eifs_common_config_item.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_common_config_item.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_common_config_item.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_common_config_item.etl_timestamp is 'ETL处理时间戳';
