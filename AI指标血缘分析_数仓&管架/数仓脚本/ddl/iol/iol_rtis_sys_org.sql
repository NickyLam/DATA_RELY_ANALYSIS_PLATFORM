/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rtis_sys_org
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rtis_sys_org
whenever sqlerror continue none;
drop table ${iol_schema}.rtis_sys_org purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rtis_sys_org(
    id_ varchar2(12) -- 机构编号
    ,parent_id varchar2(20) -- 上级机构ID
    ,full_path varchar2(100) -- 机构路径
    ,name_ varchar2(200) -- 机构名称
    ,type_ varchar2(10) -- 类型 ORG-机构， DEP-部门
    ,contact varchar2(50) -- 联系人
    ,mobile varchar2(50) -- 负责人姓名
    ,comments varchar2(400) -- 机构描述
    ,create_time timestamp -- 创建时间
    ,update_time timestamp -- 更新时间
    ,create_by varchar2(100) -- 创建人
    ,update_by varchar2(100) -- 更新人
    ,org_area varchar2(100) -- 管理区域
    ,handle_org varchar2(20) -- HANDLE ORG
    ,org_level varchar2(2) -- 机构级别
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
grant select on ${iol_schema}.rtis_sys_org to ${iml_schema};
grant select on ${iol_schema}.rtis_sys_org to ${icl_schema};
grant select on ${iol_schema}.rtis_sys_org to ${idl_schema};
grant select on ${iol_schema}.rtis_sys_org to ${iel_schema};

-- comment
comment on table ${iol_schema}.rtis_sys_org is '机构信息表';
comment on column ${iol_schema}.rtis_sys_org.id_ is '机构编号';
comment on column ${iol_schema}.rtis_sys_org.parent_id is '上级机构ID';
comment on column ${iol_schema}.rtis_sys_org.full_path is '机构路径';
comment on column ${iol_schema}.rtis_sys_org.name_ is '机构名称';
comment on column ${iol_schema}.rtis_sys_org.type_ is '类型 ORG-机构， DEP-部门';
comment on column ${iol_schema}.rtis_sys_org.contact is '联系人';
comment on column ${iol_schema}.rtis_sys_org.mobile is '负责人姓名';
comment on column ${iol_schema}.rtis_sys_org.comments is '机构描述';
comment on column ${iol_schema}.rtis_sys_org.create_time is '创建时间';
comment on column ${iol_schema}.rtis_sys_org.update_time is '更新时间';
comment on column ${iol_schema}.rtis_sys_org.create_by is '创建人';
comment on column ${iol_schema}.rtis_sys_org.update_by is '更新人';
comment on column ${iol_schema}.rtis_sys_org.org_area is '管理区域';
comment on column ${iol_schema}.rtis_sys_org.handle_org is 'HANDLE ORG';
comment on column ${iol_schema}.rtis_sys_org.org_level is '机构级别';
comment on column ${iol_schema}.rtis_sys_org.start_dt is '开始时间';
comment on column ${iol_schema}.rtis_sys_org.end_dt is '结束时间';
comment on column ${iol_schema}.rtis_sys_org.id_mark is '增删标志';
comment on column ${iol_schema}.rtis_sys_org.etl_timestamp is 'ETL处理时间戳';
