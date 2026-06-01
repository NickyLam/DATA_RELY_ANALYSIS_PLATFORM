/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_prd_policy_org
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_prd_policy_org
whenever sqlerror continue none;
drop table ${iol_schema}.icms_prd_policy_org purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_prd_policy_org(
    policyid varchar2(64) -- 政策编号
    ,orgid varchar2(64) -- 机构编号
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateorgid varchar2(64) -- 更新机构
    ,updateuserid varchar2(64) -- 更新人
    ,inputuserid varchar2(64) -- 登记人
    ,updatedate date -- 更新日期
    ,corporgid varchar2(64) -- 法人机构编号
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
grant select on ${iol_schema}.icms_prd_policy_org to ${iml_schema};
grant select on ${iol_schema}.icms_prd_policy_org to ${icl_schema};
grant select on ${iol_schema}.icms_prd_policy_org to ${idl_schema};
grant select on ${iol_schema}.icms_prd_policy_org to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_prd_policy_org is '产品政策适用机构表';
comment on column ${iol_schema}.icms_prd_policy_org.policyid is '政策编号';
comment on column ${iol_schema}.icms_prd_policy_org.orgid is '机构编号';
comment on column ${iol_schema}.icms_prd_policy_org.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_prd_policy_org.inputdate is '登记日期';
comment on column ${iol_schema}.icms_prd_policy_org.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_prd_policy_org.updateuserid is '更新人';
comment on column ${iol_schema}.icms_prd_policy_org.inputuserid is '登记人';
comment on column ${iol_schema}.icms_prd_policy_org.updatedate is '更新日期';
comment on column ${iol_schema}.icms_prd_policy_org.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_prd_policy_org.start_dt is '开始时间';
comment on column ${iol_schema}.icms_prd_policy_org.end_dt is '结束时间';
comment on column ${iol_schema}.icms_prd_policy_org.id_mark is '增删标志';
comment on column ${iol_schema}.icms_prd_policy_org.etl_timestamp is 'ETL处理时间戳';
