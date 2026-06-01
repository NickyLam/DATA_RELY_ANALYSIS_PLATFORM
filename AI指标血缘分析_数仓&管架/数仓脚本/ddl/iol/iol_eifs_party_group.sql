/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_party_group
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_party_group
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_party_group purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_party_group(
    party_id varchar2(30) -- 当事人标识
    ,group_name varchar2(150) -- 组织名称
    ,group_name_local varchar2(150) -- 组织名称本地语言
    ,office_site_name varchar2(300) -- 办公地点
    ,annual_revenue number(18,2) -- 年收入
    ,num_employees number(20) -- 员工数
    ,ticker_symbol varchar2(15) -- 股票代码
    ,comments varchar2(383) -- 备注
    ,logo_image_url varchar2(383) -- Logo图地址
    ,last_updated_stamp timestamp -- 最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事务时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事务时间
    ,org_name_cn varchar2(150) -- 
    ,org_shrt_name_cn varchar2(150) -- 
    ,core_org_id varchar2(30) -- 
    ,area_code varchar2(30) -- 
    ,org_name_en varchar2(150) -- 
    ,card_org_code varchar2(30) -- 
    ,fca_code varchar2(30) -- 
    ,org_mgt_level varchar2(30) -- 
    ,org_bsn_level varchar2(30) -- 
    ,org_vchr_level varchar2(2) -- 
    ,org_cmpn_level varchar2(30) -- 
    ,snr_mgt_org varchar2(30) -- 
    ,snr_pst_org varchar2(30) -- 
    ,snr_vchr_org varchar2(30) -- 
    ,snr_cmpn_org varchar2(30) -- 
    ,audit_org_flag varchar2(30) -- 
    ,indep_acct_flag varchar2(30) -- 
    ,swift_code varchar2(30) -- 
    ,open_date timestamp -- 
    ,close_date timestamp -- 
    ,city_rtime_ex_code varchar2(150) -- 
    ,payment_code varchar2(30) -- 
    ,broad_succ_flag varchar2(30) -- 
    ,ap_flag varchar2(30) -- 
    ,atm_flag varchar2(30) -- 
    ,pos_flag varchar2(30) -- 
    ,pbc_settle_flag varchar2(30) -- 
    ,agent_issued_flag varchar2(30) -- 
    ,ip_addr varchar2(30) -- 
    ,port varchar2(30) -- 
    ,crsp varchar2(30) -- 
    ,hr_org_id varchar2(30) -- 
    ,snr_hr_org_id varchar2(30) -- 
    ,cost_org_id varchar2(30) -- 
    ,snr_cost_org_id varchar2(30) -- 
    ,profit_org_id varchar2(30) -- 
    ,snr_profit_org_id varchar2(30) -- 
    ,profit_org_group_id varchar2(30) -- 
    ,fi_org_id varchar2(150) -- 
    ,daily_settle_flag varchar2(2) -- 
    ,catagory varchar2(30) -- 
    ,org_type varchar2(30) -- 
    ,contact varchar2(90) -- 
    ,org_simp_name_cn varchar2(150) -- 
    ,customer_category varchar2(30) -- 客户类别
    ,customer_logo varchar2(30) -- 客户标志
    ,cust_type_code varchar2(30) -- 客户类型码
    ,english_name varchar2(375) -- 英文名
    ,nation varchar2(30) -- 国籍
    ,national_treatment varchar2(30) -- 国民待遇
    ,manager_personal varchar2(30) -- 管理人员人数
    ,bank_type varchar2(30) -- 银行类型
    ,legal_enty varchar2(30) -- 企业类型
    ,enterprise_registration_type varchar2(30) -- 企业登记注册类型
    ,unit_classification varchar2(30) -- 单位分类
    ,unit_code varchar2(30) -- 单位代码
    ,registration_code varchar2(383) -- 登记注册代码
    ,subordinate_industry varchar2(30) -- 所属行业
    ,found_dat varchar2(30) -- 成立日期
    ,mode_operation varchar2(30) -- 
    ,economic_properties varchar2(30) -- 经济性质
    ,license_status varchar2(30) -- 营业执照年检标志
    ,checkdt varchar2(30) -- 年检日期
    ,bussiness_scope varchar2(3000) -- 经营范围
    ,asset_amt varchar2(30) -- 资产总额
    ,owe_amt varchar2(30) -- 负债总额
    ,loginfund varchar2(30) -- 注册资金
    ,registered_capital_currency varchar2(30) -- 注册资金币种
    ,paidcapital varchar2(30) -- 实收资本
    ,paidcapital_currency varchar2(30) -- 实收资本币种
    ,compound_interest varchar2(30) -- 复息利率
    ,is_dependent_leagal_person varchar2(30) -- 是否独立法人
    ,basic_open_acct_bk_name varchar2(375) -- 基本开户行行名
    ,basic_open_acct_bk_no varchar2(30) -- 基本开户行行号
    ,investment_country varchar2(30) -- 投资方国别
    ,business_ownership varchar2(30) -- 经营场地所有权
    ,org_reg_yearly_check_date varchar2(30) -- 
    ,work_units_subordinate varchar2(30) -- 工作单位所属行业
    ,natural_per_is_staff varchar2(30) -- 
    ,large_partner_sign varchar2(30) -- 
    ,shares varchar2(30) -- 
    ,share_capital varchar2(30) -- 
    ,web_site varchar2(383) -- 公司网址
    ,financial_customer_type varchar2(30) -- 金融客户类型
    ,party_type varchar2(30) -- 
    ,basic_check_num varchar2(90) -- 
    ,basic_accno varchar2(90) -- 
    ,basic_open_acct_dt varchar2(12) -- 
    ,basic_check_dt varchar2(12) -- 
    ,org_credit_code varchar2(30) -- 
    ,english_name_once varchar2(383) -- 曾用英文名
    ,group_name_once varchar2(383) -- 曾用名中文
    ,depositorcategory varchar2(30) -- 
    ,date_of_approval timestamp -- 
    ,belongmanager varchar2(30) -- 
    ,tax_resident varchar2(2) -- 税收居民身份
    ,tax_area varchar2(450) -- 税收居民国（地区）
    ,tax_number varchar2(546) -- 纳税人识别号
    ,tax_null_reason varchar2(1200) -- 纳税人识别号空值原因
    ,tax_statement varchar2(2) -- 是否取得自证声明(税收居民)
    ,corp_org_type varchar2(2) -- 机构类别
    ,work_region varchar2(15) -- 办公地区代码
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
grant select on ${iol_schema}.eifs_party_group to ${iml_schema};
grant select on ${iol_schema}.eifs_party_group to ${icl_schema};
grant select on ${iol_schema}.eifs_party_group to ${idl_schema};
grant select on ${iol_schema}.eifs_party_group to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_party_group is '当事人组表';
comment on column ${iol_schema}.eifs_party_group.party_id is '当事人标识';
comment on column ${iol_schema}.eifs_party_group.group_name is '组织名称';
comment on column ${iol_schema}.eifs_party_group.group_name_local is '组织名称本地语言';
comment on column ${iol_schema}.eifs_party_group.office_site_name is '办公地点';
comment on column ${iol_schema}.eifs_party_group.annual_revenue is '年收入';
comment on column ${iol_schema}.eifs_party_group.num_employees is '员工数';
comment on column ${iol_schema}.eifs_party_group.ticker_symbol is '股票代码';
comment on column ${iol_schema}.eifs_party_group.comments is '备注';
comment on column ${iol_schema}.eifs_party_group.logo_image_url is 'Logo图地址';
comment on column ${iol_schema}.eifs_party_group.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.eifs_party_group.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.eifs_party_group.created_stamp is '创建时间';
comment on column ${iol_schema}.eifs_party_group.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.eifs_party_group.org_name_cn is '';
comment on column ${iol_schema}.eifs_party_group.org_shrt_name_cn is '';
comment on column ${iol_schema}.eifs_party_group.core_org_id is '';
comment on column ${iol_schema}.eifs_party_group.area_code is '';
comment on column ${iol_schema}.eifs_party_group.org_name_en is '';
comment on column ${iol_schema}.eifs_party_group.card_org_code is '';
comment on column ${iol_schema}.eifs_party_group.fca_code is '';
comment on column ${iol_schema}.eifs_party_group.org_mgt_level is '';
comment on column ${iol_schema}.eifs_party_group.org_bsn_level is '';
comment on column ${iol_schema}.eifs_party_group.org_vchr_level is '';
comment on column ${iol_schema}.eifs_party_group.org_cmpn_level is '';
comment on column ${iol_schema}.eifs_party_group.snr_mgt_org is '';
comment on column ${iol_schema}.eifs_party_group.snr_pst_org is '';
comment on column ${iol_schema}.eifs_party_group.snr_vchr_org is '';
comment on column ${iol_schema}.eifs_party_group.snr_cmpn_org is '';
comment on column ${iol_schema}.eifs_party_group.audit_org_flag is '';
comment on column ${iol_schema}.eifs_party_group.indep_acct_flag is '';
comment on column ${iol_schema}.eifs_party_group.swift_code is '';
comment on column ${iol_schema}.eifs_party_group.open_date is '';
comment on column ${iol_schema}.eifs_party_group.close_date is '';
comment on column ${iol_schema}.eifs_party_group.city_rtime_ex_code is '';
comment on column ${iol_schema}.eifs_party_group.payment_code is '';
comment on column ${iol_schema}.eifs_party_group.broad_succ_flag is '';
comment on column ${iol_schema}.eifs_party_group.ap_flag is '';
comment on column ${iol_schema}.eifs_party_group.atm_flag is '';
comment on column ${iol_schema}.eifs_party_group.pos_flag is '';
comment on column ${iol_schema}.eifs_party_group.pbc_settle_flag is '';
comment on column ${iol_schema}.eifs_party_group.agent_issued_flag is '';
comment on column ${iol_schema}.eifs_party_group.ip_addr is '';
comment on column ${iol_schema}.eifs_party_group.port is '';
comment on column ${iol_schema}.eifs_party_group.crsp is '';
comment on column ${iol_schema}.eifs_party_group.hr_org_id is '';
comment on column ${iol_schema}.eifs_party_group.snr_hr_org_id is '';
comment on column ${iol_schema}.eifs_party_group.cost_org_id is '';
comment on column ${iol_schema}.eifs_party_group.snr_cost_org_id is '';
comment on column ${iol_schema}.eifs_party_group.profit_org_id is '';
comment on column ${iol_schema}.eifs_party_group.snr_profit_org_id is '';
comment on column ${iol_schema}.eifs_party_group.profit_org_group_id is '';
comment on column ${iol_schema}.eifs_party_group.fi_org_id is '';
comment on column ${iol_schema}.eifs_party_group.daily_settle_flag is '';
comment on column ${iol_schema}.eifs_party_group.catagory is '';
comment on column ${iol_schema}.eifs_party_group.org_type is '';
comment on column ${iol_schema}.eifs_party_group.contact is '';
comment on column ${iol_schema}.eifs_party_group.org_simp_name_cn is '';
comment on column ${iol_schema}.eifs_party_group.customer_category is '客户类别';
comment on column ${iol_schema}.eifs_party_group.customer_logo is '客户标志';
comment on column ${iol_schema}.eifs_party_group.cust_type_code is '客户类型码';
comment on column ${iol_schema}.eifs_party_group.english_name is '英文名';
comment on column ${iol_schema}.eifs_party_group.nation is '国籍';
comment on column ${iol_schema}.eifs_party_group.national_treatment is '国民待遇';
comment on column ${iol_schema}.eifs_party_group.manager_personal is '管理人员人数';
comment on column ${iol_schema}.eifs_party_group.bank_type is '银行类型';
comment on column ${iol_schema}.eifs_party_group.legal_enty is '企业类型';
comment on column ${iol_schema}.eifs_party_group.enterprise_registration_type is '企业登记注册类型';
comment on column ${iol_schema}.eifs_party_group.unit_classification is '单位分类';
comment on column ${iol_schema}.eifs_party_group.unit_code is '单位代码';
comment on column ${iol_schema}.eifs_party_group.registration_code is '登记注册代码';
comment on column ${iol_schema}.eifs_party_group.subordinate_industry is '所属行业';
comment on column ${iol_schema}.eifs_party_group.found_dat is '成立日期';
comment on column ${iol_schema}.eifs_party_group.mode_operation is '';
comment on column ${iol_schema}.eifs_party_group.economic_properties is '经济性质';
comment on column ${iol_schema}.eifs_party_group.license_status is '营业执照年检标志';
comment on column ${iol_schema}.eifs_party_group.checkdt is '年检日期';
comment on column ${iol_schema}.eifs_party_group.bussiness_scope is '经营范围';
comment on column ${iol_schema}.eifs_party_group.asset_amt is '资产总额';
comment on column ${iol_schema}.eifs_party_group.owe_amt is '负债总额';
comment on column ${iol_schema}.eifs_party_group.loginfund is '注册资金';
comment on column ${iol_schema}.eifs_party_group.registered_capital_currency is '注册资金币种';
comment on column ${iol_schema}.eifs_party_group.paidcapital is '实收资本';
comment on column ${iol_schema}.eifs_party_group.paidcapital_currency is '实收资本币种';
comment on column ${iol_schema}.eifs_party_group.compound_interest is '复息利率';
comment on column ${iol_schema}.eifs_party_group.is_dependent_leagal_person is '是否独立法人';
comment on column ${iol_schema}.eifs_party_group.basic_open_acct_bk_name is '基本开户行行名';
comment on column ${iol_schema}.eifs_party_group.basic_open_acct_bk_no is '基本开户行行号';
comment on column ${iol_schema}.eifs_party_group.investment_country is '投资方国别';
comment on column ${iol_schema}.eifs_party_group.business_ownership is '经营场地所有权';
comment on column ${iol_schema}.eifs_party_group.org_reg_yearly_check_date is '';
comment on column ${iol_schema}.eifs_party_group.work_units_subordinate is '工作单位所属行业';
comment on column ${iol_schema}.eifs_party_group.natural_per_is_staff is '';
comment on column ${iol_schema}.eifs_party_group.large_partner_sign is '';
comment on column ${iol_schema}.eifs_party_group.shares is '';
comment on column ${iol_schema}.eifs_party_group.share_capital is '';
comment on column ${iol_schema}.eifs_party_group.web_site is '公司网址';
comment on column ${iol_schema}.eifs_party_group.financial_customer_type is '金融客户类型';
comment on column ${iol_schema}.eifs_party_group.party_type is '';
comment on column ${iol_schema}.eifs_party_group.basic_check_num is '';
comment on column ${iol_schema}.eifs_party_group.basic_accno is '';
comment on column ${iol_schema}.eifs_party_group.basic_open_acct_dt is '';
comment on column ${iol_schema}.eifs_party_group.basic_check_dt is '';
comment on column ${iol_schema}.eifs_party_group.org_credit_code is '';
comment on column ${iol_schema}.eifs_party_group.english_name_once is '曾用英文名';
comment on column ${iol_schema}.eifs_party_group.group_name_once is '曾用名中文';
comment on column ${iol_schema}.eifs_party_group.depositorcategory is '';
comment on column ${iol_schema}.eifs_party_group.date_of_approval is '';
comment on column ${iol_schema}.eifs_party_group.belongmanager is '';
comment on column ${iol_schema}.eifs_party_group.tax_resident is '税收居民身份';
comment on column ${iol_schema}.eifs_party_group.tax_area is '税收居民国（地区）';
comment on column ${iol_schema}.eifs_party_group.tax_number is '纳税人识别号';
comment on column ${iol_schema}.eifs_party_group.tax_null_reason is '纳税人识别号空值原因';
comment on column ${iol_schema}.eifs_party_group.tax_statement is '是否取得自证声明(税收居民)';
comment on column ${iol_schema}.eifs_party_group.corp_org_type is '机构类别';
comment on column ${iol_schema}.eifs_party_group.work_region is '办公地区代码';
comment on column ${iol_schema}.eifs_party_group.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_party_group.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_party_group.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_party_group.etl_timestamp is 'ETL处理时间戳';
