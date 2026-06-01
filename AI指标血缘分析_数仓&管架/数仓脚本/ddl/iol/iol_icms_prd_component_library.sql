/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_prd_component_library
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_prd_component_library
whenever sqlerror continue none;
drop table ${iol_schema}.icms_prd_component_library purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_prd_component_library(
    serialno varchar2(64) -- 流水号
    ,iscatalog varchar2(2) -- 是否目录
    ,componentid varchar2(64) -- 组件编号
    ,corporgid varchar2(64) -- 法人机构编号
    ,inputdate date -- 登记日期
    ,sortno varchar2(64) -- 排序号
    ,parentserialno varchar2(64) -- 父目录编号
    ,updateuserid varchar2(64) -- 更新人
    ,deleteflag varchar2(12) -- 删除标识
    ,updatedate date -- 更新日期
    ,inputorgid varchar2(64) -- 登记机构
    ,inputuserid varchar2(64) -- 登记人
    ,updateorgid varchar2(64) -- 更新机构
    ,componentname varchar2(160) -- 组件名称
    ,componenttype varchar2(12) -- 组件类型
    ,remark varchar2(2000) -- 备注
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
grant select on ${iol_schema}.icms_prd_component_library to ${iml_schema};
grant select on ${iol_schema}.icms_prd_component_library to ${icl_schema};
grant select on ${iol_schema}.icms_prd_component_library to ${idl_schema};
grant select on ${iol_schema}.icms_prd_component_library to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_prd_component_library is '产品组件库产品组件库';
comment on column ${iol_schema}.icms_prd_component_library.serialno is '流水号';
comment on column ${iol_schema}.icms_prd_component_library.iscatalog is '是否目录';
comment on column ${iol_schema}.icms_prd_component_library.componentid is '组件编号';
comment on column ${iol_schema}.icms_prd_component_library.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_prd_component_library.inputdate is '登记日期';
comment on column ${iol_schema}.icms_prd_component_library.sortno is '排序号';
comment on column ${iol_schema}.icms_prd_component_library.parentserialno is '父目录编号';
comment on column ${iol_schema}.icms_prd_component_library.updateuserid is '更新人';
comment on column ${iol_schema}.icms_prd_component_library.deleteflag is '删除标识';
comment on column ${iol_schema}.icms_prd_component_library.updatedate is '更新日期';
comment on column ${iol_schema}.icms_prd_component_library.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_prd_component_library.inputuserid is '登记人';
comment on column ${iol_schema}.icms_prd_component_library.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_prd_component_library.componentname is '组件名称';
comment on column ${iol_schema}.icms_prd_component_library.componenttype is '组件类型';
comment on column ${iol_schema}.icms_prd_component_library.remark is '备注';
comment on column ${iol_schema}.icms_prd_component_library.start_dt is '开始时间';
comment on column ${iol_schema}.icms_prd_component_library.end_dt is '结束时间';
comment on column ${iol_schema}.icms_prd_component_library.id_mark is '增删标志';
comment on column ${iol_schema}.icms_prd_component_library.etl_timestamp is 'ETL处理时间戳';
