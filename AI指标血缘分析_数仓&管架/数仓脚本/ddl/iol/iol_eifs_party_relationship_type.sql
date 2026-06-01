/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_party_relationship_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_party_relationship_type
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_party_relationship_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_party_relationship_type(
    party_relationship_type_id varchar2(30) -- 当事人关系类型ID
    ,parent_type_id varchar2(30) -- 上级关系类型ID
    ,has_table varchar2(2) -- 是否有表
    ,party_relationship_name varchar2(150) -- 当事人关系类型名称
    ,description varchar2(383) -- 当事人关系类型描述
    ,role_type_id_valid_from varchar2(30) -- 源角色类型有效期
    ,role_type_id_valid_to varchar2(30) -- 目标角色类型有效期
    ,last_updated_stamp timestamp -- 最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事务时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事务时间
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
grant select on ${iol_schema}.eifs_party_relationship_type to ${iml_schema};
grant select on ${iol_schema}.eifs_party_relationship_type to ${icl_schema};
grant select on ${iol_schema}.eifs_party_relationship_type to ${idl_schema};
grant select on ${iol_schema}.eifs_party_relationship_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_party_relationship_type is '当事人关联类型表';
comment on column ${iol_schema}.eifs_party_relationship_type.party_relationship_type_id is '当事人关系类型ID';
comment on column ${iol_schema}.eifs_party_relationship_type.parent_type_id is '上级关系类型ID';
comment on column ${iol_schema}.eifs_party_relationship_type.has_table is '是否有表';
comment on column ${iol_schema}.eifs_party_relationship_type.party_relationship_name is '当事人关系类型名称';
comment on column ${iol_schema}.eifs_party_relationship_type.description is '当事人关系类型描述';
comment on column ${iol_schema}.eifs_party_relationship_type.role_type_id_valid_from is '源角色类型有效期';
comment on column ${iol_schema}.eifs_party_relationship_type.role_type_id_valid_to is '目标角色类型有效期';
comment on column ${iol_schema}.eifs_party_relationship_type.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.eifs_party_relationship_type.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.eifs_party_relationship_type.created_stamp is '创建时间';
comment on column ${iol_schema}.eifs_party_relationship_type.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.eifs_party_relationship_type.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_party_relationship_type.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_party_relationship_type.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_party_relationship_type.etl_timestamp is 'ETL处理时间戳';
