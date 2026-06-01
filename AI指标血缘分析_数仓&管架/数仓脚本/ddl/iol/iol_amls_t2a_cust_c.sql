/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t2a_cust_c
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t2a_cust_c
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t2a_cust_c purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t2a_cust_c(
    cust_id varchar2(48) -- 客户编号
    ,org_id varchar2(24) -- 归属机构编号
    ,create_dt date -- 建立日期
    ,cust_name varchar2(768) -- 客户名称
    ,cust_en_name varchar2(768) -- 客户英文名称
    ,cust_sts varchar2(2) -- 客户状态（参见[字典:aml0078]）
    ,cust_type varchar2(2) -- 客户类型（参见[字典:aml0030]）
    ,aml_cust_type varchar2(3) -- aml客户类型（参见[字典:aml0079]）
    ,pbc_cust_type varchar2(3) -- pbc客户类型（参见[字典:aml0043]）
    ,pbc_indus varchar2(48) -- pbc行业分类
    ,s_indus varchar2(30) -- 源系统行业分类
    ,cust_nat varchar2(75) -- 国籍
    ,cust_area varchar2(9) -- 地区代码
    ,reg_addr varchar2(768) -- 注册地址
    ,biz_addr varchar2(768) -- 营业地址
    ,cert_type varchar2(72) -- 证件类型
    ,s_cert_type varchar2(72) -- 源系统证件类型
    ,cert_no varchar2(192) -- 证件号码
    ,cert_valid_dt date -- 证件生效日期
    ,cert_invalid_dt date -- 证件失效日期
    ,cert_addr varchar2(768) -- 证件地址
    ,corp_estb_dt date -- 企业成立日期
    ,corp_type varchar2(15) -- 企业类型
    ,corp_reg_type varchar2(15) -- 企业经济性质
    ,reg_fund_amt number(30,4) -- 注册资本
    ,reg_fund_curr_cd varchar2(5) -- 注册资本币种
    ,office_tel varchar2(96) -- 办公电话
    ,website varchar2(768) -- 网址
    ,email varchar2(768) -- email地址
    ,legal_name varchar2(768) -- 法定代表人名称
    ,legal_cert_type varchar2(9) -- 法定代表人证件类型
    ,legal_cert_no varchar2(192) -- 法定代表人证件号码
    ,legal_cert_valid_dt date -- 法定代表人证件生效日期
    ,legal_cert_invalid_dt date -- 法定代表人证件失效日期
    ,legal_cust_id varchar2(48) -- 法定代表人客户编号
    ,legal_tel varchar2(96) -- 法定代表人联系电话
    ,legal_addr varchar2(768) -- 法定代表人联系地址
    ,is_group_cust varchar2(2) -- 是否集团客户（参见[字典:aml0080]）
    ,credit_no varchar2(90) -- 机构信用代码
    ,credit_valid_dt date -- 机构信用代码生效日期2
    ,credit_invalid_dt date -- 机构信用代码失效日期2
    ,organ_code varchar2(90) -- 组织机构代码
    ,organ_code_valid_dt date -- 组织机构代码生效日期
    ,organ_code_invalid_dt date -- 组织机构代码失效日期
    ,biz_lic_no varchar2(90) -- 营业执照号码
    ,biz_lic_no_valid_dt date -- 营业执照号码生效日期
    ,biz_lic_no_invalid_dt date -- 营业执照号码失效日期
    ,biz_scope varchar2(4000) -- 经营范围
    ,main_biz varchar2(300) -- 主营业务
    ,mgr_id varchar2(30) -- 客户经理编号
    ,mgr_name varchar2(150) -- 客户经理名称
    ,ctrl_name varchar2(144) -- 实际控制人姓名
    ,ctrl_cert_type varchar2(57) -- 实际控制人证件类型
    ,ctrl_cert_no varchar2(192) -- 实际控制人证件号码
    ,ctrl_cert_valid_dt date -- 实际控制人证件生效日期
    ,ctrl_cert_invalid_dt date -- 实际控制人证件失效日期
    ,corp_lkm_name varchar2(144) -- 企业联系人姓名
    ,corp_lkm_tel varchar2(96) -- 企业联系人电话
    ,hold_name varchar2(300) -- 控股股东名称
    ,hold_cert_type varchar2(57) -- 控股股东证件类型
    ,hold_cert_no varchar2(192) -- 控股股东证件号码
    ,hold_cert_valid_dt date -- 控股股东证件生效日期
    ,hold_cert_invalid_dt date -- 控股股东证件失效日期
    ,rsrv_01 varchar2(48) -- 备用字段1---放置的是cif潜在客户字段码值
    ,rsrv_02 varchar2(48) -- 备用字段2
    ,rsrv_03 varchar2(96) -- 备用字段3
    ,rsrv_04 varchar2(96) -- 备用字段4
    ,is_ebank varchar2(2) -- 是否网银客户(0:否,1:是)
    ,is_loan varchar2(2) -- 是否贷款客户(0:否,1:是)
    ,create_channel varchar2(75) -- 客户创建渠道
    ,is_free_trade varchar2(2) -- 是否自贸区
    ,remarks varchar2(768) -- 备注
    ,tax_id varchar2(90) -- 税务登记证号码
    ,opr_name varchar2(60) -- 授权办理业务员姓名
    ,opr_cert_type varchar2(9) -- 授权办理业务员身份证件类型
    ,opr_cert_no varchar2(75) -- 授权办理业务员身份证件号码
    ,opr_cert_invalid_dt date -- 授权办理业务员身份证件有效期限到期日
    ,is_pos varchar2(2) -- 是否我行pos客户
    ,oth_cert_type varchar2(192) -- 其他证件类型
    ,oth_legal_cert_type varchar2(192) -- 法定代表人其他证件类型编码
    ,oth_ctrl_cert_type varchar2(192) -- 实际控制人其他身份证件种类编码
    ,oth_hold_cert_type varchar2(192) -- 控股股东其他证件类型
    ,oth_opr_cert_type varchar2(192) -- 授权办理业务人员其他身份证件类型
    ,close_dt varchar2(12) -- 
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
grant select on ${iol_schema}.amls_t2a_cust_c to ${iml_schema};
grant select on ${iol_schema}.amls_t2a_cust_c to ${icl_schema};
grant select on ${iol_schema}.amls_t2a_cust_c to ${idl_schema};
grant select on ${iol_schema}.amls_t2a_cust_c to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t2a_cust_c is 't2a_对公客户信息';
comment on column ${iol_schema}.amls_t2a_cust_c.cust_id is '客户编号';
comment on column ${iol_schema}.amls_t2a_cust_c.org_id is '归属机构编号';
comment on column ${iol_schema}.amls_t2a_cust_c.create_dt is '建立日期';
comment on column ${iol_schema}.amls_t2a_cust_c.cust_name is '客户名称';
comment on column ${iol_schema}.amls_t2a_cust_c.cust_en_name is '客户英文名称';
comment on column ${iol_schema}.amls_t2a_cust_c.cust_sts is '客户状态（参见[字典:aml0078]）';
comment on column ${iol_schema}.amls_t2a_cust_c.cust_type is '客户类型（参见[字典:aml0030]）';
comment on column ${iol_schema}.amls_t2a_cust_c.aml_cust_type is 'aml客户类型（参见[字典:aml0079]）';
comment on column ${iol_schema}.amls_t2a_cust_c.pbc_cust_type is 'pbc客户类型（参见[字典:aml0043]）';
comment on column ${iol_schema}.amls_t2a_cust_c.pbc_indus is 'pbc行业分类';
comment on column ${iol_schema}.amls_t2a_cust_c.s_indus is '源系统行业分类';
comment on column ${iol_schema}.amls_t2a_cust_c.cust_nat is '国籍';
comment on column ${iol_schema}.amls_t2a_cust_c.cust_area is '地区代码';
comment on column ${iol_schema}.amls_t2a_cust_c.reg_addr is '注册地址';
comment on column ${iol_schema}.amls_t2a_cust_c.biz_addr is '营业地址';
comment on column ${iol_schema}.amls_t2a_cust_c.cert_type is '证件类型';
comment on column ${iol_schema}.amls_t2a_cust_c.s_cert_type is '源系统证件类型';
comment on column ${iol_schema}.amls_t2a_cust_c.cert_no is '证件号码';
comment on column ${iol_schema}.amls_t2a_cust_c.cert_valid_dt is '证件生效日期';
comment on column ${iol_schema}.amls_t2a_cust_c.cert_invalid_dt is '证件失效日期';
comment on column ${iol_schema}.amls_t2a_cust_c.cert_addr is '证件地址';
comment on column ${iol_schema}.amls_t2a_cust_c.corp_estb_dt is '企业成立日期';
comment on column ${iol_schema}.amls_t2a_cust_c.corp_type is '企业类型';
comment on column ${iol_schema}.amls_t2a_cust_c.corp_reg_type is '企业经济性质';
comment on column ${iol_schema}.amls_t2a_cust_c.reg_fund_amt is '注册资本';
comment on column ${iol_schema}.amls_t2a_cust_c.reg_fund_curr_cd is '注册资本币种';
comment on column ${iol_schema}.amls_t2a_cust_c.office_tel is '办公电话';
comment on column ${iol_schema}.amls_t2a_cust_c.website is '网址';
comment on column ${iol_schema}.amls_t2a_cust_c.email is 'email地址';
comment on column ${iol_schema}.amls_t2a_cust_c.legal_name is '法定代表人名称';
comment on column ${iol_schema}.amls_t2a_cust_c.legal_cert_type is '法定代表人证件类型';
comment on column ${iol_schema}.amls_t2a_cust_c.legal_cert_no is '法定代表人证件号码';
comment on column ${iol_schema}.amls_t2a_cust_c.legal_cert_valid_dt is '法定代表人证件生效日期';
comment on column ${iol_schema}.amls_t2a_cust_c.legal_cert_invalid_dt is '法定代表人证件失效日期';
comment on column ${iol_schema}.amls_t2a_cust_c.legal_cust_id is '法定代表人客户编号';
comment on column ${iol_schema}.amls_t2a_cust_c.legal_tel is '法定代表人联系电话';
comment on column ${iol_schema}.amls_t2a_cust_c.legal_addr is '法定代表人联系地址';
comment on column ${iol_schema}.amls_t2a_cust_c.is_group_cust is '是否集团客户（参见[字典:aml0080]）';
comment on column ${iol_schema}.amls_t2a_cust_c.credit_no is '机构信用代码';
comment on column ${iol_schema}.amls_t2a_cust_c.credit_valid_dt is '机构信用代码生效日期2';
comment on column ${iol_schema}.amls_t2a_cust_c.credit_invalid_dt is '机构信用代码失效日期2';
comment on column ${iol_schema}.amls_t2a_cust_c.organ_code is '组织机构代码';
comment on column ${iol_schema}.amls_t2a_cust_c.organ_code_valid_dt is '组织机构代码生效日期';
comment on column ${iol_schema}.amls_t2a_cust_c.organ_code_invalid_dt is '组织机构代码失效日期';
comment on column ${iol_schema}.amls_t2a_cust_c.biz_lic_no is '营业执照号码';
comment on column ${iol_schema}.amls_t2a_cust_c.biz_lic_no_valid_dt is '营业执照号码生效日期';
comment on column ${iol_schema}.amls_t2a_cust_c.biz_lic_no_invalid_dt is '营业执照号码失效日期';
comment on column ${iol_schema}.amls_t2a_cust_c.biz_scope is '经营范围';
comment on column ${iol_schema}.amls_t2a_cust_c.main_biz is '主营业务';
comment on column ${iol_schema}.amls_t2a_cust_c.mgr_id is '客户经理编号';
comment on column ${iol_schema}.amls_t2a_cust_c.mgr_name is '客户经理名称';
comment on column ${iol_schema}.amls_t2a_cust_c.ctrl_name is '实际控制人姓名';
comment on column ${iol_schema}.amls_t2a_cust_c.ctrl_cert_type is '实际控制人证件类型';
comment on column ${iol_schema}.amls_t2a_cust_c.ctrl_cert_no is '实际控制人证件号码';
comment on column ${iol_schema}.amls_t2a_cust_c.ctrl_cert_valid_dt is '实际控制人证件生效日期';
comment on column ${iol_schema}.amls_t2a_cust_c.ctrl_cert_invalid_dt is '实际控制人证件失效日期';
comment on column ${iol_schema}.amls_t2a_cust_c.corp_lkm_name is '企业联系人姓名';
comment on column ${iol_schema}.amls_t2a_cust_c.corp_lkm_tel is '企业联系人电话';
comment on column ${iol_schema}.amls_t2a_cust_c.hold_name is '控股股东名称';
comment on column ${iol_schema}.amls_t2a_cust_c.hold_cert_type is '控股股东证件类型';
comment on column ${iol_schema}.amls_t2a_cust_c.hold_cert_no is '控股股东证件号码';
comment on column ${iol_schema}.amls_t2a_cust_c.hold_cert_valid_dt is '控股股东证件生效日期';
comment on column ${iol_schema}.amls_t2a_cust_c.hold_cert_invalid_dt is '控股股东证件失效日期';
comment on column ${iol_schema}.amls_t2a_cust_c.rsrv_01 is '备用字段1---放置的是cif潜在客户字段码值';
comment on column ${iol_schema}.amls_t2a_cust_c.rsrv_02 is '备用字段2';
comment on column ${iol_schema}.amls_t2a_cust_c.rsrv_03 is '备用字段3';
comment on column ${iol_schema}.amls_t2a_cust_c.rsrv_04 is '备用字段4';
comment on column ${iol_schema}.amls_t2a_cust_c.is_ebank is '是否网银客户(0:否,1:是)';
comment on column ${iol_schema}.amls_t2a_cust_c.is_loan is '是否贷款客户(0:否,1:是)';
comment on column ${iol_schema}.amls_t2a_cust_c.create_channel is '客户创建渠道';
comment on column ${iol_schema}.amls_t2a_cust_c.is_free_trade is '是否自贸区';
comment on column ${iol_schema}.amls_t2a_cust_c.remarks is '备注';
comment on column ${iol_schema}.amls_t2a_cust_c.tax_id is '税务登记证号码';
comment on column ${iol_schema}.amls_t2a_cust_c.opr_name is '授权办理业务员姓名';
comment on column ${iol_schema}.amls_t2a_cust_c.opr_cert_type is '授权办理业务员身份证件类型';
comment on column ${iol_schema}.amls_t2a_cust_c.opr_cert_no is '授权办理业务员身份证件号码';
comment on column ${iol_schema}.amls_t2a_cust_c.opr_cert_invalid_dt is '授权办理业务员身份证件有效期限到期日';
comment on column ${iol_schema}.amls_t2a_cust_c.is_pos is '是否我行pos客户';
comment on column ${iol_schema}.amls_t2a_cust_c.oth_cert_type is '其他证件类型';
comment on column ${iol_schema}.amls_t2a_cust_c.oth_legal_cert_type is '法定代表人其他证件类型编码';
comment on column ${iol_schema}.amls_t2a_cust_c.oth_ctrl_cert_type is '实际控制人其他身份证件种类编码';
comment on column ${iol_schema}.amls_t2a_cust_c.oth_hold_cert_type is '控股股东其他证件类型';
comment on column ${iol_schema}.amls_t2a_cust_c.oth_opr_cert_type is '授权办理业务人员其他身份证件类型';
comment on column ${iol_schema}.amls_t2a_cust_c.close_dt is '';
comment on column ${iol_schema}.amls_t2a_cust_c.start_dt is '开始时间';
comment on column ${iol_schema}.amls_t2a_cust_c.end_dt is '结束时间';
comment on column ${iol_schema}.amls_t2a_cust_c.id_mark is '增删标志';
comment on column ${iol_schema}.amls_t2a_cust_c.etl_timestamp is 'ETL处理时间戳';
