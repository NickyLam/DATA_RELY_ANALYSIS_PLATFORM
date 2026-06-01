/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdws_a_cm_cust_clerk_mapping
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdws_a_cm_cust_clerk_mapping
whenever sqlerror continue none;
drop table ${iol_schema}.bdws_a_cm_cust_clerk_mapping purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdws_a_cm_cust_clerk_mapping(
    cust_id varchar2(4000) -- 客户号
    ,cust_name varchar2(4000) -- 客户名称
    ,sex varchar2(4000) -- 性别
    ,age number(4,0) -- 年龄
    ,birth_dt varchar2(4000) -- 出生日期
    ,doc_type varchar2(4000) -- 证件类型
    ,idenumber varchar2(4000) -- 证件号码
    ,phone varchar2(4000) -- 电话
    ,asset_lev varchar2(4000) -- 客户资产等级
    ,mag_cst_org_id varchar2(4000) -- 管户人所属机构ID
    ,mag_cst_org_name varchar2(4000) -- 管户人所属机构名称
    ,mag_cst_mgr_id varchar2(4000) -- 管户人ID
    ,mag_cst_mgr varchar2(4000) -- 管户人名称
    ,sys_user_id varchar2(4000) -- 共管人ID
    ,sys_user varchar2(4000) -- 共管人姓名
    ,gg_org_id varchar2(4000) -- 共管机构ID
    ,gg_org_name varchar2(4000) -- 共管机构名称
    ,is_hx_staff varchar2(4000) -- 是否我行员工
    ,clerk_id varchar2(4000) -- 我行员工号
    ,role_ids varchar2(4000) -- 拥有角色
    ,belong_org_id varchar2(4000) -- 员工所属机构ID
    ,belong_org_name varchar2(4000) -- 员工所属机构名称
    ,belong_brch_id varchar2(4000) -- 员工所属分行ID
    ,belong_brch_name varchar2(4000) -- 员工所属分行名称
    ,load_date varchar2(4000) -- 分区字段
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
grant select on ${iol_schema}.bdws_a_cm_cust_clerk_mapping to ${iml_schema};
grant select on ${iol_schema}.bdws_a_cm_cust_clerk_mapping to ${icl_schema};
grant select on ${iol_schema}.bdws_a_cm_cust_clerk_mapping to ${idl_schema};
grant select on ${iol_schema}.bdws_a_cm_cust_clerk_mapping to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdws_a_cm_cust_clerk_mapping is '客户员工映射表';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.cust_id is '客户号';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.cust_name is '客户名称';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.sex is '性别';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.age is '年龄';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.birth_dt is '出生日期';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.doc_type is '证件类型';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.idenumber is '证件号码';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.phone is '电话';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.asset_lev is '客户资产等级';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.mag_cst_org_id is '管户人所属机构ID';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.mag_cst_org_name is '管户人所属机构名称';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.mag_cst_mgr_id is '管户人ID';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.mag_cst_mgr is '管户人名称';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.sys_user_id is '共管人ID';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.sys_user is '共管人姓名';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.gg_org_id is '共管机构ID';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.gg_org_name is '共管机构名称';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.is_hx_staff is '是否我行员工';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.clerk_id is '我行员工号';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.role_ids is '拥有角色';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.belong_org_id is '员工所属机构ID';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.belong_org_name is '员工所属机构名称';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.belong_brch_id is '员工所属分行ID';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.belong_brch_name is '员工所属分行名称';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.load_date is '分区字段';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdws_a_cm_cust_clerk_mapping.etl_timestamp is 'ETL处理时间戳';
