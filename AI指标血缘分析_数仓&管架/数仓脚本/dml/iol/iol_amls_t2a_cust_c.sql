/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amls_t2a_cust_c
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
create table ${iol_schema}.amls_t2a_cust_c_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amls_t2a_cust_c
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t2a_cust_c_op purge;
drop table ${iol_schema}.amls_t2a_cust_c_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t2a_cust_c_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t2a_cust_c where 0=1;

create table ${iol_schema}.amls_t2a_cust_c_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t2a_cust_c where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amls_t2a_cust_c_cl(
            cust_id -- 客户编号
            ,org_id -- 归属机构编号
            ,create_dt -- 建立日期
            ,cust_name -- 客户名称
            ,cust_en_name -- 客户英文名称
            ,cust_sts -- 客户状态（参见[字典:AML0078]）
            ,cust_type -- 客户类型（参见[字典:AML0030]）
            ,aml_cust_type -- AML客户类型（参见[字典:AML0079]）
            ,pbc_cust_type -- PBC客户类型（参见[字典:AML0043]）
            ,pbc_indus -- PBC行业分类
            ,s_indus -- 源系统行业分类
            ,cust_nat -- 国籍
            ,cust_area -- 地区代码
            ,reg_addr -- 注册地址
            ,biz_addr -- 营业地址
            ,cert_type -- 证件类型
            ,s_cert_type -- 源系统证件类型
            ,cert_no -- 证件号码
            ,cert_valid_dt -- 证件生效日期
            ,cert_invalid_dt -- 证件失效日期
            ,cert_addr -- 证件地址
            ,corp_estb_dt -- 企业成立日期
            ,corp_type -- 企业类型
            ,corp_reg_type -- 企业经济性质
            ,reg_fund_amt -- 注册资本
            ,reg_fund_curr_cd -- 注册资本币种
            ,office_tel -- 办公电话
            ,website -- 网址
            ,email -- Email地址
            ,legal_name -- 法定代表人名称
            ,legal_cert_type -- 法定代表人证件类型
            ,legal_cert_no -- 法定代表人证件号码
            ,legal_cert_valid_dt -- 法定代表人证件生效日期
            ,legal_cert_invalid_dt -- 法定代表人证件失效日期
            ,legal_cust_id -- 法定代表人客户编号
            ,legal_tel -- 法定代表人联系电话
            ,legal_addr -- 法定代表人联系地址
            ,is_group_cust -- 是否集团客户（参见[字典:AML0080]）
            ,credit_no -- 机构信用代码
            ,credit_valid_dt -- 机构信用代码生效日期2
            ,credit_invalid_dt -- 机构信用代码失效日期2
            ,organ_code -- 组织机构代码
            ,organ_code_valid_dt -- 组织机构代码生效日期
            ,organ_code_invalid_dt -- 组织机构代码失效日期
            ,biz_lic_no -- 营业执照号码
            ,biz_lic_no_valid_dt -- 营业执照号码生效日期
            ,biz_lic_no_invalid_dt -- 营业执照号码失效日期
            ,biz_scope -- 经营范围
            ,main_biz -- 主营业务
            ,mgr_id -- 客户经理编号
            ,mgr_name -- 客户经理名称
            ,ctrl_name -- 实际控制人姓名
            ,ctrl_cert_type -- 实际控制人证件类型
            ,ctrl_cert_no -- 实际控制人证件号码
            ,ctrl_cert_valid_dt -- 实际控制人证件生效日期
            ,ctrl_cert_invalid_dt -- 实际控制人证件失效日期
            ,corp_lkm_name -- 企业联系人姓名
            ,corp_lkm_tel -- 企业联系人电话
            ,hold_name -- 控股股东名称
            ,hold_cert_type -- 控股股东证件类型
            ,hold_cert_no -- 控股股东证件号码
            ,hold_cert_valid_dt -- 控股股东证件生效日期
            ,hold_cert_invalid_dt -- 控股股东证件失效日期
            ,rsrv_01 -- 备用字段1---放置的是cif潜在客户字段码值
            ,rsrv_02 -- 备用字段2
            ,rsrv_03 -- 备用字段3
            ,rsrv_04 -- 备用字段4
            ,is_ebank -- 是否网银客户(0:否,1:是)
            ,is_loan -- 是否贷款客户(0:否,1:是)
            ,create_channel -- 客户创建渠道
            ,is_free_trade -- 是否自贸区
            ,remarks -- 备注
            ,tax_id -- 税务登记证号码
            ,opr_name -- 授权办理业务员姓名
            ,opr_cert_type -- 授权办理业务员身份证件类型
            ,opr_cert_no -- 授权办理业务员身份证件号码
            ,opr_cert_invalid_dt -- 授权办理业务员身份证件有效期限到期日
            ,is_pos -- 是否我行POS客户
            ,oth_cert_type -- 其他证件类型
            ,oth_legal_cert_type -- 法定代表人其他证件类型编码
            ,oth_ctrl_cert_type -- 实际控制人其他身份证件种类编码
            ,oth_hold_cert_type -- 控股股东其他证件类型
            ,oth_opr_cert_type -- 授权办理业务人员其他身份证件类型
            ,close_dt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amls_t2a_cust_c_op(
            cust_id -- 客户编号
            ,org_id -- 归属机构编号
            ,create_dt -- 建立日期
            ,cust_name -- 客户名称
            ,cust_en_name -- 客户英文名称
            ,cust_sts -- 客户状态（参见[字典:AML0078]）
            ,cust_type -- 客户类型（参见[字典:AML0030]）
            ,aml_cust_type -- AML客户类型（参见[字典:AML0079]）
            ,pbc_cust_type -- PBC客户类型（参见[字典:AML0043]）
            ,pbc_indus -- PBC行业分类
            ,s_indus -- 源系统行业分类
            ,cust_nat -- 国籍
            ,cust_area -- 地区代码
            ,reg_addr -- 注册地址
            ,biz_addr -- 营业地址
            ,cert_type -- 证件类型
            ,s_cert_type -- 源系统证件类型
            ,cert_no -- 证件号码
            ,cert_valid_dt -- 证件生效日期
            ,cert_invalid_dt -- 证件失效日期
            ,cert_addr -- 证件地址
            ,corp_estb_dt -- 企业成立日期
            ,corp_type -- 企业类型
            ,corp_reg_type -- 企业经济性质
            ,reg_fund_amt -- 注册资本
            ,reg_fund_curr_cd -- 注册资本币种
            ,office_tel -- 办公电话
            ,website -- 网址
            ,email -- Email地址
            ,legal_name -- 法定代表人名称
            ,legal_cert_type -- 法定代表人证件类型
            ,legal_cert_no -- 法定代表人证件号码
            ,legal_cert_valid_dt -- 法定代表人证件生效日期
            ,legal_cert_invalid_dt -- 法定代表人证件失效日期
            ,legal_cust_id -- 法定代表人客户编号
            ,legal_tel -- 法定代表人联系电话
            ,legal_addr -- 法定代表人联系地址
            ,is_group_cust -- 是否集团客户（参见[字典:AML0080]）
            ,credit_no -- 机构信用代码
            ,credit_valid_dt -- 机构信用代码生效日期2
            ,credit_invalid_dt -- 机构信用代码失效日期2
            ,organ_code -- 组织机构代码
            ,organ_code_valid_dt -- 组织机构代码生效日期
            ,organ_code_invalid_dt -- 组织机构代码失效日期
            ,biz_lic_no -- 营业执照号码
            ,biz_lic_no_valid_dt -- 营业执照号码生效日期
            ,biz_lic_no_invalid_dt -- 营业执照号码失效日期
            ,biz_scope -- 经营范围
            ,main_biz -- 主营业务
            ,mgr_id -- 客户经理编号
            ,mgr_name -- 客户经理名称
            ,ctrl_name -- 实际控制人姓名
            ,ctrl_cert_type -- 实际控制人证件类型
            ,ctrl_cert_no -- 实际控制人证件号码
            ,ctrl_cert_valid_dt -- 实际控制人证件生效日期
            ,ctrl_cert_invalid_dt -- 实际控制人证件失效日期
            ,corp_lkm_name -- 企业联系人姓名
            ,corp_lkm_tel -- 企业联系人电话
            ,hold_name -- 控股股东名称
            ,hold_cert_type -- 控股股东证件类型
            ,hold_cert_no -- 控股股东证件号码
            ,hold_cert_valid_dt -- 控股股东证件生效日期
            ,hold_cert_invalid_dt -- 控股股东证件失效日期
            ,rsrv_01 -- 备用字段1---放置的是cif潜在客户字段码值
            ,rsrv_02 -- 备用字段2
            ,rsrv_03 -- 备用字段3
            ,rsrv_04 -- 备用字段4
            ,is_ebank -- 是否网银客户(0:否,1:是)
            ,is_loan -- 是否贷款客户(0:否,1:是)
            ,create_channel -- 客户创建渠道
            ,is_free_trade -- 是否自贸区
            ,remarks -- 备注
            ,tax_id -- 税务登记证号码
            ,opr_name -- 授权办理业务员姓名
            ,opr_cert_type -- 授权办理业务员身份证件类型
            ,opr_cert_no -- 授权办理业务员身份证件号码
            ,opr_cert_invalid_dt -- 授权办理业务员身份证件有效期限到期日
            ,is_pos -- 是否我行POS客户
            ,oth_cert_type -- 其他证件类型
            ,oth_legal_cert_type -- 法定代表人其他证件类型编码
            ,oth_ctrl_cert_type -- 实际控制人其他身份证件种类编码
            ,oth_hold_cert_type -- 控股股东其他证件类型
            ,oth_opr_cert_type -- 授权办理业务人员其他身份证件类型
            ,close_dt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.org_id, o.org_id) as org_id -- 归属机构编号
    ,nvl(n.create_dt, o.create_dt) as create_dt -- 建立日期
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cust_en_name, o.cust_en_name) as cust_en_name -- 客户英文名称
    ,nvl(n.cust_sts, o.cust_sts) as cust_sts -- 客户状态（参见[字典:AML0078]）
    ,nvl(n.cust_type, o.cust_type) as cust_type -- 客户类型（参见[字典:AML0030]）
    ,nvl(n.aml_cust_type, o.aml_cust_type) as aml_cust_type -- AML客户类型（参见[字典:AML0079]）
    ,nvl(n.pbc_cust_type, o.pbc_cust_type) as pbc_cust_type -- PBC客户类型（参见[字典:AML0043]）
    ,nvl(n.pbc_indus, o.pbc_indus) as pbc_indus -- PBC行业分类
    ,nvl(n.s_indus, o.s_indus) as s_indus -- 源系统行业分类
    ,nvl(n.cust_nat, o.cust_nat) as cust_nat -- 国籍
    ,nvl(n.cust_area, o.cust_area) as cust_area -- 地区代码
    ,nvl(n.reg_addr, o.reg_addr) as reg_addr -- 注册地址
    ,nvl(n.biz_addr, o.biz_addr) as biz_addr -- 营业地址
    ,nvl(n.cert_type, o.cert_type) as cert_type -- 证件类型
    ,nvl(n.s_cert_type, o.s_cert_type) as s_cert_type -- 源系统证件类型
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.cert_valid_dt, o.cert_valid_dt) as cert_valid_dt -- 证件生效日期
    ,nvl(n.cert_invalid_dt, o.cert_invalid_dt) as cert_invalid_dt -- 证件失效日期
    ,nvl(n.cert_addr, o.cert_addr) as cert_addr -- 证件地址
    ,nvl(n.corp_estb_dt, o.corp_estb_dt) as corp_estb_dt -- 企业成立日期
    ,nvl(n.corp_type, o.corp_type) as corp_type -- 企业类型
    ,nvl(n.corp_reg_type, o.corp_reg_type) as corp_reg_type -- 企业经济性质
    ,nvl(n.reg_fund_amt, o.reg_fund_amt) as reg_fund_amt -- 注册资本
    ,nvl(n.reg_fund_curr_cd, o.reg_fund_curr_cd) as reg_fund_curr_cd -- 注册资本币种
    ,nvl(n.office_tel, o.office_tel) as office_tel -- 办公电话
    ,nvl(n.website, o.website) as website -- 网址
    ,nvl(n.email, o.email) as email -- Email地址
    ,nvl(n.legal_name, o.legal_name) as legal_name -- 法定代表人名称
    ,nvl(n.legal_cert_type, o.legal_cert_type) as legal_cert_type -- 法定代表人证件类型
    ,nvl(n.legal_cert_no, o.legal_cert_no) as legal_cert_no -- 法定代表人证件号码
    ,nvl(n.legal_cert_valid_dt, o.legal_cert_valid_dt) as legal_cert_valid_dt -- 法定代表人证件生效日期
    ,nvl(n.legal_cert_invalid_dt, o.legal_cert_invalid_dt) as legal_cert_invalid_dt -- 法定代表人证件失效日期
    ,nvl(n.legal_cust_id, o.legal_cust_id) as legal_cust_id -- 法定代表人客户编号
    ,nvl(n.legal_tel, o.legal_tel) as legal_tel -- 法定代表人联系电话
    ,nvl(n.legal_addr, o.legal_addr) as legal_addr -- 法定代表人联系地址
    ,nvl(n.is_group_cust, o.is_group_cust) as is_group_cust -- 是否集团客户（参见[字典:AML0080]）
    ,nvl(n.credit_no, o.credit_no) as credit_no -- 机构信用代码
    ,nvl(n.credit_valid_dt, o.credit_valid_dt) as credit_valid_dt -- 机构信用代码生效日期2
    ,nvl(n.credit_invalid_dt, o.credit_invalid_dt) as credit_invalid_dt -- 机构信用代码失效日期2
    ,nvl(n.organ_code, o.organ_code) as organ_code -- 组织机构代码
    ,nvl(n.organ_code_valid_dt, o.organ_code_valid_dt) as organ_code_valid_dt -- 组织机构代码生效日期
    ,nvl(n.organ_code_invalid_dt, o.organ_code_invalid_dt) as organ_code_invalid_dt -- 组织机构代码失效日期
    ,nvl(n.biz_lic_no, o.biz_lic_no) as biz_lic_no -- 营业执照号码
    ,nvl(n.biz_lic_no_valid_dt, o.biz_lic_no_valid_dt) as biz_lic_no_valid_dt -- 营业执照号码生效日期
    ,nvl(n.biz_lic_no_invalid_dt, o.biz_lic_no_invalid_dt) as biz_lic_no_invalid_dt -- 营业执照号码失效日期
    ,nvl(n.biz_scope, o.biz_scope) as biz_scope -- 经营范围
    ,nvl(n.main_biz, o.main_biz) as main_biz -- 主营业务
    ,nvl(n.mgr_id, o.mgr_id) as mgr_id -- 客户经理编号
    ,nvl(n.mgr_name, o.mgr_name) as mgr_name -- 客户经理名称
    ,nvl(n.ctrl_name, o.ctrl_name) as ctrl_name -- 实际控制人姓名
    ,nvl(n.ctrl_cert_type, o.ctrl_cert_type) as ctrl_cert_type -- 实际控制人证件类型
    ,nvl(n.ctrl_cert_no, o.ctrl_cert_no) as ctrl_cert_no -- 实际控制人证件号码
    ,nvl(n.ctrl_cert_valid_dt, o.ctrl_cert_valid_dt) as ctrl_cert_valid_dt -- 实际控制人证件生效日期
    ,nvl(n.ctrl_cert_invalid_dt, o.ctrl_cert_invalid_dt) as ctrl_cert_invalid_dt -- 实际控制人证件失效日期
    ,nvl(n.corp_lkm_name, o.corp_lkm_name) as corp_lkm_name -- 企业联系人姓名
    ,nvl(n.corp_lkm_tel, o.corp_lkm_tel) as corp_lkm_tel -- 企业联系人电话
    ,nvl(n.hold_name, o.hold_name) as hold_name -- 控股股东名称
    ,nvl(n.hold_cert_type, o.hold_cert_type) as hold_cert_type -- 控股股东证件类型
    ,nvl(n.hold_cert_no, o.hold_cert_no) as hold_cert_no -- 控股股东证件号码
    ,nvl(n.hold_cert_valid_dt, o.hold_cert_valid_dt) as hold_cert_valid_dt -- 控股股东证件生效日期
    ,nvl(n.hold_cert_invalid_dt, o.hold_cert_invalid_dt) as hold_cert_invalid_dt -- 控股股东证件失效日期
    ,nvl(n.rsrv_01, o.rsrv_01) as rsrv_01 -- 备用字段1---放置的是cif潜在客户字段码值
    ,nvl(n.rsrv_02, o.rsrv_02) as rsrv_02 -- 备用字段2
    ,nvl(n.rsrv_03, o.rsrv_03) as rsrv_03 -- 备用字段3
    ,nvl(n.rsrv_04, o.rsrv_04) as rsrv_04 -- 备用字段4
    ,nvl(n.is_ebank, o.is_ebank) as is_ebank -- 是否网银客户(0:否,1:是)
    ,nvl(n.is_loan, o.is_loan) as is_loan -- 是否贷款客户(0:否,1:是)
    ,nvl(n.create_channel, o.create_channel) as create_channel -- 客户创建渠道
    ,nvl(n.is_free_trade, o.is_free_trade) as is_free_trade -- 是否自贸区
    ,nvl(n.remarks, o.remarks) as remarks -- 备注
    ,nvl(n.tax_id, o.tax_id) as tax_id -- 税务登记证号码
    ,nvl(n.opr_name, o.opr_name) as opr_name -- 授权办理业务员姓名
    ,nvl(n.opr_cert_type, o.opr_cert_type) as opr_cert_type -- 授权办理业务员身份证件类型
    ,nvl(n.opr_cert_no, o.opr_cert_no) as opr_cert_no -- 授权办理业务员身份证件号码
    ,nvl(n.opr_cert_invalid_dt, o.opr_cert_invalid_dt) as opr_cert_invalid_dt -- 授权办理业务员身份证件有效期限到期日
    ,nvl(n.is_pos, o.is_pos) as is_pos -- 是否我行POS客户
    ,nvl(n.oth_cert_type, o.oth_cert_type) as oth_cert_type -- 其他证件类型
    ,nvl(n.oth_legal_cert_type, o.oth_legal_cert_type) as oth_legal_cert_type -- 法定代表人其他证件类型编码
    ,nvl(n.oth_ctrl_cert_type, o.oth_ctrl_cert_type) as oth_ctrl_cert_type -- 实际控制人其他身份证件种类编码
    ,nvl(n.oth_hold_cert_type, o.oth_hold_cert_type) as oth_hold_cert_type -- 控股股东其他证件类型
    ,nvl(n.oth_opr_cert_type, o.oth_opr_cert_type) as oth_opr_cert_type -- 授权办理业务人员其他身份证件类型
    ,nvl(n.close_dt, o.close_dt) as close_dt -- 
    ,case when
            n.cust_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cust_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cust_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amls_t2a_cust_c_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amls_t2a_cust_c where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cust_id = n.cust_id
where (
        o.cust_id is null
    )
    or (
        n.cust_id is null
    )
    or (
        o.org_id <> n.org_id
        or o.create_dt <> n.create_dt
        or o.cust_name <> n.cust_name
        or o.cust_en_name <> n.cust_en_name
        or o.cust_sts <> n.cust_sts
        or o.cust_type <> n.cust_type
        or o.aml_cust_type <> n.aml_cust_type
        or o.pbc_cust_type <> n.pbc_cust_type
        or o.pbc_indus <> n.pbc_indus
        or o.s_indus <> n.s_indus
        or o.cust_nat <> n.cust_nat
        or o.cust_area <> n.cust_area
        or o.reg_addr <> n.reg_addr
        or o.biz_addr <> n.biz_addr
        or o.cert_type <> n.cert_type
        or o.s_cert_type <> n.s_cert_type
        or o.cert_no <> n.cert_no
        or o.cert_valid_dt <> n.cert_valid_dt
        or o.cert_invalid_dt <> n.cert_invalid_dt
        or o.cert_addr <> n.cert_addr
        or o.corp_estb_dt <> n.corp_estb_dt
        or o.corp_type <> n.corp_type
        or o.corp_reg_type <> n.corp_reg_type
        or o.reg_fund_amt <> n.reg_fund_amt
        or o.reg_fund_curr_cd <> n.reg_fund_curr_cd
        or o.office_tel <> n.office_tel
        or o.website <> n.website
        or o.email <> n.email
        or o.legal_name <> n.legal_name
        or o.legal_cert_type <> n.legal_cert_type
        or o.legal_cert_no <> n.legal_cert_no
        or o.legal_cert_valid_dt <> n.legal_cert_valid_dt
        or o.legal_cert_invalid_dt <> n.legal_cert_invalid_dt
        or o.legal_cust_id <> n.legal_cust_id
        or o.legal_tel <> n.legal_tel
        or o.legal_addr <> n.legal_addr
        or o.is_group_cust <> n.is_group_cust
        or o.credit_no <> n.credit_no
        or o.credit_valid_dt <> n.credit_valid_dt
        or o.credit_invalid_dt <> n.credit_invalid_dt
        or o.organ_code <> n.organ_code
        or o.organ_code_valid_dt <> n.organ_code_valid_dt
        or o.organ_code_invalid_dt <> n.organ_code_invalid_dt
        or o.biz_lic_no <> n.biz_lic_no
        or o.biz_lic_no_valid_dt <> n.biz_lic_no_valid_dt
        or o.biz_lic_no_invalid_dt <> n.biz_lic_no_invalid_dt
        or o.biz_scope <> n.biz_scope
        or o.main_biz <> n.main_biz
        or o.mgr_id <> n.mgr_id
        or o.mgr_name <> n.mgr_name
        or o.ctrl_name <> n.ctrl_name
        or o.ctrl_cert_type <> n.ctrl_cert_type
        or o.ctrl_cert_no <> n.ctrl_cert_no
        or o.ctrl_cert_valid_dt <> n.ctrl_cert_valid_dt
        or o.ctrl_cert_invalid_dt <> n.ctrl_cert_invalid_dt
        or o.corp_lkm_name <> n.corp_lkm_name
        or o.corp_lkm_tel <> n.corp_lkm_tel
        or o.hold_name <> n.hold_name
        or o.hold_cert_type <> n.hold_cert_type
        or o.hold_cert_no <> n.hold_cert_no
        or o.hold_cert_valid_dt <> n.hold_cert_valid_dt
        or o.hold_cert_invalid_dt <> n.hold_cert_invalid_dt
        or o.rsrv_01 <> n.rsrv_01
        or o.rsrv_02 <> n.rsrv_02
        or o.rsrv_03 <> n.rsrv_03
        or o.rsrv_04 <> n.rsrv_04
        or o.is_ebank <> n.is_ebank
        or o.is_loan <> n.is_loan
        or o.create_channel <> n.create_channel
        or o.is_free_trade <> n.is_free_trade
        or o.remarks <> n.remarks
        or o.tax_id <> n.tax_id
        or o.opr_name <> n.opr_name
        or o.opr_cert_type <> n.opr_cert_type
        or o.opr_cert_no <> n.opr_cert_no
        or o.opr_cert_invalid_dt <> n.opr_cert_invalid_dt
        or o.is_pos <> n.is_pos
        or o.oth_cert_type <> n.oth_cert_type
        or o.oth_legal_cert_type <> n.oth_legal_cert_type
        or o.oth_ctrl_cert_type <> n.oth_ctrl_cert_type
        or o.oth_hold_cert_type <> n.oth_hold_cert_type
        or o.oth_opr_cert_type <> n.oth_opr_cert_type
        or o.close_dt <> n.close_dt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amls_t2a_cust_c_cl(
            cust_id -- 客户编号
            ,org_id -- 归属机构编号
            ,create_dt -- 建立日期
            ,cust_name -- 客户名称
            ,cust_en_name -- 客户英文名称
            ,cust_sts -- 客户状态（参见[字典:AML0078]）
            ,cust_type -- 客户类型（参见[字典:AML0030]）
            ,aml_cust_type -- AML客户类型（参见[字典:AML0079]）
            ,pbc_cust_type -- PBC客户类型（参见[字典:AML0043]）
            ,pbc_indus -- PBC行业分类
            ,s_indus -- 源系统行业分类
            ,cust_nat -- 国籍
            ,cust_area -- 地区代码
            ,reg_addr -- 注册地址
            ,biz_addr -- 营业地址
            ,cert_type -- 证件类型
            ,s_cert_type -- 源系统证件类型
            ,cert_no -- 证件号码
            ,cert_valid_dt -- 证件生效日期
            ,cert_invalid_dt -- 证件失效日期
            ,cert_addr -- 证件地址
            ,corp_estb_dt -- 企业成立日期
            ,corp_type -- 企业类型
            ,corp_reg_type -- 企业经济性质
            ,reg_fund_amt -- 注册资本
            ,reg_fund_curr_cd -- 注册资本币种
            ,office_tel -- 办公电话
            ,website -- 网址
            ,email -- Email地址
            ,legal_name -- 法定代表人名称
            ,legal_cert_type -- 法定代表人证件类型
            ,legal_cert_no -- 法定代表人证件号码
            ,legal_cert_valid_dt -- 法定代表人证件生效日期
            ,legal_cert_invalid_dt -- 法定代表人证件失效日期
            ,legal_cust_id -- 法定代表人客户编号
            ,legal_tel -- 法定代表人联系电话
            ,legal_addr -- 法定代表人联系地址
            ,is_group_cust -- 是否集团客户（参见[字典:AML0080]）
            ,credit_no -- 机构信用代码
            ,credit_valid_dt -- 机构信用代码生效日期2
            ,credit_invalid_dt -- 机构信用代码失效日期2
            ,organ_code -- 组织机构代码
            ,organ_code_valid_dt -- 组织机构代码生效日期
            ,organ_code_invalid_dt -- 组织机构代码失效日期
            ,biz_lic_no -- 营业执照号码
            ,biz_lic_no_valid_dt -- 营业执照号码生效日期
            ,biz_lic_no_invalid_dt -- 营业执照号码失效日期
            ,biz_scope -- 经营范围
            ,main_biz -- 主营业务
            ,mgr_id -- 客户经理编号
            ,mgr_name -- 客户经理名称
            ,ctrl_name -- 实际控制人姓名
            ,ctrl_cert_type -- 实际控制人证件类型
            ,ctrl_cert_no -- 实际控制人证件号码
            ,ctrl_cert_valid_dt -- 实际控制人证件生效日期
            ,ctrl_cert_invalid_dt -- 实际控制人证件失效日期
            ,corp_lkm_name -- 企业联系人姓名
            ,corp_lkm_tel -- 企业联系人电话
            ,hold_name -- 控股股东名称
            ,hold_cert_type -- 控股股东证件类型
            ,hold_cert_no -- 控股股东证件号码
            ,hold_cert_valid_dt -- 控股股东证件生效日期
            ,hold_cert_invalid_dt -- 控股股东证件失效日期
            ,rsrv_01 -- 备用字段1---放置的是cif潜在客户字段码值
            ,rsrv_02 -- 备用字段2
            ,rsrv_03 -- 备用字段3
            ,rsrv_04 -- 备用字段4
            ,is_ebank -- 是否网银客户(0:否,1:是)
            ,is_loan -- 是否贷款客户(0:否,1:是)
            ,create_channel -- 客户创建渠道
            ,is_free_trade -- 是否自贸区
            ,remarks -- 备注
            ,tax_id -- 税务登记证号码
            ,opr_name -- 授权办理业务员姓名
            ,opr_cert_type -- 授权办理业务员身份证件类型
            ,opr_cert_no -- 授权办理业务员身份证件号码
            ,opr_cert_invalid_dt -- 授权办理业务员身份证件有效期限到期日
            ,is_pos -- 是否我行POS客户
            ,oth_cert_type -- 其他证件类型
            ,oth_legal_cert_type -- 法定代表人其他证件类型编码
            ,oth_ctrl_cert_type -- 实际控制人其他身份证件种类编码
            ,oth_hold_cert_type -- 控股股东其他证件类型
            ,oth_opr_cert_type -- 授权办理业务人员其他身份证件类型
            ,close_dt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amls_t2a_cust_c_op(
            cust_id -- 客户编号
            ,org_id -- 归属机构编号
            ,create_dt -- 建立日期
            ,cust_name -- 客户名称
            ,cust_en_name -- 客户英文名称
            ,cust_sts -- 客户状态（参见[字典:AML0078]）
            ,cust_type -- 客户类型（参见[字典:AML0030]）
            ,aml_cust_type -- AML客户类型（参见[字典:AML0079]）
            ,pbc_cust_type -- PBC客户类型（参见[字典:AML0043]）
            ,pbc_indus -- PBC行业分类
            ,s_indus -- 源系统行业分类
            ,cust_nat -- 国籍
            ,cust_area -- 地区代码
            ,reg_addr -- 注册地址
            ,biz_addr -- 营业地址
            ,cert_type -- 证件类型
            ,s_cert_type -- 源系统证件类型
            ,cert_no -- 证件号码
            ,cert_valid_dt -- 证件生效日期
            ,cert_invalid_dt -- 证件失效日期
            ,cert_addr -- 证件地址
            ,corp_estb_dt -- 企业成立日期
            ,corp_type -- 企业类型
            ,corp_reg_type -- 企业经济性质
            ,reg_fund_amt -- 注册资本
            ,reg_fund_curr_cd -- 注册资本币种
            ,office_tel -- 办公电话
            ,website -- 网址
            ,email -- Email地址
            ,legal_name -- 法定代表人名称
            ,legal_cert_type -- 法定代表人证件类型
            ,legal_cert_no -- 法定代表人证件号码
            ,legal_cert_valid_dt -- 法定代表人证件生效日期
            ,legal_cert_invalid_dt -- 法定代表人证件失效日期
            ,legal_cust_id -- 法定代表人客户编号
            ,legal_tel -- 法定代表人联系电话
            ,legal_addr -- 法定代表人联系地址
            ,is_group_cust -- 是否集团客户（参见[字典:AML0080]）
            ,credit_no -- 机构信用代码
            ,credit_valid_dt -- 机构信用代码生效日期2
            ,credit_invalid_dt -- 机构信用代码失效日期2
            ,organ_code -- 组织机构代码
            ,organ_code_valid_dt -- 组织机构代码生效日期
            ,organ_code_invalid_dt -- 组织机构代码失效日期
            ,biz_lic_no -- 营业执照号码
            ,biz_lic_no_valid_dt -- 营业执照号码生效日期
            ,biz_lic_no_invalid_dt -- 营业执照号码失效日期
            ,biz_scope -- 经营范围
            ,main_biz -- 主营业务
            ,mgr_id -- 客户经理编号
            ,mgr_name -- 客户经理名称
            ,ctrl_name -- 实际控制人姓名
            ,ctrl_cert_type -- 实际控制人证件类型
            ,ctrl_cert_no -- 实际控制人证件号码
            ,ctrl_cert_valid_dt -- 实际控制人证件生效日期
            ,ctrl_cert_invalid_dt -- 实际控制人证件失效日期
            ,corp_lkm_name -- 企业联系人姓名
            ,corp_lkm_tel -- 企业联系人电话
            ,hold_name -- 控股股东名称
            ,hold_cert_type -- 控股股东证件类型
            ,hold_cert_no -- 控股股东证件号码
            ,hold_cert_valid_dt -- 控股股东证件生效日期
            ,hold_cert_invalid_dt -- 控股股东证件失效日期
            ,rsrv_01 -- 备用字段1---放置的是cif潜在客户字段码值
            ,rsrv_02 -- 备用字段2
            ,rsrv_03 -- 备用字段3
            ,rsrv_04 -- 备用字段4
            ,is_ebank -- 是否网银客户(0:否,1:是)
            ,is_loan -- 是否贷款客户(0:否,1:是)
            ,create_channel -- 客户创建渠道
            ,is_free_trade -- 是否自贸区
            ,remarks -- 备注
            ,tax_id -- 税务登记证号码
            ,opr_name -- 授权办理业务员姓名
            ,opr_cert_type -- 授权办理业务员身份证件类型
            ,opr_cert_no -- 授权办理业务员身份证件号码
            ,opr_cert_invalid_dt -- 授权办理业务员身份证件有效期限到期日
            ,is_pos -- 是否我行POS客户
            ,oth_cert_type -- 其他证件类型
            ,oth_legal_cert_type -- 法定代表人其他证件类型编码
            ,oth_ctrl_cert_type -- 实际控制人其他身份证件种类编码
            ,oth_hold_cert_type -- 控股股东其他证件类型
            ,oth_opr_cert_type -- 授权办理业务人员其他身份证件类型
            ,close_dt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cust_id -- 客户编号
    ,o.org_id -- 归属机构编号
    ,o.create_dt -- 建立日期
    ,o.cust_name -- 客户名称
    ,o.cust_en_name -- 客户英文名称
    ,o.cust_sts -- 客户状态（参见[字典:AML0078]）
    ,o.cust_type -- 客户类型（参见[字典:AML0030]）
    ,o.aml_cust_type -- AML客户类型（参见[字典:AML0079]）
    ,o.pbc_cust_type -- PBC客户类型（参见[字典:AML0043]）
    ,o.pbc_indus -- PBC行业分类
    ,o.s_indus -- 源系统行业分类
    ,o.cust_nat -- 国籍
    ,o.cust_area -- 地区代码
    ,o.reg_addr -- 注册地址
    ,o.biz_addr -- 营业地址
    ,o.cert_type -- 证件类型
    ,o.s_cert_type -- 源系统证件类型
    ,o.cert_no -- 证件号码
    ,o.cert_valid_dt -- 证件生效日期
    ,o.cert_invalid_dt -- 证件失效日期
    ,o.cert_addr -- 证件地址
    ,o.corp_estb_dt -- 企业成立日期
    ,o.corp_type -- 企业类型
    ,o.corp_reg_type -- 企业经济性质
    ,o.reg_fund_amt -- 注册资本
    ,o.reg_fund_curr_cd -- 注册资本币种
    ,o.office_tel -- 办公电话
    ,o.website -- 网址
    ,o.email -- Email地址
    ,o.legal_name -- 法定代表人名称
    ,o.legal_cert_type -- 法定代表人证件类型
    ,o.legal_cert_no -- 法定代表人证件号码
    ,o.legal_cert_valid_dt -- 法定代表人证件生效日期
    ,o.legal_cert_invalid_dt -- 法定代表人证件失效日期
    ,o.legal_cust_id -- 法定代表人客户编号
    ,o.legal_tel -- 法定代表人联系电话
    ,o.legal_addr -- 法定代表人联系地址
    ,o.is_group_cust -- 是否集团客户（参见[字典:AML0080]）
    ,o.credit_no -- 机构信用代码
    ,o.credit_valid_dt -- 机构信用代码生效日期2
    ,o.credit_invalid_dt -- 机构信用代码失效日期2
    ,o.organ_code -- 组织机构代码
    ,o.organ_code_valid_dt -- 组织机构代码生效日期
    ,o.organ_code_invalid_dt -- 组织机构代码失效日期
    ,o.biz_lic_no -- 营业执照号码
    ,o.biz_lic_no_valid_dt -- 营业执照号码生效日期
    ,o.biz_lic_no_invalid_dt -- 营业执照号码失效日期
    ,o.biz_scope -- 经营范围
    ,o.main_biz -- 主营业务
    ,o.mgr_id -- 客户经理编号
    ,o.mgr_name -- 客户经理名称
    ,o.ctrl_name -- 实际控制人姓名
    ,o.ctrl_cert_type -- 实际控制人证件类型
    ,o.ctrl_cert_no -- 实际控制人证件号码
    ,o.ctrl_cert_valid_dt -- 实际控制人证件生效日期
    ,o.ctrl_cert_invalid_dt -- 实际控制人证件失效日期
    ,o.corp_lkm_name -- 企业联系人姓名
    ,o.corp_lkm_tel -- 企业联系人电话
    ,o.hold_name -- 控股股东名称
    ,o.hold_cert_type -- 控股股东证件类型
    ,o.hold_cert_no -- 控股股东证件号码
    ,o.hold_cert_valid_dt -- 控股股东证件生效日期
    ,o.hold_cert_invalid_dt -- 控股股东证件失效日期
    ,o.rsrv_01 -- 备用字段1---放置的是cif潜在客户字段码值
    ,o.rsrv_02 -- 备用字段2
    ,o.rsrv_03 -- 备用字段3
    ,o.rsrv_04 -- 备用字段4
    ,o.is_ebank -- 是否网银客户(0:否,1:是)
    ,o.is_loan -- 是否贷款客户(0:否,1:是)
    ,o.create_channel -- 客户创建渠道
    ,o.is_free_trade -- 是否自贸区
    ,o.remarks -- 备注
    ,o.tax_id -- 税务登记证号码
    ,o.opr_name -- 授权办理业务员姓名
    ,o.opr_cert_type -- 授权办理业务员身份证件类型
    ,o.opr_cert_no -- 授权办理业务员身份证件号码
    ,o.opr_cert_invalid_dt -- 授权办理业务员身份证件有效期限到期日
    ,o.is_pos -- 是否我行POS客户
    ,o.oth_cert_type -- 其他证件类型
    ,o.oth_legal_cert_type -- 法定代表人其他证件类型编码
    ,o.oth_ctrl_cert_type -- 实际控制人其他身份证件种类编码
    ,o.oth_hold_cert_type -- 控股股东其他证件类型
    ,o.oth_opr_cert_type -- 授权办理业务人员其他身份证件类型
    ,o.close_dt -- 
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
from ${iol_schema}.amls_t2a_cust_c_bk o
    left join ${iol_schema}.amls_t2a_cust_c_op n
        on
            o.cust_id = n.cust_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amls_t2a_cust_c_cl d
        on
            o.cust_id = d.cust_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amls_t2a_cust_c;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amls_t2a_cust_c') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amls_t2a_cust_c drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amls_t2a_cust_c add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amls_t2a_cust_c exchange partition p_${batch_date} with table ${iol_schema}.amls_t2a_cust_c_cl;
alter table ${iol_schema}.amls_t2a_cust_c exchange partition p_20991231 with table ${iol_schema}.amls_t2a_cust_c_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amls_t2a_cust_c to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t2a_cust_c_op purge;
drop table ${iol_schema}.amls_t2a_cust_c_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amls_t2a_cust_c_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amls_t2a_cust_c',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
