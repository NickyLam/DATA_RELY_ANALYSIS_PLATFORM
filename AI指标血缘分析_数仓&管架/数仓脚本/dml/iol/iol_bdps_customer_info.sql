/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_customer_info
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
create table ${iol_schema}.bdps_customer_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdps_customer_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_customer_info_op purge;
drop table ${iol_schema}.bdps_customer_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_customer_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_customer_info where 0=1;

create table ${iol_schema}.bdps_customer_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_customer_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_customer_info_cl(
            id -- 
            ,cust_type -- 客户类别票据池：1-企业2-银行 3-非银行金融机构商票
            ,cust_no -- 客户号
            ,cust_name -- 客户名称
            ,cust_address -- 地址
            ,telephone -- 电知
            ,fax -- 传真
            ,contacter -- 联系人
            ,post -- 邮政编码
            ,cust_email -- 电子邮件
            ,province -- 省份
            ,city -- 城市
            ,class_id -- 性质ID
            ,scale_id -- 规模
            ,trade_type_id -- 
            ,credit_level_id -- 信用等级
            ,open_bank -- 开户银行
            ,bank_account -- 账号
            ,register_fund -- 注册资金
            ,cust_loan_card_no -- 贷款卡号
            ,group_flag -- 是否集团客户票据池：0-否 1-是
            ,group_id -- 上级公司
            ,bank_no -- 银行行号
            ,bank_cate_id -- 行分类ID
            ,bank_level -- 行级别票据池：1-总行2-一级分行3-二级分行
            ,union_id -- 联行号(银行客户用)
            ,bln_brh_id -- 所属机构表
            ,valid_flag -- 生效标志票据池：0-?未生效 1-生效
            ,credit_flag -- 是否授信客户票据池：0-否1-是
            ,organ_code -- 组织机构代码
            ,in_flag -- 是否系统内客户-产品表（票据池系统无值）0-?否 1-是
            ,last_upd_oper_id -- 最后更新操作员
            ,last_upd_time -- 最后更新时间
            ,chief_bank_flag -- 是否总行票据池：0-否1-是
            ,dualcontrol_lockstatus -- 
            ,cust_yyzh -- 营业执照号*（核心）db.customer.cust_yyzh
            ,cust_sign_add -- 注册地址
            ,cust_farener -- 法人代表名称
            ,cust_faren_card_no -- 法人代表证件号
            ,cust_is_gd -- 是否我行股东
            ,cust_jr_allow_no -- 金融许可证号
            ,cust_eff_dt -- 营业执照有效日期
            ,cust_install_dt -- 企业成立日期
            ,card_if_enable -- 贷款卡号是否有效-产品表（票据池系统无值）
            ,souceflag -- 来源CBMS-商票 LBMS-票据池(本系统维护) SASB-核心 CMSF-老信贷
            ,auto_account -- 托收回款是否自动入账0-否1-是
            ,parent_company_name -- 母公司客户名
            ,cus_manager_code -- 分管客户经理号
            ,cus_manager_name -- 分管客户经理名
            ,company_cust_no -- 集团客户号
            ,parent_company_no -- 母公司客户号
            ,usci_code -- 统一社会信用代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_customer_info_op(
            id -- 
            ,cust_type -- 客户类别票据池：1-企业2-银行 3-非银行金融机构商票
            ,cust_no -- 客户号
            ,cust_name -- 客户名称
            ,cust_address -- 地址
            ,telephone -- 电知
            ,fax -- 传真
            ,contacter -- 联系人
            ,post -- 邮政编码
            ,cust_email -- 电子邮件
            ,province -- 省份
            ,city -- 城市
            ,class_id -- 性质ID
            ,scale_id -- 规模
            ,trade_type_id -- 
            ,credit_level_id -- 信用等级
            ,open_bank -- 开户银行
            ,bank_account -- 账号
            ,register_fund -- 注册资金
            ,cust_loan_card_no -- 贷款卡号
            ,group_flag -- 是否集团客户票据池：0-否 1-是
            ,group_id -- 上级公司
            ,bank_no -- 银行行号
            ,bank_cate_id -- 行分类ID
            ,bank_level -- 行级别票据池：1-总行2-一级分行3-二级分行
            ,union_id -- 联行号(银行客户用)
            ,bln_brh_id -- 所属机构表
            ,valid_flag -- 生效标志票据池：0-?未生效 1-生效
            ,credit_flag -- 是否授信客户票据池：0-否1-是
            ,organ_code -- 组织机构代码
            ,in_flag -- 是否系统内客户-产品表（票据池系统无值）0-?否 1-是
            ,last_upd_oper_id -- 最后更新操作员
            ,last_upd_time -- 最后更新时间
            ,chief_bank_flag -- 是否总行票据池：0-否1-是
            ,dualcontrol_lockstatus -- 
            ,cust_yyzh -- 营业执照号*（核心）db.customer.cust_yyzh
            ,cust_sign_add -- 注册地址
            ,cust_farener -- 法人代表名称
            ,cust_faren_card_no -- 法人代表证件号
            ,cust_is_gd -- 是否我行股东
            ,cust_jr_allow_no -- 金融许可证号
            ,cust_eff_dt -- 营业执照有效日期
            ,cust_install_dt -- 企业成立日期
            ,card_if_enable -- 贷款卡号是否有效-产品表（票据池系统无值）
            ,souceflag -- 来源CBMS-商票 LBMS-票据池(本系统维护) SASB-核心 CMSF-老信贷
            ,auto_account -- 托收回款是否自动入账0-否1-是
            ,parent_company_name -- 母公司客户名
            ,cus_manager_code -- 分管客户经理号
            ,cus_manager_name -- 分管客户经理名
            ,company_cust_no -- 集团客户号
            ,parent_company_no -- 母公司客户号
            ,usci_code -- 统一社会信用代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.cust_type, o.cust_type) as cust_type -- 客户类别票据池：1-企业2-银行 3-非银行金融机构商票
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 客户号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cust_address, o.cust_address) as cust_address -- 地址
    ,nvl(n.telephone, o.telephone) as telephone -- 电知
    ,nvl(n.fax, o.fax) as fax -- 传真
    ,nvl(n.contacter, o.contacter) as contacter -- 联系人
    ,nvl(n.post, o.post) as post -- 邮政编码
    ,nvl(n.cust_email, o.cust_email) as cust_email -- 电子邮件
    ,nvl(n.province, o.province) as province -- 省份
    ,nvl(n.city, o.city) as city -- 城市
    ,nvl(n.class_id, o.class_id) as class_id -- 性质ID
    ,nvl(n.scale_id, o.scale_id) as scale_id -- 规模
    ,nvl(n.trade_type_id, o.trade_type_id) as trade_type_id -- 
    ,nvl(n.credit_level_id, o.credit_level_id) as credit_level_id -- 信用等级
    ,nvl(n.open_bank, o.open_bank) as open_bank -- 开户银行
    ,nvl(n.bank_account, o.bank_account) as bank_account -- 账号
    ,nvl(n.register_fund, o.register_fund) as register_fund -- 注册资金
    ,nvl(n.cust_loan_card_no, o.cust_loan_card_no) as cust_loan_card_no -- 贷款卡号
    ,nvl(n.group_flag, o.group_flag) as group_flag -- 是否集团客户票据池：0-否 1-是
    ,nvl(n.group_id, o.group_id) as group_id -- 上级公司
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 银行行号
    ,nvl(n.bank_cate_id, o.bank_cate_id) as bank_cate_id -- 行分类ID
    ,nvl(n.bank_level, o.bank_level) as bank_level -- 行级别票据池：1-总行2-一级分行3-二级分行
    ,nvl(n.union_id, o.union_id) as union_id -- 联行号(银行客户用)
    ,nvl(n.bln_brh_id, o.bln_brh_id) as bln_brh_id -- 所属机构表
    ,nvl(n.valid_flag, o.valid_flag) as valid_flag -- 生效标志票据池：0-?未生效 1-生效
    ,nvl(n.credit_flag, o.credit_flag) as credit_flag -- 是否授信客户票据池：0-否1-是
    ,nvl(n.organ_code, o.organ_code) as organ_code -- 组织机构代码
    ,nvl(n.in_flag, o.in_flag) as in_flag -- 是否系统内客户-产品表（票据池系统无值）0-?否 1-是
    ,nvl(n.last_upd_oper_id, o.last_upd_oper_id) as last_upd_oper_id -- 最后更新操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后更新时间
    ,nvl(n.chief_bank_flag, o.chief_bank_flag) as chief_bank_flag -- 是否总行票据池：0-否1-是
    ,nvl(n.dualcontrol_lockstatus, o.dualcontrol_lockstatus) as dualcontrol_lockstatus -- 
    ,nvl(n.cust_yyzh, o.cust_yyzh) as cust_yyzh -- 营业执照号*（核心）db.customer.cust_yyzh
    ,nvl(n.cust_sign_add, o.cust_sign_add) as cust_sign_add -- 注册地址
    ,nvl(n.cust_farener, o.cust_farener) as cust_farener -- 法人代表名称
    ,nvl(n.cust_faren_card_no, o.cust_faren_card_no) as cust_faren_card_no -- 法人代表证件号
    ,nvl(n.cust_is_gd, o.cust_is_gd) as cust_is_gd -- 是否我行股东
    ,nvl(n.cust_jr_allow_no, o.cust_jr_allow_no) as cust_jr_allow_no -- 金融许可证号
    ,nvl(n.cust_eff_dt, o.cust_eff_dt) as cust_eff_dt -- 营业执照有效日期
    ,nvl(n.cust_install_dt, o.cust_install_dt) as cust_install_dt -- 企业成立日期
    ,nvl(n.card_if_enable, o.card_if_enable) as card_if_enable -- 贷款卡号是否有效-产品表（票据池系统无值）
    ,nvl(n.souceflag, o.souceflag) as souceflag -- 来源CBMS-商票 LBMS-票据池(本系统维护) SASB-核心 CMSF-老信贷
    ,nvl(n.auto_account, o.auto_account) as auto_account -- 托收回款是否自动入账0-否1-是
    ,nvl(n.parent_company_name, o.parent_company_name) as parent_company_name -- 母公司客户名
    ,nvl(n.cus_manager_code, o.cus_manager_code) as cus_manager_code -- 分管客户经理号
    ,nvl(n.cus_manager_name, o.cus_manager_name) as cus_manager_name -- 分管客户经理名
    ,nvl(n.company_cust_no, o.company_cust_no) as company_cust_no -- 集团客户号
    ,nvl(n.parent_company_no, o.parent_company_no) as parent_company_no -- 母公司客户号
    ,nvl(n.usci_code, o.usci_code) as usci_code -- 统一社会信用代码
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
from (select * from ${iol_schema}.bdps_customer_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdps_customer_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.cust_name <> n.cust_name
        or o.cust_address <> n.cust_address
        or o.telephone <> n.telephone
        or o.fax <> n.fax
        or o.contacter <> n.contacter
        or o.post <> n.post
        or o.cust_email <> n.cust_email
        or o.province <> n.province
        or o.city <> n.city
        or o.class_id <> n.class_id
        or o.scale_id <> n.scale_id
        or o.trade_type_id <> n.trade_type_id
        or o.credit_level_id <> n.credit_level_id
        or o.open_bank <> n.open_bank
        or o.bank_account <> n.bank_account
        or o.register_fund <> n.register_fund
        or o.cust_loan_card_no <> n.cust_loan_card_no
        or o.group_flag <> n.group_flag
        or o.group_id <> n.group_id
        or o.bank_no <> n.bank_no
        or o.bank_cate_id <> n.bank_cate_id
        or o.bank_level <> n.bank_level
        or o.union_id <> n.union_id
        or o.bln_brh_id <> n.bln_brh_id
        or o.valid_flag <> n.valid_flag
        or o.credit_flag <> n.credit_flag
        or o.organ_code <> n.organ_code
        or o.in_flag <> n.in_flag
        or o.last_upd_oper_id <> n.last_upd_oper_id
        or o.last_upd_time <> n.last_upd_time
        or o.chief_bank_flag <> n.chief_bank_flag
        or o.dualcontrol_lockstatus <> n.dualcontrol_lockstatus
        or o.cust_yyzh <> n.cust_yyzh
        or o.cust_sign_add <> n.cust_sign_add
        or o.cust_farener <> n.cust_farener
        or o.cust_faren_card_no <> n.cust_faren_card_no
        or o.cust_is_gd <> n.cust_is_gd
        or o.cust_jr_allow_no <> n.cust_jr_allow_no
        or o.cust_eff_dt <> n.cust_eff_dt
        or o.cust_install_dt <> n.cust_install_dt
        or o.card_if_enable <> n.card_if_enable
        or o.souceflag <> n.souceflag
        or o.auto_account <> n.auto_account
        or o.parent_company_name <> n.parent_company_name
        or o.cus_manager_code <> n.cus_manager_code
        or o.cus_manager_name <> n.cus_manager_name
        or o.company_cust_no <> n.company_cust_no
        or o.parent_company_no <> n.parent_company_no
        or o.usci_code <> n.usci_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_customer_info_cl(
            id -- 
            ,cust_type -- 客户类别票据池：1-企业2-银行 3-非银行金融机构商票
            ,cust_no -- 客户号
            ,cust_name -- 客户名称
            ,cust_address -- 地址
            ,telephone -- 电知
            ,fax -- 传真
            ,contacter -- 联系人
            ,post -- 邮政编码
            ,cust_email -- 电子邮件
            ,province -- 省份
            ,city -- 城市
            ,class_id -- 性质ID
            ,scale_id -- 规模
            ,trade_type_id -- 
            ,credit_level_id -- 信用等级
            ,open_bank -- 开户银行
            ,bank_account -- 账号
            ,register_fund -- 注册资金
            ,cust_loan_card_no -- 贷款卡号
            ,group_flag -- 是否集团客户票据池：0-否 1-是
            ,group_id -- 上级公司
            ,bank_no -- 银行行号
            ,bank_cate_id -- 行分类ID
            ,bank_level -- 行级别票据池：1-总行2-一级分行3-二级分行
            ,union_id -- 联行号(银行客户用)
            ,bln_brh_id -- 所属机构表
            ,valid_flag -- 生效标志票据池：0-?未生效 1-生效
            ,credit_flag -- 是否授信客户票据池：0-否1-是
            ,organ_code -- 组织机构代码
            ,in_flag -- 是否系统内客户-产品表（票据池系统无值）0-?否 1-是
            ,last_upd_oper_id -- 最后更新操作员
            ,last_upd_time -- 最后更新时间
            ,chief_bank_flag -- 是否总行票据池：0-否1-是
            ,dualcontrol_lockstatus -- 
            ,cust_yyzh -- 营业执照号*（核心）db.customer.cust_yyzh
            ,cust_sign_add -- 注册地址
            ,cust_farener -- 法人代表名称
            ,cust_faren_card_no -- 法人代表证件号
            ,cust_is_gd -- 是否我行股东
            ,cust_jr_allow_no -- 金融许可证号
            ,cust_eff_dt -- 营业执照有效日期
            ,cust_install_dt -- 企业成立日期
            ,card_if_enable -- 贷款卡号是否有效-产品表（票据池系统无值）
            ,souceflag -- 来源CBMS-商票 LBMS-票据池(本系统维护) SASB-核心 CMSF-老信贷
            ,auto_account -- 托收回款是否自动入账0-否1-是
            ,parent_company_name -- 母公司客户名
            ,cus_manager_code -- 分管客户经理号
            ,cus_manager_name -- 分管客户经理名
            ,company_cust_no -- 集团客户号
            ,parent_company_no -- 母公司客户号
            ,usci_code -- 统一社会信用代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_customer_info_op(
            id -- 
            ,cust_type -- 客户类别票据池：1-企业2-银行 3-非银行金融机构商票
            ,cust_no -- 客户号
            ,cust_name -- 客户名称
            ,cust_address -- 地址
            ,telephone -- 电知
            ,fax -- 传真
            ,contacter -- 联系人
            ,post -- 邮政编码
            ,cust_email -- 电子邮件
            ,province -- 省份
            ,city -- 城市
            ,class_id -- 性质ID
            ,scale_id -- 规模
            ,trade_type_id -- 
            ,credit_level_id -- 信用等级
            ,open_bank -- 开户银行
            ,bank_account -- 账号
            ,register_fund -- 注册资金
            ,cust_loan_card_no -- 贷款卡号
            ,group_flag -- 是否集团客户票据池：0-否 1-是
            ,group_id -- 上级公司
            ,bank_no -- 银行行号
            ,bank_cate_id -- 行分类ID
            ,bank_level -- 行级别票据池：1-总行2-一级分行3-二级分行
            ,union_id -- 联行号(银行客户用)
            ,bln_brh_id -- 所属机构表
            ,valid_flag -- 生效标志票据池：0-?未生效 1-生效
            ,credit_flag -- 是否授信客户票据池：0-否1-是
            ,organ_code -- 组织机构代码
            ,in_flag -- 是否系统内客户-产品表（票据池系统无值）0-?否 1-是
            ,last_upd_oper_id -- 最后更新操作员
            ,last_upd_time -- 最后更新时间
            ,chief_bank_flag -- 是否总行票据池：0-否1-是
            ,dualcontrol_lockstatus -- 
            ,cust_yyzh -- 营业执照号*（核心）db.customer.cust_yyzh
            ,cust_sign_add -- 注册地址
            ,cust_farener -- 法人代表名称
            ,cust_faren_card_no -- 法人代表证件号
            ,cust_is_gd -- 是否我行股东
            ,cust_jr_allow_no -- 金融许可证号
            ,cust_eff_dt -- 营业执照有效日期
            ,cust_install_dt -- 企业成立日期
            ,card_if_enable -- 贷款卡号是否有效-产品表（票据池系统无值）
            ,souceflag -- 来源CBMS-商票 LBMS-票据池(本系统维护) SASB-核心 CMSF-老信贷
            ,auto_account -- 托收回款是否自动入账0-否1-是
            ,parent_company_name -- 母公司客户名
            ,cus_manager_code -- 分管客户经理号
            ,cus_manager_name -- 分管客户经理名
            ,company_cust_no -- 集团客户号
            ,parent_company_no -- 母公司客户号
            ,usci_code -- 统一社会信用代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.cust_type -- 客户类别票据池：1-企业2-银行 3-非银行金融机构商票
    ,o.cust_no -- 客户号
    ,o.cust_name -- 客户名称
    ,o.cust_address -- 地址
    ,o.telephone -- 电知
    ,o.fax -- 传真
    ,o.contacter -- 联系人
    ,o.post -- 邮政编码
    ,o.cust_email -- 电子邮件
    ,o.province -- 省份
    ,o.city -- 城市
    ,o.class_id -- 性质ID
    ,o.scale_id -- 规模
    ,o.trade_type_id -- 
    ,o.credit_level_id -- 信用等级
    ,o.open_bank -- 开户银行
    ,o.bank_account -- 账号
    ,o.register_fund -- 注册资金
    ,o.cust_loan_card_no -- 贷款卡号
    ,o.group_flag -- 是否集团客户票据池：0-否 1-是
    ,o.group_id -- 上级公司
    ,o.bank_no -- 银行行号
    ,o.bank_cate_id -- 行分类ID
    ,o.bank_level -- 行级别票据池：1-总行2-一级分行3-二级分行
    ,o.union_id -- 联行号(银行客户用)
    ,o.bln_brh_id -- 所属机构表
    ,o.valid_flag -- 生效标志票据池：0-?未生效 1-生效
    ,o.credit_flag -- 是否授信客户票据池：0-否1-是
    ,o.organ_code -- 组织机构代码
    ,o.in_flag -- 是否系统内客户-产品表（票据池系统无值）0-?否 1-是
    ,o.last_upd_oper_id -- 最后更新操作员
    ,o.last_upd_time -- 最后更新时间
    ,o.chief_bank_flag -- 是否总行票据池：0-否1-是
    ,o.dualcontrol_lockstatus -- 
    ,o.cust_yyzh -- 营业执照号*（核心）db.customer.cust_yyzh
    ,o.cust_sign_add -- 注册地址
    ,o.cust_farener -- 法人代表名称
    ,o.cust_faren_card_no -- 法人代表证件号
    ,o.cust_is_gd -- 是否我行股东
    ,o.cust_jr_allow_no -- 金融许可证号
    ,o.cust_eff_dt -- 营业执照有效日期
    ,o.cust_install_dt -- 企业成立日期
    ,o.card_if_enable -- 贷款卡号是否有效-产品表（票据池系统无值）
    ,o.souceflag -- 来源CBMS-商票 LBMS-票据池(本系统维护) SASB-核心 CMSF-老信贷
    ,o.auto_account -- 托收回款是否自动入账0-否1-是
    ,o.parent_company_name -- 母公司客户名
    ,o.cus_manager_code -- 分管客户经理号
    ,o.cus_manager_name -- 分管客户经理名
    ,o.company_cust_no -- 集团客户号
    ,o.parent_company_no -- 母公司客户号
    ,o.usci_code -- 统一社会信用代码
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
from ${iol_schema}.bdps_customer_info_bk o
    left join ${iol_schema}.bdps_customer_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdps_customer_info_cl d
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
--truncate table ${iol_schema}.bdps_customer_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdps_customer_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdps_customer_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdps_customer_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdps_customer_info exchange partition p_${batch_date} with table ${iol_schema}.bdps_customer_info_cl;
alter table ${iol_schema}.bdps_customer_info exchange partition p_20991231 with table ${iol_schema}.bdps_customer_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdps_customer_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_customer_info_op purge;
drop table ${iol_schema}.bdps_customer_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdps_customer_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdps_customer_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
