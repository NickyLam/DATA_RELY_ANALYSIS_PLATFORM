/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cl_business_manual_relation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cl_business_manual_relation
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cl_business_manual_relation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_business_manual_relation(
    updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,inputdate date -- 登记日期
    ,inputorgid varchar2(64) -- 登记机构
    ,relaserialno varchar2(64) -- 关联流水号
    ,creditno varchar2(64) -- 额度编号
    ,customerid varchar2(64) -- 客户编号
    ,sourcecreditno varchar2(48) -- 来源系统额度编号
    ,occupyrole varchar2(64) -- 占用角色
    ,sourcesystem varchar2(48) -- 来源系统
    ,inputuserid varchar2(64) -- 登记人
    ,updatedate date -- 更新日期
    ,serialno varchar2(64) -- 流水号
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
grant select on ${iol_schema}.icms_cl_business_manual_relation to ${iml_schema};
grant select on ${iol_schema}.icms_cl_business_manual_relation to ${icl_schema};
grant select on ${iol_schema}.icms_cl_business_manual_relation to ${idl_schema};
grant select on ${iol_schema}.icms_cl_business_manual_relation to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cl_business_manual_relation is '手工登记业务与额度关联表';
comment on column ${iol_schema}.icms_cl_business_manual_relation.updateuserid is '更新人';
comment on column ${iol_schema}.icms_cl_business_manual_relation.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_cl_business_manual_relation.inputdate is '登记日期';
comment on column ${iol_schema}.icms_cl_business_manual_relation.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_cl_business_manual_relation.relaserialno is '关联流水号';
comment on column ${iol_schema}.icms_cl_business_manual_relation.creditno is '额度编号';
comment on column ${iol_schema}.icms_cl_business_manual_relation.customerid is '客户编号';
comment on column ${iol_schema}.icms_cl_business_manual_relation.sourcecreditno is '来源系统额度编号';
comment on column ${iol_schema}.icms_cl_business_manual_relation.occupyrole is '占用角色';
comment on column ${iol_schema}.icms_cl_business_manual_relation.sourcesystem is '来源系统';
comment on column ${iol_schema}.icms_cl_business_manual_relation.inputuserid is '登记人';
comment on column ${iol_schema}.icms_cl_business_manual_relation.updatedate is '更新日期';
comment on column ${iol_schema}.icms_cl_business_manual_relation.serialno is '流水号';
comment on column ${iol_schema}.icms_cl_business_manual_relation.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_cl_business_manual_relation.etl_timestamp is 'ETL处理时间戳';
