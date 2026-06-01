/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amis_ac_dispatch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amis_ac_dispatch
whenever sqlerror continue none;
drop table ${iol_schema}.amis_ac_dispatch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amis_ac_dispatch(
    ac_dispatch_uuid varchar2(96) -- 问责发文uuid
    ,dispatch_no varchar2(96) -- 发文文号
    ,dispatch_title varchar2(300) -- 发文标题
    ,dispatch_deaprtment_uuid varchar2(96) -- 发文单位uuid
    ,dispatch_deaprtment_name varchar2(96) -- 发文单位名称
    ,dispath_time timestamp -- 发文时间
    ,pm_asset_uuid varchar2(4000) -- 关联问题资产uuid
    ,pm_asset_name varchar2(4000) -- 关联问题资产名称
    ,pm_problem_uuid varchar2(384) -- 关联问题uuid
    ,pm_problem_name varchar2(384) -- 关联问题名称
    ,entry_person_uuid varchar2(96) -- 录入人uuid
    ,entry_person_name varchar2(96) -- 录入人名称
    ,entry_org_uuid varchar2(96) -- 录入机构uuid
    ,entry_org_name varchar2(96) -- 录入机构名称
    ,deleted number(1,0) -- 删除标识
    ,ac_project_uuid varchar2(96) -- 问责项目uuid
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
grant select on ${iol_schema}.amis_ac_dispatch to ${iml_schema};
grant select on ${iol_schema}.amis_ac_dispatch to ${icl_schema};
grant select on ${iol_schema}.amis_ac_dispatch to ${idl_schema};
grant select on ${iol_schema}.amis_ac_dispatch to ${iel_schema};

-- comment
comment on table ${iol_schema}.amis_ac_dispatch is '问责发文';
comment on column ${iol_schema}.amis_ac_dispatch.ac_dispatch_uuid is '问责发文uuid';
comment on column ${iol_schema}.amis_ac_dispatch.dispatch_no is '发文文号';
comment on column ${iol_schema}.amis_ac_dispatch.dispatch_title is '发文标题';
comment on column ${iol_schema}.amis_ac_dispatch.dispatch_deaprtment_uuid is '发文单位uuid';
comment on column ${iol_schema}.amis_ac_dispatch.dispatch_deaprtment_name is '发文单位名称';
comment on column ${iol_schema}.amis_ac_dispatch.dispath_time is '发文时间';
comment on column ${iol_schema}.amis_ac_dispatch.pm_asset_uuid is '关联问题资产uuid';
comment on column ${iol_schema}.amis_ac_dispatch.pm_asset_name is '关联问题资产名称';
comment on column ${iol_schema}.amis_ac_dispatch.pm_problem_uuid is '关联问题uuid';
comment on column ${iol_schema}.amis_ac_dispatch.pm_problem_name is '关联问题名称';
comment on column ${iol_schema}.amis_ac_dispatch.entry_person_uuid is '录入人uuid';
comment on column ${iol_schema}.amis_ac_dispatch.entry_person_name is '录入人名称';
comment on column ${iol_schema}.amis_ac_dispatch.entry_org_uuid is '录入机构uuid';
comment on column ${iol_schema}.amis_ac_dispatch.entry_org_name is '录入机构名称';
comment on column ${iol_schema}.amis_ac_dispatch.deleted is '删除标识';
comment on column ${iol_schema}.amis_ac_dispatch.ac_project_uuid is '问责项目uuid';
comment on column ${iol_schema}.amis_ac_dispatch.create_time is '创建时间';
comment on column ${iol_schema}.amis_ac_dispatch.start_dt is '开始时间';
comment on column ${iol_schema}.amis_ac_dispatch.end_dt is '结束时间';
comment on column ${iol_schema}.amis_ac_dispatch.id_mark is '增删标志';
comment on column ${iol_schema}.amis_ac_dispatch.etl_timestamp is 'ETL处理时间戳';
