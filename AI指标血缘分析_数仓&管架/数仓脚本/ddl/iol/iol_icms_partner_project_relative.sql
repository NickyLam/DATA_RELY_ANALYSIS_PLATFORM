/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_partner_project_relative
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_partner_project_relative
whenever sqlerror continue none;
drop table ${iol_schema}.icms_partner_project_relative purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_partner_project_relative(
    objecttype varchar2(36) -- 合作项目类型
    ,objectno varchar2(64) -- 合作项目编号
    ,accessorytype varchar2(36) -- 附属信息类型
    ,accessoryno varchar2(64) -- 附属信息编号
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,updateuserid varchar2(64) -- 更新人
    ,corporgid varchar2(64) -- 法人机构编号
    ,updateorgid varchar2(64) -- 更新机构
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,updatedate date -- 更新日期
    ,inputdate date -- 登记日期
    ,accessoryname varchar2(200) -- 附属信息名称
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
grant select on ${iol_schema}.icms_partner_project_relative to ${iml_schema};
grant select on ${iol_schema}.icms_partner_project_relative to ${icl_schema};
grant select on ${iol_schema}.icms_partner_project_relative to ${idl_schema};
grant select on ${iol_schema}.icms_partner_project_relative to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_partner_project_relative is '项目关联信息项目关联信息';
comment on column ${iol_schema}.icms_partner_project_relative.objecttype is '合作项目类型';
comment on column ${iol_schema}.icms_partner_project_relative.objectno is '合作项目编号';
comment on column ${iol_schema}.icms_partner_project_relative.accessorytype is '附属信息类型';
comment on column ${iol_schema}.icms_partner_project_relative.accessoryno is '附属信息编号';
comment on column ${iol_schema}.icms_partner_project_relative.inputuserid is '登记人';
comment on column ${iol_schema}.icms_partner_project_relative.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_partner_project_relative.updateuserid is '更新人';
comment on column ${iol_schema}.icms_partner_project_relative.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_partner_project_relative.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_partner_project_relative.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_partner_project_relative.updatedate is '更新日期';
comment on column ${iol_schema}.icms_partner_project_relative.inputdate is '登记日期';
comment on column ${iol_schema}.icms_partner_project_relative.accessoryname is '附属信息名称';
comment on column ${iol_schema}.icms_partner_project_relative.start_dt is '开始时间';
comment on column ${iol_schema}.icms_partner_project_relative.end_dt is '结束时间';
comment on column ${iol_schema}.icms_partner_project_relative.id_mark is '增删标志';
comment on column ${iol_schema}.icms_partner_project_relative.etl_timestamp is 'ETL处理时间戳';
