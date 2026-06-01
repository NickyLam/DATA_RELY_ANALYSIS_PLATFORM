/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_customer_info
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
create table ${iol_schema}.bdms_bms_customer_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_bms_customer_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_customer_info_op purge;
drop table ${iol_schema}.bdms_bms_customer_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_customer_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_customer_info where 0=1;

create table ${iol_schema}.bdms_bms_customer_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_customer_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_customer_info_cl(
            id -- ID
            ,cust_type -- 客户类型
            ,cust_no -- 客户编号
            ,role_type -- 参与者类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,cust_name -- 客户名称
            ,cust_address -- 地址
            ,telephone -- 电话号码
            ,fax -- 传真
            ,contacter -- 联系人
            ,post -- 邮政编码
            ,province -- 行政区划
            ,city -- 城市
            ,class_id -- 性质ID
            ,scale_id -- 企业规模
            ,trade_type_id -- 所属行业类型
            ,credit_level_id -- 信用等级ID
            ,register_fund -- 注册资金
            ,group_flag -- 集团客户标志
            ,group_id -- 集团客户ID
            ,bank_no -- 人行支付行号
            ,bank_cate_id -- 行分类ID
            ,bank_level -- 行级别
            ,bln_brh_no -- 管理机构编号
            ,top_branch_no -- 所属总行机构
            ,company_up -- 上级公司
            ,company_flag -- 是否总公司： 0 否 1 是
            ,valid_flag -- 生效标志
            ,credit_flag -- 是否授信客户： 0 否 1 是
            ,organ_code -- 组织机构代码
            ,has_sign_web -- 签约网银标志
            ,last_upd_oper_no -- 最后更新操作员
            ,last_upd_time -- 最后更新时间
            ,group_rake -- 是否占用集团客户额度： 0 否 1 是
            ,dualcontrol_locks -- 双岗复核锁标记
            ,agent_flag -- 
            ,top_bank_no -- 
            ,account_no -- 
            ,delete_flag -- 删除标志： 0 否 1 是
            ,ind_cls -- 票交所行业分类
            ,corp_scale -- 票交所企业规模
            ,arc_flag -- 是否三农企业：0-否 1-是
            ,grn_flag -- 是否绿色企业：0-否 1-是
            ,social_credit_no -- 统一社会信用代码
            ,sci_flag -- 是否科技企业： 0 否 1 是
            ,pop_flag -- 是否民企： 0 否 1 是
            ,brh_no -- 会员机构代码
            ,create_time -- 创建时间
            ,quick_accept_flag -- 是否签约秒开： 0 否 1 是
            ,quick_discount_flag -- 是否签约秒贴： 0 否 1 是
            ,quick_collztn_flag -- 是否签约秒押： 0 否 1 是
            ,cross_flag -- 
            ,showr_acct_no -- 
            ,cpes_cust_info_id -- 
            ,message_status -- 
            ,reg_addr -- 
            ,per_name -- 
            ,doc_tp -- 
            ,doc_no -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_customer_info_op(
            id -- ID
            ,cust_type -- 客户类型
            ,cust_no -- 客户编号
            ,role_type -- 参与者类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,cust_name -- 客户名称
            ,cust_address -- 地址
            ,telephone -- 电话号码
            ,fax -- 传真
            ,contacter -- 联系人
            ,post -- 邮政编码
            ,province -- 行政区划
            ,city -- 城市
            ,class_id -- 性质ID
            ,scale_id -- 企业规模
            ,trade_type_id -- 所属行业类型
            ,credit_level_id -- 信用等级ID
            ,register_fund -- 注册资金
            ,group_flag -- 集团客户标志
            ,group_id -- 集团客户ID
            ,bank_no -- 人行支付行号
            ,bank_cate_id -- 行分类ID
            ,bank_level -- 行级别
            ,bln_brh_no -- 管理机构编号
            ,top_branch_no -- 所属总行机构
            ,company_up -- 上级公司
            ,company_flag -- 是否总公司： 0 否 1 是
            ,valid_flag -- 生效标志
            ,credit_flag -- 是否授信客户： 0 否 1 是
            ,organ_code -- 组织机构代码
            ,has_sign_web -- 签约网银标志
            ,last_upd_oper_no -- 最后更新操作员
            ,last_upd_time -- 最后更新时间
            ,group_rake -- 是否占用集团客户额度： 0 否 1 是
            ,dualcontrol_locks -- 双岗复核锁标记
            ,agent_flag -- 
            ,top_bank_no -- 
            ,account_no -- 
            ,delete_flag -- 删除标志： 0 否 1 是
            ,ind_cls -- 票交所行业分类
            ,corp_scale -- 票交所企业规模
            ,arc_flag -- 是否三农企业：0-否 1-是
            ,grn_flag -- 是否绿色企业：0-否 1-是
            ,social_credit_no -- 统一社会信用代码
            ,sci_flag -- 是否科技企业： 0 否 1 是
            ,pop_flag -- 是否民企： 0 否 1 是
            ,brh_no -- 会员机构代码
            ,create_time -- 创建时间
            ,quick_accept_flag -- 是否签约秒开： 0 否 1 是
            ,quick_discount_flag -- 是否签约秒贴： 0 否 1 是
            ,quick_collztn_flag -- 是否签约秒押： 0 否 1 是
            ,cross_flag -- 
            ,showr_acct_no -- 
            ,cpes_cust_info_id -- 
            ,message_status -- 
            ,reg_addr -- 
            ,per_name -- 
            ,doc_tp -- 
            ,doc_no -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.cust_type, o.cust_type) as cust_type -- 客户类型
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 客户编号
    ,nvl(n.role_type, o.role_type) as role_type -- 参与者类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cust_address, o.cust_address) as cust_address -- 地址
    ,nvl(n.telephone, o.telephone) as telephone -- 电话号码
    ,nvl(n.fax, o.fax) as fax -- 传真
    ,nvl(n.contacter, o.contacter) as contacter -- 联系人
    ,nvl(n.post, o.post) as post -- 邮政编码
    ,nvl(n.province, o.province) as province -- 行政区划
    ,nvl(n.city, o.city) as city -- 城市
    ,nvl(n.class_id, o.class_id) as class_id -- 性质ID
    ,nvl(n.scale_id, o.scale_id) as scale_id -- 企业规模
    ,nvl(n.trade_type_id, o.trade_type_id) as trade_type_id -- 所属行业类型
    ,nvl(n.credit_level_id, o.credit_level_id) as credit_level_id -- 信用等级ID
    ,nvl(n.register_fund, o.register_fund) as register_fund -- 注册资金
    ,nvl(n.group_flag, o.group_flag) as group_flag -- 集团客户标志
    ,nvl(n.group_id, o.group_id) as group_id -- 集团客户ID
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 人行支付行号
    ,nvl(n.bank_cate_id, o.bank_cate_id) as bank_cate_id -- 行分类ID
    ,nvl(n.bank_level, o.bank_level) as bank_level -- 行级别
    ,nvl(n.bln_brh_no, o.bln_brh_no) as bln_brh_no -- 管理机构编号
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 所属总行机构
    ,nvl(n.company_up, o.company_up) as company_up -- 上级公司
    ,nvl(n.company_flag, o.company_flag) as company_flag -- 是否总公司： 0 否 1 是
    ,nvl(n.valid_flag, o.valid_flag) as valid_flag -- 生效标志
    ,nvl(n.credit_flag, o.credit_flag) as credit_flag -- 是否授信客户： 0 否 1 是
    ,nvl(n.organ_code, o.organ_code) as organ_code -- 组织机构代码
    ,nvl(n.has_sign_web, o.has_sign_web) as has_sign_web -- 签约网银标志
    ,nvl(n.last_upd_oper_no, o.last_upd_oper_no) as last_upd_oper_no -- 最后更新操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后更新时间
    ,nvl(n.group_rake, o.group_rake) as group_rake -- 是否占用集团客户额度： 0 否 1 是
    ,nvl(n.dualcontrol_locks, o.dualcontrol_locks) as dualcontrol_locks -- 双岗复核锁标记
    ,nvl(n.agent_flag, o.agent_flag) as agent_flag -- 
    ,nvl(n.top_bank_no, o.top_bank_no) as top_bank_no -- 
    ,nvl(n.account_no, o.account_no) as account_no -- 
    ,nvl(n.delete_flag, o.delete_flag) as delete_flag -- 删除标志： 0 否 1 是
    ,nvl(n.ind_cls, o.ind_cls) as ind_cls -- 票交所行业分类
    ,nvl(n.corp_scale, o.corp_scale) as corp_scale -- 票交所企业规模
    ,nvl(n.arc_flag, o.arc_flag) as arc_flag -- 是否三农企业：0-否 1-是
    ,nvl(n.grn_flag, o.grn_flag) as grn_flag -- 是否绿色企业：0-否 1-是
    ,nvl(n.social_credit_no, o.social_credit_no) as social_credit_no -- 统一社会信用代码
    ,nvl(n.sci_flag, o.sci_flag) as sci_flag -- 是否科技企业： 0 否 1 是
    ,nvl(n.pop_flag, o.pop_flag) as pop_flag -- 是否民企： 0 否 1 是
    ,nvl(n.brh_no, o.brh_no) as brh_no -- 会员机构代码
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.quick_accept_flag, o.quick_accept_flag) as quick_accept_flag -- 是否签约秒开： 0 否 1 是
    ,nvl(n.quick_discount_flag, o.quick_discount_flag) as quick_discount_flag -- 是否签约秒贴： 0 否 1 是
    ,nvl(n.quick_collztn_flag, o.quick_collztn_flag) as quick_collztn_flag -- 是否签约秒押： 0 否 1 是
    ,nvl(n.cross_flag, o.cross_flag) as cross_flag -- 
    ,nvl(n.showr_acct_no, o.showr_acct_no) as showr_acct_no -- 
    ,nvl(n.cpes_cust_info_id, o.cpes_cust_info_id) as cpes_cust_info_id -- 
    ,nvl(n.message_status, o.message_status) as message_status -- 
    ,nvl(n.reg_addr, o.reg_addr) as reg_addr -- 
    ,nvl(n.per_name, o.per_name) as per_name -- 
    ,nvl(n.doc_tp, o.doc_tp) as doc_tp -- 
    ,nvl(n.doc_no, o.doc_no) as doc_no -- 
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_bms_customer_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_bms_customer_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.cust_type <> n.cust_type
        or o.cust_no <> n.cust_no
        or o.role_type <> n.role_type
        or o.cust_name <> n.cust_name
        or o.cust_address <> n.cust_address
        or o.telephone <> n.telephone
        or o.fax <> n.fax
        or o.contacter <> n.contacter
        or o.post <> n.post
        or o.province <> n.province
        or o.city <> n.city
        or o.class_id <> n.class_id
        or o.scale_id <> n.scale_id
        or o.trade_type_id <> n.trade_type_id
        or o.credit_level_id <> n.credit_level_id
        or o.register_fund <> n.register_fund
        or o.group_flag <> n.group_flag
        or o.group_id <> n.group_id
        or o.bank_no <> n.bank_no
        or o.bank_cate_id <> n.bank_cate_id
        or o.bank_level <> n.bank_level
        or o.bln_brh_no <> n.bln_brh_no
        or o.top_branch_no <> n.top_branch_no
        or o.company_up <> n.company_up
        or o.company_flag <> n.company_flag
        or o.valid_flag <> n.valid_flag
        or o.credit_flag <> n.credit_flag
        or o.organ_code <> n.organ_code
        or o.has_sign_web <> n.has_sign_web
        or o.last_upd_oper_no <> n.last_upd_oper_no
        or o.last_upd_time <> n.last_upd_time
        or o.group_rake <> n.group_rake
        or o.dualcontrol_locks <> n.dualcontrol_locks
        or o.agent_flag <> n.agent_flag
        or o.top_bank_no <> n.top_bank_no
        or o.account_no <> n.account_no
        or o.delete_flag <> n.delete_flag
        or o.ind_cls <> n.ind_cls
        or o.corp_scale <> n.corp_scale
        or o.arc_flag <> n.arc_flag
        or o.grn_flag <> n.grn_flag
        or o.social_credit_no <> n.social_credit_no
        or o.sci_flag <> n.sci_flag
        or o.pop_flag <> n.pop_flag
        or o.brh_no <> n.brh_no
        or o.create_time <> n.create_time
        or o.quick_accept_flag <> n.quick_accept_flag
        or o.quick_discount_flag <> n.quick_discount_flag
        or o.quick_collztn_flag <> n.quick_collztn_flag
        or o.cross_flag <> n.cross_flag
        or o.showr_acct_no <> n.showr_acct_no
        or o.cpes_cust_info_id <> n.cpes_cust_info_id
        or o.message_status <> n.message_status
        or o.reg_addr <> n.reg_addr
        or o.per_name <> n.per_name
        or o.doc_tp <> n.doc_tp
        or o.doc_no <> n.doc_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_customer_info_cl(
            id -- ID
            ,cust_type -- 客户类型
            ,cust_no -- 客户编号
            ,role_type -- 参与者类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,cust_name -- 客户名称
            ,cust_address -- 地址
            ,telephone -- 电话号码
            ,fax -- 传真
            ,contacter -- 联系人
            ,post -- 邮政编码
            ,province -- 行政区划
            ,city -- 城市
            ,class_id -- 性质ID
            ,scale_id -- 企业规模
            ,trade_type_id -- 所属行业类型
            ,credit_level_id -- 信用等级ID
            ,register_fund -- 注册资金
            ,group_flag -- 集团客户标志
            ,group_id -- 集团客户ID
            ,bank_no -- 人行支付行号
            ,bank_cate_id -- 行分类ID
            ,bank_level -- 行级别
            ,bln_brh_no -- 管理机构编号
            ,top_branch_no -- 所属总行机构
            ,company_up -- 上级公司
            ,company_flag -- 是否总公司： 0 否 1 是
            ,valid_flag -- 生效标志
            ,credit_flag -- 是否授信客户： 0 否 1 是
            ,organ_code -- 组织机构代码
            ,has_sign_web -- 签约网银标志
            ,last_upd_oper_no -- 最后更新操作员
            ,last_upd_time -- 最后更新时间
            ,group_rake -- 是否占用集团客户额度： 0 否 1 是
            ,dualcontrol_locks -- 双岗复核锁标记
            ,agent_flag -- 
            ,top_bank_no -- 
            ,account_no -- 
            ,delete_flag -- 删除标志： 0 否 1 是
            ,ind_cls -- 票交所行业分类
            ,corp_scale -- 票交所企业规模
            ,arc_flag -- 是否三农企业：0-否 1-是
            ,grn_flag -- 是否绿色企业：0-否 1-是
            ,social_credit_no -- 统一社会信用代码
            ,sci_flag -- 是否科技企业： 0 否 1 是
            ,pop_flag -- 是否民企： 0 否 1 是
            ,brh_no -- 会员机构代码
            ,create_time -- 创建时间
            ,quick_accept_flag -- 是否签约秒开： 0 否 1 是
            ,quick_discount_flag -- 是否签约秒贴： 0 否 1 是
            ,quick_collztn_flag -- 是否签约秒押： 0 否 1 是
            ,cross_flag -- 
            ,showr_acct_no -- 
            ,cpes_cust_info_id -- 
            ,message_status -- 
            ,reg_addr -- 
            ,per_name -- 
            ,doc_tp -- 
            ,doc_no -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_customer_info_op(
            id -- ID
            ,cust_type -- 客户类型
            ,cust_no -- 客户编号
            ,role_type -- 参与者类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,cust_name -- 客户名称
            ,cust_address -- 地址
            ,telephone -- 电话号码
            ,fax -- 传真
            ,contacter -- 联系人
            ,post -- 邮政编码
            ,province -- 行政区划
            ,city -- 城市
            ,class_id -- 性质ID
            ,scale_id -- 企业规模
            ,trade_type_id -- 所属行业类型
            ,credit_level_id -- 信用等级ID
            ,register_fund -- 注册资金
            ,group_flag -- 集团客户标志
            ,group_id -- 集团客户ID
            ,bank_no -- 人行支付行号
            ,bank_cate_id -- 行分类ID
            ,bank_level -- 行级别
            ,bln_brh_no -- 管理机构编号
            ,top_branch_no -- 所属总行机构
            ,company_up -- 上级公司
            ,company_flag -- 是否总公司： 0 否 1 是
            ,valid_flag -- 生效标志
            ,credit_flag -- 是否授信客户： 0 否 1 是
            ,organ_code -- 组织机构代码
            ,has_sign_web -- 签约网银标志
            ,last_upd_oper_no -- 最后更新操作员
            ,last_upd_time -- 最后更新时间
            ,group_rake -- 是否占用集团客户额度： 0 否 1 是
            ,dualcontrol_locks -- 双岗复核锁标记
            ,agent_flag -- 
            ,top_bank_no -- 
            ,account_no -- 
            ,delete_flag -- 删除标志： 0 否 1 是
            ,ind_cls -- 票交所行业分类
            ,corp_scale -- 票交所企业规模
            ,arc_flag -- 是否三农企业：0-否 1-是
            ,grn_flag -- 是否绿色企业：0-否 1-是
            ,social_credit_no -- 统一社会信用代码
            ,sci_flag -- 是否科技企业： 0 否 1 是
            ,pop_flag -- 是否民企： 0 否 1 是
            ,brh_no -- 会员机构代码
            ,create_time -- 创建时间
            ,quick_accept_flag -- 是否签约秒开： 0 否 1 是
            ,quick_discount_flag -- 是否签约秒贴： 0 否 1 是
            ,quick_collztn_flag -- 是否签约秒押： 0 否 1 是
            ,cross_flag -- 
            ,showr_acct_no -- 
            ,cpes_cust_info_id -- 
            ,message_status -- 
            ,reg_addr -- 
            ,per_name -- 
            ,doc_tp -- 
            ,doc_no -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.cust_type -- 客户类型
    ,o.cust_no -- 客户编号
    ,o.role_type -- 参与者类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,o.cust_name -- 客户名称
    ,o.cust_address -- 地址
    ,o.telephone -- 电话号码
    ,o.fax -- 传真
    ,o.contacter -- 联系人
    ,o.post -- 邮政编码
    ,o.province -- 行政区划
    ,o.city -- 城市
    ,o.class_id -- 性质ID
    ,o.scale_id -- 企业规模
    ,o.trade_type_id -- 所属行业类型
    ,o.credit_level_id -- 信用等级ID
    ,o.register_fund -- 注册资金
    ,o.group_flag -- 集团客户标志
    ,o.group_id -- 集团客户ID
    ,o.bank_no -- 人行支付行号
    ,o.bank_cate_id -- 行分类ID
    ,o.bank_level -- 行级别
    ,o.bln_brh_no -- 管理机构编号
    ,o.top_branch_no -- 所属总行机构
    ,o.company_up -- 上级公司
    ,o.company_flag -- 是否总公司： 0 否 1 是
    ,o.valid_flag -- 生效标志
    ,o.credit_flag -- 是否授信客户： 0 否 1 是
    ,o.organ_code -- 组织机构代码
    ,o.has_sign_web -- 签约网银标志
    ,o.last_upd_oper_no -- 最后更新操作员
    ,o.last_upd_time -- 最后更新时间
    ,o.group_rake -- 是否占用集团客户额度： 0 否 1 是
    ,o.dualcontrol_locks -- 双岗复核锁标记
    ,o.agent_flag -- 
    ,o.top_bank_no -- 
    ,o.account_no -- 
    ,o.delete_flag -- 删除标志： 0 否 1 是
    ,o.ind_cls -- 票交所行业分类
    ,o.corp_scale -- 票交所企业规模
    ,o.arc_flag -- 是否三农企业：0-否 1-是
    ,o.grn_flag -- 是否绿色企业：0-否 1-是
    ,o.social_credit_no -- 统一社会信用代码
    ,o.sci_flag -- 是否科技企业： 0 否 1 是
    ,o.pop_flag -- 是否民企： 0 否 1 是
    ,o.brh_no -- 会员机构代码
    ,o.create_time -- 创建时间
    ,o.quick_accept_flag -- 是否签约秒开： 0 否 1 是
    ,o.quick_discount_flag -- 是否签约秒贴： 0 否 1 是
    ,o.quick_collztn_flag -- 是否签约秒押： 0 否 1 是
    ,o.cross_flag -- 
    ,o.showr_acct_no -- 
    ,o.cpes_cust_info_id -- 
    ,o.message_status -- 
    ,o.reg_addr -- 
    ,o.per_name -- 
    ,o.doc_tp -- 
    ,o.doc_no -- 
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
from ${iol_schema}.bdms_bms_customer_info_bk o
    left join ${iol_schema}.bdms_bms_customer_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_bms_customer_info_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdms_bms_customer_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_bms_customer_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_bms_customer_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_bms_customer_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_bms_customer_info exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_customer_info_cl;
alter table ${iol_schema}.bdms_bms_customer_info exchange partition p_20991231 with table ${iol_schema}.bdms_bms_customer_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_customer_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_customer_info_op purge;
drop table ${iol_schema}.bdms_bms_customer_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_bms_customer_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_customer_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
