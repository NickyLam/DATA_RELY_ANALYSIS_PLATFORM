/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol noas_oa_flow_entity_relation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.noas_oa_flow_entity_relation
whenever sqlerror continue none;
drop table ${iol_schema}.noas_oa_flow_entity_relation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.noas_oa_flow_entity_relation(
    relation_id varchar2(30) -- 
    ,flow_key varchar2(90) -- 
    ,item_key varchar2(90) -- 
    ,entity_name varchar2(90) -- 
    ,entity_field varchar2(90) -- 
    ,field_type varchar2(15) -- 
    ,type varchar2(2) -- 
    ,remark varchar2(90) -- 
    ,choose_item_key varchar2(90) -- 
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
grant select on ${iol_schema}.noas_oa_flow_entity_relation to ${iml_schema};
grant select on ${iol_schema}.noas_oa_flow_entity_relation to ${icl_schema};
grant select on ${iol_schema}.noas_oa_flow_entity_relation to ${idl_schema};
grant select on ${iol_schema}.noas_oa_flow_entity_relation to ${iel_schema};

-- comment
comment on table ${iol_schema}.noas_oa_flow_entity_relation is '关系表';
comment on column ${iol_schema}.noas_oa_flow_entity_relation.relation_id is '';
comment on column ${iol_schema}.noas_oa_flow_entity_relation.flow_key is '';
comment on column ${iol_schema}.noas_oa_flow_entity_relation.item_key is '';
comment on column ${iol_schema}.noas_oa_flow_entity_relation.entity_name is '';
comment on column ${iol_schema}.noas_oa_flow_entity_relation.entity_field is '';
comment on column ${iol_schema}.noas_oa_flow_entity_relation.field_type is '';
comment on column ${iol_schema}.noas_oa_flow_entity_relation.type is '';
comment on column ${iol_schema}.noas_oa_flow_entity_relation.remark is '';
comment on column ${iol_schema}.noas_oa_flow_entity_relation.choose_item_key is '';
comment on column ${iol_schema}.noas_oa_flow_entity_relation.last_updated_stamp is '';
comment on column ${iol_schema}.noas_oa_flow_entity_relation.last_updated_tx_stamp is '';
comment on column ${iol_schema}.noas_oa_flow_entity_relation.created_stamp is '';
comment on column ${iol_schema}.noas_oa_flow_entity_relation.created_tx_stamp is '';
comment on column ${iol_schema}.noas_oa_flow_entity_relation.start_dt is '开始时间';
comment on column ${iol_schema}.noas_oa_flow_entity_relation.end_dt is '结束时间';
comment on column ${iol_schema}.noas_oa_flow_entity_relation.id_mark is '增删标志';
comment on column ${iol_schema}.noas_oa_flow_entity_relation.etl_timestamp is 'ETL处理时间戳';
