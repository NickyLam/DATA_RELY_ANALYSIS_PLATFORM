/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t01_corp_cust_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t01_corp_cust_info
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t01_corp_cust_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t01_corp_cust_info(
    party_id varchar2(45) -- 参与人id
    ,is_same_trade_cust varchar2(2) -- 是否同业客户
    ,cust_name varchar2(300) -- 客户名称
    ,org_type_cd varchar2(30) -- 组织机构类型
    ,rgst_type_cd varchar2(30) -- 登记注册类型
    ,reg_area_code varchar2(15) -- 注册地区代码
    ,rgst_cap number(20,2) -- 注册资本
    ,reg_capital_currency varchar2(30) -- 注册资本币种
    ,actl_recv_cap number(20,2) -- 实收资本
    ,paidcapital_currency varchar2(30) -- 实收资本币种
    ,work_region varchar2(15) -- 办公地区代码
    ,corp_found_dt varchar2(12) -- 企业成立日期
    ,tax_register_flag varchar2(2) -- 税务登记办理标识
    ,tax_org_certificate varchar2(90) -- 税务机关证明
    ,national_tax_no varchar2(90) -- 国税证号
    ,land_tax_no varchar2(90) -- 地税证号
    ,busi_or_not_reg_cer varchar2(150) -- 商事与非商事登记号
    ,licence_for_open_acct varchar2(90) -- 开户许可证
    ,date_of_approval varchar2(12) -- 核准日期
    ,org_credit_code_cert_num varchar2(30) -- 机构信用代码证号
    ,depositor_type_cd varchar2(30) -- 存款人类别
    ,belong_indus_cd varchar2(30) -- 所属行业类型
    ,belong_indus_acct varchar2(30) -- 所属行业类型(账户报备)
    ,economic_org_form varchar2(8) -- 经济组织形式
    ,corp_totl_asset number(20,2) -- 企业总资产
    ,corp_net_asset number(20,2) -- 企业净资产
    ,corp_year_in number(20,2) -- 企业年收入
    ,corp_emply_person_cnt number(10,0) -- 企业员工人数
    ,salmon varchar2(30) -- 销售额
    ,corp_size_cd varchar2(30) -- 企业规模
    ,nation_eco_dept_cd varchar2(30) -- 国民经济部门类型
    ,oper_biz varchar2(4000) -- 经营范围
    ,survival_status varchar2(3) -- 存续状态
    ,bank_cd varchar2(30) -- 银行行号
    ,bank_level varchar2(2) -- 行级别
    ,basic_acct_open_bank_name varchar2(300) -- 基本账户开户行名称
    ,basic_acct_open_bank_code varchar2(135) -- 基本账户开户行代码
    ,basic_acct_num varchar2(90) -- 基本账户账号
    ,basic_open_acct_dt varchar2(12) -- 基本户开户日期
    ,create_te varchar2(15) -- 创建柜员
    ,create_org varchar2(15) -- 创建机构号
    ,init_system_id varchar2(15) -- 创建渠道
    ,init_created_ts timestamp -- 源系统创建时间
    ,created_ts timestamp -- 进入ecif的时间
    ,updated_ts timestamp -- 在ecif中失效的时间
    ,last_updated_te varchar2(45) -- 最新更新柜员
    ,last_updated_org varchar2(30) -- 最新更新机构号
    ,last_system_id varchar2(15) -- 最新更新渠道
    ,last_updated_ts timestamp -- 最新更新时间
    ,org_type varchar2(5) -- 机构类别
    ,oper_place_area number(20,2) -- 经营场地面积
    ,oper_place_prop_cd varchar2(30) -- 经营场地所有权
    ,industry_class_id varchar2(300) -- 行分类id
    ,enterprise_type varchar2(2) -- 企业类型
    ,party_role varchar2(3) -- 参与人角色
    ,cntrpty varchar2(8) -- 交易对手类别
    ,src_sys_num varchar2(45) -- 来源系统编号
    ,last_updated_src_sys_num varchar2(45) -- 最新更新源系统编号
    ,loan_flag varchar2(2) -- 信贷客户标识
    ,self_sup_flag varchar2(2) -- 自营客户标识
    ,guarantee_flag varchar2(2) -- 担保客户标志
    ,rele_flg varchar2(2) -- 根据监管规定是否可豁免识别
    ,aml_dep_flag varchar2(2) -- 担保类标志
    ,aml_loan_flag varchar2(2) -- 贷款类标志
    ,aml_guar_flag varchar2(2) -- 
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
grant select on ${iol_schema}.eifs_t01_corp_cust_info to ${iml_schema};
grant select on ${iol_schema}.eifs_t01_corp_cust_info to ${icl_schema};
grant select on ${iol_schema}.eifs_t01_corp_cust_info to ${idl_schema};
grant select on ${iol_schema}.eifs_t01_corp_cust_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t01_corp_cust_info is '对公客户基本信息';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.party_id is '参与人id';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.is_same_trade_cust is '是否同业客户';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.cust_name is '客户名称';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.org_type_cd is '组织机构类型';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.rgst_type_cd is '登记注册类型';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.reg_area_code is '注册地区代码';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.rgst_cap is '注册资本';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.reg_capital_currency is '注册资本币种';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.actl_recv_cap is '实收资本';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.paidcapital_currency is '实收资本币种';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.work_region is '办公地区代码';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.corp_found_dt is '企业成立日期';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.tax_register_flag is '税务登记办理标识';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.tax_org_certificate is '税务机关证明';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.national_tax_no is '国税证号';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.land_tax_no is '地税证号';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.busi_or_not_reg_cer is '商事与非商事登记号';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.licence_for_open_acct is '开户许可证';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.date_of_approval is '核准日期';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.org_credit_code_cert_num is '机构信用代码证号';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.depositor_type_cd is '存款人类别';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.belong_indus_cd is '所属行业类型';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.belong_indus_acct is '所属行业类型(账户报备)';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.economic_org_form is '经济组织形式';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.corp_totl_asset is '企业总资产';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.corp_net_asset is '企业净资产';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.corp_year_in is '企业年收入';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.corp_emply_person_cnt is '企业员工人数';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.salmon is '销售额';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.corp_size_cd is '企业规模';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.nation_eco_dept_cd is '国民经济部门类型';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.oper_biz is '经营范围';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.survival_status is '存续状态';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.bank_cd is '银行行号';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.bank_level is '行级别';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.basic_acct_open_bank_name is '基本账户开户行名称';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.basic_acct_open_bank_code is '基本账户开户行代码';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.basic_acct_num is '基本账户账号';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.basic_open_acct_dt is '基本户开户日期';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.create_te is '创建柜员';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.create_org is '创建机构号';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.init_system_id is '创建渠道';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.init_created_ts is '源系统创建时间';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.created_ts is '进入ecif的时间';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.updated_ts is '在ecif中失效的时间';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.last_updated_te is '最新更新柜员';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.last_updated_org is '最新更新机构号';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.last_system_id is '最新更新渠道';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.last_updated_ts is '最新更新时间';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.org_type is '机构类别';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.oper_place_area is '经营场地面积';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.oper_place_prop_cd is '经营场地所有权';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.industry_class_id is '行分类id';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.enterprise_type is '企业类型';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.party_role is '参与人角色';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.cntrpty is '交易对手类别';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.src_sys_num is '来源系统编号';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.last_updated_src_sys_num is '最新更新源系统编号';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.loan_flag is '信贷客户标识';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.self_sup_flag is '自营客户标识';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.guarantee_flag is '担保客户标志';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.rele_flg is '根据监管规定是否可豁免识别';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.aml_dep_flag is '担保类标志';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.aml_loan_flag is '贷款类标志';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.aml_guar_flag is '';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t01_corp_cust_info.etl_timestamp is 'ETL处理时间戳';
