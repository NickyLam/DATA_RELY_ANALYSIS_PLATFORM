/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_acct_attach
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
create table ${iol_schema}.ncbs_rb_acct_attach_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_acct_attach
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_acct_attach_op purge;
drop table ${iol_schema}.ncbs_rb_acct_attach_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_attach_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_acct_attach where 0=1;

create table ${iol_schema}.ncbs_rb_acct_attach_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_acct_attach where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_acct_attach_cl(
            internal_key -- 账户内部键值
            ,gl_code -- 科目代码
            ,acct_proof_status -- 账户验证状态
            ,acct_proof_reason -- 验证失败原因
            ,acct_property -- 外汇账户性质
            ,bal_chg_ind -- 余额联动变动标识
            ,bal_upd_type -- 余额更新类型
            ,balance_way -- 余额方向
            ,od_facility -- 是否可透支
            ,cycle_int_flag -- 按频率付息标志
            ,auto_settle_flag -- 自动结清标志
            ,auto_dep -- 是否自动续存
            ,manual_account_flag -- 是否允许手工记账标识
            ,fta_acct_flag -- 是否自贸区账户标识
            ,fta_code -- 自贸区代码
            ,contra_base_acct_no -- 交易对手账号
            ,contra_acct_name -- 对手账号名称
            ,contra_branch -- 对手账户开户行
            ,contra_branch_name -- 对手账户开户行名称
            ,hang_write_off_flag -- 挂销账标志
            ,hang_term -- 挂账期限
            ,write_off_way -- 销账方式
            ,agreement_status -- 协议状态
            ,prod_class -- 产品分类
            ,special_prod_class -- 签约产品分类
            ,stage_code -- 期次代码
            ,annual_flag -- 证件年检标志
            ,annual_status -- 年检通过状态
            ,last_reset_date -- 上一年检重置日期
            ,last_stop_date -- 上一年检截止日期
            ,blacklist_status -- 黑名单状态
            ,last_blacklist_date -- 最后黑名单日期
            ,free_sum -- 手续费免费次数
            ,impound_fad -- 强制扣划导致违约状态
            ,msg_status -- 短信签约状态
            ,client_no -- 客户编号
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,auto_renew_term -- 账户转存期限
            ,auto_renew_term_type -- 账户转存存期类型
            ,total_draw_amt -- 累计可支取本金金额
            ,allow_suspend_flag -- 是否允许账户转久悬
            ,all_dra_int_branch -- 通兑机构
            ,deposit_nature -- 核心存款性质
            ,acct_verify_status -- 账户核实状态
            ,is_sell_cheque -- 是否允许出售支票标识
            ,acct_verify_status_prev -- 账户上一核实状态
            ,private_acct_flag -- 隐私账户标志
            ,case_involved_date -- 客户涉案日期
            ,case_involved_reason -- 客户涉案原因
            ,treatment -- 处理种类
            ,agreement_id -- 协议编号
            ,approval_no -- 审批单号
            ,contra_client_no -- 对方客户号
            ,contra_area_code -- 对手行开立机构所属区域代码
            ,contra_country -- 交易对手行所属国家/地区
            ,swift_id -- 银行国际代码
            ,counter_dep_flag -- 是否允许柜面跨行存入许可标识
            ,counter_debt_flag -- 是否允许柜面跨行支取许可标识
            ,pre_debt_date -- 定期提前支取日期
            ,online_flag -- 是否联机
            ,check_certificate_amt -- 查证金额
            ,manage_flag -- 监管标志
            ,check_certificate_type -- 查证类型
            ,manage_content -- 监管内容
            ,agreement_deposit_type -- 协议存款类型
            ,next_dep_day -- 下一续存日
            ,acct_open_mode -- 开户模式
            ,manage_type -- 监管类型
            ,back_to_date -- 转回日期
            ,amount_nature -- 资金性质
            ,int_tax_levy -- 利息税征收标志
            ,re_open_date -- 销户重开日期和时间
            ,acct_open_type -- 开户方式
            ,contra_acct_open_date -- 对手账户开户日期
            ,first_draw_date -- 最早可支取日
            ,tax_rate -- 税率
            ,acct_channel_flag -- 账户渠道标识
            ,fast_open_acct_flag -- 是否一键开户标识
            ,acct_property2 -- 账户性质2
            ,case_involved_flag -- 涉案标识及暂停非柜原因
            ,delay_pay_int -- 延期付息标志
            ,spec_day -- 指定日
            ,tax_discount_maturity_date -- 优惠利息税率到期日
            ,both_limit_flag -- 双边限额限制标识
            ,fund_from_acct_no -- 资金来源账号
            ,fund_from_acct_seq_no -- 资金来源账户子序号
            ,is_effect_document -- 是否有有效身份证件
            ,dc_prod_change_flag -- 大额存单产品变更标志|是否为大额存单产品变更的账户
            ,pcp_delay_int_flag -- 兴惠存标识|是否签约集团资金池或延期付息
            ,open_acct_prov -- 开户省份|开户省份(用于二三类开户使用)
            ,open_acct_city -- 开户城市|开户城市(用于二三类开户使用)
            ,off_site_sign -- 本异地标识|用于二三类户开户1-异地,0-本地
            ,fix_rate_period_freq -- 固定利率周期|固定利率周期
            ,book_settele_date -- 预约结清日
            ,apply_debt_date -- 预约支取日期
            ,apply_debt_flag -- 是否预约支取
            ,allow_print_certificate_flag -- 打印证实书标志
            ,cash_manage_product -- 是否现金管理类产品
            ,int_rate_form_no -- 利率审批单单号
            ,manage_start_date -- 监管标识设置日期
            ,manage_end_date -- 取消监管标识日期
            ,bal_int_split -- 本息分离标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_acct_attach_op(
            internal_key -- 账户内部键值
            ,gl_code -- 科目代码
            ,acct_proof_status -- 账户验证状态
            ,acct_proof_reason -- 验证失败原因
            ,acct_property -- 外汇账户性质
            ,bal_chg_ind -- 余额联动变动标识
            ,bal_upd_type -- 余额更新类型
            ,balance_way -- 余额方向
            ,od_facility -- 是否可透支
            ,cycle_int_flag -- 按频率付息标志
            ,auto_settle_flag -- 自动结清标志
            ,auto_dep -- 是否自动续存
            ,manual_account_flag -- 是否允许手工记账标识
            ,fta_acct_flag -- 是否自贸区账户标识
            ,fta_code -- 自贸区代码
            ,contra_base_acct_no -- 交易对手账号
            ,contra_acct_name -- 对手账号名称
            ,contra_branch -- 对手账户开户行
            ,contra_branch_name -- 对手账户开户行名称
            ,hang_write_off_flag -- 挂销账标志
            ,hang_term -- 挂账期限
            ,write_off_way -- 销账方式
            ,agreement_status -- 协议状态
            ,prod_class -- 产品分类
            ,special_prod_class -- 签约产品分类
            ,stage_code -- 期次代码
            ,annual_flag -- 证件年检标志
            ,annual_status -- 年检通过状态
            ,last_reset_date -- 上一年检重置日期
            ,last_stop_date -- 上一年检截止日期
            ,blacklist_status -- 黑名单状态
            ,last_blacklist_date -- 最后黑名单日期
            ,free_sum -- 手续费免费次数
            ,impound_fad -- 强制扣划导致违约状态
            ,msg_status -- 短信签约状态
            ,client_no -- 客户编号
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,auto_renew_term -- 账户转存期限
            ,auto_renew_term_type -- 账户转存存期类型
            ,total_draw_amt -- 累计可支取本金金额
            ,allow_suspend_flag -- 是否允许账户转久悬
            ,all_dra_int_branch -- 通兑机构
            ,deposit_nature -- 核心存款性质
            ,acct_verify_status -- 账户核实状态
            ,is_sell_cheque -- 是否允许出售支票标识
            ,acct_verify_status_prev -- 账户上一核实状态
            ,private_acct_flag -- 隐私账户标志
            ,case_involved_date -- 客户涉案日期
            ,case_involved_reason -- 客户涉案原因
            ,treatment -- 处理种类
            ,agreement_id -- 协议编号
            ,approval_no -- 审批单号
            ,contra_client_no -- 对方客户号
            ,contra_area_code -- 对手行开立机构所属区域代码
            ,contra_country -- 交易对手行所属国家/地区
            ,swift_id -- 银行国际代码
            ,counter_dep_flag -- 是否允许柜面跨行存入许可标识
            ,counter_debt_flag -- 是否允许柜面跨行支取许可标识
            ,pre_debt_date -- 定期提前支取日期
            ,online_flag -- 是否联机
            ,check_certificate_amt -- 查证金额
            ,manage_flag -- 监管标志
            ,check_certificate_type -- 查证类型
            ,manage_content -- 监管内容
            ,agreement_deposit_type -- 协议存款类型
            ,next_dep_day -- 下一续存日
            ,acct_open_mode -- 开户模式
            ,manage_type -- 监管类型
            ,back_to_date -- 转回日期
            ,amount_nature -- 资金性质
            ,int_tax_levy -- 利息税征收标志
            ,re_open_date -- 销户重开日期和时间
            ,acct_open_type -- 开户方式
            ,contra_acct_open_date -- 对手账户开户日期
            ,first_draw_date -- 最早可支取日
            ,tax_rate -- 税率
            ,acct_channel_flag -- 账户渠道标识
            ,fast_open_acct_flag -- 是否一键开户标识
            ,acct_property2 -- 账户性质2
            ,case_involved_flag -- 涉案标识及暂停非柜原因
            ,delay_pay_int -- 延期付息标志
            ,spec_day -- 指定日
            ,tax_discount_maturity_date -- 优惠利息税率到期日
            ,both_limit_flag -- 双边限额限制标识
            ,fund_from_acct_no -- 资金来源账号
            ,fund_from_acct_seq_no -- 资金来源账户子序号
            ,is_effect_document -- 是否有有效身份证件
            ,dc_prod_change_flag -- 大额存单产品变更标志|是否为大额存单产品变更的账户
            ,pcp_delay_int_flag -- 兴惠存标识|是否签约集团资金池或延期付息
            ,open_acct_prov -- 开户省份|开户省份(用于二三类开户使用)
            ,open_acct_city -- 开户城市|开户城市(用于二三类开户使用)
            ,off_site_sign -- 本异地标识|用于二三类户开户1-异地,0-本地
            ,fix_rate_period_freq -- 固定利率周期|固定利率周期
            ,book_settele_date -- 预约结清日
            ,apply_debt_date -- 预约支取日期
            ,apply_debt_flag -- 是否预约支取
            ,allow_print_certificate_flag -- 打印证实书标志
            ,cash_manage_product -- 是否现金管理类产品
            ,int_rate_form_no -- 利率审批单单号
            ,manage_start_date -- 监管标识设置日期
            ,manage_end_date -- 取消监管标识日期
            ,bal_int_split -- 本息分离标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.gl_code, o.gl_code) as gl_code -- 科目代码
    ,nvl(n.acct_proof_status, o.acct_proof_status) as acct_proof_status -- 账户验证状态
    ,nvl(n.acct_proof_reason, o.acct_proof_reason) as acct_proof_reason -- 验证失败原因
    ,nvl(n.acct_property, o.acct_property) as acct_property -- 外汇账户性质
    ,nvl(n.bal_chg_ind, o.bal_chg_ind) as bal_chg_ind -- 余额联动变动标识
    ,nvl(n.bal_upd_type, o.bal_upd_type) as bal_upd_type -- 余额更新类型
    ,nvl(n.balance_way, o.balance_way) as balance_way -- 余额方向
    ,nvl(n.od_facility, o.od_facility) as od_facility -- 是否可透支
    ,nvl(n.cycle_int_flag, o.cycle_int_flag) as cycle_int_flag -- 按频率付息标志
    ,nvl(n.auto_settle_flag, o.auto_settle_flag) as auto_settle_flag -- 自动结清标志
    ,nvl(n.auto_dep, o.auto_dep) as auto_dep -- 是否自动续存
    ,nvl(n.manual_account_flag, o.manual_account_flag) as manual_account_flag -- 是否允许手工记账标识
    ,nvl(n.fta_acct_flag, o.fta_acct_flag) as fta_acct_flag -- 是否自贸区账户标识
    ,nvl(n.fta_code, o.fta_code) as fta_code -- 自贸区代码
    ,nvl(n.contra_base_acct_no, o.contra_base_acct_no) as contra_base_acct_no -- 交易对手账号
    ,nvl(n.contra_acct_name, o.contra_acct_name) as contra_acct_name -- 对手账号名称
    ,nvl(n.contra_branch, o.contra_branch) as contra_branch -- 对手账户开户行
    ,nvl(n.contra_branch_name, o.contra_branch_name) as contra_branch_name -- 对手账户开户行名称
    ,nvl(n.hang_write_off_flag, o.hang_write_off_flag) as hang_write_off_flag -- 挂销账标志
    ,nvl(n.hang_term, o.hang_term) as hang_term -- 挂账期限
    ,nvl(n.write_off_way, o.write_off_way) as write_off_way -- 销账方式
    ,nvl(n.agreement_status, o.agreement_status) as agreement_status -- 协议状态
    ,nvl(n.prod_class, o.prod_class) as prod_class -- 产品分类
    ,nvl(n.special_prod_class, o.special_prod_class) as special_prod_class -- 签约产品分类
    ,nvl(n.stage_code, o.stage_code) as stage_code -- 期次代码
    ,nvl(n.annual_flag, o.annual_flag) as annual_flag -- 证件年检标志
    ,nvl(n.annual_status, o.annual_status) as annual_status -- 年检通过状态
    ,nvl(n.last_reset_date, o.last_reset_date) as last_reset_date -- 上一年检重置日期
    ,nvl(n.last_stop_date, o.last_stop_date) as last_stop_date -- 上一年检截止日期
    ,nvl(n.blacklist_status, o.blacklist_status) as blacklist_status -- 黑名单状态
    ,nvl(n.last_blacklist_date, o.last_blacklist_date) as last_blacklist_date -- 最后黑名单日期
    ,nvl(n.free_sum, o.free_sum) as free_sum -- 手续费免费次数
    ,nvl(n.impound_fad, o.impound_fad) as impound_fad -- 强制扣划导致违约状态
    ,nvl(n.msg_status, o.msg_status) as msg_status -- 短信签约状态
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.auto_renew_term, o.auto_renew_term) as auto_renew_term -- 账户转存期限
    ,nvl(n.auto_renew_term_type, o.auto_renew_term_type) as auto_renew_term_type -- 账户转存存期类型
    ,nvl(n.total_draw_amt, o.total_draw_amt) as total_draw_amt -- 累计可支取本金金额
    ,nvl(n.allow_suspend_flag, o.allow_suspend_flag) as allow_suspend_flag -- 是否允许账户转久悬
    ,nvl(n.all_dra_int_branch, o.all_dra_int_branch) as all_dra_int_branch -- 通兑机构
    ,nvl(n.deposit_nature, o.deposit_nature) as deposit_nature -- 核心存款性质
    ,nvl(n.acct_verify_status, o.acct_verify_status) as acct_verify_status -- 账户核实状态
    ,nvl(n.is_sell_cheque, o.is_sell_cheque) as is_sell_cheque -- 是否允许出售支票标识
    ,nvl(n.acct_verify_status_prev, o.acct_verify_status_prev) as acct_verify_status_prev -- 账户上一核实状态
    ,nvl(n.private_acct_flag, o.private_acct_flag) as private_acct_flag -- 隐私账户标志
    ,nvl(n.case_involved_date, o.case_involved_date) as case_involved_date -- 客户涉案日期
    ,nvl(n.case_involved_reason, o.case_involved_reason) as case_involved_reason -- 客户涉案原因
    ,nvl(n.treatment, o.treatment) as treatment -- 处理种类
    ,nvl(n.agreement_id, o.agreement_id) as agreement_id -- 协议编号
    ,nvl(n.approval_no, o.approval_no) as approval_no -- 审批单号
    ,nvl(n.contra_client_no, o.contra_client_no) as contra_client_no -- 对方客户号
    ,nvl(n.contra_area_code, o.contra_area_code) as contra_area_code -- 对手行开立机构所属区域代码
    ,nvl(n.contra_country, o.contra_country) as contra_country -- 交易对手行所属国家/地区
    ,nvl(n.swift_id, o.swift_id) as swift_id -- 银行国际代码
    ,nvl(n.counter_dep_flag, o.counter_dep_flag) as counter_dep_flag -- 是否允许柜面跨行存入许可标识
    ,nvl(n.counter_debt_flag, o.counter_debt_flag) as counter_debt_flag -- 是否允许柜面跨行支取许可标识
    ,nvl(n.pre_debt_date, o.pre_debt_date) as pre_debt_date -- 定期提前支取日期
    ,nvl(n.online_flag, o.online_flag) as online_flag -- 是否联机
    ,nvl(n.check_certificate_amt, o.check_certificate_amt) as check_certificate_amt -- 查证金额
    ,nvl(n.manage_flag, o.manage_flag) as manage_flag -- 监管标志
    ,nvl(n.check_certificate_type, o.check_certificate_type) as check_certificate_type -- 查证类型
    ,nvl(n.manage_content, o.manage_content) as manage_content -- 监管内容
    ,nvl(n.agreement_deposit_type, o.agreement_deposit_type) as agreement_deposit_type -- 协议存款类型
    ,nvl(n.next_dep_day, o.next_dep_day) as next_dep_day -- 下一续存日
    ,nvl(n.acct_open_mode, o.acct_open_mode) as acct_open_mode -- 开户模式
    ,nvl(n.manage_type, o.manage_type) as manage_type -- 监管类型
    ,nvl(n.back_to_date, o.back_to_date) as back_to_date -- 转回日期
    ,nvl(n.amount_nature, o.amount_nature) as amount_nature -- 资金性质
    ,nvl(n.int_tax_levy, o.int_tax_levy) as int_tax_levy -- 利息税征收标志
    ,nvl(n.re_open_date, o.re_open_date) as re_open_date -- 销户重开日期和时间
    ,nvl(n.acct_open_type, o.acct_open_type) as acct_open_type -- 开户方式
    ,nvl(n.contra_acct_open_date, o.contra_acct_open_date) as contra_acct_open_date -- 对手账户开户日期
    ,nvl(n.first_draw_date, o.first_draw_date) as first_draw_date -- 最早可支取日
    ,nvl(n.tax_rate, o.tax_rate) as tax_rate -- 税率
    ,nvl(n.acct_channel_flag, o.acct_channel_flag) as acct_channel_flag -- 账户渠道标识
    ,nvl(n.fast_open_acct_flag, o.fast_open_acct_flag) as fast_open_acct_flag -- 是否一键开户标识
    ,nvl(n.acct_property2, o.acct_property2) as acct_property2 -- 账户性质2
    ,nvl(n.case_involved_flag, o.case_involved_flag) as case_involved_flag -- 涉案标识及暂停非柜原因
    ,nvl(n.delay_pay_int, o.delay_pay_int) as delay_pay_int -- 延期付息标志
    ,nvl(n.spec_day, o.spec_day) as spec_day -- 指定日
    ,nvl(n.tax_discount_maturity_date, o.tax_discount_maturity_date) as tax_discount_maturity_date -- 优惠利息税率到期日
    ,nvl(n.both_limit_flag, o.both_limit_flag) as both_limit_flag -- 双边限额限制标识
    ,nvl(n.fund_from_acct_no, o.fund_from_acct_no) as fund_from_acct_no -- 资金来源账号
    ,nvl(n.fund_from_acct_seq_no, o.fund_from_acct_seq_no) as fund_from_acct_seq_no -- 资金来源账户子序号
    ,nvl(n.is_effect_document, o.is_effect_document) as is_effect_document -- 是否有有效身份证件
    ,nvl(n.dc_prod_change_flag, o.dc_prod_change_flag) as dc_prod_change_flag -- 大额存单产品变更标志|是否为大额存单产品变更的账户
    ,nvl(n.pcp_delay_int_flag, o.pcp_delay_int_flag) as pcp_delay_int_flag -- 兴惠存标识|是否签约集团资金池或延期付息
    ,nvl(n.open_acct_prov, o.open_acct_prov) as open_acct_prov -- 开户省份|开户省份(用于二三类开户使用)
    ,nvl(n.open_acct_city, o.open_acct_city) as open_acct_city -- 开户城市|开户城市(用于二三类开户使用)
    ,nvl(n.off_site_sign, o.off_site_sign) as off_site_sign -- 本异地标识|用于二三类户开户1-异地,0-本地
    ,nvl(n.fix_rate_period_freq, o.fix_rate_period_freq) as fix_rate_period_freq -- 固定利率周期|固定利率周期
    ,nvl(n.book_settele_date, o.book_settele_date) as book_settele_date -- 预约结清日
    ,nvl(n.apply_debt_date, o.apply_debt_date) as apply_debt_date -- 预约支取日期
    ,nvl(n.apply_debt_flag, o.apply_debt_flag) as apply_debt_flag -- 是否预约支取
    ,nvl(n.allow_print_certificate_flag, o.allow_print_certificate_flag) as allow_print_certificate_flag -- 打印证实书标志
    ,nvl(n.cash_manage_product, o.cash_manage_product) as cash_manage_product -- 是否现金管理类产品
    ,nvl(n.int_rate_form_no, o.int_rate_form_no) as int_rate_form_no -- 利率审批单单号
    ,nvl(n.manage_start_date, o.manage_start_date) as manage_start_date -- 监管标识设置日期
    ,nvl(n.manage_end_date, o.manage_end_date) as manage_end_date -- 取消监管标识日期
    ,nvl(n.bal_int_split, o.bal_int_split) as bal_int_split -- 本息分离标志
    ,case when
            n.internal_key is null
            and n.client_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internal_key is null
            and n.client_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internal_key is null
            and n.client_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_acct_attach_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_acct_attach where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
            and o.client_no = n.client_no
where (
        o.internal_key is null
        and o.client_no is null
    )
    or (
        n.internal_key is null
        and n.client_no is null
    )
    or (
        o.gl_code <> n.gl_code
        or o.acct_proof_status <> n.acct_proof_status
        or o.acct_proof_reason <> n.acct_proof_reason
        or o.acct_property <> n.acct_property
        or o.bal_chg_ind <> n.bal_chg_ind
        or o.bal_upd_type <> n.bal_upd_type
        or o.balance_way <> n.balance_way
        or o.od_facility <> n.od_facility
        or o.cycle_int_flag <> n.cycle_int_flag
        or o.auto_settle_flag <> n.auto_settle_flag
        or o.auto_dep <> n.auto_dep
        or o.manual_account_flag <> n.manual_account_flag
        or o.fta_acct_flag <> n.fta_acct_flag
        or o.fta_code <> n.fta_code
        or o.contra_base_acct_no <> n.contra_base_acct_no
        or o.contra_acct_name <> n.contra_acct_name
        or o.contra_branch <> n.contra_branch
        or o.contra_branch_name <> n.contra_branch_name
        or o.hang_write_off_flag <> n.hang_write_off_flag
        or o.hang_term <> n.hang_term
        or o.write_off_way <> n.write_off_way
        or o.agreement_status <> n.agreement_status
        or o.prod_class <> n.prod_class
        or o.special_prod_class <> n.special_prod_class
        or o.stage_code <> n.stage_code
        or o.annual_flag <> n.annual_flag
        or o.annual_status <> n.annual_status
        or o.last_reset_date <> n.last_reset_date
        or o.last_stop_date <> n.last_stop_date
        or o.blacklist_status <> n.blacklist_status
        or o.last_blacklist_date <> n.last_blacklist_date
        or o.free_sum <> n.free_sum
        or o.impound_fad <> n.impound_fad
        or o.msg_status <> n.msg_status
        or o.tran_timestamp <> n.tran_timestamp
        or o.company <> n.company
        or o.auto_renew_term <> n.auto_renew_term
        or o.auto_renew_term_type <> n.auto_renew_term_type
        or o.total_draw_amt <> n.total_draw_amt
        or o.allow_suspend_flag <> n.allow_suspend_flag
        or o.all_dra_int_branch <> n.all_dra_int_branch
        or o.deposit_nature <> n.deposit_nature
        or o.acct_verify_status <> n.acct_verify_status
        or o.is_sell_cheque <> n.is_sell_cheque
        or o.acct_verify_status_prev <> n.acct_verify_status_prev
        or o.private_acct_flag <> n.private_acct_flag
        or o.case_involved_date <> n.case_involved_date
        or o.case_involved_reason <> n.case_involved_reason
        or o.treatment <> n.treatment
        or o.agreement_id <> n.agreement_id
        or o.approval_no <> n.approval_no
        or o.contra_client_no <> n.contra_client_no
        or o.contra_area_code <> n.contra_area_code
        or o.contra_country <> n.contra_country
        or o.swift_id <> n.swift_id
        or o.counter_dep_flag <> n.counter_dep_flag
        or o.counter_debt_flag <> n.counter_debt_flag
        or o.pre_debt_date <> n.pre_debt_date
        or o.online_flag <> n.online_flag
        or o.check_certificate_amt <> n.check_certificate_amt
        or o.manage_flag <> n.manage_flag
        or o.check_certificate_type <> n.check_certificate_type
        or o.manage_content <> n.manage_content
        or o.agreement_deposit_type <> n.agreement_deposit_type
        or o.next_dep_day <> n.next_dep_day
        or o.acct_open_mode <> n.acct_open_mode
        or o.manage_type <> n.manage_type
        or o.back_to_date <> n.back_to_date
        or o.amount_nature <> n.amount_nature
        or o.int_tax_levy <> n.int_tax_levy
        or o.re_open_date <> n.re_open_date
        or o.acct_open_type <> n.acct_open_type
        or o.contra_acct_open_date <> n.contra_acct_open_date
        or o.first_draw_date <> n.first_draw_date
        or o.tax_rate <> n.tax_rate
        or o.acct_channel_flag <> n.acct_channel_flag
        or o.fast_open_acct_flag <> n.fast_open_acct_flag
        or o.acct_property2 <> n.acct_property2
        or o.case_involved_flag <> n.case_involved_flag
        or o.delay_pay_int <> n.delay_pay_int
        or o.spec_day <> n.spec_day
        or o.tax_discount_maturity_date <> n.tax_discount_maturity_date
        or o.both_limit_flag <> n.both_limit_flag
        or o.fund_from_acct_no <> n.fund_from_acct_no
        or o.fund_from_acct_seq_no <> n.fund_from_acct_seq_no
        or o.is_effect_document <> n.is_effect_document
        or o.dc_prod_change_flag <> n.dc_prod_change_flag
        or o.pcp_delay_int_flag <> n.pcp_delay_int_flag
        or o.open_acct_prov <> n.open_acct_prov
        or o.open_acct_city <> n.open_acct_city
        or o.off_site_sign <> n.off_site_sign
        or o.fix_rate_period_freq <> n.fix_rate_period_freq
        or o.book_settele_date <> n.book_settele_date
        or o.apply_debt_date <> n.apply_debt_date
        or o.apply_debt_flag <> n.apply_debt_flag
        or o.allow_print_certificate_flag <> n.allow_print_certificate_flag
        or o.cash_manage_product <> n.cash_manage_product
        or o.int_rate_form_no <> n.int_rate_form_no
        or o.manage_start_date <> n.manage_start_date
        or o.manage_end_date <> n.manage_end_date
        or o.bal_int_split <> n.bal_int_split
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_acct_attach_cl(
            internal_key -- 账户内部键值
            ,gl_code -- 科目代码
            ,acct_proof_status -- 账户验证状态
            ,acct_proof_reason -- 验证失败原因
            ,acct_property -- 外汇账户性质
            ,bal_chg_ind -- 余额联动变动标识
            ,bal_upd_type -- 余额更新类型
            ,balance_way -- 余额方向
            ,od_facility -- 是否可透支
            ,cycle_int_flag -- 按频率付息标志
            ,auto_settle_flag -- 自动结清标志
            ,auto_dep -- 是否自动续存
            ,manual_account_flag -- 是否允许手工记账标识
            ,fta_acct_flag -- 是否自贸区账户标识
            ,fta_code -- 自贸区代码
            ,contra_base_acct_no -- 交易对手账号
            ,contra_acct_name -- 对手账号名称
            ,contra_branch -- 对手账户开户行
            ,contra_branch_name -- 对手账户开户行名称
            ,hang_write_off_flag -- 挂销账标志
            ,hang_term -- 挂账期限
            ,write_off_way -- 销账方式
            ,agreement_status -- 协议状态
            ,prod_class -- 产品分类
            ,special_prod_class -- 签约产品分类
            ,stage_code -- 期次代码
            ,annual_flag -- 证件年检标志
            ,annual_status -- 年检通过状态
            ,last_reset_date -- 上一年检重置日期
            ,last_stop_date -- 上一年检截止日期
            ,blacklist_status -- 黑名单状态
            ,last_blacklist_date -- 最后黑名单日期
            ,free_sum -- 手续费免费次数
            ,impound_fad -- 强制扣划导致违约状态
            ,msg_status -- 短信签约状态
            ,client_no -- 客户编号
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,auto_renew_term -- 账户转存期限
            ,auto_renew_term_type -- 账户转存存期类型
            ,total_draw_amt -- 累计可支取本金金额
            ,allow_suspend_flag -- 是否允许账户转久悬
            ,all_dra_int_branch -- 通兑机构
            ,deposit_nature -- 核心存款性质
            ,acct_verify_status -- 账户核实状态
            ,is_sell_cheque -- 是否允许出售支票标识
            ,acct_verify_status_prev -- 账户上一核实状态
            ,private_acct_flag -- 隐私账户标志
            ,case_involved_date -- 客户涉案日期
            ,case_involved_reason -- 客户涉案原因
            ,treatment -- 处理种类
            ,agreement_id -- 协议编号
            ,approval_no -- 审批单号
            ,contra_client_no -- 对方客户号
            ,contra_area_code -- 对手行开立机构所属区域代码
            ,contra_country -- 交易对手行所属国家/地区
            ,swift_id -- 银行国际代码
            ,counter_dep_flag -- 是否允许柜面跨行存入许可标识
            ,counter_debt_flag -- 是否允许柜面跨行支取许可标识
            ,pre_debt_date -- 定期提前支取日期
            ,online_flag -- 是否联机
            ,check_certificate_amt -- 查证金额
            ,manage_flag -- 监管标志
            ,check_certificate_type -- 查证类型
            ,manage_content -- 监管内容
            ,agreement_deposit_type -- 协议存款类型
            ,next_dep_day -- 下一续存日
            ,acct_open_mode -- 开户模式
            ,manage_type -- 监管类型
            ,back_to_date -- 转回日期
            ,amount_nature -- 资金性质
            ,int_tax_levy -- 利息税征收标志
            ,re_open_date -- 销户重开日期和时间
            ,acct_open_type -- 开户方式
            ,contra_acct_open_date -- 对手账户开户日期
            ,first_draw_date -- 最早可支取日
            ,tax_rate -- 税率
            ,acct_channel_flag -- 账户渠道标识
            ,fast_open_acct_flag -- 是否一键开户标识
            ,acct_property2 -- 账户性质2
            ,case_involved_flag -- 涉案标识及暂停非柜原因
            ,delay_pay_int -- 延期付息标志
            ,spec_day -- 指定日
            ,tax_discount_maturity_date -- 优惠利息税率到期日
            ,both_limit_flag -- 双边限额限制标识
            ,fund_from_acct_no -- 资金来源账号
            ,fund_from_acct_seq_no -- 资金来源账户子序号
            ,is_effect_document -- 是否有有效身份证件
            ,dc_prod_change_flag -- 大额存单产品变更标志|是否为大额存单产品变更的账户
            ,pcp_delay_int_flag -- 兴惠存标识|是否签约集团资金池或延期付息
            ,open_acct_prov -- 开户省份|开户省份(用于二三类开户使用)
            ,open_acct_city -- 开户城市|开户城市(用于二三类开户使用)
            ,off_site_sign -- 本异地标识|用于二三类户开户1-异地,0-本地
            ,fix_rate_period_freq -- 固定利率周期|固定利率周期
            ,book_settele_date -- 预约结清日
            ,apply_debt_date -- 预约支取日期
            ,apply_debt_flag -- 是否预约支取
            ,allow_print_certificate_flag -- 打印证实书标志
            ,cash_manage_product -- 是否现金管理类产品
            ,int_rate_form_no -- 利率审批单单号
            ,manage_start_date -- 监管标识设置日期
            ,manage_end_date -- 取消监管标识日期
            ,bal_int_split -- 本息分离标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_acct_attach_op(
            internal_key -- 账户内部键值
            ,gl_code -- 科目代码
            ,acct_proof_status -- 账户验证状态
            ,acct_proof_reason -- 验证失败原因
            ,acct_property -- 外汇账户性质
            ,bal_chg_ind -- 余额联动变动标识
            ,bal_upd_type -- 余额更新类型
            ,balance_way -- 余额方向
            ,od_facility -- 是否可透支
            ,cycle_int_flag -- 按频率付息标志
            ,auto_settle_flag -- 自动结清标志
            ,auto_dep -- 是否自动续存
            ,manual_account_flag -- 是否允许手工记账标识
            ,fta_acct_flag -- 是否自贸区账户标识
            ,fta_code -- 自贸区代码
            ,contra_base_acct_no -- 交易对手账号
            ,contra_acct_name -- 对手账号名称
            ,contra_branch -- 对手账户开户行
            ,contra_branch_name -- 对手账户开户行名称
            ,hang_write_off_flag -- 挂销账标志
            ,hang_term -- 挂账期限
            ,write_off_way -- 销账方式
            ,agreement_status -- 协议状态
            ,prod_class -- 产品分类
            ,special_prod_class -- 签约产品分类
            ,stage_code -- 期次代码
            ,annual_flag -- 证件年检标志
            ,annual_status -- 年检通过状态
            ,last_reset_date -- 上一年检重置日期
            ,last_stop_date -- 上一年检截止日期
            ,blacklist_status -- 黑名单状态
            ,last_blacklist_date -- 最后黑名单日期
            ,free_sum -- 手续费免费次数
            ,impound_fad -- 强制扣划导致违约状态
            ,msg_status -- 短信签约状态
            ,client_no -- 客户编号
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,auto_renew_term -- 账户转存期限
            ,auto_renew_term_type -- 账户转存存期类型
            ,total_draw_amt -- 累计可支取本金金额
            ,allow_suspend_flag -- 是否允许账户转久悬
            ,all_dra_int_branch -- 通兑机构
            ,deposit_nature -- 核心存款性质
            ,acct_verify_status -- 账户核实状态
            ,is_sell_cheque -- 是否允许出售支票标识
            ,acct_verify_status_prev -- 账户上一核实状态
            ,private_acct_flag -- 隐私账户标志
            ,case_involved_date -- 客户涉案日期
            ,case_involved_reason -- 客户涉案原因
            ,treatment -- 处理种类
            ,agreement_id -- 协议编号
            ,approval_no -- 审批单号
            ,contra_client_no -- 对方客户号
            ,contra_area_code -- 对手行开立机构所属区域代码
            ,contra_country -- 交易对手行所属国家/地区
            ,swift_id -- 银行国际代码
            ,counter_dep_flag -- 是否允许柜面跨行存入许可标识
            ,counter_debt_flag -- 是否允许柜面跨行支取许可标识
            ,pre_debt_date -- 定期提前支取日期
            ,online_flag -- 是否联机
            ,check_certificate_amt -- 查证金额
            ,manage_flag -- 监管标志
            ,check_certificate_type -- 查证类型
            ,manage_content -- 监管内容
            ,agreement_deposit_type -- 协议存款类型
            ,next_dep_day -- 下一续存日
            ,acct_open_mode -- 开户模式
            ,manage_type -- 监管类型
            ,back_to_date -- 转回日期
            ,amount_nature -- 资金性质
            ,int_tax_levy -- 利息税征收标志
            ,re_open_date -- 销户重开日期和时间
            ,acct_open_type -- 开户方式
            ,contra_acct_open_date -- 对手账户开户日期
            ,first_draw_date -- 最早可支取日
            ,tax_rate -- 税率
            ,acct_channel_flag -- 账户渠道标识
            ,fast_open_acct_flag -- 是否一键开户标识
            ,acct_property2 -- 账户性质2
            ,case_involved_flag -- 涉案标识及暂停非柜原因
            ,delay_pay_int -- 延期付息标志
            ,spec_day -- 指定日
            ,tax_discount_maturity_date -- 优惠利息税率到期日
            ,both_limit_flag -- 双边限额限制标识
            ,fund_from_acct_no -- 资金来源账号
            ,fund_from_acct_seq_no -- 资金来源账户子序号
            ,is_effect_document -- 是否有有效身份证件
            ,dc_prod_change_flag -- 大额存单产品变更标志|是否为大额存单产品变更的账户
            ,pcp_delay_int_flag -- 兴惠存标识|是否签约集团资金池或延期付息
            ,open_acct_prov -- 开户省份|开户省份(用于二三类开户使用)
            ,open_acct_city -- 开户城市|开户城市(用于二三类开户使用)
            ,off_site_sign -- 本异地标识|用于二三类户开户1-异地,0-本地
            ,fix_rate_period_freq -- 固定利率周期|固定利率周期
            ,book_settele_date -- 预约结清日
            ,apply_debt_date -- 预约支取日期
            ,apply_debt_flag -- 是否预约支取
            ,allow_print_certificate_flag -- 打印证实书标志
            ,cash_manage_product -- 是否现金管理类产品
            ,int_rate_form_no -- 利率审批单单号
            ,manage_start_date -- 监管标识设置日期
            ,manage_end_date -- 取消监管标识日期
            ,bal_int_split -- 本息分离标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.internal_key -- 账户内部键值
    ,o.gl_code -- 科目代码
    ,o.acct_proof_status -- 账户验证状态
    ,o.acct_proof_reason -- 验证失败原因
    ,o.acct_property -- 外汇账户性质
    ,o.bal_chg_ind -- 余额联动变动标识
    ,o.bal_upd_type -- 余额更新类型
    ,o.balance_way -- 余额方向
    ,o.od_facility -- 是否可透支
    ,o.cycle_int_flag -- 按频率付息标志
    ,o.auto_settle_flag -- 自动结清标志
    ,o.auto_dep -- 是否自动续存
    ,o.manual_account_flag -- 是否允许手工记账标识
    ,o.fta_acct_flag -- 是否自贸区账户标识
    ,o.fta_code -- 自贸区代码
    ,o.contra_base_acct_no -- 交易对手账号
    ,o.contra_acct_name -- 对手账号名称
    ,o.contra_branch -- 对手账户开户行
    ,o.contra_branch_name -- 对手账户开户行名称
    ,o.hang_write_off_flag -- 挂销账标志
    ,o.hang_term -- 挂账期限
    ,o.write_off_way -- 销账方式
    ,o.agreement_status -- 协议状态
    ,o.prod_class -- 产品分类
    ,o.special_prod_class -- 签约产品分类
    ,o.stage_code -- 期次代码
    ,o.annual_flag -- 证件年检标志
    ,o.annual_status -- 年检通过状态
    ,o.last_reset_date -- 上一年检重置日期
    ,o.last_stop_date -- 上一年检截止日期
    ,o.blacklist_status -- 黑名单状态
    ,o.last_blacklist_date -- 最后黑名单日期
    ,o.free_sum -- 手续费免费次数
    ,o.impound_fad -- 强制扣划导致违约状态
    ,o.msg_status -- 短信签约状态
    ,o.client_no -- 客户编号
    ,o.tran_timestamp -- 交易时间戳
    ,o.company -- 法人
    ,o.auto_renew_term -- 账户转存期限
    ,o.auto_renew_term_type -- 账户转存存期类型
    ,o.total_draw_amt -- 累计可支取本金金额
    ,o.allow_suspend_flag -- 是否允许账户转久悬
    ,o.all_dra_int_branch -- 通兑机构
    ,o.deposit_nature -- 核心存款性质
    ,o.acct_verify_status -- 账户核实状态
    ,o.is_sell_cheque -- 是否允许出售支票标识
    ,o.acct_verify_status_prev -- 账户上一核实状态
    ,o.private_acct_flag -- 隐私账户标志
    ,o.case_involved_date -- 客户涉案日期
    ,o.case_involved_reason -- 客户涉案原因
    ,o.treatment -- 处理种类
    ,o.agreement_id -- 协议编号
    ,o.approval_no -- 审批单号
    ,o.contra_client_no -- 对方客户号
    ,o.contra_area_code -- 对手行开立机构所属区域代码
    ,o.contra_country -- 交易对手行所属国家/地区
    ,o.swift_id -- 银行国际代码
    ,o.counter_dep_flag -- 是否允许柜面跨行存入许可标识
    ,o.counter_debt_flag -- 是否允许柜面跨行支取许可标识
    ,o.pre_debt_date -- 定期提前支取日期
    ,o.online_flag -- 是否联机
    ,o.check_certificate_amt -- 查证金额
    ,o.manage_flag -- 监管标志
    ,o.check_certificate_type -- 查证类型
    ,o.manage_content -- 监管内容
    ,o.agreement_deposit_type -- 协议存款类型
    ,o.next_dep_day -- 下一续存日
    ,o.acct_open_mode -- 开户模式
    ,o.manage_type -- 监管类型
    ,o.back_to_date -- 转回日期
    ,o.amount_nature -- 资金性质
    ,o.int_tax_levy -- 利息税征收标志
    ,o.re_open_date -- 销户重开日期和时间
    ,o.acct_open_type -- 开户方式
    ,o.contra_acct_open_date -- 对手账户开户日期
    ,o.first_draw_date -- 最早可支取日
    ,o.tax_rate -- 税率
    ,o.acct_channel_flag -- 账户渠道标识
    ,o.fast_open_acct_flag -- 是否一键开户标识
    ,o.acct_property2 -- 账户性质2
    ,o.case_involved_flag -- 涉案标识及暂停非柜原因
    ,o.delay_pay_int -- 延期付息标志
    ,o.spec_day -- 指定日
    ,o.tax_discount_maturity_date -- 优惠利息税率到期日
    ,o.both_limit_flag -- 双边限额限制标识
    ,o.fund_from_acct_no -- 资金来源账号
    ,o.fund_from_acct_seq_no -- 资金来源账户子序号
    ,o.is_effect_document -- 是否有有效身份证件
    ,o.dc_prod_change_flag -- 大额存单产品变更标志|是否为大额存单产品变更的账户
    ,o.pcp_delay_int_flag -- 兴惠存标识|是否签约集团资金池或延期付息
    ,o.open_acct_prov -- 开户省份|开户省份(用于二三类开户使用)
    ,o.open_acct_city -- 开户城市|开户城市(用于二三类开户使用)
    ,o.off_site_sign -- 本异地标识|用于二三类户开户1-异地,0-本地
    ,o.fix_rate_period_freq -- 固定利率周期|固定利率周期
    ,o.book_settele_date -- 预约结清日
    ,o.apply_debt_date -- 预约支取日期
    ,o.apply_debt_flag -- 是否预约支取
    ,o.allow_print_certificate_flag -- 打印证实书标志
    ,o.cash_manage_product -- 是否现金管理类产品
    ,o.int_rate_form_no -- 利率审批单单号
    ,o.manage_start_date -- 监管标识设置日期
    ,o.manage_end_date -- 取消监管标识日期
    ,o.bal_int_split -- 本息分离标志
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
from ${iol_schema}.ncbs_rb_acct_attach_bk o
    left join ${iol_schema}.ncbs_rb_acct_attach_op n
        on
            o.internal_key = n.internal_key
            and o.client_no = n.client_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_acct_attach_cl d
        on
            o.internal_key = d.internal_key
            and o.client_no = d.client_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_acct_attach;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_acct_attach') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_acct_attach drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_acct_attach add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_acct_attach exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_acct_attach_cl;
alter table ${iol_schema}.ncbs_rb_acct_attach exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_acct_attach_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_acct_attach to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_acct_attach_op purge;
drop table ${iol_schema}.ncbs_rb_acct_attach_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_acct_attach_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_acct_attach',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
