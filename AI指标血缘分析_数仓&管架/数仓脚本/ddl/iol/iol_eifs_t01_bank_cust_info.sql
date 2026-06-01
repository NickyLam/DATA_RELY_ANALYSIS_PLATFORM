/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t01_bank_cust_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t01_bank_cust_info
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t01_bank_cust_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t01_bank_cust_info(
    party_id varchar2(45) -- 参与人id
    ,ibank_cust_cate_cd varchar2(30) -- 金融机构类别
    ,acct_lic_no varchar2(45) -- 开户许可证号
    ,forng_lic_id varchar2(45) -- 外汇经营许可证号码
    ,bank_license varchar2(45) -- 金融机构许可证
    ,csrc_id varchar2(45) -- 证监会代码证号
    ,union_bank_no varchar2(18) -- 大额支付号（联行号）
    ,swift_code varchar2(45) -- swift编号
    ,app_cert_no varchar2(450) -- 审批文号
    ,app_cert_no_valid_date varchar2(15) -- 审批文号有效期
    ,ent_tube_no varchar2(45) -- 企业外管代码
    ,sml_unspot_chck_no varchar2(45) -- 银监会非现场监管编码
    ,sml_unspot_chck_no_date varchar2(15) -- 银监会非现场监管编码有效日期
    ,insurance_lic_no varchar2(45) -- 保险许可证
    ,insurance_lic_no_date varchar2(15) -- 保险许可证有效期
    ,bond_lic_no varchar2(45) -- 证券许可证
    ,bond_lic_no_date varchar2(15) -- 证券许可证有效期
    ,gts_bls_cert_no varchar2(45) -- 国结保理商证号
    ,create_te varchar2(12) -- 创建柜员
    ,create_org varchar2(15) -- 创建机构号
    ,init_system_id varchar2(15) -- 创建渠道
    ,init_created_ts timestamp -- 源系统创建时间
    ,created_ts timestamp -- 进入ecif的时间
    ,updated_ts timestamp -- 在ecif中失效的时间
    ,last_updated_te varchar2(45) -- 最新更新柜员
    ,last_updated_org varchar2(30) -- 最新更新机构号
    ,last_system_id varchar2(15) -- 最新更新渠道
    ,last_updated_ts timestamp -- 最新更新时间
    ,financial_institution_code varchar2(48) -- 金融机构编码
    ,src_sys_num varchar2(45) -- 来源系统编号
    ,last_updated_src_sys_num varchar2(45) -- 最新更新源系统编号
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
grant select on ${iol_schema}.eifs_t01_bank_cust_info to ${iml_schema};
grant select on ${iol_schema}.eifs_t01_bank_cust_info to ${icl_schema};
grant select on ${iol_schema}.eifs_t01_bank_cust_info to ${idl_schema};
grant select on ${iol_schema}.eifs_t01_bank_cust_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t01_bank_cust_info is '同业客户特有信息';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.party_id is '参与人id';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.ibank_cust_cate_cd is '金融机构类别';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.acct_lic_no is '开户许可证号';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.forng_lic_id is '外汇经营许可证号码';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.bank_license is '金融机构许可证';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.csrc_id is '证监会代码证号';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.union_bank_no is '大额支付号（联行号）';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.swift_code is 'swift编号';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.app_cert_no is '审批文号';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.app_cert_no_valid_date is '审批文号有效期';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.ent_tube_no is '企业外管代码';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.sml_unspot_chck_no is '银监会非现场监管编码';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.sml_unspot_chck_no_date is '银监会非现场监管编码有效日期';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.insurance_lic_no is '保险许可证';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.insurance_lic_no_date is '保险许可证有效期';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.bond_lic_no is '证券许可证';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.bond_lic_no_date is '证券许可证有效期';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.gts_bls_cert_no is '国结保理商证号';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.create_te is '创建柜员';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.create_org is '创建机构号';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.init_system_id is '创建渠道';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.init_created_ts is '源系统创建时间';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.created_ts is '进入ecif的时间';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.updated_ts is '在ecif中失效的时间';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.last_updated_te is '最新更新柜员';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.last_updated_org is '最新更新机构号';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.last_system_id is '最新更新渠道';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.last_updated_ts is '最新更新时间';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.financial_institution_code is '金融机构编码';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.src_sys_num is '来源系统编号';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.last_updated_src_sys_num is '最新更新源系统编号';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t01_bank_cust_info.etl_timestamp is 'ETL处理时间戳';
