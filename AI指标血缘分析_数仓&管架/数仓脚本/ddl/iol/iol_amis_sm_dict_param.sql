/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amis_sm_dict_param
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amis_sm_dict_param
whenever sqlerror continue none;
drop table ${iol_schema}.amis_sm_dict_param purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amis_sm_dict_param(
    sm_dict_param_uuid varchar2(96) -- 参数码表主键uuid
    ,sm_dict_uuid varchar2(96) -- 参数类别uuid
    ,dict_param_code varchar2(96) -- 参数编号
    ,dict_param_name varchar2(4000) -- 参数名称
    ,dict_param_desc varchar2(4000) -- 参数描述
    ,dict_param_seq number(5,0) -- 参数排序号
    ,edit number(1,0) -- 系统参数标志
    ,del_flag number(1,0) -- 删除标志
    ,dict_param_ext1 varchar2(384) -- 扩展字段
    ,parent_uuid varchar2(96) -- 父节点uuid
    ,create_person_uuid varchar2(96) -- 创建人uuid
    ,create_person_name varchar2(384) -- 创建人姓名
    ,create_org_name varchar2(384) -- 创建机构
    ,create_time timestamp -- 创建时间
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
grant select on ${iol_schema}.amis_sm_dict_param to ${iml_schema};
grant select on ${iol_schema}.amis_sm_dict_param to ${icl_schema};
grant select on ${iol_schema}.amis_sm_dict_param to ${idl_schema};
grant select on ${iol_schema}.amis_sm_dict_param to ${iel_schema};

-- comment
comment on table ${iol_schema}.amis_sm_dict_param is '词典参数码表';
comment on column ${iol_schema}.amis_sm_dict_param.sm_dict_param_uuid is '参数码表主键uuid';
comment on column ${iol_schema}.amis_sm_dict_param.sm_dict_uuid is '参数类别uuid';
comment on column ${iol_schema}.amis_sm_dict_param.dict_param_code is '参数编号';
comment on column ${iol_schema}.amis_sm_dict_param.dict_param_name is '参数名称';
comment on column ${iol_schema}.amis_sm_dict_param.dict_param_desc is '参数描述';
comment on column ${iol_schema}.amis_sm_dict_param.dict_param_seq is '参数排序号';
comment on column ${iol_schema}.amis_sm_dict_param.edit is '系统参数标志';
comment on column ${iol_schema}.amis_sm_dict_param.del_flag is '删除标志';
comment on column ${iol_schema}.amis_sm_dict_param.dict_param_ext1 is '扩展字段';
comment on column ${iol_schema}.amis_sm_dict_param.parent_uuid is '父节点uuid';
comment on column ${iol_schema}.amis_sm_dict_param.create_person_uuid is '创建人uuid';
comment on column ${iol_schema}.amis_sm_dict_param.create_person_name is '创建人姓名';
comment on column ${iol_schema}.amis_sm_dict_param.create_org_name is '创建机构';
comment on column ${iol_schema}.amis_sm_dict_param.create_time is '创建时间';
comment on column ${iol_schema}.amis_sm_dict_param.start_dt is '开始时间';
comment on column ${iol_schema}.amis_sm_dict_param.end_dt is '结束时间';
comment on column ${iol_schema}.amis_sm_dict_param.id_mark is '增删标志';
comment on column ${iol_schema}.amis_sm_dict_param.etl_timestamp is 'ETL处理时间戳';
