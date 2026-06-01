/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_accounting_secu_obj_comp
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/
set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;
truncate table ibms_ttrd_accounting_secu_obj_comp;

whenever sqlerror continue none ;
alter table ibms_ttrd_accounting_secu_obj_comp add partition p_${batch_date} values (to_date(${batch_date},'yyyymmdd'));

insert /*+ append */ into ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp(
    obj_id -- 
    ,tsk_id -- 
    ,beg_date -- 
    ,end_date -- 
    ,ext_secu_acct_id -- 
    ,secu_acct_id -- 
    ,trade_grp_id -- 
    ,i_code -- 
    ,a_type -- 
    ,m_type -- 
    ,trade_id -- 
    ,extra_dim -- 
    ,real_volume -- 
    ,real_amount -- 
    ,real_cp -- 
    ,ai -- 
    ,ai_cost -- 
    ,chg_fv -- 
    ,due_amount -- 
    ,due_cp -- 
    ,due_ai -- 
    ,amrt_count -- 
    ,amrt_date -- 
    ,amrt_ir -- 
    ,prft_fv -- 
    ,prft_trd -- 
    ,prft_ir -- 
    ,prft_ir_ai -- 
    ,prft_ir_amrt -- 
    ,prft_ir_ai_hld -- 
    ,prft_ir_amrt_hld -- 
    ,reclass_prft_fv -- 
    ,impair -- 
    ,prft_impair -- 
    ,real_margin -- 
    ,open_time -- 
    ,update_time -- 
    ,prft_fee -- 
    ,due_fee -- 
    ,fee -- 
    ,amrt_cost_cp -- 
    ,amrt_cost_ai -- 
    ,amrt_ir_hp -- 
    ,amrt_ytm -- 
    ,invest_ytm -- 
    ,open_ytm -- 
    ,future_ai -- 
    ,real_cp_noamrt -- 
    ,chg_fv_noamrt -- 
    ,prft_fv_noamrt -- 
    ,prft_trd_noamrt -- 
    ,amrt_method -- 
    ,real_volume_termcur -- 
    ,real_amount_termcur -- 
    ,due_amount_termcur -- 
    ,real_cp_termcur -- 
    ,due_cp_termcur -- 
    ,prft_ir_amrt_rc -- 
    ,prft_ir_amrt_hld_rc -- 
    ,amrt_cost_cp_rc -- 
    ,amrt_ytm_rc -- 
    ,amrt_ir_hp_rc -- 
    ,calc_date -- 
    ,ipr_state -- 
    ,ipr_prft_cp -- 
    ,ipr_prft_ai -- 
    ,ipr_cp -- 
    ,ipr_hx_cp -- 
    ,ipr_hx_ai -- 
    ,ipr_hx_due_ai -- 
    ,ipr_bw_ai -- 
    ,ipr_bw_due_ai -- 
    ,amrt_date_rc -- 
    ,amrt_cost_ai_rc -- 
    ,open_date_rc -- 
    ,prft_ir_ai_calc_tax -- 应计利息收入增量
    ,tax_ai -- 应计增值税
    ,tax_due_ai -- 应付增值税
    ,tax_fee -- 费用收入税/支出税
    ,fv_currency -- 估值币种
    ,set_date -- 结算日期
    ,prft_fv_cash -- 已实现公允价值变动损益
    ,tax_ai_hld -- 当前持仓利息收入税/支出税
    ,open_ai -- 开仓利息成本
    ,open_ytm_opt -- 开仓行权收益率
    ,prft_ir_ai_fut -- 预收利息收入
    ,prft_ir_ai_cur -- 计提利息收入
    ,prft_ir_ai_due -- 应收利息收入
    ,prft_ir_ai_cash -- 实收利息收入
    ,tax_fut_ai -- 计提利息收入预收税
    ,tax_due_amrt -- 摊销利息收入应付增值税
    ,tax_due_amrt_rc -- 重分类后资本公积摊销收入应付增值税
    ,tax_due_trd -- 买卖损益应付增值税
    ,tax_due_fv -- 公允价值损益应付增值税
    ,tax_due_fv_reclass -- 重分类公允价值损益应付增值税
    ,tax_due_fv_cash -- 已实现公允价值损益应付增值税
    ,tax_due_fee -- 费用损益应付增值税
    ,due_chg_fv -- 结转公允价值变动
    ,due_volume -- 结转数量
    ,amrt_verify_code -- 摊销验证码
    ,amrt_verify_date -- 摊销验证日期
    ,prft_reclass -- 重分类损益
    ,close_set_date -- 平仓交割日期
    ,trade_inst_id -- 交易指令号
    ,custom_dim1 -- 扩展维度1
    ,ipr_period -- 减值阶段
    ,ipr_cp1 -- 阶段一减值准备
    ,ipr_cp2 -- 阶段二减值准备
    ,ipr_cp3 -- 阶段三减值准备
    ,ipr_prft_cp1 -- 阶段一减值损失
    ,ipr_prft_cp2 -- 阶段二减值损失
    ,ipr_prft_cp3 -- 阶段三减值损失
    ,amrt_start_ir_hp -- 摊销开始日期初利息调整余额(高精度)
    ,tax_amrt -- 摊销利息收入暂估税
    ,calc_tax_amrt_cur -- 计提摊销利息收入税
    ,calc_tax_amrt_due -- 应收摊销利息收入税
    ,calc_tax_amrt_cash -- 实收摊销利息收入税
    ,tax_fv -- 未实现损益暂估税
    ,discount_ai -- 贴现利息单张值
    ,tax_due_ai_amrt -- 存储到期、行权、赎回摊销部分拆出来的税
    ,prft_ir_trd -- 买卖损益计为利息收入
    ,tax_due_ai_trd -- 买卖损益计入利息收入产生的税
    ,prft_ir_amrt_cur -- 计提摊销利息收入
    ,prft_ir_amrt_due -- 应收摊销利息收入
    ,prft_ir_amrt_cash -- 实收摊销利息收入
    ,tax_ir -- 利息收入暂估税
    ,tax_due_ir -- 利息收入应付增值税
    ,prft_id -- 损益对象id
    ,deviation -- 偏离金额
    ,prft_ir_fut_ai -- 预收息利息收入
    ,is_ai_transfered -- 计利息是否结转
    ,ipr_ai3 -- 阶段三减值利息
    ,ipr_prft_ai3 -- 阶段三利息减值损失
    ,deferred_fv_tax -- 估值递延税
    ,deferred_profit_fv_tax -- 损益递延税
    ,ipr_ai -- 利息减值准备
    ,obj_type -- 余额类型 -1 正常余额 1 逾期豁免余额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    obj_id -- 
    ,tsk_id -- 
    ,beg_date -- 
    ,end_date -- 
    ,ext_secu_acct_id -- 
    ,secu_acct_id -- 
    ,trade_grp_id -- 
    ,i_code -- 
    ,a_type -- 
    ,m_type -- 
    ,trade_id -- 
    ,extra_dim -- 
    ,real_volume -- 
    ,real_amount -- 
    ,real_cp -- 
    ,ai -- 
    ,ai_cost -- 
    ,chg_fv -- 
    ,due_amount -- 
    ,due_cp -- 
    ,due_ai -- 
    ,amrt_count -- 
    ,amrt_date -- 
    ,amrt_ir -- 
    ,prft_fv -- 
    ,prft_trd -- 
    ,prft_ir -- 
    ,prft_ir_ai -- 
    ,prft_ir_amrt -- 
    ,prft_ir_ai_hld -- 
    ,prft_ir_amrt_hld -- 
    ,reclass_prft_fv -- 
    ,impair -- 
    ,prft_impair -- 
    ,real_margin -- 
    ,open_time -- 
    ,update_time -- 
    ,prft_fee -- 
    ,due_fee -- 
    ,fee -- 
    ,amrt_cost_cp -- 
    ,amrt_cost_ai -- 
    ,amrt_ir_hp -- 
    ,amrt_ytm -- 
    ,invest_ytm -- 
    ,open_ytm -- 
    ,future_ai -- 
    ,real_cp_noamrt -- 
    ,chg_fv_noamrt -- 
    ,prft_fv_noamrt -- 
    ,prft_trd_noamrt -- 
    ,amrt_method -- 
    ,real_volume_termcur -- 
    ,real_amount_termcur -- 
    ,due_amount_termcur -- 
    ,real_cp_termcur -- 
    ,due_cp_termcur -- 
    ,prft_ir_amrt_rc -- 
    ,prft_ir_amrt_hld_rc -- 
    ,amrt_cost_cp_rc -- 
    ,amrt_ytm_rc -- 
    ,amrt_ir_hp_rc -- 
    ,calc_date -- 
    ,ipr_state -- 
    ,ipr_prft_cp -- 
    ,ipr_prft_ai -- 
    ,ipr_cp -- 
    ,ipr_hx_cp -- 
    ,ipr_hx_ai -- 
    ,ipr_hx_due_ai -- 
    ,ipr_bw_ai -- 
    ,ipr_bw_due_ai -- 
    ,amrt_date_rc -- 
    ,amrt_cost_ai_rc -- 
    ,open_date_rc -- 
    ,prft_ir_ai_calc_tax -- 应计利息收入增量
    ,tax_ai -- 应计增值税
    ,tax_due_ai -- 应付增值税
    ,tax_fee -- 费用收入税/支出税
    ,fv_currency -- 估值币种
    ,set_date -- 结算日期
    ,prft_fv_cash -- 已实现公允价值变动损益
    ,tax_ai_hld -- 当前持仓利息收入税/支出税
    ,open_ai -- 开仓利息成本
    ,open_ytm_opt -- 开仓行权收益率
    ,prft_ir_ai_fut -- 预收利息收入
    ,prft_ir_ai_cur -- 计提利息收入
    ,prft_ir_ai_due -- 应收利息收入
    ,prft_ir_ai_cash -- 实收利息收入
    ,tax_fut_ai -- 计提利息收入预收税
    ,tax_due_amrt -- 摊销利息收入应付增值税
    ,tax_due_amrt_rc -- 重分类后资本公积摊销收入应付增值税
    ,tax_due_trd -- 买卖损益应付增值税
    ,tax_due_fv -- 公允价值损益应付增值税
    ,tax_due_fv_reclass -- 重分类公允价值损益应付增值税
    ,tax_due_fv_cash -- 已实现公允价值损益应付增值税
    ,tax_due_fee -- 费用损益应付增值税
    ,due_chg_fv -- 结转公允价值变动
    ,due_volume -- 结转数量
    ,amrt_verify_code -- 摊销验证码
    ,amrt_verify_date -- 摊销验证日期
    ,prft_reclass -- 重分类损益
    ,close_set_date -- 平仓交割日期
    ,trade_inst_id -- 交易指令号
    ,custom_dim1 -- 扩展维度1
    ,ipr_period -- 减值阶段
    ,ipr_cp1 -- 阶段一减值准备
    ,ipr_cp2 -- 阶段二减值准备
    ,ipr_cp3 -- 阶段三减值准备
    ,ipr_prft_cp1 -- 阶段一减值损失
    ,ipr_prft_cp2 -- 阶段二减值损失
    ,ipr_prft_cp3 -- 阶段三减值损失
    ,amrt_start_ir_hp -- 摊销开始日期初利息调整余额(高精度)
    ,tax_amrt -- 摊销利息收入暂估税
    ,calc_tax_amrt_cur -- 计提摊销利息收入税
    ,calc_tax_amrt_due -- 应收摊销利息收入税
    ,calc_tax_amrt_cash -- 实收摊销利息收入税
    ,tax_fv -- 未实现损益暂估税
    ,discount_ai -- 贴现利息单张值
    ,tax_due_ai_amrt -- 存储到期、行权、赎回摊销部分拆出来的税
    ,prft_ir_trd -- 买卖损益计为利息收入
    ,tax_due_ai_trd -- 买卖损益计入利息收入产生的税
    ,prft_ir_amrt_cur -- 计提摊销利息收入
    ,prft_ir_amrt_due -- 应收摊销利息收入
    ,prft_ir_amrt_cash -- 实收摊销利息收入
    ,tax_ir -- 利息收入暂估税
    ,tax_due_ir -- 利息收入应付增值税
    ,prft_id -- 损益对象id
    ,deviation -- 偏离金额
    ,prft_ir_fut_ai -- 预收息利息收入
    ,is_ai_transfered -- 计利息是否结转
    ,ipr_ai3 -- 阶段三减值利息
    ,ipr_prft_ai3 -- 阶段三利息减值损失
    ,deferred_fv_tax -- 估值递延税
    ,deferred_profit_fv_tax -- 损益递延税
    ,ipr_ai -- 利息减值准备
    ,' ' as obj_type -- 余额类型 -1 正常余额 1 逾期豁免余额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
from iol.ibms_ttrd_accounting_secu_obj_comp_bak_${batch_date}
where etl_dt = to_date(${batch_date}, 'yyyymmdd');

commit;
