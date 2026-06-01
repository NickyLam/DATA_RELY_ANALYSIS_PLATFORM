/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rtis_bank_cust_corp
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
create table ${iol_schema}.rtis_bank_cust_corp_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rtis_bank_cust_corp
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rtis_bank_cust_corp_op purge;
drop table ${iol_schema}.rtis_bank_cust_corp_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rtis_bank_cust_corp_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rtis_bank_cust_corp where 0=1;

create table ${iol_schema}.rtis_bank_cust_corp_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rtis_bank_cust_corp where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rtis_bank_cust_corp_cl(
            biz_lic_exp_date -- 营业执照到期日期
            ,open_at -- 开户时间
            ,create_at -- 入库时间
            ,create_by -- 入库人
            ,last_update_at -- 入库后最后变更时间
            ,last_update_by -- 最后变更人
            ,cust_surname -- 客户姓氏
            ,cust_middle_name -- 客户中间名
            ,cust_first_name -- 客户名字
            ,id_card_type -- 证件类型
            ,id_card_number -- 证件号码
            ,mobile_number -- 预留手机号
            ,age -- 年龄(法人年龄)
            ,cust_open_inst_prov -- 开户机构所在省
            ,cust_open_inst_city -- 开户机构所在市
            ,id_card_prov -- 身份证归属省
            ,id_card_city -- 身份证归属市
            ,mobile_prov -- 预留手机号归属省
            ,mobile_city -- 预留手机号归属市
            ,gender -- 性别
            ,risk_level -- 风险等级
            ,cust_build_channel -- 客户信息建立渠道
            ,occupation -- 职业
            ,register_address -- 注册地址
            ,business_address -- 办公地址
            ,operation_no -- 运营机构编号
            ,corporate_card_indate -- 法定代表人证件有效期
            ,cust_principal_name -- 客户负责人姓名
            ,cust_principal_card_type -- 客户负责人证件类型
            ,cust_principal_card_indate -- 单位负责人证件有效期
            ,cust_receiptor_name -- 客户受益人姓名
            ,cust_receiptor_card_type -- 客户受益人证件类型
            ,cust_receiptor_card_no -- 客户受益人证件号
            ,cust_linkman_name -- 客户业务联系人姓名
            ,cust_linkman_card_type -- 客户业务联系人证件类型
            ,cust_linkman_card_no -- 客户业务联系人证件号
            ,cust_agent_name -- 客户授权代表人姓名
            ,cust_agent_card_type -- 客户授权代表人证件类型
            ,cust_agent_card_no -- 客户授权代表人证件号
            ,cust_charater -- 客户性质
            ,cust_type -- 客户类型
            ,corporate_phone_no -- 法人联系电话
            ,finance_mgr_phone_no -- 财务负责人联系电话
            ,posta_addr -- 通讯地址
            ,iden_addr -- 户口所在地
            ,work_unit_addr -- 单位地址
            ,if_acct_black -- 是否为黑名单
            ,cust_id -- 客户号
            ,cust_name -- 客户名称
            ,cust_stat -- 客户状态
            ,cust_open_inst_no -- 开户机构编号
            ,cust_open_inst_name -- 开户机构名称
            ,corp_cert_type -- 企业证件类型
            ,corp_cert_no -- 企业证件号码
            ,cust_kind -- 企业种类
            ,country -- 国别代码
            ,ind_type -- 行业分类代码
            ,corp_scale -- 企业规模
            ,corp_scope -- 经营范围
            ,address -- 客户地址
            ,tel -- 联系电话
            ,fex -- 传真号码
            ,email -- 电子邮箱
            ,reg_capital -- 注册资本
            ,contrib_capital -- 实缴资本
            ,reg_date -- 注册时间
            ,legal_name -- 法人姓名
            ,legal_cert_type -- 法人证件类型
            ,legal_cert_no -- 法人证件号码
            ,financial_name -- 财务姓名
            ,financial_cert_type -- 财务证件类型
            ,financial_cert_no -- 财务证件号码
            ,manager_no -- 客户经理编号
            ,manager_name -- 客户经理姓名
            ,manager_mobile -- 客户经理手机号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rtis_bank_cust_corp_op(
            biz_lic_exp_date -- 营业执照到期日期
            ,open_at -- 开户时间
            ,create_at -- 入库时间
            ,create_by -- 入库人
            ,last_update_at -- 入库后最后变更时间
            ,last_update_by -- 最后变更人
            ,cust_surname -- 客户姓氏
            ,cust_middle_name -- 客户中间名
            ,cust_first_name -- 客户名字
            ,id_card_type -- 证件类型
            ,id_card_number -- 证件号码
            ,mobile_number -- 预留手机号
            ,age -- 年龄(法人年龄)
            ,cust_open_inst_prov -- 开户机构所在省
            ,cust_open_inst_city -- 开户机构所在市
            ,id_card_prov -- 身份证归属省
            ,id_card_city -- 身份证归属市
            ,mobile_prov -- 预留手机号归属省
            ,mobile_city -- 预留手机号归属市
            ,gender -- 性别
            ,risk_level -- 风险等级
            ,cust_build_channel -- 客户信息建立渠道
            ,occupation -- 职业
            ,register_address -- 注册地址
            ,business_address -- 办公地址
            ,operation_no -- 运营机构编号
            ,corporate_card_indate -- 法定代表人证件有效期
            ,cust_principal_name -- 客户负责人姓名
            ,cust_principal_card_type -- 客户负责人证件类型
            ,cust_principal_card_indate -- 单位负责人证件有效期
            ,cust_receiptor_name -- 客户受益人姓名
            ,cust_receiptor_card_type -- 客户受益人证件类型
            ,cust_receiptor_card_no -- 客户受益人证件号
            ,cust_linkman_name -- 客户业务联系人姓名
            ,cust_linkman_card_type -- 客户业务联系人证件类型
            ,cust_linkman_card_no -- 客户业务联系人证件号
            ,cust_agent_name -- 客户授权代表人姓名
            ,cust_agent_card_type -- 客户授权代表人证件类型
            ,cust_agent_card_no -- 客户授权代表人证件号
            ,cust_charater -- 客户性质
            ,cust_type -- 客户类型
            ,corporate_phone_no -- 法人联系电话
            ,finance_mgr_phone_no -- 财务负责人联系电话
            ,posta_addr -- 通讯地址
            ,iden_addr -- 户口所在地
            ,work_unit_addr -- 单位地址
            ,if_acct_black -- 是否为黑名单
            ,cust_id -- 客户号
            ,cust_name -- 客户名称
            ,cust_stat -- 客户状态
            ,cust_open_inst_no -- 开户机构编号
            ,cust_open_inst_name -- 开户机构名称
            ,corp_cert_type -- 企业证件类型
            ,corp_cert_no -- 企业证件号码
            ,cust_kind -- 企业种类
            ,country -- 国别代码
            ,ind_type -- 行业分类代码
            ,corp_scale -- 企业规模
            ,corp_scope -- 经营范围
            ,address -- 客户地址
            ,tel -- 联系电话
            ,fex -- 传真号码
            ,email -- 电子邮箱
            ,reg_capital -- 注册资本
            ,contrib_capital -- 实缴资本
            ,reg_date -- 注册时间
            ,legal_name -- 法人姓名
            ,legal_cert_type -- 法人证件类型
            ,legal_cert_no -- 法人证件号码
            ,financial_name -- 财务姓名
            ,financial_cert_type -- 财务证件类型
            ,financial_cert_no -- 财务证件号码
            ,manager_no -- 客户经理编号
            ,manager_name -- 客户经理姓名
            ,manager_mobile -- 客户经理手机号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.biz_lic_exp_date, o.biz_lic_exp_date) as biz_lic_exp_date -- 营业执照到期日期
    ,nvl(n.open_at, o.open_at) as open_at -- 开户时间
    ,nvl(n.create_at, o.create_at) as create_at -- 入库时间
    ,nvl(n.create_by, o.create_by) as create_by -- 入库人
    ,nvl(n.last_update_at, o.last_update_at) as last_update_at -- 入库后最后变更时间
    ,nvl(n.last_update_by, o.last_update_by) as last_update_by -- 最后变更人
    ,nvl(n.cust_surname, o.cust_surname) as cust_surname -- 客户姓氏
    ,nvl(n.cust_middle_name, o.cust_middle_name) as cust_middle_name -- 客户中间名
    ,nvl(n.cust_first_name, o.cust_first_name) as cust_first_name -- 客户名字
    ,nvl(n.id_card_type, o.id_card_type) as id_card_type -- 证件类型
    ,nvl(n.id_card_number, o.id_card_number) as id_card_number -- 证件号码
    ,nvl(n.mobile_number, o.mobile_number) as mobile_number -- 预留手机号
    ,nvl(n.age, o.age) as age -- 年龄(法人年龄)
    ,nvl(n.cust_open_inst_prov, o.cust_open_inst_prov) as cust_open_inst_prov -- 开户机构所在省
    ,nvl(n.cust_open_inst_city, o.cust_open_inst_city) as cust_open_inst_city -- 开户机构所在市
    ,nvl(n.id_card_prov, o.id_card_prov) as id_card_prov -- 身份证归属省
    ,nvl(n.id_card_city, o.id_card_city) as id_card_city -- 身份证归属市
    ,nvl(n.mobile_prov, o.mobile_prov) as mobile_prov -- 预留手机号归属省
    ,nvl(n.mobile_city, o.mobile_city) as mobile_city -- 预留手机号归属市
    ,nvl(n.gender, o.gender) as gender -- 性别
    ,nvl(n.risk_level, o.risk_level) as risk_level -- 风险等级
    ,nvl(n.cust_build_channel, o.cust_build_channel) as cust_build_channel -- 客户信息建立渠道
    ,nvl(n.occupation, o.occupation) as occupation -- 职业
    ,nvl(n.register_address, o.register_address) as register_address -- 注册地址
    ,nvl(n.business_address, o.business_address) as business_address -- 办公地址
    ,nvl(n.operation_no, o.operation_no) as operation_no -- 运营机构编号
    ,nvl(n.corporate_card_indate, o.corporate_card_indate) as corporate_card_indate -- 法定代表人证件有效期
    ,nvl(n.cust_principal_name, o.cust_principal_name) as cust_principal_name -- 客户负责人姓名
    ,nvl(n.cust_principal_card_type, o.cust_principal_card_type) as cust_principal_card_type -- 客户负责人证件类型
    ,nvl(n.cust_principal_card_indate, o.cust_principal_card_indate) as cust_principal_card_indate -- 单位负责人证件有效期
    ,nvl(n.cust_receiptor_name, o.cust_receiptor_name) as cust_receiptor_name -- 客户受益人姓名
    ,nvl(n.cust_receiptor_card_type, o.cust_receiptor_card_type) as cust_receiptor_card_type -- 客户受益人证件类型
    ,nvl(n.cust_receiptor_card_no, o.cust_receiptor_card_no) as cust_receiptor_card_no -- 客户受益人证件号
    ,nvl(n.cust_linkman_name, o.cust_linkman_name) as cust_linkman_name -- 客户业务联系人姓名
    ,nvl(n.cust_linkman_card_type, o.cust_linkman_card_type) as cust_linkman_card_type -- 客户业务联系人证件类型
    ,nvl(n.cust_linkman_card_no, o.cust_linkman_card_no) as cust_linkman_card_no -- 客户业务联系人证件号
    ,nvl(n.cust_agent_name, o.cust_agent_name) as cust_agent_name -- 客户授权代表人姓名
    ,nvl(n.cust_agent_card_type, o.cust_agent_card_type) as cust_agent_card_type -- 客户授权代表人证件类型
    ,nvl(n.cust_agent_card_no, o.cust_agent_card_no) as cust_agent_card_no -- 客户授权代表人证件号
    ,nvl(n.cust_charater, o.cust_charater) as cust_charater -- 客户性质
    ,nvl(n.cust_type, o.cust_type) as cust_type -- 客户类型
    ,nvl(n.corporate_phone_no, o.corporate_phone_no) as corporate_phone_no -- 法人联系电话
    ,nvl(n.finance_mgr_phone_no, o.finance_mgr_phone_no) as finance_mgr_phone_no -- 财务负责人联系电话
    ,nvl(n.posta_addr, o.posta_addr) as posta_addr -- 通讯地址
    ,nvl(n.iden_addr, o.iden_addr) as iden_addr -- 户口所在地
    ,nvl(n.work_unit_addr, o.work_unit_addr) as work_unit_addr -- 单位地址
    ,nvl(n.if_acct_black, o.if_acct_black) as if_acct_black -- 是否为黑名单
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cust_stat, o.cust_stat) as cust_stat -- 客户状态
    ,nvl(n.cust_open_inst_no, o.cust_open_inst_no) as cust_open_inst_no -- 开户机构编号
    ,nvl(n.cust_open_inst_name, o.cust_open_inst_name) as cust_open_inst_name -- 开户机构名称
    ,nvl(n.corp_cert_type, o.corp_cert_type) as corp_cert_type -- 企业证件类型
    ,nvl(n.corp_cert_no, o.corp_cert_no) as corp_cert_no -- 企业证件号码
    ,nvl(n.cust_kind, o.cust_kind) as cust_kind -- 企业种类
    ,nvl(n.country, o.country) as country -- 国别代码
    ,nvl(n.ind_type, o.ind_type) as ind_type -- 行业分类代码
    ,nvl(n.corp_scale, o.corp_scale) as corp_scale -- 企业规模
    ,nvl(n.corp_scope, o.corp_scope) as corp_scope -- 经营范围
    ,nvl(n.address, o.address) as address -- 客户地址
    ,nvl(n.tel, o.tel) as tel -- 联系电话
    ,nvl(n.fex, o.fex) as fex -- 传真号码
    ,nvl(n.email, o.email) as email -- 电子邮箱
    ,nvl(n.reg_capital, o.reg_capital) as reg_capital -- 注册资本
    ,nvl(n.contrib_capital, o.contrib_capital) as contrib_capital -- 实缴资本
    ,nvl(n.reg_date, o.reg_date) as reg_date -- 注册时间
    ,nvl(n.legal_name, o.legal_name) as legal_name -- 法人姓名
    ,nvl(n.legal_cert_type, o.legal_cert_type) as legal_cert_type -- 法人证件类型
    ,nvl(n.legal_cert_no, o.legal_cert_no) as legal_cert_no -- 法人证件号码
    ,nvl(n.financial_name, o.financial_name) as financial_name -- 财务姓名
    ,nvl(n.financial_cert_type, o.financial_cert_type) as financial_cert_type -- 财务证件类型
    ,nvl(n.financial_cert_no, o.financial_cert_no) as financial_cert_no -- 财务证件号码
    ,nvl(n.manager_no, o.manager_no) as manager_no -- 客户经理编号
    ,nvl(n.manager_name, o.manager_name) as manager_name -- 客户经理姓名
    ,nvl(n.manager_mobile, o.manager_mobile) as manager_mobile -- 客户经理手机号
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
from (select * from ${iol_schema}.rtis_bank_cust_corp_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rtis_bank_cust_corp where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cust_id = n.cust_id
where (
        o.cust_id is null
    )
    or (
        n.cust_id is null
    )
    or (
        o.biz_lic_exp_date <> n.biz_lic_exp_date
        or o.open_at <> n.open_at
        or o.create_at <> n.create_at
        or o.create_by <> n.create_by
        or o.last_update_at <> n.last_update_at
        or o.last_update_by <> n.last_update_by
        or o.cust_surname <> n.cust_surname
        or o.cust_middle_name <> n.cust_middle_name
        or o.cust_first_name <> n.cust_first_name
        or o.id_card_type <> n.id_card_type
        or o.id_card_number <> n.id_card_number
        or o.mobile_number <> n.mobile_number
        or o.age <> n.age
        or o.cust_open_inst_prov <> n.cust_open_inst_prov
        or o.cust_open_inst_city <> n.cust_open_inst_city
        or o.id_card_prov <> n.id_card_prov
        or o.id_card_city <> n.id_card_city
        or o.mobile_prov <> n.mobile_prov
        or o.mobile_city <> n.mobile_city
        or o.gender <> n.gender
        or o.risk_level <> n.risk_level
        or o.cust_build_channel <> n.cust_build_channel
        or o.occupation <> n.occupation
        or o.register_address <> n.register_address
        or o.business_address <> n.business_address
        or o.operation_no <> n.operation_no
        or o.corporate_card_indate <> n.corporate_card_indate
        or o.cust_principal_name <> n.cust_principal_name
        or o.cust_principal_card_type <> n.cust_principal_card_type
        or o.cust_principal_card_indate <> n.cust_principal_card_indate
        or o.cust_receiptor_name <> n.cust_receiptor_name
        or o.cust_receiptor_card_type <> n.cust_receiptor_card_type
        or o.cust_receiptor_card_no <> n.cust_receiptor_card_no
        or o.cust_linkman_name <> n.cust_linkman_name
        or o.cust_linkman_card_type <> n.cust_linkman_card_type
        or o.cust_linkman_card_no <> n.cust_linkman_card_no
        or o.cust_agent_name <> n.cust_agent_name
        or o.cust_agent_card_type <> n.cust_agent_card_type
        or o.cust_agent_card_no <> n.cust_agent_card_no
        or o.cust_charater <> n.cust_charater
        or o.cust_type <> n.cust_type
        or o.corporate_phone_no <> n.corporate_phone_no
        or o.finance_mgr_phone_no <> n.finance_mgr_phone_no
        or o.posta_addr <> n.posta_addr
        or o.iden_addr <> n.iden_addr
        or o.work_unit_addr <> n.work_unit_addr
        or o.if_acct_black <> n.if_acct_black
        or o.cust_name <> n.cust_name
        or o.cust_stat <> n.cust_stat
        or o.cust_open_inst_no <> n.cust_open_inst_no
        or o.cust_open_inst_name <> n.cust_open_inst_name
        or o.corp_cert_type <> n.corp_cert_type
        or o.corp_cert_no <> n.corp_cert_no
        or o.cust_kind <> n.cust_kind
        or o.country <> n.country
        or o.ind_type <> n.ind_type
        or o.corp_scale <> n.corp_scale
        or o.corp_scope <> n.corp_scope
        or o.address <> n.address
        or o.tel <> n.tel
        or o.fex <> n.fex
        or o.email <> n.email
        or o.reg_capital <> n.reg_capital
        or o.contrib_capital <> n.contrib_capital
        or o.reg_date <> n.reg_date
        or o.legal_name <> n.legal_name
        or o.legal_cert_type <> n.legal_cert_type
        or o.legal_cert_no <> n.legal_cert_no
        or o.financial_name <> n.financial_name
        or o.financial_cert_type <> n.financial_cert_type
        or o.financial_cert_no <> n.financial_cert_no
        or o.manager_no <> n.manager_no
        or o.manager_name <> n.manager_name
        or o.manager_mobile <> n.manager_mobile
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rtis_bank_cust_corp_cl(
            biz_lic_exp_date -- 营业执照到期日期
            ,open_at -- 开户时间
            ,create_at -- 入库时间
            ,create_by -- 入库人
            ,last_update_at -- 入库后最后变更时间
            ,last_update_by -- 最后变更人
            ,cust_surname -- 客户姓氏
            ,cust_middle_name -- 客户中间名
            ,cust_first_name -- 客户名字
            ,id_card_type -- 证件类型
            ,id_card_number -- 证件号码
            ,mobile_number -- 预留手机号
            ,age -- 年龄(法人年龄)
            ,cust_open_inst_prov -- 开户机构所在省
            ,cust_open_inst_city -- 开户机构所在市
            ,id_card_prov -- 身份证归属省
            ,id_card_city -- 身份证归属市
            ,mobile_prov -- 预留手机号归属省
            ,mobile_city -- 预留手机号归属市
            ,gender -- 性别
            ,risk_level -- 风险等级
            ,cust_build_channel -- 客户信息建立渠道
            ,occupation -- 职业
            ,register_address -- 注册地址
            ,business_address -- 办公地址
            ,operation_no -- 运营机构编号
            ,corporate_card_indate -- 法定代表人证件有效期
            ,cust_principal_name -- 客户负责人姓名
            ,cust_principal_card_type -- 客户负责人证件类型
            ,cust_principal_card_indate -- 单位负责人证件有效期
            ,cust_receiptor_name -- 客户受益人姓名
            ,cust_receiptor_card_type -- 客户受益人证件类型
            ,cust_receiptor_card_no -- 客户受益人证件号
            ,cust_linkman_name -- 客户业务联系人姓名
            ,cust_linkman_card_type -- 客户业务联系人证件类型
            ,cust_linkman_card_no -- 客户业务联系人证件号
            ,cust_agent_name -- 客户授权代表人姓名
            ,cust_agent_card_type -- 客户授权代表人证件类型
            ,cust_agent_card_no -- 客户授权代表人证件号
            ,cust_charater -- 客户性质
            ,cust_type -- 客户类型
            ,corporate_phone_no -- 法人联系电话
            ,finance_mgr_phone_no -- 财务负责人联系电话
            ,posta_addr -- 通讯地址
            ,iden_addr -- 户口所在地
            ,work_unit_addr -- 单位地址
            ,if_acct_black -- 是否为黑名单
            ,cust_id -- 客户号
            ,cust_name -- 客户名称
            ,cust_stat -- 客户状态
            ,cust_open_inst_no -- 开户机构编号
            ,cust_open_inst_name -- 开户机构名称
            ,corp_cert_type -- 企业证件类型
            ,corp_cert_no -- 企业证件号码
            ,cust_kind -- 企业种类
            ,country -- 国别代码
            ,ind_type -- 行业分类代码
            ,corp_scale -- 企业规模
            ,corp_scope -- 经营范围
            ,address -- 客户地址
            ,tel -- 联系电话
            ,fex -- 传真号码
            ,email -- 电子邮箱
            ,reg_capital -- 注册资本
            ,contrib_capital -- 实缴资本
            ,reg_date -- 注册时间
            ,legal_name -- 法人姓名
            ,legal_cert_type -- 法人证件类型
            ,legal_cert_no -- 法人证件号码
            ,financial_name -- 财务姓名
            ,financial_cert_type -- 财务证件类型
            ,financial_cert_no -- 财务证件号码
            ,manager_no -- 客户经理编号
            ,manager_name -- 客户经理姓名
            ,manager_mobile -- 客户经理手机号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rtis_bank_cust_corp_op(
            biz_lic_exp_date -- 营业执照到期日期
            ,open_at -- 开户时间
            ,create_at -- 入库时间
            ,create_by -- 入库人
            ,last_update_at -- 入库后最后变更时间
            ,last_update_by -- 最后变更人
            ,cust_surname -- 客户姓氏
            ,cust_middle_name -- 客户中间名
            ,cust_first_name -- 客户名字
            ,id_card_type -- 证件类型
            ,id_card_number -- 证件号码
            ,mobile_number -- 预留手机号
            ,age -- 年龄(法人年龄)
            ,cust_open_inst_prov -- 开户机构所在省
            ,cust_open_inst_city -- 开户机构所在市
            ,id_card_prov -- 身份证归属省
            ,id_card_city -- 身份证归属市
            ,mobile_prov -- 预留手机号归属省
            ,mobile_city -- 预留手机号归属市
            ,gender -- 性别
            ,risk_level -- 风险等级
            ,cust_build_channel -- 客户信息建立渠道
            ,occupation -- 职业
            ,register_address -- 注册地址
            ,business_address -- 办公地址
            ,operation_no -- 运营机构编号
            ,corporate_card_indate -- 法定代表人证件有效期
            ,cust_principal_name -- 客户负责人姓名
            ,cust_principal_card_type -- 客户负责人证件类型
            ,cust_principal_card_indate -- 单位负责人证件有效期
            ,cust_receiptor_name -- 客户受益人姓名
            ,cust_receiptor_card_type -- 客户受益人证件类型
            ,cust_receiptor_card_no -- 客户受益人证件号
            ,cust_linkman_name -- 客户业务联系人姓名
            ,cust_linkman_card_type -- 客户业务联系人证件类型
            ,cust_linkman_card_no -- 客户业务联系人证件号
            ,cust_agent_name -- 客户授权代表人姓名
            ,cust_agent_card_type -- 客户授权代表人证件类型
            ,cust_agent_card_no -- 客户授权代表人证件号
            ,cust_charater -- 客户性质
            ,cust_type -- 客户类型
            ,corporate_phone_no -- 法人联系电话
            ,finance_mgr_phone_no -- 财务负责人联系电话
            ,posta_addr -- 通讯地址
            ,iden_addr -- 户口所在地
            ,work_unit_addr -- 单位地址
            ,if_acct_black -- 是否为黑名单
            ,cust_id -- 客户号
            ,cust_name -- 客户名称
            ,cust_stat -- 客户状态
            ,cust_open_inst_no -- 开户机构编号
            ,cust_open_inst_name -- 开户机构名称
            ,corp_cert_type -- 企业证件类型
            ,corp_cert_no -- 企业证件号码
            ,cust_kind -- 企业种类
            ,country -- 国别代码
            ,ind_type -- 行业分类代码
            ,corp_scale -- 企业规模
            ,corp_scope -- 经营范围
            ,address -- 客户地址
            ,tel -- 联系电话
            ,fex -- 传真号码
            ,email -- 电子邮箱
            ,reg_capital -- 注册资本
            ,contrib_capital -- 实缴资本
            ,reg_date -- 注册时间
            ,legal_name -- 法人姓名
            ,legal_cert_type -- 法人证件类型
            ,legal_cert_no -- 法人证件号码
            ,financial_name -- 财务姓名
            ,financial_cert_type -- 财务证件类型
            ,financial_cert_no -- 财务证件号码
            ,manager_no -- 客户经理编号
            ,manager_name -- 客户经理姓名
            ,manager_mobile -- 客户经理手机号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.biz_lic_exp_date -- 营业执照到期日期
    ,o.open_at -- 开户时间
    ,o.create_at -- 入库时间
    ,o.create_by -- 入库人
    ,o.last_update_at -- 入库后最后变更时间
    ,o.last_update_by -- 最后变更人
    ,o.cust_surname -- 客户姓氏
    ,o.cust_middle_name -- 客户中间名
    ,o.cust_first_name -- 客户名字
    ,o.id_card_type -- 证件类型
    ,o.id_card_number -- 证件号码
    ,o.mobile_number -- 预留手机号
    ,o.age -- 年龄(法人年龄)
    ,o.cust_open_inst_prov -- 开户机构所在省
    ,o.cust_open_inst_city -- 开户机构所在市
    ,o.id_card_prov -- 身份证归属省
    ,o.id_card_city -- 身份证归属市
    ,o.mobile_prov -- 预留手机号归属省
    ,o.mobile_city -- 预留手机号归属市
    ,o.gender -- 性别
    ,o.risk_level -- 风险等级
    ,o.cust_build_channel -- 客户信息建立渠道
    ,o.occupation -- 职业
    ,o.register_address -- 注册地址
    ,o.business_address -- 办公地址
    ,o.operation_no -- 运营机构编号
    ,o.corporate_card_indate -- 法定代表人证件有效期
    ,o.cust_principal_name -- 客户负责人姓名
    ,o.cust_principal_card_type -- 客户负责人证件类型
    ,o.cust_principal_card_indate -- 单位负责人证件有效期
    ,o.cust_receiptor_name -- 客户受益人姓名
    ,o.cust_receiptor_card_type -- 客户受益人证件类型
    ,o.cust_receiptor_card_no -- 客户受益人证件号
    ,o.cust_linkman_name -- 客户业务联系人姓名
    ,o.cust_linkman_card_type -- 客户业务联系人证件类型
    ,o.cust_linkman_card_no -- 客户业务联系人证件号
    ,o.cust_agent_name -- 客户授权代表人姓名
    ,o.cust_agent_card_type -- 客户授权代表人证件类型
    ,o.cust_agent_card_no -- 客户授权代表人证件号
    ,o.cust_charater -- 客户性质
    ,o.cust_type -- 客户类型
    ,o.corporate_phone_no -- 法人联系电话
    ,o.finance_mgr_phone_no -- 财务负责人联系电话
    ,o.posta_addr -- 通讯地址
    ,o.iden_addr -- 户口所在地
    ,o.work_unit_addr -- 单位地址
    ,o.if_acct_black -- 是否为黑名单
    ,o.cust_id -- 客户号
    ,o.cust_name -- 客户名称
    ,o.cust_stat -- 客户状态
    ,o.cust_open_inst_no -- 开户机构编号
    ,o.cust_open_inst_name -- 开户机构名称
    ,o.corp_cert_type -- 企业证件类型
    ,o.corp_cert_no -- 企业证件号码
    ,o.cust_kind -- 企业种类
    ,o.country -- 国别代码
    ,o.ind_type -- 行业分类代码
    ,o.corp_scale -- 企业规模
    ,o.corp_scope -- 经营范围
    ,o.address -- 客户地址
    ,o.tel -- 联系电话
    ,o.fex -- 传真号码
    ,o.email -- 电子邮箱
    ,o.reg_capital -- 注册资本
    ,o.contrib_capital -- 实缴资本
    ,o.reg_date -- 注册时间
    ,o.legal_name -- 法人姓名
    ,o.legal_cert_type -- 法人证件类型
    ,o.legal_cert_no -- 法人证件号码
    ,o.financial_name -- 财务姓名
    ,o.financial_cert_type -- 财务证件类型
    ,o.financial_cert_no -- 财务证件号码
    ,o.manager_no -- 客户经理编号
    ,o.manager_name -- 客户经理姓名
    ,o.manager_mobile -- 客户经理手机号
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
from ${iol_schema}.rtis_bank_cust_corp_bk o
    left join ${iol_schema}.rtis_bank_cust_corp_op n
        on
            o.cust_id = n.cust_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rtis_bank_cust_corp_cl d
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
--truncate table ${iol_schema}.rtis_bank_cust_corp;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rtis_bank_cust_corp') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rtis_bank_cust_corp drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rtis_bank_cust_corp add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rtis_bank_cust_corp exchange partition p_${batch_date} with table ${iol_schema}.rtis_bank_cust_corp_cl;
alter table ${iol_schema}.rtis_bank_cust_corp exchange partition p_20991231 with table ${iol_schema}.rtis_bank_cust_corp_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rtis_bank_cust_corp to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rtis_bank_cust_corp_op purge;
drop table ${iol_schema}.rtis_bank_cust_corp_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rtis_bank_cust_corp_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rtis_bank_cust_corp',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
