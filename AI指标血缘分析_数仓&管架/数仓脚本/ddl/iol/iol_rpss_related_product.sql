/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rpss_related_product
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rpss_related_product
whenever sqlerror continue none;
drop table ${iol_schema}.rpss_related_product purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rpss_related_product(
    related_id varchar2(20) -- 关联方编号
    ,person_name varchar2(100) -- 关联方名称
    ,certificate_type_id varchar2(20) -- 证件类型
    ,certificate_no varchar2(60) -- 证件号码
    ,domestic_or_foreign varchar2(20) -- 证件类型境内外1
    ,shareholding_ratio varchar2(20) -- 持股比例
    ,organization varchar2(60) -- 所属机构
    ,department varchar2(100) -- 所属部门
    ,belong_org varchar2(60) -- 归属机构
    ,mainten_org varchar2(60) -- 维护机构
    ,certificate_type_id_t varchar2(20) -- 证件类型2
    ,certificate_no_t varchar2(60) -- 证件号码2
    ,domestic_or_foreign_t varchar2(20) -- 证件类型境内外2
    ,product_name varchar2(200) -- 金融产品全称
    ,product_issue_no varchar2(100) -- 产品批准/注册/备案号
    ,product_register_no varchar2(100) -- 产品代码
    ,product_type varchar2(10) -- 产品分类
    ,register_org varchar2(100) -- 产品登记机构
    ,product_owner varchar2(100) -- 产品管理人全称
    ,product_owner_unisc_code varchar2(40) -- 产品管理人统一社会信用代码
    ,product_custodian varchar2(100) -- 产品托管人全称
    ,product_custodian_unisc_code varchar2(40) -- 产品托管人统一社会信用代码
    ,comments varchar2(256) -- 备注
    ,last_updated_stamp timestamp -- 
    ,last_updated_tx_stamp timestamp -- 
    ,created_stamp timestamp -- 
    ,created_tx_stamp timestamp -- 
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
grant select on ${iol_schema}.rpss_related_product to ${iml_schema};
grant select on ${iol_schema}.rpss_related_product to ${icl_schema};
grant select on ${iol_schema}.rpss_related_product to ${idl_schema};
grant select on ${iol_schema}.rpss_related_product to ${iel_schema};

-- comment
comment on table ${iol_schema}.rpss_related_product is '关联方金融产品表';
comment on column ${iol_schema}.rpss_related_product.related_id is '关联方编号';
comment on column ${iol_schema}.rpss_related_product.person_name is '关联方名称';
comment on column ${iol_schema}.rpss_related_product.certificate_type_id is '证件类型';
comment on column ${iol_schema}.rpss_related_product.certificate_no is '证件号码';
comment on column ${iol_schema}.rpss_related_product.domestic_or_foreign is '证件类型境内外1';
comment on column ${iol_schema}.rpss_related_product.shareholding_ratio is '持股比例';
comment on column ${iol_schema}.rpss_related_product.organization is '所属机构';
comment on column ${iol_schema}.rpss_related_product.department is '所属部门';
comment on column ${iol_schema}.rpss_related_product.belong_org is '归属机构';
comment on column ${iol_schema}.rpss_related_product.mainten_org is '维护机构';
comment on column ${iol_schema}.rpss_related_product.certificate_type_id_t is '证件类型2';
comment on column ${iol_schema}.rpss_related_product.certificate_no_t is '证件号码2';
comment on column ${iol_schema}.rpss_related_product.domestic_or_foreign_t is '证件类型境内外2';
comment on column ${iol_schema}.rpss_related_product.product_name is '金融产品全称';
comment on column ${iol_schema}.rpss_related_product.product_issue_no is '产品批准/注册/备案号';
comment on column ${iol_schema}.rpss_related_product.product_register_no is '产品代码';
comment on column ${iol_schema}.rpss_related_product.product_type is '产品分类';
comment on column ${iol_schema}.rpss_related_product.register_org is '产品登记机构';
comment on column ${iol_schema}.rpss_related_product.product_owner is '产品管理人全称';
comment on column ${iol_schema}.rpss_related_product.product_owner_unisc_code is '产品管理人统一社会信用代码';
comment on column ${iol_schema}.rpss_related_product.product_custodian is '产品托管人全称';
comment on column ${iol_schema}.rpss_related_product.product_custodian_unisc_code is '产品托管人统一社会信用代码';
comment on column ${iol_schema}.rpss_related_product.comments is '备注';
comment on column ${iol_schema}.rpss_related_product.last_updated_stamp is '';
comment on column ${iol_schema}.rpss_related_product.last_updated_tx_stamp is '';
comment on column ${iol_schema}.rpss_related_product.created_stamp is '';
comment on column ${iol_schema}.rpss_related_product.created_tx_stamp is '';
comment on column ${iol_schema}.rpss_related_product.start_dt is '开始时间';
comment on column ${iol_schema}.rpss_related_product.end_dt is '结束时间';
comment on column ${iol_schema}.rpss_related_product.id_mark is '增删标志';
comment on column ${iol_schema}.rpss_related_product.etl_timestamp is 'ETL处理时间戳';
