/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_prd_policy
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_prd_policy
whenever sqlerror continue none;
drop table ${iol_schema}.icms_prd_policy purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_prd_policy(
    policyid varchar2(64) -- 产品政策编号
    ,deptline varchar2(64) -- 适用部门条线
    ,productid varchar2(64) -- 产品编号
    ,inputuserid varchar2(64) -- 登记人
    ,policydesc varchar2(2000) -- 产品政策描述
    ,changerule varchar2(12) -- 产品政策变更规则
    ,updateuserid varchar2(64) -- 更新人
    ,expirydate date -- 失效日期
    ,corporgid varchar2(64) -- 法人机构编号
    ,policyname varchar2(160) -- 产品政策名称
    ,policyversionid varchar2(64) -- 有效版本编号
    ,relamodelno varchar2(64) -- 政策关联模型编号
    ,basemodelno varchar2(64) -- 政策基础模型编号
    ,effectivedate date -- 生效日期
    ,inputdate date -- 登记日期
    ,updateorgid varchar2(64) -- 更新机构
    ,policystatus varchar2(12) -- 政策状态
    ,inputorgid varchar2(64) -- 登记机构
    ,updatedate date -- 更新日期
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
grant select on ${iol_schema}.icms_prd_policy to ${iml_schema};
grant select on ${iol_schema}.icms_prd_policy to ${icl_schema};
grant select on ${iol_schema}.icms_prd_policy to ${idl_schema};
grant select on ${iol_schema}.icms_prd_policy to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_prd_policy is '产品政策表产品政策';
comment on column ${iol_schema}.icms_prd_policy.policyid is '产品政策编号';
comment on column ${iol_schema}.icms_prd_policy.deptline is '适用部门条线';
comment on column ${iol_schema}.icms_prd_policy.productid is '产品编号';
comment on column ${iol_schema}.icms_prd_policy.inputuserid is '登记人';
comment on column ${iol_schema}.icms_prd_policy.policydesc is '产品政策描述';
comment on column ${iol_schema}.icms_prd_policy.changerule is '产品政策变更规则';
comment on column ${iol_schema}.icms_prd_policy.updateuserid is '更新人';
comment on column ${iol_schema}.icms_prd_policy.expirydate is '失效日期';
comment on column ${iol_schema}.icms_prd_policy.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_prd_policy.policyname is '产品政策名称';
comment on column ${iol_schema}.icms_prd_policy.policyversionid is '有效版本编号';
comment on column ${iol_schema}.icms_prd_policy.relamodelno is '政策关联模型编号';
comment on column ${iol_schema}.icms_prd_policy.basemodelno is '政策基础模型编号';
comment on column ${iol_schema}.icms_prd_policy.effectivedate is '生效日期';
comment on column ${iol_schema}.icms_prd_policy.inputdate is '登记日期';
comment on column ${iol_schema}.icms_prd_policy.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_prd_policy.policystatus is '政策状态';
comment on column ${iol_schema}.icms_prd_policy.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_prd_policy.updatedate is '更新日期';
comment on column ${iol_schema}.icms_prd_policy.start_dt is '开始时间';
comment on column ${iol_schema}.icms_prd_policy.end_dt is '结束时间';
comment on column ${iol_schema}.icms_prd_policy.id_mark is '增删标志';
comment on column ${iol_schema}.icms_prd_policy.etl_timestamp is 'ETL处理时间戳';
