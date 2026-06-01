/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_accounting_secu_chg_his
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
create table ${iol_schema}.ibms_ttrd_accounting_secu_chg_his_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_accounting_secu_chg_his;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_accounting_secu_chg_his_op purge;
drop table ${iol_schema}.ibms_ttrd_accounting_secu_chg_his_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_accounting_secu_chg_his_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_accounting_secu_chg_his where 0=1;

create table ${iol_schema}.ibms_ttrd_accounting_secu_chg_his_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_accounting_secu_chg_his where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_accounting_secu_chg_his_cl(
            chg_id -- 变动Id
            ,erase_ref_chg_id -- 撤销关联变动Id
            ,tsk_id -- 任务Id
            ,chg_date -- 变动日期
            ,chg_type -- 变动类型
            ,acctg_obj_id -- 对象Id
            ,inst_id -- 指令Id
            ,ext_secu_acct_id -- 外部券账户
            ,secu_acct_id -- 内部券账户
            ,trade_grp_id -- 组合交易号
            ,i_code -- 金融工具代码
            ,a_type -- 金融工具资产类型
            ,m_type -- 金融工具市场类型
            ,trade_id -- 交易号
            ,extra_dim -- 额外维度
            ,estd_or_real -- E：理论核算；R：实际核算
            ,real_volume -- 数量
            ,real_amount -- 余额
            ,real_cp -- 净价成本
            ,ai -- 应计利息
            ,ai_cost -- 利息成本
            ,ai2ri -- 应计转应收未收
            ,ri2pi -- 应收未收转实收
            ,ai_fillup_estd -- 应计利息理论补计提
            ,ai_fillup_real -- 应计利息实际补计提
            ,chg_fv -- 公允价值变动
            ,chg_fv_l -- 公允价值损益(资产部分)
            ,chg_fv_s -- 公允价值损益(负债部分)
            ,due_amount -- 应收未收余额
            ,due_cp -- 应收未收净价成本
            ,due_ai -- 应收未收应计利息
            ,amrt_count -- 当天摊销业务次数
            ,amrt_date -- 摊销日期
            ,amrt_ir -- 利息调整
            ,prft_fv -- 公允价值损益
            ,prft_trd -- 买卖损益
            ,prft_ir -- 利息收入
            ,prft_ir_ai -- 应计利息利息收入
            ,prft_ir_amrt -- 摊销利息收入
            ,prft_ir_ai_hld -- 当前持仓应计利息利息收入
            ,prft_ir_amrt_hld -- 当前持仓摊销利息收入
            ,reclass_prft_fv -- 重分类公允价值损益
            ,impair -- 减值准备
            ,prft_impair -- 减值损失
            ,real_margin -- 期货保证金
            ,update_time -- 更新时间
            ,prft_fee -- 费用
            ,due_fee -- 应付费用
            ,fee -- 费用成本
            ,amrt_cost_cp -- 摊余净价成本
            ,amrt_cost_ai -- 摊余利息成本
            ,biz_date -- 业务日期
            ,his_amrt_date -- 历史摊销开始日期
            ,amrt_ir_hp -- 利息调整(高精度)
            ,amrt_ytm -- 实际利率
            ,invest_ytm -- 投资收益率
            ,process -- 核算过程
            ,open_ytm -- 开仓收益率
            ,future_ai -- 预收息
            ,real_cp_noamrt -- 不摊销净价成本
            ,chg_fv_noamrt -- 不摊销公允价值变动
            ,prft_fv_noamrt -- 不摊销公允价值损益
            ,prft_trd_noamrt -- 不摊销买卖损益
            ,amrt_date_old -- 重置前摊销日期
            ,amrt_method -- 摊销算法
            ,real_volume_termcur -- 货币对反向实际数量
            ,real_amount_termcur -- 货币对反向实际面值
            ,due_amount_termcur -- 货币对反向结转面值
            ,real_cp_termcur -- 货币对反向实际成本
            ,due_cp_termcur -- 货币对反向结转成本
            ,prft_ir_amrt_rc -- 重分类利息收入（摊销部分）
            ,prft_ir_amrt_hld_rc -- 重分类利息收入（当前持仓摊销部分）
            ,amrt_cost_cp_rc -- 重分类摊余净价成本
            ,amrt_ytm_rc -- 重分类实际利率
            ,amrt_ir_hp_rc -- 重分类利息调整（高精度）
            ,calc_date -- 重置后计提摊销截止日期
            ,calc_date_old -- 重置前计提摊销截止日期
            ,ipr_state -- 减值状态：0-未减值，1-减值，2-核销
            ,ipr_prft_cp -- 成本减值损失
            ,ipr_prft_ai -- 利息减值损失
            ,ipr_cp -- 成本减值准备
            ,ipr_hx_cp -- 已核销成本
            ,ipr_hx_ai -- 已核销应计利息
            ,ipr_hx_due_ai -- 已核销应收未收利息
            ,ipr_bw_ai -- 表外应计利息
            ,ipr_bw_due_ai -- 表外应收未收利息
            ,amrt_date_rc_old -- 重置前重分类摊销开始日期
            ,amrt_date_rc -- 重置后重分类摊销开始日期
            ,amrt_cost_ai_rc -- 重分类摊销开始日期利息成本
            ,open_date_rc_old -- 重置前重分类开仓日期
            ,open_date_rc -- 重置后重分类开仓日期
            ,prft_ir_ai_calc_tax -- 应计利息收入增量
            ,tax_ai -- 应计增值税
            ,tax_due_ai -- 应付增值税
            ,tax_fee -- 费用收入税/支出税
            ,fv_currency_old -- 重置前估值币种
            ,fv_currency -- 重置后估值币种
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
            ,amrt_verify_code_old -- 重置前摊销验证码
            ,amrt_verify_code -- 重置后摊销验证码
            ,amrt_verify_date_old -- 重置前摊销验证日期
            ,amrt_verify_date -- 重置后摊销验证日期
            ,prft_reclass -- 重分类损益
            ,close_set_date -- 平仓交割日期
            ,close_set_date_old -- 重置前平仓交割日期
            ,trade_inst_id -- 交易指令号
            ,trade_inst_id_old -- 重置前交易指令号
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
            ,calc_tax_amrt_cur -- 计提摊销利息收入
            ,calc_tax_amrt_due -- 应收摊销利息收入
            ,calc_tax_amrt_cash -- 实收摊销利息收入
            ,tax_fv -- 未实现损益暂估税
            ,tax_ir -- 利息收入暂估税
            ,tax_due_ir -- 利息收入应付增值税
            ,prft_id -- 损益对象id
            ,prft_id_old -- 老损益对象id
            ,deviation -- 偏离金额
            ,prft_ir_fut_ai -- 预收息利息收入
            ,f_chg_fv_sub -- 公允价值变动（全冲全提冲减量）
            ,f_chg_fv_add -- 公允价值变动（全冲全提增加量）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_accounting_secu_chg_his_op(
            chg_id -- 变动Id
            ,erase_ref_chg_id -- 撤销关联变动Id
            ,tsk_id -- 任务Id
            ,chg_date -- 变动日期
            ,chg_type -- 变动类型
            ,acctg_obj_id -- 对象Id
            ,inst_id -- 指令Id
            ,ext_secu_acct_id -- 外部券账户
            ,secu_acct_id -- 内部券账户
            ,trade_grp_id -- 组合交易号
            ,i_code -- 金融工具代码
            ,a_type -- 金融工具资产类型
            ,m_type -- 金融工具市场类型
            ,trade_id -- 交易号
            ,extra_dim -- 额外维度
            ,estd_or_real -- E：理论核算；R：实际核算
            ,real_volume -- 数量
            ,real_amount -- 余额
            ,real_cp -- 净价成本
            ,ai -- 应计利息
            ,ai_cost -- 利息成本
            ,ai2ri -- 应计转应收未收
            ,ri2pi -- 应收未收转实收
            ,ai_fillup_estd -- 应计利息理论补计提
            ,ai_fillup_real -- 应计利息实际补计提
            ,chg_fv -- 公允价值变动
            ,chg_fv_l -- 公允价值损益(资产部分)
            ,chg_fv_s -- 公允价值损益(负债部分)
            ,due_amount -- 应收未收余额
            ,due_cp -- 应收未收净价成本
            ,due_ai -- 应收未收应计利息
            ,amrt_count -- 当天摊销业务次数
            ,amrt_date -- 摊销日期
            ,amrt_ir -- 利息调整
            ,prft_fv -- 公允价值损益
            ,prft_trd -- 买卖损益
            ,prft_ir -- 利息收入
            ,prft_ir_ai -- 应计利息利息收入
            ,prft_ir_amrt -- 摊销利息收入
            ,prft_ir_ai_hld -- 当前持仓应计利息利息收入
            ,prft_ir_amrt_hld -- 当前持仓摊销利息收入
            ,reclass_prft_fv -- 重分类公允价值损益
            ,impair -- 减值准备
            ,prft_impair -- 减值损失
            ,real_margin -- 期货保证金
            ,update_time -- 更新时间
            ,prft_fee -- 费用
            ,due_fee -- 应付费用
            ,fee -- 费用成本
            ,amrt_cost_cp -- 摊余净价成本
            ,amrt_cost_ai -- 摊余利息成本
            ,biz_date -- 业务日期
            ,his_amrt_date -- 历史摊销开始日期
            ,amrt_ir_hp -- 利息调整(高精度)
            ,amrt_ytm -- 实际利率
            ,invest_ytm -- 投资收益率
            ,process -- 核算过程
            ,open_ytm -- 开仓收益率
            ,future_ai -- 预收息
            ,real_cp_noamrt -- 不摊销净价成本
            ,chg_fv_noamrt -- 不摊销公允价值变动
            ,prft_fv_noamrt -- 不摊销公允价值损益
            ,prft_trd_noamrt -- 不摊销买卖损益
            ,amrt_date_old -- 重置前摊销日期
            ,amrt_method -- 摊销算法
            ,real_volume_termcur -- 货币对反向实际数量
            ,real_amount_termcur -- 货币对反向实际面值
            ,due_amount_termcur -- 货币对反向结转面值
            ,real_cp_termcur -- 货币对反向实际成本
            ,due_cp_termcur -- 货币对反向结转成本
            ,prft_ir_amrt_rc -- 重分类利息收入（摊销部分）
            ,prft_ir_amrt_hld_rc -- 重分类利息收入（当前持仓摊销部分）
            ,amrt_cost_cp_rc -- 重分类摊余净价成本
            ,amrt_ytm_rc -- 重分类实际利率
            ,amrt_ir_hp_rc -- 重分类利息调整（高精度）
            ,calc_date -- 重置后计提摊销截止日期
            ,calc_date_old -- 重置前计提摊销截止日期
            ,ipr_state -- 减值状态：0-未减值，1-减值，2-核销
            ,ipr_prft_cp -- 成本减值损失
            ,ipr_prft_ai -- 利息减值损失
            ,ipr_cp -- 成本减值准备
            ,ipr_hx_cp -- 已核销成本
            ,ipr_hx_ai -- 已核销应计利息
            ,ipr_hx_due_ai -- 已核销应收未收利息
            ,ipr_bw_ai -- 表外应计利息
            ,ipr_bw_due_ai -- 表外应收未收利息
            ,amrt_date_rc_old -- 重置前重分类摊销开始日期
            ,amrt_date_rc -- 重置后重分类摊销开始日期
            ,amrt_cost_ai_rc -- 重分类摊销开始日期利息成本
            ,open_date_rc_old -- 重置前重分类开仓日期
            ,open_date_rc -- 重置后重分类开仓日期
            ,prft_ir_ai_calc_tax -- 应计利息收入增量
            ,tax_ai -- 应计增值税
            ,tax_due_ai -- 应付增值税
            ,tax_fee -- 费用收入税/支出税
            ,fv_currency_old -- 重置前估值币种
            ,fv_currency -- 重置后估值币种
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
            ,amrt_verify_code_old -- 重置前摊销验证码
            ,amrt_verify_code -- 重置后摊销验证码
            ,amrt_verify_date_old -- 重置前摊销验证日期
            ,amrt_verify_date -- 重置后摊销验证日期
            ,prft_reclass -- 重分类损益
            ,close_set_date -- 平仓交割日期
            ,close_set_date_old -- 重置前平仓交割日期
            ,trade_inst_id -- 交易指令号
            ,trade_inst_id_old -- 重置前交易指令号
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
            ,calc_tax_amrt_cur -- 计提摊销利息收入
            ,calc_tax_amrt_due -- 应收摊销利息收入
            ,calc_tax_amrt_cash -- 实收摊销利息收入
            ,tax_fv -- 未实现损益暂估税
            ,tax_ir -- 利息收入暂估税
            ,tax_due_ir -- 利息收入应付增值税
            ,prft_id -- 损益对象id
            ,prft_id_old -- 老损益对象id
            ,deviation -- 偏离金额
            ,prft_ir_fut_ai -- 预收息利息收入
            ,f_chg_fv_sub -- 公允价值变动（全冲全提冲减量）
            ,f_chg_fv_add -- 公允价值变动（全冲全提增加量）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.chg_id, o.chg_id) as chg_id -- 变动Id
    ,nvl(n.erase_ref_chg_id, o.erase_ref_chg_id) as erase_ref_chg_id -- 撤销关联变动Id
    ,nvl(n.tsk_id, o.tsk_id) as tsk_id -- 任务Id
    ,nvl(n.chg_date, o.chg_date) as chg_date -- 变动日期
    ,nvl(n.chg_type, o.chg_type) as chg_type -- 变动类型
    ,nvl(n.acctg_obj_id, o.acctg_obj_id) as acctg_obj_id -- 对象Id
    ,nvl(n.inst_id, o.inst_id) as inst_id -- 指令Id
    ,nvl(n.ext_secu_acct_id, o.ext_secu_acct_id) as ext_secu_acct_id -- 外部券账户
    ,nvl(n.secu_acct_id, o.secu_acct_id) as secu_acct_id -- 内部券账户
    ,nvl(n.trade_grp_id, o.trade_grp_id) as trade_grp_id -- 组合交易号
    ,nvl(n.i_code, o.i_code) as i_code -- 金融工具代码
    ,nvl(n.a_type, o.a_type) as a_type -- 金融工具资产类型
    ,nvl(n.m_type, o.m_type) as m_type -- 金融工具市场类型
    ,nvl(n.trade_id, o.trade_id) as trade_id -- 交易号
    ,nvl(n.extra_dim, o.extra_dim) as extra_dim -- 额外维度
    ,nvl(n.estd_or_real, o.estd_or_real) as estd_or_real -- E：理论核算；R：实际核算
    ,nvl(n.real_volume, o.real_volume) as real_volume -- 数量
    ,nvl(n.real_amount, o.real_amount) as real_amount -- 余额
    ,nvl(n.real_cp, o.real_cp) as real_cp -- 净价成本
    ,nvl(n.ai, o.ai) as ai -- 应计利息
    ,nvl(n.ai_cost, o.ai_cost) as ai_cost -- 利息成本
    ,nvl(n.ai2ri, o.ai2ri) as ai2ri -- 应计转应收未收
    ,nvl(n.ri2pi, o.ri2pi) as ri2pi -- 应收未收转实收
    ,nvl(n.ai_fillup_estd, o.ai_fillup_estd) as ai_fillup_estd -- 应计利息理论补计提
    ,nvl(n.ai_fillup_real, o.ai_fillup_real) as ai_fillup_real -- 应计利息实际补计提
    ,nvl(n.chg_fv, o.chg_fv) as chg_fv -- 公允价值变动
    ,nvl(n.chg_fv_l, o.chg_fv_l) as chg_fv_l -- 公允价值损益(资产部分)
    ,nvl(n.chg_fv_s, o.chg_fv_s) as chg_fv_s -- 公允价值损益(负债部分)
    ,nvl(n.due_amount, o.due_amount) as due_amount -- 应收未收余额
    ,nvl(n.due_cp, o.due_cp) as due_cp -- 应收未收净价成本
    ,nvl(n.due_ai, o.due_ai) as due_ai -- 应收未收应计利息
    ,nvl(n.amrt_count, o.amrt_count) as amrt_count -- 当天摊销业务次数
    ,nvl(n.amrt_date, o.amrt_date) as amrt_date -- 摊销日期
    ,nvl(n.amrt_ir, o.amrt_ir) as amrt_ir -- 利息调整
    ,nvl(n.prft_fv, o.prft_fv) as prft_fv -- 公允价值损益
    ,nvl(n.prft_trd, o.prft_trd) as prft_trd -- 买卖损益
    ,nvl(n.prft_ir, o.prft_ir) as prft_ir -- 利息收入
    ,nvl(n.prft_ir_ai, o.prft_ir_ai) as prft_ir_ai -- 应计利息利息收入
    ,nvl(n.prft_ir_amrt, o.prft_ir_amrt) as prft_ir_amrt -- 摊销利息收入
    ,nvl(n.prft_ir_ai_hld, o.prft_ir_ai_hld) as prft_ir_ai_hld -- 当前持仓应计利息利息收入
    ,nvl(n.prft_ir_amrt_hld, o.prft_ir_amrt_hld) as prft_ir_amrt_hld -- 当前持仓摊销利息收入
    ,nvl(n.reclass_prft_fv, o.reclass_prft_fv) as reclass_prft_fv -- 重分类公允价值损益
    ,nvl(n.impair, o.impair) as impair -- 减值准备
    ,nvl(n.prft_impair, o.prft_impair) as prft_impair -- 减值损失
    ,nvl(n.real_margin, o.real_margin) as real_margin -- 期货保证金
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.prft_fee, o.prft_fee) as prft_fee -- 费用
    ,nvl(n.due_fee, o.due_fee) as due_fee -- 应付费用
    ,nvl(n.fee, o.fee) as fee -- 费用成本
    ,nvl(n.amrt_cost_cp, o.amrt_cost_cp) as amrt_cost_cp -- 摊余净价成本
    ,nvl(n.amrt_cost_ai, o.amrt_cost_ai) as amrt_cost_ai -- 摊余利息成本
    ,nvl(n.biz_date, o.biz_date) as biz_date -- 业务日期
    ,nvl(n.his_amrt_date, o.his_amrt_date) as his_amrt_date -- 历史摊销开始日期
    ,nvl(n.amrt_ir_hp, o.amrt_ir_hp) as amrt_ir_hp -- 利息调整(高精度)
    ,nvl(n.amrt_ytm, o.amrt_ytm) as amrt_ytm -- 实际利率
    ,nvl(n.invest_ytm, o.invest_ytm) as invest_ytm -- 投资收益率
    ,nvl(n.process, o.process) as process -- 核算过程
    ,nvl(n.open_ytm, o.open_ytm) as open_ytm -- 开仓收益率
    ,nvl(n.future_ai, o.future_ai) as future_ai -- 预收息
    ,nvl(n.real_cp_noamrt, o.real_cp_noamrt) as real_cp_noamrt -- 不摊销净价成本
    ,nvl(n.chg_fv_noamrt, o.chg_fv_noamrt) as chg_fv_noamrt -- 不摊销公允价值变动
    ,nvl(n.prft_fv_noamrt, o.prft_fv_noamrt) as prft_fv_noamrt -- 不摊销公允价值损益
    ,nvl(n.prft_trd_noamrt, o.prft_trd_noamrt) as prft_trd_noamrt -- 不摊销买卖损益
    ,nvl(n.amrt_date_old, o.amrt_date_old) as amrt_date_old -- 重置前摊销日期
    ,nvl(n.amrt_method, o.amrt_method) as amrt_method -- 摊销算法
    ,nvl(n.real_volume_termcur, o.real_volume_termcur) as real_volume_termcur -- 货币对反向实际数量
    ,nvl(n.real_amount_termcur, o.real_amount_termcur) as real_amount_termcur -- 货币对反向实际面值
    ,nvl(n.due_amount_termcur, o.due_amount_termcur) as due_amount_termcur -- 货币对反向结转面值
    ,nvl(n.real_cp_termcur, o.real_cp_termcur) as real_cp_termcur -- 货币对反向实际成本
    ,nvl(n.due_cp_termcur, o.due_cp_termcur) as due_cp_termcur -- 货币对反向结转成本
    ,nvl(n.prft_ir_amrt_rc, o.prft_ir_amrt_rc) as prft_ir_amrt_rc -- 重分类利息收入（摊销部分）
    ,nvl(n.prft_ir_amrt_hld_rc, o.prft_ir_amrt_hld_rc) as prft_ir_amrt_hld_rc -- 重分类利息收入（当前持仓摊销部分）
    ,nvl(n.amrt_cost_cp_rc, o.amrt_cost_cp_rc) as amrt_cost_cp_rc -- 重分类摊余净价成本
    ,nvl(n.amrt_ytm_rc, o.amrt_ytm_rc) as amrt_ytm_rc -- 重分类实际利率
    ,nvl(n.amrt_ir_hp_rc, o.amrt_ir_hp_rc) as amrt_ir_hp_rc -- 重分类利息调整（高精度）
    ,nvl(n.calc_date, o.calc_date) as calc_date -- 重置后计提摊销截止日期
    ,nvl(n.calc_date_old, o.calc_date_old) as calc_date_old -- 重置前计提摊销截止日期
    ,nvl(n.ipr_state, o.ipr_state) as ipr_state -- 减值状态：0-未减值，1-减值，2-核销
    ,nvl(n.ipr_prft_cp, o.ipr_prft_cp) as ipr_prft_cp -- 成本减值损失
    ,nvl(n.ipr_prft_ai, o.ipr_prft_ai) as ipr_prft_ai -- 利息减值损失
    ,nvl(n.ipr_cp, o.ipr_cp) as ipr_cp -- 成本减值准备
    ,nvl(n.ipr_hx_cp, o.ipr_hx_cp) as ipr_hx_cp -- 已核销成本
    ,nvl(n.ipr_hx_ai, o.ipr_hx_ai) as ipr_hx_ai -- 已核销应计利息
    ,nvl(n.ipr_hx_due_ai, o.ipr_hx_due_ai) as ipr_hx_due_ai -- 已核销应收未收利息
    ,nvl(n.ipr_bw_ai, o.ipr_bw_ai) as ipr_bw_ai -- 表外应计利息
    ,nvl(n.ipr_bw_due_ai, o.ipr_bw_due_ai) as ipr_bw_due_ai -- 表外应收未收利息
    ,nvl(n.amrt_date_rc_old, o.amrt_date_rc_old) as amrt_date_rc_old -- 重置前重分类摊销开始日期
    ,nvl(n.amrt_date_rc, o.amrt_date_rc) as amrt_date_rc -- 重置后重分类摊销开始日期
    ,nvl(n.amrt_cost_ai_rc, o.amrt_cost_ai_rc) as amrt_cost_ai_rc -- 重分类摊销开始日期利息成本
    ,nvl(n.open_date_rc_old, o.open_date_rc_old) as open_date_rc_old -- 重置前重分类开仓日期
    ,nvl(n.open_date_rc, o.open_date_rc) as open_date_rc -- 重置后重分类开仓日期
    ,nvl(n.prft_ir_ai_calc_tax, o.prft_ir_ai_calc_tax) as prft_ir_ai_calc_tax -- 应计利息收入增量
    ,nvl(n.tax_ai, o.tax_ai) as tax_ai -- 应计增值税
    ,nvl(n.tax_due_ai, o.tax_due_ai) as tax_due_ai -- 应付增值税
    ,nvl(n.tax_fee, o.tax_fee) as tax_fee -- 费用收入税/支出税
    ,nvl(n.fv_currency_old, o.fv_currency_old) as fv_currency_old -- 重置前估值币种
    ,nvl(n.fv_currency, o.fv_currency) as fv_currency -- 重置后估值币种
    ,nvl(n.set_date, o.set_date) as set_date -- 结算日期
    ,nvl(n.prft_fv_cash, o.prft_fv_cash) as prft_fv_cash -- 已实现公允价值变动损益
    ,nvl(n.tax_ai_hld, o.tax_ai_hld) as tax_ai_hld -- 当前持仓利息收入税/支出税
    ,nvl(n.open_ai, o.open_ai) as open_ai -- 开仓利息成本
    ,nvl(n.open_ytm_opt, o.open_ytm_opt) as open_ytm_opt -- 开仓行权收益率
    ,nvl(n.prft_ir_ai_fut, o.prft_ir_ai_fut) as prft_ir_ai_fut -- 预收利息收入
    ,nvl(n.prft_ir_ai_cur, o.prft_ir_ai_cur) as prft_ir_ai_cur -- 计提利息收入
    ,nvl(n.prft_ir_ai_due, o.prft_ir_ai_due) as prft_ir_ai_due -- 应收利息收入
    ,nvl(n.prft_ir_ai_cash, o.prft_ir_ai_cash) as prft_ir_ai_cash -- 实收利息收入
    ,nvl(n.tax_fut_ai, o.tax_fut_ai) as tax_fut_ai -- 计提利息收入预收税
    ,nvl(n.tax_due_amrt, o.tax_due_amrt) as tax_due_amrt -- 摊销利息收入应付增值税
    ,nvl(n.tax_due_amrt_rc, o.tax_due_amrt_rc) as tax_due_amrt_rc -- 重分类后资本公积摊销收入应付增值税
    ,nvl(n.tax_due_trd, o.tax_due_trd) as tax_due_trd -- 买卖损益应付增值税
    ,nvl(n.tax_due_fv, o.tax_due_fv) as tax_due_fv -- 公允价值损益应付增值税
    ,nvl(n.tax_due_fv_reclass, o.tax_due_fv_reclass) as tax_due_fv_reclass -- 重分类公允价值损益应付增值税
    ,nvl(n.tax_due_fv_cash, o.tax_due_fv_cash) as tax_due_fv_cash -- 已实现公允价值损益应付增值税
    ,nvl(n.tax_due_fee, o.tax_due_fee) as tax_due_fee -- 费用损益应付增值税
    ,nvl(n.due_chg_fv, o.due_chg_fv) as due_chg_fv -- 结转公允价值变动
    ,nvl(n.due_volume, o.due_volume) as due_volume -- 结转数量
    ,nvl(n.amrt_verify_code_old, o.amrt_verify_code_old) as amrt_verify_code_old -- 重置前摊销验证码
    ,nvl(n.amrt_verify_code, o.amrt_verify_code) as amrt_verify_code -- 重置后摊销验证码
    ,nvl(n.amrt_verify_date_old, o.amrt_verify_date_old) as amrt_verify_date_old -- 重置前摊销验证日期
    ,nvl(n.amrt_verify_date, o.amrt_verify_date) as amrt_verify_date -- 重置后摊销验证日期
    ,nvl(n.prft_reclass, o.prft_reclass) as prft_reclass -- 重分类损益
    ,nvl(n.close_set_date, o.close_set_date) as close_set_date -- 平仓交割日期
    ,nvl(n.close_set_date_old, o.close_set_date_old) as close_set_date_old -- 重置前平仓交割日期
    ,nvl(n.trade_inst_id, o.trade_inst_id) as trade_inst_id -- 交易指令号
    ,nvl(n.trade_inst_id_old, o.trade_inst_id_old) as trade_inst_id_old -- 重置前交易指令号
    ,nvl(n.custom_dim1, o.custom_dim1) as custom_dim1 -- 扩展维度1
    ,nvl(n.ipr_period, o.ipr_period) as ipr_period -- 减值阶段
    ,nvl(n.ipr_cp1, o.ipr_cp1) as ipr_cp1 -- 阶段一减值准备
    ,nvl(n.ipr_cp2, o.ipr_cp2) as ipr_cp2 -- 阶段二减值准备
    ,nvl(n.ipr_cp3, o.ipr_cp3) as ipr_cp3 -- 阶段三减值准备
    ,nvl(n.ipr_prft_cp1, o.ipr_prft_cp1) as ipr_prft_cp1 -- 阶段一减值损失
    ,nvl(n.ipr_prft_cp2, o.ipr_prft_cp2) as ipr_prft_cp2 -- 阶段二减值损失
    ,nvl(n.ipr_prft_cp3, o.ipr_prft_cp3) as ipr_prft_cp3 -- 阶段三减值损失
    ,nvl(n.amrt_start_ir_hp, o.amrt_start_ir_hp) as amrt_start_ir_hp -- 摊销开始日期初利息调整余额(高精度)
    ,nvl(n.tax_amrt, o.tax_amrt) as tax_amrt -- 摊销利息收入暂估税
    ,nvl(n.calc_tax_amrt_cur, o.calc_tax_amrt_cur) as calc_tax_amrt_cur -- 计提摊销利息收入
    ,nvl(n.calc_tax_amrt_due, o.calc_tax_amrt_due) as calc_tax_amrt_due -- 应收摊销利息收入
    ,nvl(n.calc_tax_amrt_cash, o.calc_tax_amrt_cash) as calc_tax_amrt_cash -- 实收摊销利息收入
    ,nvl(n.tax_fv, o.tax_fv) as tax_fv -- 未实现损益暂估税
    ,nvl(n.tax_ir, o.tax_ir) as tax_ir -- 利息收入暂估税
    ,nvl(n.tax_due_ir, o.tax_due_ir) as tax_due_ir -- 利息收入应付增值税
    ,nvl(n.prft_id, o.prft_id) as prft_id -- 损益对象id
    ,nvl(n.prft_id_old, o.prft_id_old) as prft_id_old -- 老损益对象id
    ,nvl(n.deviation, o.deviation) as deviation -- 偏离金额
    ,nvl(n.prft_ir_fut_ai, o.prft_ir_fut_ai) as prft_ir_fut_ai -- 预收息利息收入
    ,nvl(n.f_chg_fv_sub, o.f_chg_fv_sub) as f_chg_fv_sub -- 公允价值变动（全冲全提冲减量）
    ,nvl(n.f_chg_fv_add, o.f_chg_fv_add) as f_chg_fv_add -- 公允价值变动（全冲全提增加量）
    ,case when
            n.chg_id is null
            and n.tsk_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.chg_id is null
            and n.tsk_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.chg_id is null
            and n.tsk_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_accounting_secu_chg_his_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_accounting_secu_chg_his where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.chg_id = n.chg_id
            and o.tsk_id = n.tsk_id
where (
        o.chg_id is null
        and o.tsk_id is null
    )
    or (
        n.chg_id is null
        and n.tsk_id is null
    )
    or (
        o.erase_ref_chg_id <> n.erase_ref_chg_id
        or o.chg_date <> n.chg_date
        or o.chg_type <> n.chg_type
        or o.acctg_obj_id <> n.acctg_obj_id
        or o.inst_id <> n.inst_id
        or o.ext_secu_acct_id <> n.ext_secu_acct_id
        or o.secu_acct_id <> n.secu_acct_id
        or o.trade_grp_id <> n.trade_grp_id
        or o.i_code <> n.i_code
        or o.a_type <> n.a_type
        or o.m_type <> n.m_type
        or o.trade_id <> n.trade_id
        or o.extra_dim <> n.extra_dim
        or o.estd_or_real <> n.estd_or_real
        or o.real_volume <> n.real_volume
        or o.real_amount <> n.real_amount
        or o.real_cp <> n.real_cp
        or o.ai <> n.ai
        or o.ai_cost <> n.ai_cost
        or o.ai2ri <> n.ai2ri
        or o.ri2pi <> n.ri2pi
        or o.ai_fillup_estd <> n.ai_fillup_estd
        or o.ai_fillup_real <> n.ai_fillup_real
        or o.chg_fv <> n.chg_fv
        or o.chg_fv_l <> n.chg_fv_l
        or o.chg_fv_s <> n.chg_fv_s
        or o.due_amount <> n.due_amount
        or o.due_cp <> n.due_cp
        or o.due_ai <> n.due_ai
        or o.amrt_count <> n.amrt_count
        or o.amrt_date <> n.amrt_date
        or o.amrt_ir <> n.amrt_ir
        or o.prft_fv <> n.prft_fv
        or o.prft_trd <> n.prft_trd
        or o.prft_ir <> n.prft_ir
        or o.prft_ir_ai <> n.prft_ir_ai
        or o.prft_ir_amrt <> n.prft_ir_amrt
        or o.prft_ir_ai_hld <> n.prft_ir_ai_hld
        or o.prft_ir_amrt_hld <> n.prft_ir_amrt_hld
        or o.reclass_prft_fv <> n.reclass_prft_fv
        or o.impair <> n.impair
        or o.prft_impair <> n.prft_impair
        or o.real_margin <> n.real_margin
        or o.update_time <> n.update_time
        or o.prft_fee <> n.prft_fee
        or o.due_fee <> n.due_fee
        or o.fee <> n.fee
        or o.amrt_cost_cp <> n.amrt_cost_cp
        or o.amrt_cost_ai <> n.amrt_cost_ai
        or o.biz_date <> n.biz_date
        or o.his_amrt_date <> n.his_amrt_date
        or o.amrt_ir_hp <> n.amrt_ir_hp
        or o.amrt_ytm <> n.amrt_ytm
        or o.invest_ytm <> n.invest_ytm
        or o.process <> n.process
        or o.open_ytm <> n.open_ytm
        or o.future_ai <> n.future_ai
        or o.real_cp_noamrt <> n.real_cp_noamrt
        or o.chg_fv_noamrt <> n.chg_fv_noamrt
        or o.prft_fv_noamrt <> n.prft_fv_noamrt
        or o.prft_trd_noamrt <> n.prft_trd_noamrt
        or o.amrt_date_old <> n.amrt_date_old
        or o.amrt_method <> n.amrt_method
        or o.real_volume_termcur <> n.real_volume_termcur
        or o.real_amount_termcur <> n.real_amount_termcur
        or o.due_amount_termcur <> n.due_amount_termcur
        or o.real_cp_termcur <> n.real_cp_termcur
        or o.due_cp_termcur <> n.due_cp_termcur
        or o.prft_ir_amrt_rc <> n.prft_ir_amrt_rc
        or o.prft_ir_amrt_hld_rc <> n.prft_ir_amrt_hld_rc
        or o.amrt_cost_cp_rc <> n.amrt_cost_cp_rc
        or o.amrt_ytm_rc <> n.amrt_ytm_rc
        or o.amrt_ir_hp_rc <> n.amrt_ir_hp_rc
        or o.calc_date <> n.calc_date
        or o.calc_date_old <> n.calc_date_old
        or o.ipr_state <> n.ipr_state
        or o.ipr_prft_cp <> n.ipr_prft_cp
        or o.ipr_prft_ai <> n.ipr_prft_ai
        or o.ipr_cp <> n.ipr_cp
        or o.ipr_hx_cp <> n.ipr_hx_cp
        or o.ipr_hx_ai <> n.ipr_hx_ai
        or o.ipr_hx_due_ai <> n.ipr_hx_due_ai
        or o.ipr_bw_ai <> n.ipr_bw_ai
        or o.ipr_bw_due_ai <> n.ipr_bw_due_ai
        or o.amrt_date_rc_old <> n.amrt_date_rc_old
        or o.amrt_date_rc <> n.amrt_date_rc
        or o.amrt_cost_ai_rc <> n.amrt_cost_ai_rc
        or o.open_date_rc_old <> n.open_date_rc_old
        or o.open_date_rc <> n.open_date_rc
        or o.prft_ir_ai_calc_tax <> n.prft_ir_ai_calc_tax
        or o.tax_ai <> n.tax_ai
        or o.tax_due_ai <> n.tax_due_ai
        or o.tax_fee <> n.tax_fee
        or o.fv_currency_old <> n.fv_currency_old
        or o.fv_currency <> n.fv_currency
        or o.set_date <> n.set_date
        or o.prft_fv_cash <> n.prft_fv_cash
        or o.tax_ai_hld <> n.tax_ai_hld
        or o.open_ai <> n.open_ai
        or o.open_ytm_opt <> n.open_ytm_opt
        or o.prft_ir_ai_fut <> n.prft_ir_ai_fut
        or o.prft_ir_ai_cur <> n.prft_ir_ai_cur
        or o.prft_ir_ai_due <> n.prft_ir_ai_due
        or o.prft_ir_ai_cash <> n.prft_ir_ai_cash
        or o.tax_fut_ai <> n.tax_fut_ai
        or o.tax_due_amrt <> n.tax_due_amrt
        or o.tax_due_amrt_rc <> n.tax_due_amrt_rc
        or o.tax_due_trd <> n.tax_due_trd
        or o.tax_due_fv <> n.tax_due_fv
        or o.tax_due_fv_reclass <> n.tax_due_fv_reclass
        or o.tax_due_fv_cash <> n.tax_due_fv_cash
        or o.tax_due_fee <> n.tax_due_fee
        or o.due_chg_fv <> n.due_chg_fv
        or o.due_volume <> n.due_volume
        or o.amrt_verify_code_old <> n.amrt_verify_code_old
        or o.amrt_verify_code <> n.amrt_verify_code
        or o.amrt_verify_date_old <> n.amrt_verify_date_old
        or o.amrt_verify_date <> n.amrt_verify_date
        or o.prft_reclass <> n.prft_reclass
        or o.close_set_date <> n.close_set_date
        or o.close_set_date_old <> n.close_set_date_old
        or o.trade_inst_id <> n.trade_inst_id
        or o.trade_inst_id_old <> n.trade_inst_id_old
        or o.custom_dim1 <> n.custom_dim1
        or o.ipr_period <> n.ipr_period
        or o.ipr_cp1 <> n.ipr_cp1
        or o.ipr_cp2 <> n.ipr_cp2
        or o.ipr_cp3 <> n.ipr_cp3
        or o.ipr_prft_cp1 <> n.ipr_prft_cp1
        or o.ipr_prft_cp2 <> n.ipr_prft_cp2
        or o.ipr_prft_cp3 <> n.ipr_prft_cp3
        or o.amrt_start_ir_hp <> n.amrt_start_ir_hp
        or o.tax_amrt <> n.tax_amrt
        or o.calc_tax_amrt_cur <> n.calc_tax_amrt_cur
        or o.calc_tax_amrt_due <> n.calc_tax_amrt_due
        or o.calc_tax_amrt_cash <> n.calc_tax_amrt_cash
        or o.tax_fv <> n.tax_fv
        or o.tax_ir <> n.tax_ir
        or o.tax_due_ir <> n.tax_due_ir
        or o.prft_id <> n.prft_id
        or o.prft_id_old <> n.prft_id_old
        or o.deviation <> n.deviation
        or o.prft_ir_fut_ai <> n.prft_ir_fut_ai
        or o.f_chg_fv_sub <> n.f_chg_fv_sub
        or o.f_chg_fv_add <> n.f_chg_fv_add
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_accounting_secu_chg_his_cl(
            chg_id -- 变动Id
            ,erase_ref_chg_id -- 撤销关联变动Id
            ,tsk_id -- 任务Id
            ,chg_date -- 变动日期
            ,chg_type -- 变动类型
            ,acctg_obj_id -- 对象Id
            ,inst_id -- 指令Id
            ,ext_secu_acct_id -- 外部券账户
            ,secu_acct_id -- 内部券账户
            ,trade_grp_id -- 组合交易号
            ,i_code -- 金融工具代码
            ,a_type -- 金融工具资产类型
            ,m_type -- 金融工具市场类型
            ,trade_id -- 交易号
            ,extra_dim -- 额外维度
            ,estd_or_real -- E：理论核算；R：实际核算
            ,real_volume -- 数量
            ,real_amount -- 余额
            ,real_cp -- 净价成本
            ,ai -- 应计利息
            ,ai_cost -- 利息成本
            ,ai2ri -- 应计转应收未收
            ,ri2pi -- 应收未收转实收
            ,ai_fillup_estd -- 应计利息理论补计提
            ,ai_fillup_real -- 应计利息实际补计提
            ,chg_fv -- 公允价值变动
            ,chg_fv_l -- 公允价值损益(资产部分)
            ,chg_fv_s -- 公允价值损益(负债部分)
            ,due_amount -- 应收未收余额
            ,due_cp -- 应收未收净价成本
            ,due_ai -- 应收未收应计利息
            ,amrt_count -- 当天摊销业务次数
            ,amrt_date -- 摊销日期
            ,amrt_ir -- 利息调整
            ,prft_fv -- 公允价值损益
            ,prft_trd -- 买卖损益
            ,prft_ir -- 利息收入
            ,prft_ir_ai -- 应计利息利息收入
            ,prft_ir_amrt -- 摊销利息收入
            ,prft_ir_ai_hld -- 当前持仓应计利息利息收入
            ,prft_ir_amrt_hld -- 当前持仓摊销利息收入
            ,reclass_prft_fv -- 重分类公允价值损益
            ,impair -- 减值准备
            ,prft_impair -- 减值损失
            ,real_margin -- 期货保证金
            ,update_time -- 更新时间
            ,prft_fee -- 费用
            ,due_fee -- 应付费用
            ,fee -- 费用成本
            ,amrt_cost_cp -- 摊余净价成本
            ,amrt_cost_ai -- 摊余利息成本
            ,biz_date -- 业务日期
            ,his_amrt_date -- 历史摊销开始日期
            ,amrt_ir_hp -- 利息调整(高精度)
            ,amrt_ytm -- 实际利率
            ,invest_ytm -- 投资收益率
            ,process -- 核算过程
            ,open_ytm -- 开仓收益率
            ,future_ai -- 预收息
            ,real_cp_noamrt -- 不摊销净价成本
            ,chg_fv_noamrt -- 不摊销公允价值变动
            ,prft_fv_noamrt -- 不摊销公允价值损益
            ,prft_trd_noamrt -- 不摊销买卖损益
            ,amrt_date_old -- 重置前摊销日期
            ,amrt_method -- 摊销算法
            ,real_volume_termcur -- 货币对反向实际数量
            ,real_amount_termcur -- 货币对反向实际面值
            ,due_amount_termcur -- 货币对反向结转面值
            ,real_cp_termcur -- 货币对反向实际成本
            ,due_cp_termcur -- 货币对反向结转成本
            ,prft_ir_amrt_rc -- 重分类利息收入（摊销部分）
            ,prft_ir_amrt_hld_rc -- 重分类利息收入（当前持仓摊销部分）
            ,amrt_cost_cp_rc -- 重分类摊余净价成本
            ,amrt_ytm_rc -- 重分类实际利率
            ,amrt_ir_hp_rc -- 重分类利息调整（高精度）
            ,calc_date -- 重置后计提摊销截止日期
            ,calc_date_old -- 重置前计提摊销截止日期
            ,ipr_state -- 减值状态：0-未减值，1-减值，2-核销
            ,ipr_prft_cp -- 成本减值损失
            ,ipr_prft_ai -- 利息减值损失
            ,ipr_cp -- 成本减值准备
            ,ipr_hx_cp -- 已核销成本
            ,ipr_hx_ai -- 已核销应计利息
            ,ipr_hx_due_ai -- 已核销应收未收利息
            ,ipr_bw_ai -- 表外应计利息
            ,ipr_bw_due_ai -- 表外应收未收利息
            ,amrt_date_rc_old -- 重置前重分类摊销开始日期
            ,amrt_date_rc -- 重置后重分类摊销开始日期
            ,amrt_cost_ai_rc -- 重分类摊销开始日期利息成本
            ,open_date_rc_old -- 重置前重分类开仓日期
            ,open_date_rc -- 重置后重分类开仓日期
            ,prft_ir_ai_calc_tax -- 应计利息收入增量
            ,tax_ai -- 应计增值税
            ,tax_due_ai -- 应付增值税
            ,tax_fee -- 费用收入税/支出税
            ,fv_currency_old -- 重置前估值币种
            ,fv_currency -- 重置后估值币种
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
            ,amrt_verify_code_old -- 重置前摊销验证码
            ,amrt_verify_code -- 重置后摊销验证码
            ,amrt_verify_date_old -- 重置前摊销验证日期
            ,amrt_verify_date -- 重置后摊销验证日期
            ,prft_reclass -- 重分类损益
            ,close_set_date -- 平仓交割日期
            ,close_set_date_old -- 重置前平仓交割日期
            ,trade_inst_id -- 交易指令号
            ,trade_inst_id_old -- 重置前交易指令号
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
            ,calc_tax_amrt_cur -- 计提摊销利息收入
            ,calc_tax_amrt_due -- 应收摊销利息收入
            ,calc_tax_amrt_cash -- 实收摊销利息收入
            ,tax_fv -- 未实现损益暂估税
            ,tax_ir -- 利息收入暂估税
            ,tax_due_ir -- 利息收入应付增值税
            ,prft_id -- 损益对象id
            ,prft_id_old -- 老损益对象id
            ,deviation -- 偏离金额
            ,prft_ir_fut_ai -- 预收息利息收入
            ,f_chg_fv_sub -- 公允价值变动（全冲全提冲减量）
            ,f_chg_fv_add -- 公允价值变动（全冲全提增加量）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_accounting_secu_chg_his_op(
            chg_id -- 变动Id
            ,erase_ref_chg_id -- 撤销关联变动Id
            ,tsk_id -- 任务Id
            ,chg_date -- 变动日期
            ,chg_type -- 变动类型
            ,acctg_obj_id -- 对象Id
            ,inst_id -- 指令Id
            ,ext_secu_acct_id -- 外部券账户
            ,secu_acct_id -- 内部券账户
            ,trade_grp_id -- 组合交易号
            ,i_code -- 金融工具代码
            ,a_type -- 金融工具资产类型
            ,m_type -- 金融工具市场类型
            ,trade_id -- 交易号
            ,extra_dim -- 额外维度
            ,estd_or_real -- E：理论核算；R：实际核算
            ,real_volume -- 数量
            ,real_amount -- 余额
            ,real_cp -- 净价成本
            ,ai -- 应计利息
            ,ai_cost -- 利息成本
            ,ai2ri -- 应计转应收未收
            ,ri2pi -- 应收未收转实收
            ,ai_fillup_estd -- 应计利息理论补计提
            ,ai_fillup_real -- 应计利息实际补计提
            ,chg_fv -- 公允价值变动
            ,chg_fv_l -- 公允价值损益(资产部分)
            ,chg_fv_s -- 公允价值损益(负债部分)
            ,due_amount -- 应收未收余额
            ,due_cp -- 应收未收净价成本
            ,due_ai -- 应收未收应计利息
            ,amrt_count -- 当天摊销业务次数
            ,amrt_date -- 摊销日期
            ,amrt_ir -- 利息调整
            ,prft_fv -- 公允价值损益
            ,prft_trd -- 买卖损益
            ,prft_ir -- 利息收入
            ,prft_ir_ai -- 应计利息利息收入
            ,prft_ir_amrt -- 摊销利息收入
            ,prft_ir_ai_hld -- 当前持仓应计利息利息收入
            ,prft_ir_amrt_hld -- 当前持仓摊销利息收入
            ,reclass_prft_fv -- 重分类公允价值损益
            ,impair -- 减值准备
            ,prft_impair -- 减值损失
            ,real_margin -- 期货保证金
            ,update_time -- 更新时间
            ,prft_fee -- 费用
            ,due_fee -- 应付费用
            ,fee -- 费用成本
            ,amrt_cost_cp -- 摊余净价成本
            ,amrt_cost_ai -- 摊余利息成本
            ,biz_date -- 业务日期
            ,his_amrt_date -- 历史摊销开始日期
            ,amrt_ir_hp -- 利息调整(高精度)
            ,amrt_ytm -- 实际利率
            ,invest_ytm -- 投资收益率
            ,process -- 核算过程
            ,open_ytm -- 开仓收益率
            ,future_ai -- 预收息
            ,real_cp_noamrt -- 不摊销净价成本
            ,chg_fv_noamrt -- 不摊销公允价值变动
            ,prft_fv_noamrt -- 不摊销公允价值损益
            ,prft_trd_noamrt -- 不摊销买卖损益
            ,amrt_date_old -- 重置前摊销日期
            ,amrt_method -- 摊销算法
            ,real_volume_termcur -- 货币对反向实际数量
            ,real_amount_termcur -- 货币对反向实际面值
            ,due_amount_termcur -- 货币对反向结转面值
            ,real_cp_termcur -- 货币对反向实际成本
            ,due_cp_termcur -- 货币对反向结转成本
            ,prft_ir_amrt_rc -- 重分类利息收入（摊销部分）
            ,prft_ir_amrt_hld_rc -- 重分类利息收入（当前持仓摊销部分）
            ,amrt_cost_cp_rc -- 重分类摊余净价成本
            ,amrt_ytm_rc -- 重分类实际利率
            ,amrt_ir_hp_rc -- 重分类利息调整（高精度）
            ,calc_date -- 重置后计提摊销截止日期
            ,calc_date_old -- 重置前计提摊销截止日期
            ,ipr_state -- 减值状态：0-未减值，1-减值，2-核销
            ,ipr_prft_cp -- 成本减值损失
            ,ipr_prft_ai -- 利息减值损失
            ,ipr_cp -- 成本减值准备
            ,ipr_hx_cp -- 已核销成本
            ,ipr_hx_ai -- 已核销应计利息
            ,ipr_hx_due_ai -- 已核销应收未收利息
            ,ipr_bw_ai -- 表外应计利息
            ,ipr_bw_due_ai -- 表外应收未收利息
            ,amrt_date_rc_old -- 重置前重分类摊销开始日期
            ,amrt_date_rc -- 重置后重分类摊销开始日期
            ,amrt_cost_ai_rc -- 重分类摊销开始日期利息成本
            ,open_date_rc_old -- 重置前重分类开仓日期
            ,open_date_rc -- 重置后重分类开仓日期
            ,prft_ir_ai_calc_tax -- 应计利息收入增量
            ,tax_ai -- 应计增值税
            ,tax_due_ai -- 应付增值税
            ,tax_fee -- 费用收入税/支出税
            ,fv_currency_old -- 重置前估值币种
            ,fv_currency -- 重置后估值币种
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
            ,amrt_verify_code_old -- 重置前摊销验证码
            ,amrt_verify_code -- 重置后摊销验证码
            ,amrt_verify_date_old -- 重置前摊销验证日期
            ,amrt_verify_date -- 重置后摊销验证日期
            ,prft_reclass -- 重分类损益
            ,close_set_date -- 平仓交割日期
            ,close_set_date_old -- 重置前平仓交割日期
            ,trade_inst_id -- 交易指令号
            ,trade_inst_id_old -- 重置前交易指令号
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
            ,calc_tax_amrt_cur -- 计提摊销利息收入
            ,calc_tax_amrt_due -- 应收摊销利息收入
            ,calc_tax_amrt_cash -- 实收摊销利息收入
            ,tax_fv -- 未实现损益暂估税
            ,tax_ir -- 利息收入暂估税
            ,tax_due_ir -- 利息收入应付增值税
            ,prft_id -- 损益对象id
            ,prft_id_old -- 老损益对象id
            ,deviation -- 偏离金额
            ,prft_ir_fut_ai -- 预收息利息收入
            ,f_chg_fv_sub -- 公允价值变动（全冲全提冲减量）
            ,f_chg_fv_add -- 公允价值变动（全冲全提增加量）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.chg_id -- 变动Id
    ,o.erase_ref_chg_id -- 撤销关联变动Id
    ,o.tsk_id -- 任务Id
    ,o.chg_date -- 变动日期
    ,o.chg_type -- 变动类型
    ,o.acctg_obj_id -- 对象Id
    ,o.inst_id -- 指令Id
    ,o.ext_secu_acct_id -- 外部券账户
    ,o.secu_acct_id -- 内部券账户
    ,o.trade_grp_id -- 组合交易号
    ,o.i_code -- 金融工具代码
    ,o.a_type -- 金融工具资产类型
    ,o.m_type -- 金融工具市场类型
    ,o.trade_id -- 交易号
    ,o.extra_dim -- 额外维度
    ,o.estd_or_real -- E：理论核算；R：实际核算
    ,o.real_volume -- 数量
    ,o.real_amount -- 余额
    ,o.real_cp -- 净价成本
    ,o.ai -- 应计利息
    ,o.ai_cost -- 利息成本
    ,o.ai2ri -- 应计转应收未收
    ,o.ri2pi -- 应收未收转实收
    ,o.ai_fillup_estd -- 应计利息理论补计提
    ,o.ai_fillup_real -- 应计利息实际补计提
    ,o.chg_fv -- 公允价值变动
    ,o.chg_fv_l -- 公允价值损益(资产部分)
    ,o.chg_fv_s -- 公允价值损益(负债部分)
    ,o.due_amount -- 应收未收余额
    ,o.due_cp -- 应收未收净价成本
    ,o.due_ai -- 应收未收应计利息
    ,o.amrt_count -- 当天摊销业务次数
    ,o.amrt_date -- 摊销日期
    ,o.amrt_ir -- 利息调整
    ,o.prft_fv -- 公允价值损益
    ,o.prft_trd -- 买卖损益
    ,o.prft_ir -- 利息收入
    ,o.prft_ir_ai -- 应计利息利息收入
    ,o.prft_ir_amrt -- 摊销利息收入
    ,o.prft_ir_ai_hld -- 当前持仓应计利息利息收入
    ,o.prft_ir_amrt_hld -- 当前持仓摊销利息收入
    ,o.reclass_prft_fv -- 重分类公允价值损益
    ,o.impair -- 减值准备
    ,o.prft_impair -- 减值损失
    ,o.real_margin -- 期货保证金
    ,o.update_time -- 更新时间
    ,o.prft_fee -- 费用
    ,o.due_fee -- 应付费用
    ,o.fee -- 费用成本
    ,o.amrt_cost_cp -- 摊余净价成本
    ,o.amrt_cost_ai -- 摊余利息成本
    ,o.biz_date -- 业务日期
    ,o.his_amrt_date -- 历史摊销开始日期
    ,o.amrt_ir_hp -- 利息调整(高精度)
    ,o.amrt_ytm -- 实际利率
    ,o.invest_ytm -- 投资收益率
    ,o.process -- 核算过程
    ,o.open_ytm -- 开仓收益率
    ,o.future_ai -- 预收息
    ,o.real_cp_noamrt -- 不摊销净价成本
    ,o.chg_fv_noamrt -- 不摊销公允价值变动
    ,o.prft_fv_noamrt -- 不摊销公允价值损益
    ,o.prft_trd_noamrt -- 不摊销买卖损益
    ,o.amrt_date_old -- 重置前摊销日期
    ,o.amrt_method -- 摊销算法
    ,o.real_volume_termcur -- 货币对反向实际数量
    ,o.real_amount_termcur -- 货币对反向实际面值
    ,o.due_amount_termcur -- 货币对反向结转面值
    ,o.real_cp_termcur -- 货币对反向实际成本
    ,o.due_cp_termcur -- 货币对反向结转成本
    ,o.prft_ir_amrt_rc -- 重分类利息收入（摊销部分）
    ,o.prft_ir_amrt_hld_rc -- 重分类利息收入（当前持仓摊销部分）
    ,o.amrt_cost_cp_rc -- 重分类摊余净价成本
    ,o.amrt_ytm_rc -- 重分类实际利率
    ,o.amrt_ir_hp_rc -- 重分类利息调整（高精度）
    ,o.calc_date -- 重置后计提摊销截止日期
    ,o.calc_date_old -- 重置前计提摊销截止日期
    ,o.ipr_state -- 减值状态：0-未减值，1-减值，2-核销
    ,o.ipr_prft_cp -- 成本减值损失
    ,o.ipr_prft_ai -- 利息减值损失
    ,o.ipr_cp -- 成本减值准备
    ,o.ipr_hx_cp -- 已核销成本
    ,o.ipr_hx_ai -- 已核销应计利息
    ,o.ipr_hx_due_ai -- 已核销应收未收利息
    ,o.ipr_bw_ai -- 表外应计利息
    ,o.ipr_bw_due_ai -- 表外应收未收利息
    ,o.amrt_date_rc_old -- 重置前重分类摊销开始日期
    ,o.amrt_date_rc -- 重置后重分类摊销开始日期
    ,o.amrt_cost_ai_rc -- 重分类摊销开始日期利息成本
    ,o.open_date_rc_old -- 重置前重分类开仓日期
    ,o.open_date_rc -- 重置后重分类开仓日期
    ,o.prft_ir_ai_calc_tax -- 应计利息收入增量
    ,o.tax_ai -- 应计增值税
    ,o.tax_due_ai -- 应付增值税
    ,o.tax_fee -- 费用收入税/支出税
    ,o.fv_currency_old -- 重置前估值币种
    ,o.fv_currency -- 重置后估值币种
    ,o.set_date -- 结算日期
    ,o.prft_fv_cash -- 已实现公允价值变动损益
    ,o.tax_ai_hld -- 当前持仓利息收入税/支出税
    ,o.open_ai -- 开仓利息成本
    ,o.open_ytm_opt -- 开仓行权收益率
    ,o.prft_ir_ai_fut -- 预收利息收入
    ,o.prft_ir_ai_cur -- 计提利息收入
    ,o.prft_ir_ai_due -- 应收利息收入
    ,o.prft_ir_ai_cash -- 实收利息收入
    ,o.tax_fut_ai -- 计提利息收入预收税
    ,o.tax_due_amrt -- 摊销利息收入应付增值税
    ,o.tax_due_amrt_rc -- 重分类后资本公积摊销收入应付增值税
    ,o.tax_due_trd -- 买卖损益应付增值税
    ,o.tax_due_fv -- 公允价值损益应付增值税
    ,o.tax_due_fv_reclass -- 重分类公允价值损益应付增值税
    ,o.tax_due_fv_cash -- 已实现公允价值损益应付增值税
    ,o.tax_due_fee -- 费用损益应付增值税
    ,o.due_chg_fv -- 结转公允价值变动
    ,o.due_volume -- 结转数量
    ,o.amrt_verify_code_old -- 重置前摊销验证码
    ,o.amrt_verify_code -- 重置后摊销验证码
    ,o.amrt_verify_date_old -- 重置前摊销验证日期
    ,o.amrt_verify_date -- 重置后摊销验证日期
    ,o.prft_reclass -- 重分类损益
    ,o.close_set_date -- 平仓交割日期
    ,o.close_set_date_old -- 重置前平仓交割日期
    ,o.trade_inst_id -- 交易指令号
    ,o.trade_inst_id_old -- 重置前交易指令号
    ,o.custom_dim1 -- 扩展维度1
    ,o.ipr_period -- 减值阶段
    ,o.ipr_cp1 -- 阶段一减值准备
    ,o.ipr_cp2 -- 阶段二减值准备
    ,o.ipr_cp3 -- 阶段三减值准备
    ,o.ipr_prft_cp1 -- 阶段一减值损失
    ,o.ipr_prft_cp2 -- 阶段二减值损失
    ,o.ipr_prft_cp3 -- 阶段三减值损失
    ,o.amrt_start_ir_hp -- 摊销开始日期初利息调整余额(高精度)
    ,o.tax_amrt -- 摊销利息收入暂估税
    ,o.calc_tax_amrt_cur -- 计提摊销利息收入
    ,o.calc_tax_amrt_due -- 应收摊销利息收入
    ,o.calc_tax_amrt_cash -- 实收摊销利息收入
    ,o.tax_fv -- 未实现损益暂估税
    ,o.tax_ir -- 利息收入暂估税
    ,o.tax_due_ir -- 利息收入应付增值税
    ,o.prft_id -- 损益对象id
    ,o.prft_id_old -- 老损益对象id
    ,o.deviation -- 偏离金额
    ,o.prft_ir_fut_ai -- 预收息利息收入
    ,o.f_chg_fv_sub -- 公允价值变动（全冲全提冲减量）
    ,o.f_chg_fv_add -- 公允价值变动（全冲全提增加量）
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_accounting_secu_chg_his_bk o
    left join ${iol_schema}.ibms_ttrd_accounting_secu_chg_his_op n
        on
            o.chg_id = n.chg_id
            and o.tsk_id = n.tsk_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_accounting_secu_chg_his_cl d
        on
            o.chg_id = d.chg_id
            and o.tsk_id = d.tsk_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ibms_ttrd_accounting_secu_chg_his;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_ttrd_accounting_secu_chg_his exchange partition p_19000101 with table ${iol_schema}.ibms_ttrd_accounting_secu_chg_his_cl;
alter table ${iol_schema}.ibms_ttrd_accounting_secu_chg_his exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_accounting_secu_chg_his_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_accounting_secu_chg_his to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_accounting_secu_chg_his_op purge;
drop table ${iol_schema}.ibms_ttrd_accounting_secu_chg_his_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_accounting_secu_chg_his_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_accounting_secu_chg_his',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
