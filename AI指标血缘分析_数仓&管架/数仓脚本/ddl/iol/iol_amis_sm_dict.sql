/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amis_sm_dict
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amis_sm_dict
whenever sqlerror continue none;
drop table ${iol_schema}.amis_sm_dict purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amis_sm_dict(
    sm_dict_uuid varchar2(96) -- 参数类别主键uuid
    ,dict_code varchar2(48) -- 参数类别编号
    ,dict_name varchar2(384) -- 参数类别名称
    ,dict_desc varchar2(4000) -- 参数类别描述
    ,edit number(1,0) -- 系统参数标志
    ,del_flag number(1,0) -- 删除标志
    ,create_person_uuid varchar2(96) -- 创建人uuid
    ,create_person_name varchar2(384) -- 创建人姓名
    ,create_org_name varchar2(384) -- 创建机构
    ,create_time timestamp -- 创建时间
    ,edit_desc varchar2(150) -- 系统参数标志描述
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
grant select on ${iol_schema}.amis_sm_dict to ${iml_schema};
grant select on ${iol_schema}.amis_sm_dict to ${icl_schema};
grant select on ${iol_schema}.amis_sm_dict to ${idl_schema};
grant select on ${iol_schema}.amis_sm_dict to ${iel_schema};

-- comment
comment on table ${iol_schema}.amis_sm_dict is '词典参数类别表';
comment on column ${iol_schema}.amis_sm_dict.sm_dict_uuid is '参数类别主键uuid';
comment on column ${iol_schema}.amis_sm_dict.dict_code is '参数类别编号';
comment on column ${iol_schema}.amis_sm_dict.dict_name is '参数类别名称';
comment on column ${iol_schema}.amis_sm_dict.dict_desc is '参数类别描述';
comment on column ${iol_schema}.amis_sm_dict.edit is '系统参数标志';
comment on column ${iol_schema}.amis_sm_dict.del_flag is '删除标志';
comment on column ${iol_schema}.amis_sm_dict.create_person_uuid is '创建人uuid';
comment on column ${iol_schema}.amis_sm_dict.create_person_name is '创建人姓名';
comment on column ${iol_schema}.amis_sm_dict.create_org_name is '创建机构';
comment on column ${iol_schema}.amis_sm_dict.create_time is '创建时间';
comment on column ${iol_schema}.amis_sm_dict.edit_desc is '系统参数标志描述';
comment on column ${iol_schema}.amis_sm_dict.start_dt is '开始时间';
comment on column ${iol_schema}.amis_sm_dict.end_dt is '结束时间';
comment on column ${iol_schema}.amis_sm_dict.id_mark is '增删标志';
comment on column ${iol_schema}.amis_sm_dict.etl_timestamp is 'ETL处理时间戳';
