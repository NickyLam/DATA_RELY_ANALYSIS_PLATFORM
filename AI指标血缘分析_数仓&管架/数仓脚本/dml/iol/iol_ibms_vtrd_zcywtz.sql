/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_vtrd_zcywtz
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
create table ${iol_schema}.ibms_vtrd_zcywtz_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_vtrd_zcywtz
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_vtrd_zcywtz_op purge;
drop table ${iol_schema}.ibms_vtrd_zcywtz_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_vtrd_zcywtz_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_vtrd_zcywtz where 0=1;

create table ${iol_schema}.ibms_vtrd_zcywtz_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_vtrd_zcywtz where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_vtrd_zcywtz_cl(
            obj_id -- 核算id
            ,beg_date -- 余额日期
            ,org_id -- 机构号
            ,trade_id -- 交易单号
            ,secu_acct_name -- 投组单元
            ,dict_value -- 会计分类
            ,p_type_name -- 产品类型
            ,p_class -- 产品分类
            ,i_code -- 金融工具代码
            ,i_name -- 金融工具名称
            ,trd_orddate -- 交易日期
            ,trd_party_name -- 交易对手
            ,trd_party_class -- 交易对手客户分类
            ,issue_name -- 发行人/实际融资人
            ,issue_class -- 实际融资人客户分类
            ,exhacc -- 划款账号
            ,party_acct_code -- 收款账号
            ,currency -- 币种
            ,cp -- 投资本金
            ,coupon -- 执行利率
            ,open_date -- 起息日
            ,end_date -- 到期日
            ,inst_start_date -- 原始期限
            ,inst_mrt_date -- 剩余期限
            ,first_payment_date -- 首次付息日
            ,pay_freq_name -- 付息频率
            ,daycount_name -- 计息基准
            ,coupon_type_name -- 息票类型
            ,tzye -- 投资余额
            ,ai -- 应计利息
            ,prft_ir -- 利息收入
            ,zmye -- 账面余额
            ,business_category_name -- 投向行业门类
            ,business_category_min_name -- 投向行业大类
            ,s_grade -- 债项/主体评级
            ,g31_plass -- g31分类
            ,final_invest_name -- 最终投向类型
            ,management_mode -- 管理方式
            ,raise_way -- 产品募集方式
            ,tzcplx -- 投资产品类型
            ,under_debt_class -- 底层为债券的债券分类
            ,under_debt_rating -- 底层为债券的评级
            ,hx_isgover_fund -- 是否政府投资基金
            ,is_pioneer_invest_fund -- 是否创业投资基金
            ,hx_isdistbus -- 是否异地业务
            ,hx_islocfinanc -- 是否地方政府融资平台
            ,risk_assets_weight -- 风险权重
            ,trader -- 经办人
            ,op_user_name1 -- 总行经办人
            ,op_user_name2 -- 总行复核人
            ,cp_subj_code -- 本金科目号
            ,ai_tax_rate -- 增值税税率(应计利息收入)
            ,amrt_tax_rate -- 增值税税率(摊销利息收入)
            ,trd_tax_rate -- 增值税税率(买卖损益)
            ,ibs -- 数据来源
            ,hxkhh -- 交易对手核心客户号
            ,hxkhh1 -- 实际融资人核心客户号
            ,mid_invest_industry_categories -- 投向行业中类
            ,invest_industry_subcategories -- 投向行业细类
            ,funds_purpose -- 资金用途
            ,guarantee_method -- 担保方式
            ,credit_methods -- 增信方式
            ,credit_cust -- 增信主体
            ,datamark -- 唯一标识
            ,month_repay_record -- 当月还本记录
            ,month_average -- 月日均
            ,year_average -- 年日均
            ,in_due_ai -- 表内应收未收利息
            ,out_due_ai -- 表外应收利息
            ,this_month_prft_ir -- 利息收入（当月）
            ,this_year_prft_ir -- 利息收入（本年）
            ,year_chg_fv -- 公允价值变动（年初）
            ,month_chg_fv -- 公允价值变动（当月）
            ,year_prft_fv_real -- 公允价值变动损益（本年）
            ,year_prft_trd -- 买卖损益（本年）
            ,prft_ir_subj_code -- 利息损益科目号
            ,prft_trd_subj_code -- 价差损益科目号
            ,chg_fv_subj_code -- 估值损益科目号
            ,basic_asset_clients -- 基础资产客户
            ,underly_types_assets -- 底层资产类型
            ,guarantee_description -- 担保描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_vtrd_zcywtz_op(
            obj_id -- 核算id
            ,beg_date -- 余额日期
            ,org_id -- 机构号
            ,trade_id -- 交易单号
            ,secu_acct_name -- 投组单元
            ,dict_value -- 会计分类
            ,p_type_name -- 产品类型
            ,p_class -- 产品分类
            ,i_code -- 金融工具代码
            ,i_name -- 金融工具名称
            ,trd_orddate -- 交易日期
            ,trd_party_name -- 交易对手
            ,trd_party_class -- 交易对手客户分类
            ,issue_name -- 发行人/实际融资人
            ,issue_class -- 实际融资人客户分类
            ,exhacc -- 划款账号
            ,party_acct_code -- 收款账号
            ,currency -- 币种
            ,cp -- 投资本金
            ,coupon -- 执行利率
            ,open_date -- 起息日
            ,end_date -- 到期日
            ,inst_start_date -- 原始期限
            ,inst_mrt_date -- 剩余期限
            ,first_payment_date -- 首次付息日
            ,pay_freq_name -- 付息频率
            ,daycount_name -- 计息基准
            ,coupon_type_name -- 息票类型
            ,tzye -- 投资余额
            ,ai -- 应计利息
            ,prft_ir -- 利息收入
            ,zmye -- 账面余额
            ,business_category_name -- 投向行业门类
            ,business_category_min_name -- 投向行业大类
            ,s_grade -- 债项/主体评级
            ,g31_plass -- g31分类
            ,final_invest_name -- 最终投向类型
            ,management_mode -- 管理方式
            ,raise_way -- 产品募集方式
            ,tzcplx -- 投资产品类型
            ,under_debt_class -- 底层为债券的债券分类
            ,under_debt_rating -- 底层为债券的评级
            ,hx_isgover_fund -- 是否政府投资基金
            ,is_pioneer_invest_fund -- 是否创业投资基金
            ,hx_isdistbus -- 是否异地业务
            ,hx_islocfinanc -- 是否地方政府融资平台
            ,risk_assets_weight -- 风险权重
            ,trader -- 经办人
            ,op_user_name1 -- 总行经办人
            ,op_user_name2 -- 总行复核人
            ,cp_subj_code -- 本金科目号
            ,ai_tax_rate -- 增值税税率(应计利息收入)
            ,amrt_tax_rate -- 增值税税率(摊销利息收入)
            ,trd_tax_rate -- 增值税税率(买卖损益)
            ,ibs -- 数据来源
            ,hxkhh -- 交易对手核心客户号
            ,hxkhh1 -- 实际融资人核心客户号
            ,mid_invest_industry_categories -- 投向行业中类
            ,invest_industry_subcategories -- 投向行业细类
            ,funds_purpose -- 资金用途
            ,guarantee_method -- 担保方式
            ,credit_methods -- 增信方式
            ,credit_cust -- 增信主体
            ,datamark -- 唯一标识
            ,month_repay_record -- 当月还本记录
            ,month_average -- 月日均
            ,year_average -- 年日均
            ,in_due_ai -- 表内应收未收利息
            ,out_due_ai -- 表外应收利息
            ,this_month_prft_ir -- 利息收入（当月）
            ,this_year_prft_ir -- 利息收入（本年）
            ,year_chg_fv -- 公允价值变动（年初）
            ,month_chg_fv -- 公允价值变动（当月）
            ,year_prft_fv_real -- 公允价值变动损益（本年）
            ,year_prft_trd -- 买卖损益（本年）
            ,prft_ir_subj_code -- 利息损益科目号
            ,prft_trd_subj_code -- 价差损益科目号
            ,chg_fv_subj_code -- 估值损益科目号
            ,basic_asset_clients -- 基础资产客户
            ,underly_types_assets -- 底层资产类型
            ,guarantee_description -- 担保描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.obj_id, o.obj_id) as obj_id -- 核算id
    ,nvl(n.beg_date, o.beg_date) as beg_date -- 余额日期
    ,nvl(n.org_id, o.org_id) as org_id -- 机构号
    ,nvl(n.trade_id, o.trade_id) as trade_id -- 交易单号
    ,nvl(n.secu_acct_name, o.secu_acct_name) as secu_acct_name -- 投组单元
    ,nvl(n.dict_value, o.dict_value) as dict_value -- 会计分类
    ,nvl(n.p_type_name, o.p_type_name) as p_type_name -- 产品类型
    ,nvl(n.p_class, o.p_class) as p_class -- 产品分类
    ,nvl(n.i_code, o.i_code) as i_code -- 金融工具代码
    ,nvl(n.i_name, o.i_name) as i_name -- 金融工具名称
    ,nvl(n.trd_orddate, o.trd_orddate) as trd_orddate -- 交易日期
    ,nvl(n.trd_party_name, o.trd_party_name) as trd_party_name -- 交易对手
    ,nvl(n.trd_party_class, o.trd_party_class) as trd_party_class -- 交易对手客户分类
    ,nvl(n.issue_name, o.issue_name) as issue_name -- 发行人/实际融资人
    ,nvl(n.issue_class, o.issue_class) as issue_class -- 实际融资人客户分类
    ,nvl(n.exhacc, o.exhacc) as exhacc -- 划款账号
    ,nvl(n.party_acct_code, o.party_acct_code) as party_acct_code -- 收款账号
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.cp, o.cp) as cp -- 投资本金
    ,nvl(n.coupon, o.coupon) as coupon -- 执行利率
    ,nvl(n.open_date, o.open_date) as open_date -- 起息日
    ,nvl(n.end_date, o.end_date) as end_date -- 到期日
    ,nvl(n.inst_start_date, o.inst_start_date) as inst_start_date -- 原始期限
    ,nvl(n.inst_mrt_date, o.inst_mrt_date) as inst_mrt_date -- 剩余期限
    ,nvl(n.first_payment_date, o.first_payment_date) as first_payment_date -- 首次付息日
    ,nvl(n.pay_freq_name, o.pay_freq_name) as pay_freq_name -- 付息频率
    ,nvl(n.daycount_name, o.daycount_name) as daycount_name -- 计息基准
    ,nvl(n.coupon_type_name, o.coupon_type_name) as coupon_type_name -- 息票类型
    ,nvl(n.tzye, o.tzye) as tzye -- 投资余额
    ,nvl(n.ai, o.ai) as ai -- 应计利息
    ,nvl(n.prft_ir, o.prft_ir) as prft_ir -- 利息收入
    ,nvl(n.zmye, o.zmye) as zmye -- 账面余额
    ,nvl(n.business_category_name, o.business_category_name) as business_category_name -- 投向行业门类
    ,nvl(n.business_category_min_name, o.business_category_min_name) as business_category_min_name -- 投向行业大类
    ,nvl(n.s_grade, o.s_grade) as s_grade -- 债项/主体评级
    ,nvl(n.g31_plass, o.g31_plass) as g31_plass -- g31分类
    ,nvl(n.final_invest_name, o.final_invest_name) as final_invest_name -- 最终投向类型
    ,nvl(n.management_mode, o.management_mode) as management_mode -- 管理方式
    ,nvl(n.raise_way, o.raise_way) as raise_way -- 产品募集方式
    ,nvl(n.tzcplx, o.tzcplx) as tzcplx -- 投资产品类型
    ,nvl(n.under_debt_class, o.under_debt_class) as under_debt_class -- 底层为债券的债券分类
    ,nvl(n.under_debt_rating, o.under_debt_rating) as under_debt_rating -- 底层为债券的评级
    ,nvl(n.hx_isgover_fund, o.hx_isgover_fund) as hx_isgover_fund -- 是否政府投资基金
    ,nvl(n.is_pioneer_invest_fund, o.is_pioneer_invest_fund) as is_pioneer_invest_fund -- 是否创业投资基金
    ,nvl(n.hx_isdistbus, o.hx_isdistbus) as hx_isdistbus -- 是否异地业务
    ,nvl(n.hx_islocfinanc, o.hx_islocfinanc) as hx_islocfinanc -- 是否地方政府融资平台
    ,nvl(n.risk_assets_weight, o.risk_assets_weight) as risk_assets_weight -- 风险权重
    ,nvl(n.trader, o.trader) as trader -- 经办人
    ,nvl(n.op_user_name1, o.op_user_name1) as op_user_name1 -- 总行经办人
    ,nvl(n.op_user_name2, o.op_user_name2) as op_user_name2 -- 总行复核人
    ,nvl(n.cp_subj_code, o.cp_subj_code) as cp_subj_code -- 本金科目号
    ,nvl(n.ai_tax_rate, o.ai_tax_rate) as ai_tax_rate -- 增值税税率(应计利息收入)
    ,nvl(n.amrt_tax_rate, o.amrt_tax_rate) as amrt_tax_rate -- 增值税税率(摊销利息收入)
    ,nvl(n.trd_tax_rate, o.trd_tax_rate) as trd_tax_rate -- 增值税税率(买卖损益)
    ,nvl(n.ibs, o.ibs) as ibs -- 数据来源
    ,nvl(n.hxkhh, o.hxkhh) as hxkhh -- 交易对手核心客户号
    ,nvl(n.hxkhh1, o.hxkhh1) as hxkhh1 -- 实际融资人核心客户号
    ,nvl(n.mid_invest_industry_categories, o.mid_invest_industry_categories) as mid_invest_industry_categories -- 投向行业中类
    ,nvl(n.invest_industry_subcategories, o.invest_industry_subcategories) as invest_industry_subcategories -- 投向行业细类
    ,nvl(n.funds_purpose, o.funds_purpose) as funds_purpose -- 资金用途
    ,nvl(n.guarantee_method, o.guarantee_method) as guarantee_method -- 担保方式
    ,nvl(n.credit_methods, o.credit_methods) as credit_methods -- 增信方式
    ,nvl(n.credit_cust, o.credit_cust) as credit_cust -- 增信主体
    ,nvl(n.datamark, o.datamark) as datamark -- 唯一标识
    ,nvl(n.month_repay_record, o.month_repay_record) as month_repay_record -- 当月还本记录
    ,nvl(n.month_average, o.month_average) as month_average -- 月日均
    ,nvl(n.year_average, o.year_average) as year_average -- 年日均
    ,nvl(n.in_due_ai, o.in_due_ai) as in_due_ai -- 表内应收未收利息
    ,nvl(n.out_due_ai, o.out_due_ai) as out_due_ai -- 表外应收利息
    ,nvl(n.this_month_prft_ir, o.this_month_prft_ir) as this_month_prft_ir -- 利息收入（当月）
    ,nvl(n.this_year_prft_ir, o.this_year_prft_ir) as this_year_prft_ir -- 利息收入（本年）
    ,nvl(n.year_chg_fv, o.year_chg_fv) as year_chg_fv -- 公允价值变动（年初）
    ,nvl(n.month_chg_fv, o.month_chg_fv) as month_chg_fv -- 公允价值变动（当月）
    ,nvl(n.year_prft_fv_real, o.year_prft_fv_real) as year_prft_fv_real -- 公允价值变动损益（本年）
    ,nvl(n.year_prft_trd, o.year_prft_trd) as year_prft_trd -- 买卖损益（本年）
    ,nvl(n.prft_ir_subj_code, o.prft_ir_subj_code) as prft_ir_subj_code -- 利息损益科目号
    ,nvl(n.prft_trd_subj_code, o.prft_trd_subj_code) as prft_trd_subj_code -- 价差损益科目号
    ,nvl(n.chg_fv_subj_code, o.chg_fv_subj_code) as chg_fv_subj_code -- 估值损益科目号
    ,nvl(n.basic_asset_clients, o.basic_asset_clients) as basic_asset_clients -- 基础资产客户
    ,nvl(n.underly_types_assets, o.underly_types_assets) as underly_types_assets -- 底层资产类型
    ,nvl(n.guarantee_description, o.guarantee_description) as guarantee_description -- 担保描述
    ,case when
            n.obj_id is null
            and n.beg_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.obj_id is null
            and n.beg_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.obj_id is null
            and n.beg_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_vtrd_zcywtz_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_vtrd_zcywtz where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.obj_id = n.obj_id
            and o.beg_date = n.beg_date
where (
        o.obj_id is null
        and o.beg_date is null
    )
    or (
        n.obj_id is null
        and n.beg_date is null
    )
    or (
        o.org_id <> n.org_id
        or o.trade_id <> n.trade_id
        or o.secu_acct_name <> n.secu_acct_name
        or o.dict_value <> n.dict_value
        or o.p_type_name <> n.p_type_name
        or o.p_class <> n.p_class
        or o.i_code <> n.i_code
        or o.i_name <> n.i_name
        or o.trd_orddate <> n.trd_orddate
        or o.trd_party_name <> n.trd_party_name
        or o.trd_party_class <> n.trd_party_class
        or o.issue_name <> n.issue_name
        or o.issue_class <> n.issue_class
        or o.exhacc <> n.exhacc
        or o.party_acct_code <> n.party_acct_code
        or o.currency <> n.currency
        or o.cp <> n.cp
        or o.coupon <> n.coupon
        or o.open_date <> n.open_date
        or o.end_date <> n.end_date
        or o.inst_start_date <> n.inst_start_date
        or o.inst_mrt_date <> n.inst_mrt_date
        or o.first_payment_date <> n.first_payment_date
        or o.pay_freq_name <> n.pay_freq_name
        or o.daycount_name <> n.daycount_name
        or o.coupon_type_name <> n.coupon_type_name
        or o.tzye <> n.tzye
        or o.ai <> n.ai
        or o.prft_ir <> n.prft_ir
        or o.zmye <> n.zmye
        or o.business_category_name <> n.business_category_name
        or o.business_category_min_name <> n.business_category_min_name
        or o.s_grade <> n.s_grade
        or o.g31_plass <> n.g31_plass
        or o.final_invest_name <> n.final_invest_name
        or o.management_mode <> n.management_mode
        or o.raise_way <> n.raise_way
        or o.tzcplx <> n.tzcplx
        or o.under_debt_class <> n.under_debt_class
        or o.under_debt_rating <> n.under_debt_rating
        or o.hx_isgover_fund <> n.hx_isgover_fund
        or o.is_pioneer_invest_fund <> n.is_pioneer_invest_fund
        or o.hx_isdistbus <> n.hx_isdistbus
        or o.hx_islocfinanc <> n.hx_islocfinanc
        or o.risk_assets_weight <> n.risk_assets_weight
        or o.trader <> n.trader
        or o.op_user_name1 <> n.op_user_name1
        or o.op_user_name2 <> n.op_user_name2
        or o.cp_subj_code <> n.cp_subj_code
        or o.ai_tax_rate <> n.ai_tax_rate
        or o.amrt_tax_rate <> n.amrt_tax_rate
        or o.trd_tax_rate <> n.trd_tax_rate
        or o.ibs <> n.ibs
        or o.hxkhh <> n.hxkhh
        or o.hxkhh1 <> n.hxkhh1
        or o.mid_invest_industry_categories <> n.mid_invest_industry_categories
        or o.invest_industry_subcategories <> n.invest_industry_subcategories
        or o.funds_purpose <> n.funds_purpose
        or o.guarantee_method <> n.guarantee_method
        or o.credit_methods <> n.credit_methods
        or o.credit_cust <> n.credit_cust
        or o.datamark <> n.datamark
        or o.month_repay_record <> n.month_repay_record
        or o.month_average <> n.month_average
        or o.year_average <> n.year_average
        or o.in_due_ai <> n.in_due_ai
        or o.out_due_ai <> n.out_due_ai
        or o.this_month_prft_ir <> n.this_month_prft_ir
        or o.this_year_prft_ir <> n.this_year_prft_ir
        or o.year_chg_fv <> n.year_chg_fv
        or o.month_chg_fv <> n.month_chg_fv
        or o.year_prft_fv_real <> n.year_prft_fv_real
        or o.year_prft_trd <> n.year_prft_trd
        or o.prft_ir_subj_code <> n.prft_ir_subj_code
        or o.prft_trd_subj_code <> n.prft_trd_subj_code
        or o.chg_fv_subj_code <> n.chg_fv_subj_code
        or o.basic_asset_clients <> n.basic_asset_clients
        or o.underly_types_assets <> n.underly_types_assets
        or o.guarantee_description <> n.guarantee_description
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_vtrd_zcywtz_cl(
            obj_id -- 核算id
            ,beg_date -- 余额日期
            ,org_id -- 机构号
            ,trade_id -- 交易单号
            ,secu_acct_name -- 投组单元
            ,dict_value -- 会计分类
            ,p_type_name -- 产品类型
            ,p_class -- 产品分类
            ,i_code -- 金融工具代码
            ,i_name -- 金融工具名称
            ,trd_orddate -- 交易日期
            ,trd_party_name -- 交易对手
            ,trd_party_class -- 交易对手客户分类
            ,issue_name -- 发行人/实际融资人
            ,issue_class -- 实际融资人客户分类
            ,exhacc -- 划款账号
            ,party_acct_code -- 收款账号
            ,currency -- 币种
            ,cp -- 投资本金
            ,coupon -- 执行利率
            ,open_date -- 起息日
            ,end_date -- 到期日
            ,inst_start_date -- 原始期限
            ,inst_mrt_date -- 剩余期限
            ,first_payment_date -- 首次付息日
            ,pay_freq_name -- 付息频率
            ,daycount_name -- 计息基准
            ,coupon_type_name -- 息票类型
            ,tzye -- 投资余额
            ,ai -- 应计利息
            ,prft_ir -- 利息收入
            ,zmye -- 账面余额
            ,business_category_name -- 投向行业门类
            ,business_category_min_name -- 投向行业大类
            ,s_grade -- 债项/主体评级
            ,g31_plass -- g31分类
            ,final_invest_name -- 最终投向类型
            ,management_mode -- 管理方式
            ,raise_way -- 产品募集方式
            ,tzcplx -- 投资产品类型
            ,under_debt_class -- 底层为债券的债券分类
            ,under_debt_rating -- 底层为债券的评级
            ,hx_isgover_fund -- 是否政府投资基金
            ,is_pioneer_invest_fund -- 是否创业投资基金
            ,hx_isdistbus -- 是否异地业务
            ,hx_islocfinanc -- 是否地方政府融资平台
            ,risk_assets_weight -- 风险权重
            ,trader -- 经办人
            ,op_user_name1 -- 总行经办人
            ,op_user_name2 -- 总行复核人
            ,cp_subj_code -- 本金科目号
            ,ai_tax_rate -- 增值税税率(应计利息收入)
            ,amrt_tax_rate -- 增值税税率(摊销利息收入)
            ,trd_tax_rate -- 增值税税率(买卖损益)
            ,ibs -- 数据来源
            ,hxkhh -- 交易对手核心客户号
            ,hxkhh1 -- 实际融资人核心客户号
            ,mid_invest_industry_categories -- 投向行业中类
            ,invest_industry_subcategories -- 投向行业细类
            ,funds_purpose -- 资金用途
            ,guarantee_method -- 担保方式
            ,credit_methods -- 增信方式
            ,credit_cust -- 增信主体
            ,datamark -- 唯一标识
            ,month_repay_record -- 当月还本记录
            ,month_average -- 月日均
            ,year_average -- 年日均
            ,in_due_ai -- 表内应收未收利息
            ,out_due_ai -- 表外应收利息
            ,this_month_prft_ir -- 利息收入（当月）
            ,this_year_prft_ir -- 利息收入（本年）
            ,year_chg_fv -- 公允价值变动（年初）
            ,month_chg_fv -- 公允价值变动（当月）
            ,year_prft_fv_real -- 公允价值变动损益（本年）
            ,year_prft_trd -- 买卖损益（本年）
            ,prft_ir_subj_code -- 利息损益科目号
            ,prft_trd_subj_code -- 价差损益科目号
            ,chg_fv_subj_code -- 估值损益科目号
            ,basic_asset_clients -- 基础资产客户
            ,underly_types_assets -- 底层资产类型
            ,guarantee_description -- 担保描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_vtrd_zcywtz_op(
            obj_id -- 核算id
            ,beg_date -- 余额日期
            ,org_id -- 机构号
            ,trade_id -- 交易单号
            ,secu_acct_name -- 投组单元
            ,dict_value -- 会计分类
            ,p_type_name -- 产品类型
            ,p_class -- 产品分类
            ,i_code -- 金融工具代码
            ,i_name -- 金融工具名称
            ,trd_orddate -- 交易日期
            ,trd_party_name -- 交易对手
            ,trd_party_class -- 交易对手客户分类
            ,issue_name -- 发行人/实际融资人
            ,issue_class -- 实际融资人客户分类
            ,exhacc -- 划款账号
            ,party_acct_code -- 收款账号
            ,currency -- 币种
            ,cp -- 投资本金
            ,coupon -- 执行利率
            ,open_date -- 起息日
            ,end_date -- 到期日
            ,inst_start_date -- 原始期限
            ,inst_mrt_date -- 剩余期限
            ,first_payment_date -- 首次付息日
            ,pay_freq_name -- 付息频率
            ,daycount_name -- 计息基准
            ,coupon_type_name -- 息票类型
            ,tzye -- 投资余额
            ,ai -- 应计利息
            ,prft_ir -- 利息收入
            ,zmye -- 账面余额
            ,business_category_name -- 投向行业门类
            ,business_category_min_name -- 投向行业大类
            ,s_grade -- 债项/主体评级
            ,g31_plass -- g31分类
            ,final_invest_name -- 最终投向类型
            ,management_mode -- 管理方式
            ,raise_way -- 产品募集方式
            ,tzcplx -- 投资产品类型
            ,under_debt_class -- 底层为债券的债券分类
            ,under_debt_rating -- 底层为债券的评级
            ,hx_isgover_fund -- 是否政府投资基金
            ,is_pioneer_invest_fund -- 是否创业投资基金
            ,hx_isdistbus -- 是否异地业务
            ,hx_islocfinanc -- 是否地方政府融资平台
            ,risk_assets_weight -- 风险权重
            ,trader -- 经办人
            ,op_user_name1 -- 总行经办人
            ,op_user_name2 -- 总行复核人
            ,cp_subj_code -- 本金科目号
            ,ai_tax_rate -- 增值税税率(应计利息收入)
            ,amrt_tax_rate -- 增值税税率(摊销利息收入)
            ,trd_tax_rate -- 增值税税率(买卖损益)
            ,ibs -- 数据来源
            ,hxkhh -- 交易对手核心客户号
            ,hxkhh1 -- 实际融资人核心客户号
            ,mid_invest_industry_categories -- 投向行业中类
            ,invest_industry_subcategories -- 投向行业细类
            ,funds_purpose -- 资金用途
            ,guarantee_method -- 担保方式
            ,credit_methods -- 增信方式
            ,credit_cust -- 增信主体
            ,datamark -- 唯一标识
            ,month_repay_record -- 当月还本记录
            ,month_average -- 月日均
            ,year_average -- 年日均
            ,in_due_ai -- 表内应收未收利息
            ,out_due_ai -- 表外应收利息
            ,this_month_prft_ir -- 利息收入（当月）
            ,this_year_prft_ir -- 利息收入（本年）
            ,year_chg_fv -- 公允价值变动（年初）
            ,month_chg_fv -- 公允价值变动（当月）
            ,year_prft_fv_real -- 公允价值变动损益（本年）
            ,year_prft_trd -- 买卖损益（本年）
            ,prft_ir_subj_code -- 利息损益科目号
            ,prft_trd_subj_code -- 价差损益科目号
            ,chg_fv_subj_code -- 估值损益科目号
            ,basic_asset_clients -- 基础资产客户
            ,underly_types_assets -- 底层资产类型
            ,guarantee_description -- 担保描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.obj_id -- 核算id
    ,o.beg_date -- 余额日期
    ,o.org_id -- 机构号
    ,o.trade_id -- 交易单号
    ,o.secu_acct_name -- 投组单元
    ,o.dict_value -- 会计分类
    ,o.p_type_name -- 产品类型
    ,o.p_class -- 产品分类
    ,o.i_code -- 金融工具代码
    ,o.i_name -- 金融工具名称
    ,o.trd_orddate -- 交易日期
    ,o.trd_party_name -- 交易对手
    ,o.trd_party_class -- 交易对手客户分类
    ,o.issue_name -- 发行人/实际融资人
    ,o.issue_class -- 实际融资人客户分类
    ,o.exhacc -- 划款账号
    ,o.party_acct_code -- 收款账号
    ,o.currency -- 币种
    ,o.cp -- 投资本金
    ,o.coupon -- 执行利率
    ,o.open_date -- 起息日
    ,o.end_date -- 到期日
    ,o.inst_start_date -- 原始期限
    ,o.inst_mrt_date -- 剩余期限
    ,o.first_payment_date -- 首次付息日
    ,o.pay_freq_name -- 付息频率
    ,o.daycount_name -- 计息基准
    ,o.coupon_type_name -- 息票类型
    ,o.tzye -- 投资余额
    ,o.ai -- 应计利息
    ,o.prft_ir -- 利息收入
    ,o.zmye -- 账面余额
    ,o.business_category_name -- 投向行业门类
    ,o.business_category_min_name -- 投向行业大类
    ,o.s_grade -- 债项/主体评级
    ,o.g31_plass -- g31分类
    ,o.final_invest_name -- 最终投向类型
    ,o.management_mode -- 管理方式
    ,o.raise_way -- 产品募集方式
    ,o.tzcplx -- 投资产品类型
    ,o.under_debt_class -- 底层为债券的债券分类
    ,o.under_debt_rating -- 底层为债券的评级
    ,o.hx_isgover_fund -- 是否政府投资基金
    ,o.is_pioneer_invest_fund -- 是否创业投资基金
    ,o.hx_isdistbus -- 是否异地业务
    ,o.hx_islocfinanc -- 是否地方政府融资平台
    ,o.risk_assets_weight -- 风险权重
    ,o.trader -- 经办人
    ,o.op_user_name1 -- 总行经办人
    ,o.op_user_name2 -- 总行复核人
    ,o.cp_subj_code -- 本金科目号
    ,o.ai_tax_rate -- 增值税税率(应计利息收入)
    ,o.amrt_tax_rate -- 增值税税率(摊销利息收入)
    ,o.trd_tax_rate -- 增值税税率(买卖损益)
    ,o.ibs -- 数据来源
    ,o.hxkhh -- 交易对手核心客户号
    ,o.hxkhh1 -- 实际融资人核心客户号
    ,o.mid_invest_industry_categories -- 投向行业中类
    ,o.invest_industry_subcategories -- 投向行业细类
    ,o.funds_purpose -- 资金用途
    ,o.guarantee_method -- 担保方式
    ,o.credit_methods -- 增信方式
    ,o.credit_cust -- 增信主体
    ,o.datamark -- 唯一标识
    ,o.month_repay_record -- 当月还本记录
    ,o.month_average -- 月日均
    ,o.year_average -- 年日均
    ,o.in_due_ai -- 表内应收未收利息
    ,o.out_due_ai -- 表外应收利息
    ,o.this_month_prft_ir -- 利息收入（当月）
    ,o.this_year_prft_ir -- 利息收入（本年）
    ,o.year_chg_fv -- 公允价值变动（年初）
    ,o.month_chg_fv -- 公允价值变动（当月）
    ,o.year_prft_fv_real -- 公允价值变动损益（本年）
    ,o.year_prft_trd -- 买卖损益（本年）
    ,o.prft_ir_subj_code -- 利息损益科目号
    ,o.prft_trd_subj_code -- 价差损益科目号
    ,o.chg_fv_subj_code -- 估值损益科目号
    ,o.basic_asset_clients -- 基础资产客户
    ,o.underly_types_assets -- 底层资产类型
    ,o.guarantee_description -- 担保描述
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
from ${iol_schema}.ibms_vtrd_zcywtz_bk o
    left join ${iol_schema}.ibms_vtrd_zcywtz_op n
        on
            o.obj_id = n.obj_id
            and o.beg_date = n.beg_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_vtrd_zcywtz_cl d
        on
            o.obj_id = d.obj_id
            and o.beg_date = d.beg_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_vtrd_zcywtz;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_vtrd_zcywtz') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_vtrd_zcywtz drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_vtrd_zcywtz add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_vtrd_zcywtz exchange partition p_${batch_date} with table ${iol_schema}.ibms_vtrd_zcywtz_cl;
alter table ${iol_schema}.ibms_vtrd_zcywtz exchange partition p_20991231 with table ${iol_schema}.ibms_vtrd_zcywtz_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_vtrd_zcywtz to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_vtrd_zcywtz_op purge;
drop table ${iol_schema}.ibms_vtrd_zcywtz_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_vtrd_zcywtz_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_vtrd_zcywtz',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
