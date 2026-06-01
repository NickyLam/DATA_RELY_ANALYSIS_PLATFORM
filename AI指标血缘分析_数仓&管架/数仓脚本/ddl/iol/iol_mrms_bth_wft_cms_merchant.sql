/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_bth_wft_cms_merchant
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_bth_wft_cms_merchant
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_bth_wft_cms_merchant purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_bth_wft_cms_merchant(
    merchant varchar2(48) -- 商户编号
    ,merchant_name varchar2(192) -- 商户名称
    ,branch_no varchar2(48) -- 威富通机构编号
    ,branch_name varchar2(96) -- 威富通机构名称
    ,merchant_type varchar2(96) -- 商户类型:大商户,普通商户,直营商户,加盟商户
    ,company_id_type varchar2(96) -- 企业证件类型:统一社会信用代码证号,营业执照
    ,company_id varchar2(384) -- 企业证件号码
    ,company_id_start_date varchar2(18) -- 企业证件有效期开始日
    ,company_id_end_date varchar2(18) -- 企业证件有效期结束日
    ,business_scope varchar2(4000) -- 经营范围
    ,register_address varchar2(768) -- 注册地址
    ,legal_representative_name varchar2(96) -- 法定代表人姓名
    ,legal_representative_sex varchar2(24) -- 法定代表人性别:男，女
    ,legal_representative_id_type varchar2(192) -- 法定代表人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
    ,legal_representative_id varchar2(192) -- 法定代表人证件号码
    ,legal_representative_id_start_date varchar2(18) -- 法定代表人证件有效期开始日
    ,legal_representative_id_end_date varchar2(18) -- 法定代表人证件有效期到期日
    ,legal_representative_phone varchar2(192) -- 法定代表人手机号码
    ,beneficial_owner_name varchar2(96) -- 受益所有人姓名
    ,beneficial_owner_id_type varchar2(192) -- 受益所有人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
    ,beneficial_owner_id varchar2(192) -- 受益所有人证件号码
    ,beneficial_owner_id_start_date varchar2(18) -- 受益所有人证件有效期开始日
    ,beneficial_owner_id_end_date varchar2(18) -- 受益所有人证件有效期到期日
    ,beneficial_owner_address varchar2(768) -- 受益所有人详细地址
    ,control_shareholder_name varchar2(96) -- 控股股东名称
    ,control_shareholder_id_type varchar2(192) -- 控股股东证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
    ,control_shareholder_id varchar2(192) -- 控股股东证件号码
    ,control_shareholder_id_start_date varchar2(18) -- 控股股东证件有效期起始日
    ,control_shareholder_id_end_date varchar2(18) -- 控股股东证件有效期到期日
    ,author_agent_name varchar2(96) -- 授权办理人姓名
    ,author_agent_id_type varchar2(192) -- 授权办理人证件类型
    ,author_agent_id varchar2(192) -- 授权办理人证件号码
    ,author_agent_id_start_date varchar2(18) -- 授权办理人证件有效期起始日
    ,author_agent_id_end_date varchar2(18) -- 授权办理人证件有效期到期日
    ,company_id_type_value varchar2(48) -- 企业证件类:统一社会信用代码证号,营业执照
    ,legal_representative_sex_value varchar2(48) -- 法定代表人性别:男:1,女:2,未知的性别:0,未说明的性别:9
    ,legal_representative_id_type_value varchar2(48) -- 法定代表人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
    ,beneficial_owner_id_type_value varchar2(48) -- 受益所有人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
    ,control_shareholder_id_type_value varchar2(48) -- 控股股东证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
    ,author_agent_id_type_value varchar2(48) -- 授权办理人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
    ,ghbank_branch_no varchar2(48) -- 华兴银行机构编号
    ,ghbank_branch_name varchar2(96) -- 华兴银行机构全称
    ,merchant_okfile varchar2(192) -- 商户信息ok文件
    ,merchant_txtfile varchar2(192) -- 商户信息明细文件
    ,remark1 varchar2(384) -- 商户审核状态:未审核,审核通过,审核不通过,需再次审核
    ,remark2 varchar2(384) -- 商户激活状态:未激活,激活成功,激活失败,需再次激活,冻结,注销
    ,remark3 varchar2(768) -- 备注3
    ,remark4 varchar2(768) -- 备注4
    ,remark5 varchar2(1536) -- 备注5
    ,remark6 varchar2(1536) -- 备注6
    ,remark7 varchar2(3072) -- 备注7
    ,remark8 varchar2(3072) -- 备注8
    ,create_date varchar2(36) -- 创建时间:timestamp(yyyy-MM-dd HH24MiSS)
    ,update_date varchar2(36) -- 更新时间:timestamp(yyyy-MM-dd HH24MiSS)
    ,settle_accno_name varchar2(192) -- 结算账户名称
    ,settle_accno_type varchar2(96) -- 结算账户类型
    ,settle_bank_name varchar2(192) -- 结算账户开户行
    ,settle_accno varchar2(192) -- 结算账号
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
grant select on ${iol_schema}.mrms_bth_wft_cms_merchant to ${iml_schema};
grant select on ${iol_schema}.mrms_bth_wft_cms_merchant to ${icl_schema};
grant select on ${iol_schema}.mrms_bth_wft_cms_merchant to ${idl_schema};
grant select on ${iol_schema}.mrms_bth_wft_cms_merchant to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_bth_wft_cms_merchant is '威富通商户信息表';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.merchant is '商户编号';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.merchant_name is '商户名称';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.branch_no is '威富通机构编号';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.branch_name is '威富通机构名称';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.merchant_type is '商户类型:大商户,普通商户,直营商户,加盟商户';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.company_id_type is '企业证件类型:统一社会信用代码证号,营业执照';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.company_id is '企业证件号码';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.company_id_start_date is '企业证件有效期开始日';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.company_id_end_date is '企业证件有效期结束日';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.business_scope is '经营范围';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.register_address is '注册地址';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.legal_representative_name is '法定代表人姓名';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.legal_representative_sex is '法定代表人性别:男，女';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.legal_representative_id_type is '法定代表人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.legal_representative_id is '法定代表人证件号码';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.legal_representative_id_start_date is '法定代表人证件有效期开始日';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.legal_representative_id_end_date is '法定代表人证件有效期到期日';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.legal_representative_phone is '法定代表人手机号码';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.beneficial_owner_name is '受益所有人姓名';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.beneficial_owner_id_type is '受益所有人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.beneficial_owner_id is '受益所有人证件号码';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.beneficial_owner_id_start_date is '受益所有人证件有效期开始日';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.beneficial_owner_id_end_date is '受益所有人证件有效期到期日';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.beneficial_owner_address is '受益所有人详细地址';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.control_shareholder_name is '控股股东名称';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.control_shareholder_id_type is '控股股东证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.control_shareholder_id is '控股股东证件号码';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.control_shareholder_id_start_date is '控股股东证件有效期起始日';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.control_shareholder_id_end_date is '控股股东证件有效期到期日';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.author_agent_name is '授权办理人姓名';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.author_agent_id_type is '授权办理人证件类型';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.author_agent_id is '授权办理人证件号码';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.author_agent_id_start_date is '授权办理人证件有效期起始日';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.author_agent_id_end_date is '授权办理人证件有效期到期日';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.company_id_type_value is '企业证件类:统一社会信用代码证号,营业执照';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.legal_representative_sex_value is '法定代表人性别:男:1,女:2,未知的性别:0,未说明的性别:9';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.legal_representative_id_type_value is '法定代表人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.beneficial_owner_id_type_value is '受益所有人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.control_shareholder_id_type_value is '控股股东证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.author_agent_id_type_value is '授权办理人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.ghbank_branch_no is '华兴银行机构编号';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.ghbank_branch_name is '华兴银行机构全称';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.merchant_okfile is '商户信息ok文件';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.merchant_txtfile is '商户信息明细文件';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.remark1 is '商户审核状态:未审核,审核通过,审核不通过,需再次审核';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.remark2 is '商户激活状态:未激活,激活成功,激活失败,需再次激活,冻结,注销';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.remark3 is '备注3';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.remark4 is '备注4';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.remark5 is '备注5';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.remark6 is '备注6';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.remark7 is '备注7';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.remark8 is '备注8';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.create_date is '创建时间:timestamp(yyyy-MM-dd HH24MiSS)';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.update_date is '更新时间:timestamp(yyyy-MM-dd HH24MiSS)';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.settle_accno_name is '结算账户名称';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.settle_accno_type is '结算账户类型';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.settle_bank_name is '结算账户开户行';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.settle_accno is '结算账号';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.start_dt is '开始时间';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.end_dt is '结束时间';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.id_mark is '增删标志';
comment on column ${iol_schema}.mrms_bth_wft_cms_merchant.etl_timestamp is 'ETL处理时间戳';
