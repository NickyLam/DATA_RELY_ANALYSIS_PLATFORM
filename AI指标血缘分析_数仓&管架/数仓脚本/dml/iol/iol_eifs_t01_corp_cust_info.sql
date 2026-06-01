/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t01_corp_cust_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.eifs_t01_corp_cust_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.eifs_t01_corp_cust_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t01_corp_cust_info_op purge;
drop table ${iol_schema}.eifs_t01_corp_cust_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t01_corp_cust_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t01_corp_cust_info where 0=1;

create table ${iol_schema}.eifs_t01_corp_cust_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t01_corp_cust_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t01_corp_cust_info_cl(
            party_id -- 参与人id
            ,is_same_trade_cust -- 是否同业客户
            ,cust_name -- 客户名称
            ,org_type_cd -- 组织机构类型
            ,rgst_type_cd -- 登记注册类型
            ,reg_area_code -- 注册地区代码
            ,rgst_cap -- 注册资本
            ,reg_capital_currency -- 注册资本币种
            ,actl_recv_cap -- 实收资本
            ,paidcapital_currency -- 实收资本币种
            ,work_region -- 办公地区代码
            ,corp_found_dt -- 企业成立日期
            ,tax_register_flag -- 税务登记办理标识
            ,tax_org_certificate -- 税务机关证明
            ,national_tax_no -- 国税证号
            ,land_tax_no -- 地税证号
            ,busi_or_not_reg_cer -- 商事与非商事登记号
            ,licence_for_open_acct -- 开户许可证
            ,date_of_approval -- 核准日期
            ,org_credit_code_cert_num -- 机构信用代码证号
            ,depositor_type_cd -- 存款人类别
            ,belong_indus_cd -- 所属行业类型
            ,belong_indus_acct -- 所属行业类型(账户报备)
            ,economic_org_form -- 经济组织形式
            ,corp_totl_asset -- 企业总资产
            ,corp_net_asset -- 企业净资产
            ,corp_year_in -- 企业年收入
            ,corp_emply_person_cnt -- 企业员工人数
            ,salmon -- 销售额
            ,corp_size_cd -- 企业规模
            ,nation_eco_dept_cd -- 国民经济部门类型
            ,oper_biz -- 经营范围
            ,survival_status -- 存续状态
            ,bank_cd -- 银行行号
            ,bank_level -- 行级别
            ,basic_acct_open_bank_name -- 基本账户开户行名称
            ,basic_acct_open_bank_code -- 基本账户开户行代码
            ,basic_acct_num -- 基本账户账号
            ,basic_open_acct_dt -- 基本户开户日期
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,org_type -- 机构类别
            ,oper_place_area -- 经营场地面积
            ,oper_place_prop_cd -- 经营场地所有权
            ,industry_class_id -- 行分类id
            ,enterprise_type -- 企业类型
            ,party_role -- 参与人角色
            ,cntrpty -- 交易对手类别
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,loan_flag -- 信贷客户标识
            ,self_sup_flag -- 自营客户标识
            ,guarantee_flag -- 担保客户标志
            ,rele_flg -- 根据监管规定是否可豁免识别
            ,aml_dep_flag -- 担保类标志
            ,aml_loan_flag -- 贷款类标志
            ,aml_guar_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t01_corp_cust_info_op(
            party_id -- 参与人id
            ,is_same_trade_cust -- 是否同业客户
            ,cust_name -- 客户名称
            ,org_type_cd -- 组织机构类型
            ,rgst_type_cd -- 登记注册类型
            ,reg_area_code -- 注册地区代码
            ,rgst_cap -- 注册资本
            ,reg_capital_currency -- 注册资本币种
            ,actl_recv_cap -- 实收资本
            ,paidcapital_currency -- 实收资本币种
            ,work_region -- 办公地区代码
            ,corp_found_dt -- 企业成立日期
            ,tax_register_flag -- 税务登记办理标识
            ,tax_org_certificate -- 税务机关证明
            ,national_tax_no -- 国税证号
            ,land_tax_no -- 地税证号
            ,busi_or_not_reg_cer -- 商事与非商事登记号
            ,licence_for_open_acct -- 开户许可证
            ,date_of_approval -- 核准日期
            ,org_credit_code_cert_num -- 机构信用代码证号
            ,depositor_type_cd -- 存款人类别
            ,belong_indus_cd -- 所属行业类型
            ,belong_indus_acct -- 所属行业类型(账户报备)
            ,economic_org_form -- 经济组织形式
            ,corp_totl_asset -- 企业总资产
            ,corp_net_asset -- 企业净资产
            ,corp_year_in -- 企业年收入
            ,corp_emply_person_cnt -- 企业员工人数
            ,salmon -- 销售额
            ,corp_size_cd -- 企业规模
            ,nation_eco_dept_cd -- 国民经济部门类型
            ,oper_biz -- 经营范围
            ,survival_status -- 存续状态
            ,bank_cd -- 银行行号
            ,bank_level -- 行级别
            ,basic_acct_open_bank_name -- 基本账户开户行名称
            ,basic_acct_open_bank_code -- 基本账户开户行代码
            ,basic_acct_num -- 基本账户账号
            ,basic_open_acct_dt -- 基本户开户日期
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,org_type -- 机构类别
            ,oper_place_area -- 经营场地面积
            ,oper_place_prop_cd -- 经营场地所有权
            ,industry_class_id -- 行分类id
            ,enterprise_type -- 企业类型
            ,party_role -- 参与人角色
            ,cntrpty -- 交易对手类别
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,loan_flag -- 信贷客户标识
            ,self_sup_flag -- 自营客户标识
            ,guarantee_flag -- 担保客户标志
            ,rele_flg -- 根据监管规定是否可豁免识别
            ,aml_dep_flag -- 担保类标志
            ,aml_loan_flag -- 贷款类标志
            ,aml_guar_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 参与人id
    ,nvl(n.is_same_trade_cust, o.is_same_trade_cust) as is_same_trade_cust -- 是否同业客户
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.org_type_cd, o.org_type_cd) as org_type_cd -- 组织机构类型
    ,nvl(n.rgst_type_cd, o.rgst_type_cd) as rgst_type_cd -- 登记注册类型
    ,nvl(n.reg_area_code, o.reg_area_code) as reg_area_code -- 注册地区代码
    ,nvl(n.rgst_cap, o.rgst_cap) as rgst_cap -- 注册资本
    ,nvl(n.reg_capital_currency, o.reg_capital_currency) as reg_capital_currency -- 注册资本币种
    ,nvl(n.actl_recv_cap, o.actl_recv_cap) as actl_recv_cap -- 实收资本
    ,nvl(n.paidcapital_currency, o.paidcapital_currency) as paidcapital_currency -- 实收资本币种
    ,nvl(n.work_region, o.work_region) as work_region -- 办公地区代码
    ,nvl(n.corp_found_dt, o.corp_found_dt) as corp_found_dt -- 企业成立日期
    ,nvl(n.tax_register_flag, o.tax_register_flag) as tax_register_flag -- 税务登记办理标识
    ,nvl(n.tax_org_certificate, o.tax_org_certificate) as tax_org_certificate -- 税务机关证明
    ,nvl(n.national_tax_no, o.national_tax_no) as national_tax_no -- 国税证号
    ,nvl(n.land_tax_no, o.land_tax_no) as land_tax_no -- 地税证号
    ,nvl(n.busi_or_not_reg_cer, o.busi_or_not_reg_cer) as busi_or_not_reg_cer -- 商事与非商事登记号
    ,nvl(n.licence_for_open_acct, o.licence_for_open_acct) as licence_for_open_acct -- 开户许可证
    ,nvl(n.date_of_approval, o.date_of_approval) as date_of_approval -- 核准日期
    ,nvl(n.org_credit_code_cert_num, o.org_credit_code_cert_num) as org_credit_code_cert_num -- 机构信用代码证号
    ,nvl(n.depositor_type_cd, o.depositor_type_cd) as depositor_type_cd -- 存款人类别
    ,nvl(n.belong_indus_cd, o.belong_indus_cd) as belong_indus_cd -- 所属行业类型
    ,nvl(n.belong_indus_acct, o.belong_indus_acct) as belong_indus_acct -- 所属行业类型(账户报备)
    ,nvl(n.economic_org_form, o.economic_org_form) as economic_org_form -- 经济组织形式
    ,nvl(n.corp_totl_asset, o.corp_totl_asset) as corp_totl_asset -- 企业总资产
    ,nvl(n.corp_net_asset, o.corp_net_asset) as corp_net_asset -- 企业净资产
    ,nvl(n.corp_year_in, o.corp_year_in) as corp_year_in -- 企业年收入
    ,nvl(n.corp_emply_person_cnt, o.corp_emply_person_cnt) as corp_emply_person_cnt -- 企业员工人数
    ,nvl(n.salmon, o.salmon) as salmon -- 销售额
    ,nvl(n.corp_size_cd, o.corp_size_cd) as corp_size_cd -- 企业规模
    ,nvl(n.nation_eco_dept_cd, o.nation_eco_dept_cd) as nation_eco_dept_cd -- 国民经济部门类型
    ,nvl(n.oper_biz, o.oper_biz) as oper_biz -- 经营范围
    ,nvl(n.survival_status, o.survival_status) as survival_status -- 存续状态
    ,nvl(n.bank_cd, o.bank_cd) as bank_cd -- 银行行号
    ,nvl(n.bank_level, o.bank_level) as bank_level -- 行级别
    ,nvl(n.basic_acct_open_bank_name, o.basic_acct_open_bank_name) as basic_acct_open_bank_name -- 基本账户开户行名称
    ,nvl(n.basic_acct_open_bank_code, o.basic_acct_open_bank_code) as basic_acct_open_bank_code -- 基本账户开户行代码
    ,nvl(n.basic_acct_num, o.basic_acct_num) as basic_acct_num -- 基本账户账号
    ,nvl(n.basic_open_acct_dt, o.basic_open_acct_dt) as basic_open_acct_dt -- 基本户开户日期
    ,nvl(n.create_te, o.create_te) as create_te -- 创建柜员
    ,nvl(n.create_org, o.create_org) as create_org -- 创建机构号
    ,nvl(n.init_system_id, o.init_system_id) as init_system_id -- 创建渠道
    ,nvl(n.init_created_ts, o.init_created_ts) as init_created_ts -- 源系统创建时间
    ,nvl(n.created_ts, o.created_ts) as created_ts -- 进入ecif的时间
    ,nvl(n.updated_ts, o.updated_ts) as updated_ts -- 在ecif中失效的时间
    ,nvl(n.last_updated_te, o.last_updated_te) as last_updated_te -- 最新更新柜员
    ,nvl(n.last_updated_org, o.last_updated_org) as last_updated_org -- 最新更新机构号
    ,nvl(n.last_system_id, o.last_system_id) as last_system_id -- 最新更新渠道
    ,nvl(n.last_updated_ts, o.last_updated_ts) as last_updated_ts -- 最新更新时间
    ,nvl(n.org_type, o.org_type) as org_type -- 机构类别
    ,nvl(n.oper_place_area, o.oper_place_area) as oper_place_area -- 经营场地面积
    ,nvl(n.oper_place_prop_cd, o.oper_place_prop_cd) as oper_place_prop_cd -- 经营场地所有权
    ,nvl(n.industry_class_id, o.industry_class_id) as industry_class_id -- 行分类id
    ,nvl(n.enterprise_type, o.enterprise_type) as enterprise_type -- 企业类型
    ,nvl(n.party_role, o.party_role) as party_role -- 参与人角色
    ,nvl(n.cntrpty, o.cntrpty) as cntrpty -- 交易对手类别
    ,nvl(n.src_sys_num, o.src_sys_num) as src_sys_num -- 来源系统编号
    ,nvl(n.last_updated_src_sys_num, o.last_updated_src_sys_num) as last_updated_src_sys_num -- 最新更新源系统编号
    ,nvl(n.loan_flag, o.loan_flag) as loan_flag -- 信贷客户标识
    ,nvl(n.self_sup_flag, o.self_sup_flag) as self_sup_flag -- 自营客户标识
    ,nvl(n.guarantee_flag, o.guarantee_flag) as guarantee_flag -- 担保客户标志
    ,nvl(n.rele_flg, o.rele_flg) as rele_flg -- 根据监管规定是否可豁免识别
    ,nvl(n.aml_dep_flag, o.aml_dep_flag) as aml_dep_flag -- 担保类标志
    ,nvl(n.aml_loan_flag, o.aml_loan_flag) as aml_loan_flag -- 贷款类标志
    ,nvl(n.aml_guar_flag, o.aml_guar_flag) as aml_guar_flag -- 
    ,case when
            n.party_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.eifs_t01_corp_cust_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.eifs_t01_corp_cust_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.party_id = n.party_id
where (
        o.party_id is null
    )
    or (
        n.party_id is null
    )
    or (
        o.is_same_trade_cust <> n.is_same_trade_cust
        or o.cust_name <> n.cust_name
        or o.org_type_cd <> n.org_type_cd
        or o.rgst_type_cd <> n.rgst_type_cd
        or o.reg_area_code <> n.reg_area_code
        or o.rgst_cap <> n.rgst_cap
        or o.reg_capital_currency <> n.reg_capital_currency
        or o.actl_recv_cap <> n.actl_recv_cap
        or o.paidcapital_currency <> n.paidcapital_currency
        or o.work_region <> n.work_region
        or o.corp_found_dt <> n.corp_found_dt
        or o.tax_register_flag <> n.tax_register_flag
        or o.tax_org_certificate <> n.tax_org_certificate
        or o.national_tax_no <> n.national_tax_no
        or o.land_tax_no <> n.land_tax_no
        or o.busi_or_not_reg_cer <> n.busi_or_not_reg_cer
        or o.licence_for_open_acct <> n.licence_for_open_acct
        or o.date_of_approval <> n.date_of_approval
        or o.org_credit_code_cert_num <> n.org_credit_code_cert_num
        or o.depositor_type_cd <> n.depositor_type_cd
        or o.belong_indus_cd <> n.belong_indus_cd
        or o.belong_indus_acct <> n.belong_indus_acct
        or o.economic_org_form <> n.economic_org_form
        or o.corp_totl_asset <> n.corp_totl_asset
        or o.corp_net_asset <> n.corp_net_asset
        or o.corp_year_in <> n.corp_year_in
        or o.corp_emply_person_cnt <> n.corp_emply_person_cnt
        or o.salmon <> n.salmon
        or o.corp_size_cd <> n.corp_size_cd
        or o.nation_eco_dept_cd <> n.nation_eco_dept_cd
        or o.oper_biz <> n.oper_biz
        or o.survival_status <> n.survival_status
        or o.bank_cd <> n.bank_cd
        or o.bank_level <> n.bank_level
        or o.basic_acct_open_bank_name <> n.basic_acct_open_bank_name
        or o.basic_acct_open_bank_code <> n.basic_acct_open_bank_code
        or o.basic_acct_num <> n.basic_acct_num
        or o.basic_open_acct_dt <> n.basic_open_acct_dt
        or o.create_te <> n.create_te
        or o.create_org <> n.create_org
        or o.init_system_id <> n.init_system_id
        or o.init_created_ts <> n.init_created_ts
        or o.created_ts <> n.created_ts
        or o.updated_ts <> n.updated_ts
        or o.last_updated_te <> n.last_updated_te
        or o.last_updated_org <> n.last_updated_org
        or o.last_system_id <> n.last_system_id
        or o.last_updated_ts <> n.last_updated_ts
        or o.org_type <> n.org_type
        or o.oper_place_area <> n.oper_place_area
        or o.oper_place_prop_cd <> n.oper_place_prop_cd
        or o.industry_class_id <> n.industry_class_id
        or o.enterprise_type <> n.enterprise_type
        or o.party_role <> n.party_role
        or o.cntrpty <> n.cntrpty
        or o.src_sys_num <> n.src_sys_num
        or o.last_updated_src_sys_num <> n.last_updated_src_sys_num
        or o.loan_flag <> n.loan_flag
        or o.self_sup_flag <> n.self_sup_flag
        or o.guarantee_flag <> n.guarantee_flag
        or o.rele_flg <> n.rele_flg
        or o.aml_dep_flag <> n.aml_dep_flag
        or o.aml_loan_flag <> n.aml_loan_flag
        or o.aml_guar_flag <> n.aml_guar_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t01_corp_cust_info_cl(
            party_id -- 参与人id
            ,is_same_trade_cust -- 是否同业客户
            ,cust_name -- 客户名称
            ,org_type_cd -- 组织机构类型
            ,rgst_type_cd -- 登记注册类型
            ,reg_area_code -- 注册地区代码
            ,rgst_cap -- 注册资本
            ,reg_capital_currency -- 注册资本币种
            ,actl_recv_cap -- 实收资本
            ,paidcapital_currency -- 实收资本币种
            ,work_region -- 办公地区代码
            ,corp_found_dt -- 企业成立日期
            ,tax_register_flag -- 税务登记办理标识
            ,tax_org_certificate -- 税务机关证明
            ,national_tax_no -- 国税证号
            ,land_tax_no -- 地税证号
            ,busi_or_not_reg_cer -- 商事与非商事登记号
            ,licence_for_open_acct -- 开户许可证
            ,date_of_approval -- 核准日期
            ,org_credit_code_cert_num -- 机构信用代码证号
            ,depositor_type_cd -- 存款人类别
            ,belong_indus_cd -- 所属行业类型
            ,belong_indus_acct -- 所属行业类型(账户报备)
            ,economic_org_form -- 经济组织形式
            ,corp_totl_asset -- 企业总资产
            ,corp_net_asset -- 企业净资产
            ,corp_year_in -- 企业年收入
            ,corp_emply_person_cnt -- 企业员工人数
            ,salmon -- 销售额
            ,corp_size_cd -- 企业规模
            ,nation_eco_dept_cd -- 国民经济部门类型
            ,oper_biz -- 经营范围
            ,survival_status -- 存续状态
            ,bank_cd -- 银行行号
            ,bank_level -- 行级别
            ,basic_acct_open_bank_name -- 基本账户开户行名称
            ,basic_acct_open_bank_code -- 基本账户开户行代码
            ,basic_acct_num -- 基本账户账号
            ,basic_open_acct_dt -- 基本户开户日期
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,org_type -- 机构类别
            ,oper_place_area -- 经营场地面积
            ,oper_place_prop_cd -- 经营场地所有权
            ,industry_class_id -- 行分类id
            ,enterprise_type -- 企业类型
            ,party_role -- 参与人角色
            ,cntrpty -- 交易对手类别
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,loan_flag -- 信贷客户标识
            ,self_sup_flag -- 自营客户标识
            ,guarantee_flag -- 担保客户标志
            ,rele_flg -- 根据监管规定是否可豁免识别
            ,aml_dep_flag -- 担保类标志
            ,aml_loan_flag -- 贷款类标志
            ,aml_guar_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t01_corp_cust_info_op(
            party_id -- 参与人id
            ,is_same_trade_cust -- 是否同业客户
            ,cust_name -- 客户名称
            ,org_type_cd -- 组织机构类型
            ,rgst_type_cd -- 登记注册类型
            ,reg_area_code -- 注册地区代码
            ,rgst_cap -- 注册资本
            ,reg_capital_currency -- 注册资本币种
            ,actl_recv_cap -- 实收资本
            ,paidcapital_currency -- 实收资本币种
            ,work_region -- 办公地区代码
            ,corp_found_dt -- 企业成立日期
            ,tax_register_flag -- 税务登记办理标识
            ,tax_org_certificate -- 税务机关证明
            ,national_tax_no -- 国税证号
            ,land_tax_no -- 地税证号
            ,busi_or_not_reg_cer -- 商事与非商事登记号
            ,licence_for_open_acct -- 开户许可证
            ,date_of_approval -- 核准日期
            ,org_credit_code_cert_num -- 机构信用代码证号
            ,depositor_type_cd -- 存款人类别
            ,belong_indus_cd -- 所属行业类型
            ,belong_indus_acct -- 所属行业类型(账户报备)
            ,economic_org_form -- 经济组织形式
            ,corp_totl_asset -- 企业总资产
            ,corp_net_asset -- 企业净资产
            ,corp_year_in -- 企业年收入
            ,corp_emply_person_cnt -- 企业员工人数
            ,salmon -- 销售额
            ,corp_size_cd -- 企业规模
            ,nation_eco_dept_cd -- 国民经济部门类型
            ,oper_biz -- 经营范围
            ,survival_status -- 存续状态
            ,bank_cd -- 银行行号
            ,bank_level -- 行级别
            ,basic_acct_open_bank_name -- 基本账户开户行名称
            ,basic_acct_open_bank_code -- 基本账户开户行代码
            ,basic_acct_num -- 基本账户账号
            ,basic_open_acct_dt -- 基本户开户日期
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,org_type -- 机构类别
            ,oper_place_area -- 经营场地面积
            ,oper_place_prop_cd -- 经营场地所有权
            ,industry_class_id -- 行分类id
            ,enterprise_type -- 企业类型
            ,party_role -- 参与人角色
            ,cntrpty -- 交易对手类别
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,loan_flag -- 信贷客户标识
            ,self_sup_flag -- 自营客户标识
            ,guarantee_flag -- 担保客户标志
            ,rele_flg -- 根据监管规定是否可豁免识别
            ,aml_dep_flag -- 担保类标志
            ,aml_loan_flag -- 贷款类标志
            ,aml_guar_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 参与人id
    ,o.is_same_trade_cust -- 是否同业客户
    ,o.cust_name -- 客户名称
    ,o.org_type_cd -- 组织机构类型
    ,o.rgst_type_cd -- 登记注册类型
    ,o.reg_area_code -- 注册地区代码
    ,o.rgst_cap -- 注册资本
    ,o.reg_capital_currency -- 注册资本币种
    ,o.actl_recv_cap -- 实收资本
    ,o.paidcapital_currency -- 实收资本币种
    ,o.work_region -- 办公地区代码
    ,o.corp_found_dt -- 企业成立日期
    ,o.tax_register_flag -- 税务登记办理标识
    ,o.tax_org_certificate -- 税务机关证明
    ,o.national_tax_no -- 国税证号
    ,o.land_tax_no -- 地税证号
    ,o.busi_or_not_reg_cer -- 商事与非商事登记号
    ,o.licence_for_open_acct -- 开户许可证
    ,o.date_of_approval -- 核准日期
    ,o.org_credit_code_cert_num -- 机构信用代码证号
    ,o.depositor_type_cd -- 存款人类别
    ,o.belong_indus_cd -- 所属行业类型
    ,o.belong_indus_acct -- 所属行业类型(账户报备)
    ,o.economic_org_form -- 经济组织形式
    ,o.corp_totl_asset -- 企业总资产
    ,o.corp_net_asset -- 企业净资产
    ,o.corp_year_in -- 企业年收入
    ,o.corp_emply_person_cnt -- 企业员工人数
    ,o.salmon -- 销售额
    ,o.corp_size_cd -- 企业规模
    ,o.nation_eco_dept_cd -- 国民经济部门类型
    ,o.oper_biz -- 经营范围
    ,o.survival_status -- 存续状态
    ,o.bank_cd -- 银行行号
    ,o.bank_level -- 行级别
    ,o.basic_acct_open_bank_name -- 基本账户开户行名称
    ,o.basic_acct_open_bank_code -- 基本账户开户行代码
    ,o.basic_acct_num -- 基本账户账号
    ,o.basic_open_acct_dt -- 基本户开户日期
    ,o.create_te -- 创建柜员
    ,o.create_org -- 创建机构号
    ,o.init_system_id -- 创建渠道
    ,o.init_created_ts -- 源系统创建时间
    ,o.created_ts -- 进入ecif的时间
    ,o.updated_ts -- 在ecif中失效的时间
    ,o.last_updated_te -- 最新更新柜员
    ,o.last_updated_org -- 最新更新机构号
    ,o.last_system_id -- 最新更新渠道
    ,o.last_updated_ts -- 最新更新时间
    ,o.org_type -- 机构类别
    ,o.oper_place_area -- 经营场地面积
    ,o.oper_place_prop_cd -- 经营场地所有权
    ,o.industry_class_id -- 行分类id
    ,o.enterprise_type -- 企业类型
    ,o.party_role -- 参与人角色
    ,o.cntrpty -- 交易对手类别
    ,o.src_sys_num -- 来源系统编号
    ,o.last_updated_src_sys_num -- 最新更新源系统编号
    ,o.loan_flag -- 信贷客户标识
    ,o.self_sup_flag -- 自营客户标识
    ,o.guarantee_flag -- 担保客户标志
    ,o.rele_flg -- 根据监管规定是否可豁免识别
    ,o.aml_dep_flag -- 担保类标志
    ,o.aml_loan_flag -- 贷款类标志
    ,o.aml_guar_flag -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.eifs_t01_corp_cust_info_bk o
    left join ${iol_schema}.eifs_t01_corp_cust_info_op n
        on
            o.party_id = n.party_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.eifs_t01_corp_cust_info_cl d
        on
            o.party_id = d.party_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.eifs_t01_corp_cust_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('eifs_t01_corp_cust_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.eifs_t01_corp_cust_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.eifs_t01_corp_cust_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.eifs_t01_corp_cust_info exchange partition p_${batch_date} with table ${iol_schema}.eifs_t01_corp_cust_info_cl;
alter table ${iol_schema}.eifs_t01_corp_cust_info exchange partition p_20991231 with table ${iol_schema}.eifs_t01_corp_cust_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.eifs_t01_corp_cust_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t01_corp_cust_info_op purge;
drop table ${iol_schema}.eifs_t01_corp_cust_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.eifs_t01_corp_cust_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'eifs_t01_corp_cust_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
