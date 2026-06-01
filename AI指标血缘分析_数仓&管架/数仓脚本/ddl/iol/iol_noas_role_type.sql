/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol noas_role_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.noas_role_type
whenever sqlerror continue none;
drop table ${iol_schema}.noas_role_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.noas_role_type(
    role_type_id varchar2(30) -- 主键
    ,description varchar2(383) -- 角色名
    ,last_updated_stamp timestamp -- bosent自带最后修改时间
    ,last_updated_tx_stamp timestamp -- bosent自带最后修改时间
    ,created_stamp timestamp -- bosent自带创建时间
    ,created_tx_stamp timestamp -- bosent自带创建时间
    ,role_attribute varchar2(30) -- 角色归属(枚举值: 1-总行 2-分行 3-总分行)
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
grant select on ${iol_schema}.noas_role_type to ${iml_schema};
grant select on ${iol_schema}.noas_role_type to ${icl_schema};
grant select on ${iol_schema}.noas_role_type to ${idl_schema};
grant select on ${iol_schema}.noas_role_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.noas_role_type is '角色表';
comment on column ${iol_schema}.noas_role_type.role_type_id is '主键';
comment on column ${iol_schema}.noas_role_type.description is '角色名';
comment on column ${iol_schema}.noas_role_type.last_updated_stamp is 'bosent自带最后修改时间';
comment on column ${iol_schema}.noas_role_type.last_updated_tx_stamp is 'bosent自带最后修改时间';
comment on column ${iol_schema}.noas_role_type.created_stamp is 'bosent自带创建时间';
comment on column ${iol_schema}.noas_role_type.created_tx_stamp is 'bosent自带创建时间';
comment on column ${iol_schema}.noas_role_type.role_attribute is '角色归属(枚举值: 1-总行 2-分行 3-总分行)';
comment on column ${iol_schema}.noas_role_type.start_dt is '开始时间';
comment on column ${iol_schema}.noas_role_type.end_dt is '结束时间';
comment on column ${iol_schema}.noas_role_type.id_mark is '增删标志';
comment on column ${iol_schema}.noas_role_type.etl_timestamp is 'ETL处理时间戳';
