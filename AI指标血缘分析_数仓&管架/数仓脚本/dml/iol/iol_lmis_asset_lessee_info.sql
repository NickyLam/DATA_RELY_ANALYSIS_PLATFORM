/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_lmis_asset_lessee_info
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
create table ${iol_schema}.lmis_asset_lessee_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.lmis_asset_lessee_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.lmis_asset_lessee_info_op purge;
drop table ${iol_schema}.lmis_asset_lessee_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.lmis_asset_lessee_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.lmis_asset_lessee_info where 0=1;

create table ${iol_schema}.lmis_asset_lessee_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.lmis_asset_lessee_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.lmis_asset_lessee_info_cl(
            id -- 承租资产ID
            ,asset_id -- 资产ID
            ,line_num -- 行号
            ,contract_id -- 承租合同ID
            ,contract_code -- 合同编号
            ,contract_name -- 合同名称
            ,contract_effect_date -- 合同生效日
            ,lessor -- 出租方
            ,operate_type -- 操作类型
            ,book_code -- 账簿代码
            ,asset_number -- 资产编号
            ,tag_number -- 资产标签号
            ,asset_type -- 资产类型
            ,asset_name -- 资产名称
            ,asset_category_id -- 资产类别ID
            ,company_id -- 使用机构
            ,department_id -- 使用部门
            ,quantity -- 数量
            ,lessee_status -- 状态
            ,account_status -- 凭证状态
            ,prepayment_amount -- 预付账款（不含税）
            ,other_direct_cost -- 其他直接费用（不含税）
            ,lease_liability_pay_amt_tax -- 租赁负债-应付租赁款（含税）
            ,lease_liability_pay_amt -- 租赁负债-应付租赁款（不含税）
            ,lease_liability_bal -- 租赁负债
            ,lease_liability_int_bal -- 租赁负债-未确认融资费用
            ,asset_amount -- 使用权资产-原值
            ,deducted_tax -- 其他待抵扣进项税额
            ,lease_begin_date -- 租赁开始日
            ,lease_end_date -- 租赁到期日
            ,lease_life_month -- 租赁期限（月）
            ,amount_tax -- 税额
            ,amount_no_tax -- 计划付款总额（不含税）
            ,amount_with_tax -- 计划付款总额（含税）
            ,discount_rule_code -- 折现规则代码
            ,year_discount_rate -- 折现率（年）
            ,day_discount_rate -- 折现率（日）
            ,date_effective -- 有效日期（记账日期）
            ,date_ineffective -- 失效日期
            ,transaction_header_id_in -- 事物处理生效头ID
            ,transaction_header_id_out -- 事物处理失效头ID
            ,tenant_id -- 租户ID
            ,created_by -- 创建人
            ,created_date -- 创建时间
            ,last_updated_by -- 最后更新人
            ,last_updated_date -- 最后更新时间
            ,version_number -- 版本号
            ,memo -- 备注说明
            ,deposit_amount -- 押金
            ,lessee_scope -- 租赁范围
            ,monthly_rent_amt -- 月租金（含税）
            ,tax_rate -- 税率（%）
            ,pay_frequency -- 付款频率
            ,plan_payment_date -- 首期计划付款日
            ,fund_growth_rate -- 资金增长率
            ,fund_growth_date -- 资金增长率起始日
            ,create_mode -- 创建方式
            ,attachment_oid -- 附件oid
            ,lease_id -- ASSET_LESSEE_CONTRACT_IDENTIFY表ID
            ,area -- 面积
            ,termin_fine -- 终止罚金
            ,buy_right_price -- 购买行权价
            ,recovery_cost -- 预计复原成本
            ,residual_value -- 剩余价值担保金额
            ,urge_measure_amount -- 激励措施金
            ,invoice_type -- 发票类型
            ,rent_pay_amt -- 应付租赁款
            ,lease_usage -- 租赁用途
            ,pay_type -- 支付方式
            ,deduction_flag -- 是否可抵扣
            ,i16_begin_date -- 准则起始日
            ,lessee_prepay_amount -- 预付待摊余额
            ,company_code -- 公司Code
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.lmis_asset_lessee_info_op(
            id -- 承租资产ID
            ,asset_id -- 资产ID
            ,line_num -- 行号
            ,contract_id -- 承租合同ID
            ,contract_code -- 合同编号
            ,contract_name -- 合同名称
            ,contract_effect_date -- 合同生效日
            ,lessor -- 出租方
            ,operate_type -- 操作类型
            ,book_code -- 账簿代码
            ,asset_number -- 资产编号
            ,tag_number -- 资产标签号
            ,asset_type -- 资产类型
            ,asset_name -- 资产名称
            ,asset_category_id -- 资产类别ID
            ,company_id -- 使用机构
            ,department_id -- 使用部门
            ,quantity -- 数量
            ,lessee_status -- 状态
            ,account_status -- 凭证状态
            ,prepayment_amount -- 预付账款（不含税）
            ,other_direct_cost -- 其他直接费用（不含税）
            ,lease_liability_pay_amt_tax -- 租赁负债-应付租赁款（含税）
            ,lease_liability_pay_amt -- 租赁负债-应付租赁款（不含税）
            ,lease_liability_bal -- 租赁负债
            ,lease_liability_int_bal -- 租赁负债-未确认融资费用
            ,asset_amount -- 使用权资产-原值
            ,deducted_tax -- 其他待抵扣进项税额
            ,lease_begin_date -- 租赁开始日
            ,lease_end_date -- 租赁到期日
            ,lease_life_month -- 租赁期限（月）
            ,amount_tax -- 税额
            ,amount_no_tax -- 计划付款总额（不含税）
            ,amount_with_tax -- 计划付款总额（含税）
            ,discount_rule_code -- 折现规则代码
            ,year_discount_rate -- 折现率（年）
            ,day_discount_rate -- 折现率（日）
            ,date_effective -- 有效日期（记账日期）
            ,date_ineffective -- 失效日期
            ,transaction_header_id_in -- 事物处理生效头ID
            ,transaction_header_id_out -- 事物处理失效头ID
            ,tenant_id -- 租户ID
            ,created_by -- 创建人
            ,created_date -- 创建时间
            ,last_updated_by -- 最后更新人
            ,last_updated_date -- 最后更新时间
            ,version_number -- 版本号
            ,memo -- 备注说明
            ,deposit_amount -- 押金
            ,lessee_scope -- 租赁范围
            ,monthly_rent_amt -- 月租金（含税）
            ,tax_rate -- 税率（%）
            ,pay_frequency -- 付款频率
            ,plan_payment_date -- 首期计划付款日
            ,fund_growth_rate -- 资金增长率
            ,fund_growth_date -- 资金增长率起始日
            ,create_mode -- 创建方式
            ,attachment_oid -- 附件oid
            ,lease_id -- ASSET_LESSEE_CONTRACT_IDENTIFY表ID
            ,area -- 面积
            ,termin_fine -- 终止罚金
            ,buy_right_price -- 购买行权价
            ,recovery_cost -- 预计复原成本
            ,residual_value -- 剩余价值担保金额
            ,urge_measure_amount -- 激励措施金
            ,invoice_type -- 发票类型
            ,rent_pay_amt -- 应付租赁款
            ,lease_usage -- 租赁用途
            ,pay_type -- 支付方式
            ,deduction_flag -- 是否可抵扣
            ,i16_begin_date -- 准则起始日
            ,lessee_prepay_amount -- 预付待摊余额
            ,company_code -- 公司Code
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 承租资产ID
    ,nvl(n.asset_id, o.asset_id) as asset_id -- 资产ID
    ,nvl(n.line_num, o.line_num) as line_num -- 行号
    ,nvl(n.contract_id, o.contract_id) as contract_id -- 承租合同ID
    ,nvl(n.contract_code, o.contract_code) as contract_code -- 合同编号
    ,nvl(n.contract_name, o.contract_name) as contract_name -- 合同名称
    ,nvl(n.contract_effect_date, o.contract_effect_date) as contract_effect_date -- 合同生效日
    ,nvl(n.lessor, o.lessor) as lessor -- 出租方
    ,nvl(n.operate_type, o.operate_type) as operate_type -- 操作类型
    ,nvl(n.book_code, o.book_code) as book_code -- 账簿代码
    ,nvl(n.asset_number, o.asset_number) as asset_number -- 资产编号
    ,nvl(n.tag_number, o.tag_number) as tag_number -- 资产标签号
    ,nvl(n.asset_type, o.asset_type) as asset_type -- 资产类型
    ,nvl(n.asset_name, o.asset_name) as asset_name -- 资产名称
    ,nvl(n.asset_category_id, o.asset_category_id) as asset_category_id -- 资产类别ID
    ,nvl(n.company_id, o.company_id) as company_id -- 使用机构
    ,nvl(n.department_id, o.department_id) as department_id -- 使用部门
    ,nvl(n.quantity, o.quantity) as quantity -- 数量
    ,nvl(n.lessee_status, o.lessee_status) as lessee_status -- 状态
    ,nvl(n.account_status, o.account_status) as account_status -- 凭证状态
    ,nvl(n.prepayment_amount, o.prepayment_amount) as prepayment_amount -- 预付账款（不含税）
    ,nvl(n.other_direct_cost, o.other_direct_cost) as other_direct_cost -- 其他直接费用（不含税）
    ,nvl(n.lease_liability_pay_amt_tax, o.lease_liability_pay_amt_tax) as lease_liability_pay_amt_tax -- 租赁负债-应付租赁款（含税）
    ,nvl(n.lease_liability_pay_amt, o.lease_liability_pay_amt) as lease_liability_pay_amt -- 租赁负债-应付租赁款（不含税）
    ,nvl(n.lease_liability_bal, o.lease_liability_bal) as lease_liability_bal -- 租赁负债
    ,nvl(n.lease_liability_int_bal, o.lease_liability_int_bal) as lease_liability_int_bal -- 租赁负债-未确认融资费用
    ,nvl(n.asset_amount, o.asset_amount) as asset_amount -- 使用权资产-原值
    ,nvl(n.deducted_tax, o.deducted_tax) as deducted_tax -- 其他待抵扣进项税额
    ,nvl(n.lease_begin_date, o.lease_begin_date) as lease_begin_date -- 租赁开始日
    ,nvl(n.lease_end_date, o.lease_end_date) as lease_end_date -- 租赁到期日
    ,nvl(n.lease_life_month, o.lease_life_month) as lease_life_month -- 租赁期限（月）
    ,nvl(n.amount_tax, o.amount_tax) as amount_tax -- 税额
    ,nvl(n.amount_no_tax, o.amount_no_tax) as amount_no_tax -- 计划付款总额（不含税）
    ,nvl(n.amount_with_tax, o.amount_with_tax) as amount_with_tax -- 计划付款总额（含税）
    ,nvl(n.discount_rule_code, o.discount_rule_code) as discount_rule_code -- 折现规则代码
    ,nvl(n.year_discount_rate, o.year_discount_rate) as year_discount_rate -- 折现率（年）
    ,nvl(n.day_discount_rate, o.day_discount_rate) as day_discount_rate -- 折现率（日）
    ,nvl(n.date_effective, o.date_effective) as date_effective -- 有效日期（记账日期）
    ,nvl(n.date_ineffective, o.date_ineffective) as date_ineffective -- 失效日期
    ,nvl(n.transaction_header_id_in, o.transaction_header_id_in) as transaction_header_id_in -- 事物处理生效头ID
    ,nvl(n.transaction_header_id_out, o.transaction_header_id_out) as transaction_header_id_out -- 事物处理失效头ID
    ,nvl(n.tenant_id, o.tenant_id) as tenant_id -- 租户ID
    ,nvl(n.created_by, o.created_by) as created_by -- 创建人
    ,nvl(n.created_date, o.created_date) as created_date -- 创建时间
    ,nvl(n.last_updated_by, o.last_updated_by) as last_updated_by -- 最后更新人
    ,nvl(n.last_updated_date, o.last_updated_date) as last_updated_date -- 最后更新时间
    ,nvl(n.version_number, o.version_number) as version_number -- 版本号
    ,nvl(n.memo, o.memo) as memo -- 备注说明
    ,nvl(n.deposit_amount, o.deposit_amount) as deposit_amount -- 押金
    ,nvl(n.lessee_scope, o.lessee_scope) as lessee_scope -- 租赁范围
    ,nvl(n.monthly_rent_amt, o.monthly_rent_amt) as monthly_rent_amt -- 月租金（含税）
    ,nvl(n.tax_rate, o.tax_rate) as tax_rate -- 税率（%）
    ,nvl(n.pay_frequency, o.pay_frequency) as pay_frequency -- 付款频率
    ,nvl(n.plan_payment_date, o.plan_payment_date) as plan_payment_date -- 首期计划付款日
    ,nvl(n.fund_growth_rate, o.fund_growth_rate) as fund_growth_rate -- 资金增长率
    ,nvl(n.fund_growth_date, o.fund_growth_date) as fund_growth_date -- 资金增长率起始日
    ,nvl(n.create_mode, o.create_mode) as create_mode -- 创建方式
    ,nvl(n.attachment_oid, o.attachment_oid) as attachment_oid -- 附件oid
    ,nvl(n.lease_id, o.lease_id) as lease_id -- ASSET_LESSEE_CONTRACT_IDENTIFY表ID
    ,nvl(n.area, o.area) as area -- 面积
    ,nvl(n.termin_fine, o.termin_fine) as termin_fine -- 终止罚金
    ,nvl(n.buy_right_price, o.buy_right_price) as buy_right_price -- 购买行权价
    ,nvl(n.recovery_cost, o.recovery_cost) as recovery_cost -- 预计复原成本
    ,nvl(n.residual_value, o.residual_value) as residual_value -- 剩余价值担保金额
    ,nvl(n.urge_measure_amount, o.urge_measure_amount) as urge_measure_amount -- 激励措施金
    ,nvl(n.invoice_type, o.invoice_type) as invoice_type -- 发票类型
    ,nvl(n.rent_pay_amt, o.rent_pay_amt) as rent_pay_amt -- 应付租赁款
    ,nvl(n.lease_usage, o.lease_usage) as lease_usage -- 租赁用途
    ,nvl(n.pay_type, o.pay_type) as pay_type -- 支付方式
    ,nvl(n.deduction_flag, o.deduction_flag) as deduction_flag -- 是否可抵扣
    ,nvl(n.i16_begin_date, o.i16_begin_date) as i16_begin_date -- 准则起始日
    ,nvl(n.lessee_prepay_amount, o.lessee_prepay_amount) as lessee_prepay_amount -- 预付待摊余额
    ,nvl(n.company_code, o.company_code) as company_code -- 公司Code
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
from (select * from ${iol_schema}.lmis_asset_lessee_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.lmis_asset_lessee_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.asset_id <> n.asset_id
        or o.line_num <> n.line_num
        or o.contract_id <> n.contract_id
        or o.contract_code <> n.contract_code
        or o.contract_name <> n.contract_name
        or o.contract_effect_date <> n.contract_effect_date
        or o.lessor <> n.lessor
        or o.operate_type <> n.operate_type
        or o.book_code <> n.book_code
        or o.asset_number <> n.asset_number
        or o.tag_number <> n.tag_number
        or o.asset_type <> n.asset_type
        or o.asset_name <> n.asset_name
        or o.asset_category_id <> n.asset_category_id
        or o.company_id <> n.company_id
        or o.department_id <> n.department_id
        or o.quantity <> n.quantity
        or o.lessee_status <> n.lessee_status
        or o.account_status <> n.account_status
        or o.prepayment_amount <> n.prepayment_amount
        or o.other_direct_cost <> n.other_direct_cost
        or o.lease_liability_pay_amt_tax <> n.lease_liability_pay_amt_tax
        or o.lease_liability_pay_amt <> n.lease_liability_pay_amt
        or o.lease_liability_bal <> n.lease_liability_bal
        or o.lease_liability_int_bal <> n.lease_liability_int_bal
        or o.asset_amount <> n.asset_amount
        or o.deducted_tax <> n.deducted_tax
        or o.lease_begin_date <> n.lease_begin_date
        or o.lease_end_date <> n.lease_end_date
        or o.lease_life_month <> n.lease_life_month
        or o.amount_tax <> n.amount_tax
        or o.amount_no_tax <> n.amount_no_tax
        or o.amount_with_tax <> n.amount_with_tax
        or o.discount_rule_code <> n.discount_rule_code
        or o.year_discount_rate <> n.year_discount_rate
        or o.day_discount_rate <> n.day_discount_rate
        or o.date_effective <> n.date_effective
        or o.date_ineffective <> n.date_ineffective
        or o.transaction_header_id_in <> n.transaction_header_id_in
        or o.transaction_header_id_out <> n.transaction_header_id_out
        or o.tenant_id <> n.tenant_id
        or o.created_by <> n.created_by
        or o.created_date <> n.created_date
        or o.last_updated_by <> n.last_updated_by
        or o.last_updated_date <> n.last_updated_date
        or o.version_number <> n.version_number
        or o.memo <> n.memo
        or o.deposit_amount <> n.deposit_amount
        or o.lessee_scope <> n.lessee_scope
        or o.monthly_rent_amt <> n.monthly_rent_amt
        or o.tax_rate <> n.tax_rate
        or o.pay_frequency <> n.pay_frequency
        or o.plan_payment_date <> n.plan_payment_date
        or o.fund_growth_rate <> n.fund_growth_rate
        or o.fund_growth_date <> n.fund_growth_date
        or o.create_mode <> n.create_mode
        or o.attachment_oid <> n.attachment_oid
        or o.lease_id <> n.lease_id
        or o.area <> n.area
        or o.termin_fine <> n.termin_fine
        or o.buy_right_price <> n.buy_right_price
        or o.recovery_cost <> n.recovery_cost
        or o.residual_value <> n.residual_value
        or o.urge_measure_amount <> n.urge_measure_amount
        or o.invoice_type <> n.invoice_type
        or o.rent_pay_amt <> n.rent_pay_amt
        or o.lease_usage <> n.lease_usage
        or o.pay_type <> n.pay_type
        or o.deduction_flag <> n.deduction_flag
        or o.i16_begin_date <> n.i16_begin_date
        or o.lessee_prepay_amount <> n.lessee_prepay_amount
        or o.company_code <> n.company_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.lmis_asset_lessee_info_cl(
            id -- 承租资产ID
            ,asset_id -- 资产ID
            ,line_num -- 行号
            ,contract_id -- 承租合同ID
            ,contract_code -- 合同编号
            ,contract_name -- 合同名称
            ,contract_effect_date -- 合同生效日
            ,lessor -- 出租方
            ,operate_type -- 操作类型
            ,book_code -- 账簿代码
            ,asset_number -- 资产编号
            ,tag_number -- 资产标签号
            ,asset_type -- 资产类型
            ,asset_name -- 资产名称
            ,asset_category_id -- 资产类别ID
            ,company_id -- 使用机构
            ,department_id -- 使用部门
            ,quantity -- 数量
            ,lessee_status -- 状态
            ,account_status -- 凭证状态
            ,prepayment_amount -- 预付账款（不含税）
            ,other_direct_cost -- 其他直接费用（不含税）
            ,lease_liability_pay_amt_tax -- 租赁负债-应付租赁款（含税）
            ,lease_liability_pay_amt -- 租赁负债-应付租赁款（不含税）
            ,lease_liability_bal -- 租赁负债
            ,lease_liability_int_bal -- 租赁负债-未确认融资费用
            ,asset_amount -- 使用权资产-原值
            ,deducted_tax -- 其他待抵扣进项税额
            ,lease_begin_date -- 租赁开始日
            ,lease_end_date -- 租赁到期日
            ,lease_life_month -- 租赁期限（月）
            ,amount_tax -- 税额
            ,amount_no_tax -- 计划付款总额（不含税）
            ,amount_with_tax -- 计划付款总额（含税）
            ,discount_rule_code -- 折现规则代码
            ,year_discount_rate -- 折现率（年）
            ,day_discount_rate -- 折现率（日）
            ,date_effective -- 有效日期（记账日期）
            ,date_ineffective -- 失效日期
            ,transaction_header_id_in -- 事物处理生效头ID
            ,transaction_header_id_out -- 事物处理失效头ID
            ,tenant_id -- 租户ID
            ,created_by -- 创建人
            ,created_date -- 创建时间
            ,last_updated_by -- 最后更新人
            ,last_updated_date -- 最后更新时间
            ,version_number -- 版本号
            ,memo -- 备注说明
            ,deposit_amount -- 押金
            ,lessee_scope -- 租赁范围
            ,monthly_rent_amt -- 月租金（含税）
            ,tax_rate -- 税率（%）
            ,pay_frequency -- 付款频率
            ,plan_payment_date -- 首期计划付款日
            ,fund_growth_rate -- 资金增长率
            ,fund_growth_date -- 资金增长率起始日
            ,create_mode -- 创建方式
            ,attachment_oid -- 附件oid
            ,lease_id -- ASSET_LESSEE_CONTRACT_IDENTIFY表ID
            ,area -- 面积
            ,termin_fine -- 终止罚金
            ,buy_right_price -- 购买行权价
            ,recovery_cost -- 预计复原成本
            ,residual_value -- 剩余价值担保金额
            ,urge_measure_amount -- 激励措施金
            ,invoice_type -- 发票类型
            ,rent_pay_amt -- 应付租赁款
            ,lease_usage -- 租赁用途
            ,pay_type -- 支付方式
            ,deduction_flag -- 是否可抵扣
            ,i16_begin_date -- 准则起始日
            ,lessee_prepay_amount -- 预付待摊余额
            ,company_code -- 公司Code
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.lmis_asset_lessee_info_op(
            id -- 承租资产ID
            ,asset_id -- 资产ID
            ,line_num -- 行号
            ,contract_id -- 承租合同ID
            ,contract_code -- 合同编号
            ,contract_name -- 合同名称
            ,contract_effect_date -- 合同生效日
            ,lessor -- 出租方
            ,operate_type -- 操作类型
            ,book_code -- 账簿代码
            ,asset_number -- 资产编号
            ,tag_number -- 资产标签号
            ,asset_type -- 资产类型
            ,asset_name -- 资产名称
            ,asset_category_id -- 资产类别ID
            ,company_id -- 使用机构
            ,department_id -- 使用部门
            ,quantity -- 数量
            ,lessee_status -- 状态
            ,account_status -- 凭证状态
            ,prepayment_amount -- 预付账款（不含税）
            ,other_direct_cost -- 其他直接费用（不含税）
            ,lease_liability_pay_amt_tax -- 租赁负债-应付租赁款（含税）
            ,lease_liability_pay_amt -- 租赁负债-应付租赁款（不含税）
            ,lease_liability_bal -- 租赁负债
            ,lease_liability_int_bal -- 租赁负债-未确认融资费用
            ,asset_amount -- 使用权资产-原值
            ,deducted_tax -- 其他待抵扣进项税额
            ,lease_begin_date -- 租赁开始日
            ,lease_end_date -- 租赁到期日
            ,lease_life_month -- 租赁期限（月）
            ,amount_tax -- 税额
            ,amount_no_tax -- 计划付款总额（不含税）
            ,amount_with_tax -- 计划付款总额（含税）
            ,discount_rule_code -- 折现规则代码
            ,year_discount_rate -- 折现率（年）
            ,day_discount_rate -- 折现率（日）
            ,date_effective -- 有效日期（记账日期）
            ,date_ineffective -- 失效日期
            ,transaction_header_id_in -- 事物处理生效头ID
            ,transaction_header_id_out -- 事物处理失效头ID
            ,tenant_id -- 租户ID
            ,created_by -- 创建人
            ,created_date -- 创建时间
            ,last_updated_by -- 最后更新人
            ,last_updated_date -- 最后更新时间
            ,version_number -- 版本号
            ,memo -- 备注说明
            ,deposit_amount -- 押金
            ,lessee_scope -- 租赁范围
            ,monthly_rent_amt -- 月租金（含税）
            ,tax_rate -- 税率（%）
            ,pay_frequency -- 付款频率
            ,plan_payment_date -- 首期计划付款日
            ,fund_growth_rate -- 资金增长率
            ,fund_growth_date -- 资金增长率起始日
            ,create_mode -- 创建方式
            ,attachment_oid -- 附件oid
            ,lease_id -- ASSET_LESSEE_CONTRACT_IDENTIFY表ID
            ,area -- 面积
            ,termin_fine -- 终止罚金
            ,buy_right_price -- 购买行权价
            ,recovery_cost -- 预计复原成本
            ,residual_value -- 剩余价值担保金额
            ,urge_measure_amount -- 激励措施金
            ,invoice_type -- 发票类型
            ,rent_pay_amt -- 应付租赁款
            ,lease_usage -- 租赁用途
            ,pay_type -- 支付方式
            ,deduction_flag -- 是否可抵扣
            ,i16_begin_date -- 准则起始日
            ,lessee_prepay_amount -- 预付待摊余额
            ,company_code -- 公司Code
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 承租资产ID
    ,o.asset_id -- 资产ID
    ,o.line_num -- 行号
    ,o.contract_id -- 承租合同ID
    ,o.contract_code -- 合同编号
    ,o.contract_name -- 合同名称
    ,o.contract_effect_date -- 合同生效日
    ,o.lessor -- 出租方
    ,o.operate_type -- 操作类型
    ,o.book_code -- 账簿代码
    ,o.asset_number -- 资产编号
    ,o.tag_number -- 资产标签号
    ,o.asset_type -- 资产类型
    ,o.asset_name -- 资产名称
    ,o.asset_category_id -- 资产类别ID
    ,o.company_id -- 使用机构
    ,o.department_id -- 使用部门
    ,o.quantity -- 数量
    ,o.lessee_status -- 状态
    ,o.account_status -- 凭证状态
    ,o.prepayment_amount -- 预付账款（不含税）
    ,o.other_direct_cost -- 其他直接费用（不含税）
    ,o.lease_liability_pay_amt_tax -- 租赁负债-应付租赁款（含税）
    ,o.lease_liability_pay_amt -- 租赁负债-应付租赁款（不含税）
    ,o.lease_liability_bal -- 租赁负债
    ,o.lease_liability_int_bal -- 租赁负债-未确认融资费用
    ,o.asset_amount -- 使用权资产-原值
    ,o.deducted_tax -- 其他待抵扣进项税额
    ,o.lease_begin_date -- 租赁开始日
    ,o.lease_end_date -- 租赁到期日
    ,o.lease_life_month -- 租赁期限（月）
    ,o.amount_tax -- 税额
    ,o.amount_no_tax -- 计划付款总额（不含税）
    ,o.amount_with_tax -- 计划付款总额（含税）
    ,o.discount_rule_code -- 折现规则代码
    ,o.year_discount_rate -- 折现率（年）
    ,o.day_discount_rate -- 折现率（日）
    ,o.date_effective -- 有效日期（记账日期）
    ,o.date_ineffective -- 失效日期
    ,o.transaction_header_id_in -- 事物处理生效头ID
    ,o.transaction_header_id_out -- 事物处理失效头ID
    ,o.tenant_id -- 租户ID
    ,o.created_by -- 创建人
    ,o.created_date -- 创建时间
    ,o.last_updated_by -- 最后更新人
    ,o.last_updated_date -- 最后更新时间
    ,o.version_number -- 版本号
    ,o.memo -- 备注说明
    ,o.deposit_amount -- 押金
    ,o.lessee_scope -- 租赁范围
    ,o.monthly_rent_amt -- 月租金（含税）
    ,o.tax_rate -- 税率（%）
    ,o.pay_frequency -- 付款频率
    ,o.plan_payment_date -- 首期计划付款日
    ,o.fund_growth_rate -- 资金增长率
    ,o.fund_growth_date -- 资金增长率起始日
    ,o.create_mode -- 创建方式
    ,o.attachment_oid -- 附件oid
    ,o.lease_id -- ASSET_LESSEE_CONTRACT_IDENTIFY表ID
    ,o.area -- 面积
    ,o.termin_fine -- 终止罚金
    ,o.buy_right_price -- 购买行权价
    ,o.recovery_cost -- 预计复原成本
    ,o.residual_value -- 剩余价值担保金额
    ,o.urge_measure_amount -- 激励措施金
    ,o.invoice_type -- 发票类型
    ,o.rent_pay_amt -- 应付租赁款
    ,o.lease_usage -- 租赁用途
    ,o.pay_type -- 支付方式
    ,o.deduction_flag -- 是否可抵扣
    ,o.i16_begin_date -- 准则起始日
    ,o.lessee_prepay_amount -- 预付待摊余额
    ,o.company_code -- 公司Code
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
from ${iol_schema}.lmis_asset_lessee_info_bk o
    left join ${iol_schema}.lmis_asset_lessee_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.lmis_asset_lessee_info_cl d
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
--truncate table ${iol_schema}.lmis_asset_lessee_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('lmis_asset_lessee_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.lmis_asset_lessee_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.lmis_asset_lessee_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.lmis_asset_lessee_info exchange partition p_${batch_date} with table ${iol_schema}.lmis_asset_lessee_info_cl;
alter table ${iol_schema}.lmis_asset_lessee_info exchange partition p_20991231 with table ${iol_schema}.lmis_asset_lessee_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.lmis_asset_lessee_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.lmis_asset_lessee_info_op purge;
drop table ${iol_schema}.lmis_asset_lessee_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.lmis_asset_lessee_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'lmis_asset_lessee_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
