/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_prd_policy_version
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_prd_policy_version
whenever sqlerror continue none;
drop table ${iol_schema}.icms_prd_policy_version purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_prd_policy_version(
    versionid varchar2(64) -- 版本编号
    ,corporgid varchar2(64) -- 法人机构编号
    ,inputorgid varchar2(64) -- 登记机构
    ,startdate date -- 开始执行日期
    ,updateuserid varchar2(64) -- 更新人
    ,updatedate date -- 更新日期
    ,productid varchar2(48) -- 产品编号
    ,effectivedate date -- 生效日期
    ,expirydate date -- 失效日期
    ,remark varchar2(2000) -- 备注
    ,versionname varchar2(160) -- 版本名称
    ,inputdate date -- 登记日期
    ,policyid varchar2(64) -- 政策编号
    ,updateorgid varchar2(64) -- 更新机构
    ,relacomponents varchar2(4000) -- 引入关联组件
    ,versionstatus varchar2(12) -- 版本状态
    ,inputuserid varchar2(64) -- 登记人
    ,basecomponents varchar2(4000) -- 引入基础组件
    ,versiondesc varchar2(2000) -- 版本说明
    ,title varchar2(200) -- 
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
grant select on ${iol_schema}.icms_prd_policy_version to ${iml_schema};
grant select on ${iol_schema}.icms_prd_policy_version to ${icl_schema};
grant select on ${iol_schema}.icms_prd_policy_version to ${idl_schema};
grant select on ${iol_schema}.icms_prd_policy_version to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_prd_policy_version is '产品政策版本表';
comment on column ${iol_schema}.icms_prd_policy_version.versionid is '版本编号';
comment on column ${iol_schema}.icms_prd_policy_version.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_prd_policy_version.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_prd_policy_version.startdate is '开始执行日期';
comment on column ${iol_schema}.icms_prd_policy_version.updateuserid is '更新人';
comment on column ${iol_schema}.icms_prd_policy_version.updatedate is '更新日期';
comment on column ${iol_schema}.icms_prd_policy_version.productid is '产品编号';
comment on column ${iol_schema}.icms_prd_policy_version.effectivedate is '生效日期';
comment on column ${iol_schema}.icms_prd_policy_version.expirydate is '失效日期';
comment on column ${iol_schema}.icms_prd_policy_version.remark is '备注';
comment on column ${iol_schema}.icms_prd_policy_version.versionname is '版本名称';
comment on column ${iol_schema}.icms_prd_policy_version.inputdate is '登记日期';
comment on column ${iol_schema}.icms_prd_policy_version.policyid is '政策编号';
comment on column ${iol_schema}.icms_prd_policy_version.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_prd_policy_version.relacomponents is '引入关联组件';
comment on column ${iol_schema}.icms_prd_policy_version.versionstatus is '版本状态';
comment on column ${iol_schema}.icms_prd_policy_version.inputuserid is '登记人';
comment on column ${iol_schema}.icms_prd_policy_version.basecomponents is '引入基础组件';
comment on column ${iol_schema}.icms_prd_policy_version.versiondesc is '版本说明';
comment on column ${iol_schema}.icms_prd_policy_version.title is '';
comment on column ${iol_schema}.icms_prd_policy_version.start_dt is '开始时间';
comment on column ${iol_schema}.icms_prd_policy_version.end_dt is '结束时间';
comment on column ${iol_schema}.icms_prd_policy_version.id_mark is '增删标志';
comment on column ${iol_schema}.icms_prd_policy_version.etl_timestamp is 'ETL处理时间戳';
