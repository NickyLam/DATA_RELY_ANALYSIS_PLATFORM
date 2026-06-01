/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol hgls_loan_branch_website
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.hgls_loan_branch_website
whenever sqlerror continue none;
drop table ${iol_schema}.hgls_loan_branch_website purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.hgls_loan_branch_website(
    id number(22,0) -- 主键id
    ,bank_name varchar2(4000) -- 支行名称
    ,bank_phone varchar2(4000) -- 支行电话
    ,province_region varchar2(4000) -- 支行住址的省市区,多级斜杠隔开
    ,address varchar2(4000) -- 支行具体地址
    ,start_time varchar2(4000) -- 营业开始时间
    ,end_time varchar2(4000) -- 营业结束时间
    ,system_type varchar2(4000) -- 系统类型，1，业务系统，2营销系统
    ,enterprise_code varchar2(4000) -- 企业注册码
    ,org_num varchar2(4000) -- 机构号
    ,busi_cover_area varchar2(4000) -- 业务覆盖区域
    ,create_date timestamp -- 申请日期
    ,update_date timestamp -- 更新时间
    ,isdel number(22,0) -- 删除标识
    ,code varchar2(4000) -- 唯一编码
    ,bank_credit_accounts varchar2(4000) -- 机构征信查询账户
    ,bank_credit_recheck_user varchar2(4000) -- 机构征信复核用户
    ,parent_code varchar2(4000) -- 上级机构code
    ,org_type varchar2(4000) -- 机构类型，1：总行2：分行3：支行
    ,org_level number(22,0) -- 机构层级，总行一级，下级依次递增，最多不超过六级
    ,corporcate_bank_num varchar2(4000) -- 法人行行号
    ,corporate_name varchar2(4000) -- 企业名称（合同用）
    ,core_org_num varchar2(4000) -- 核心机构号
    ,business_label varchar2(4000) -- 行业客群标签
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
grant select on ${iol_schema}.hgls_loan_branch_website to ${iml_schema};
grant select on ${iol_schema}.hgls_loan_branch_website to ${icl_schema};
grant select on ${iol_schema}.hgls_loan_branch_website to ${idl_schema};
grant select on ${iol_schema}.hgls_loan_branch_website to ${iel_schema};

-- comment
comment on table ${iol_schema}.hgls_loan_branch_website is '支行网点信息';
comment on column ${iol_schema}.hgls_loan_branch_website.id is '主键id';
comment on column ${iol_schema}.hgls_loan_branch_website.bank_name is '支行名称';
comment on column ${iol_schema}.hgls_loan_branch_website.bank_phone is '支行电话';
comment on column ${iol_schema}.hgls_loan_branch_website.province_region is '支行住址的省市区,多级斜杠隔开';
comment on column ${iol_schema}.hgls_loan_branch_website.address is '支行具体地址';
comment on column ${iol_schema}.hgls_loan_branch_website.start_time is '营业开始时间';
comment on column ${iol_schema}.hgls_loan_branch_website.end_time is '营业结束时间';
comment on column ${iol_schema}.hgls_loan_branch_website.system_type is '系统类型，1，业务系统，2营销系统';
comment on column ${iol_schema}.hgls_loan_branch_website.enterprise_code is '企业注册码';
comment on column ${iol_schema}.hgls_loan_branch_website.org_num is '机构号';
comment on column ${iol_schema}.hgls_loan_branch_website.busi_cover_area is '业务覆盖区域';
comment on column ${iol_schema}.hgls_loan_branch_website.create_date is '申请日期';
comment on column ${iol_schema}.hgls_loan_branch_website.update_date is '更新时间';
comment on column ${iol_schema}.hgls_loan_branch_website.isdel is '删除标识';
comment on column ${iol_schema}.hgls_loan_branch_website.code is '唯一编码';
comment on column ${iol_schema}.hgls_loan_branch_website.bank_credit_accounts is '机构征信查询账户';
comment on column ${iol_schema}.hgls_loan_branch_website.bank_credit_recheck_user is '机构征信复核用户';
comment on column ${iol_schema}.hgls_loan_branch_website.parent_code is '上级机构code';
comment on column ${iol_schema}.hgls_loan_branch_website.org_type is '机构类型，1：总行2：分行3：支行';
comment on column ${iol_schema}.hgls_loan_branch_website.org_level is '机构层级，总行一级，下级依次递增，最多不超过六级';
comment on column ${iol_schema}.hgls_loan_branch_website.corporcate_bank_num is '法人行行号';
comment on column ${iol_schema}.hgls_loan_branch_website.corporate_name is '企业名称（合同用）';
comment on column ${iol_schema}.hgls_loan_branch_website.core_org_num is '核心机构号';
comment on column ${iol_schema}.hgls_loan_branch_website.business_label is '行业客群标签';
comment on column ${iol_schema}.hgls_loan_branch_website.start_dt is '开始时间';
comment on column ${iol_schema}.hgls_loan_branch_website.end_dt is '结束时间';
comment on column ${iol_schema}.hgls_loan_branch_website.id_mark is '增删标志';
comment on column ${iol_schema}.hgls_loan_branch_website.etl_timestamp is 'ETL处理时间戳';
