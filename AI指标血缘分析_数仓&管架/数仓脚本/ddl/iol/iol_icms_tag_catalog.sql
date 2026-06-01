/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_tag_catalog
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_tag_catalog
whenever sqlerror continue none;
drop table ${iol_schema}.icms_tag_catalog purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_tag_catalog(
    tagid varchar2(32) -- 流水号
    ,tagname varchar2(2000) -- 标签名称
    ,tagtype varchar2(64) -- 标签类型
    ,tagcode varchar2(4000) -- 标签码值
    ,tagcodeflag varchar2(10) -- 是否落标码值
    ,tagstatus varchar2(10) -- 标签状态
    ,taghirearchy varchar2(10) -- 标签层级
    ,remark varchar2(3000) -- 标签说明
    ,completeflag varchar2(2) -- 完善标识
    ,managerorgid varchar2(64) -- 管理部门编号
    ,manageruserid varchar2(64) -- 管理人
    ,migtflag varchar2(80) -- 迁移标识
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记人所属机构
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,tagmaintenancetype varchar2(10) -- 标签维护类型
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_tag_catalog to ${iml_schema};
grant select on ${iol_schema}.icms_tag_catalog to ${icl_schema};
grant select on ${iol_schema}.icms_tag_catalog to ${idl_schema};
grant select on ${iol_schema}.icms_tag_catalog to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_tag_catalog is '标签目录表';
comment on column ${iol_schema}.icms_tag_catalog.tagid is '流水号';
comment on column ${iol_schema}.icms_tag_catalog.tagname is '标签名称';
comment on column ${iol_schema}.icms_tag_catalog.tagtype is '标签类型';
comment on column ${iol_schema}.icms_tag_catalog.tagcode is '标签码值';
comment on column ${iol_schema}.icms_tag_catalog.tagcodeflag is '是否落标码值';
comment on column ${iol_schema}.icms_tag_catalog.tagstatus is '标签状态';
comment on column ${iol_schema}.icms_tag_catalog.taghirearchy is '标签层级';
comment on column ${iol_schema}.icms_tag_catalog.remark is '标签说明';
comment on column ${iol_schema}.icms_tag_catalog.completeflag is '完善标识';
comment on column ${iol_schema}.icms_tag_catalog.managerorgid is '管理部门编号';
comment on column ${iol_schema}.icms_tag_catalog.manageruserid is '管理人';
comment on column ${iol_schema}.icms_tag_catalog.migtflag is '迁移标识';
comment on column ${iol_schema}.icms_tag_catalog.inputuserid is '登记人';
comment on column ${iol_schema}.icms_tag_catalog.inputorgid is '登记人所属机构';
comment on column ${iol_schema}.icms_tag_catalog.inputdate is '登记时间';
comment on column ${iol_schema}.icms_tag_catalog.updateuserid is '更新人';
comment on column ${iol_schema}.icms_tag_catalog.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_tag_catalog.updatedate is '更新日期';
comment on column ${iol_schema}.icms_tag_catalog.tagmaintenancetype is '标签维护类型';
comment on column ${iol_schema}.icms_tag_catalog.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_tag_catalog.etl_timestamp is 'ETL处理时间戳';
