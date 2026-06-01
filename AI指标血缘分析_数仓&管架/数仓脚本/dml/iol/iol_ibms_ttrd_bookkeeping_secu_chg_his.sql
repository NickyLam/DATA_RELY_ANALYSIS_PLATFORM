/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_bookkeeping_secu_chg_his
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_bookkeeping_secu_chg_his_ex purge;
alter table ${iol_schema}.ibms_ttrd_bookkeeping_secu_chg_his add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ibms_ttrd_bookkeeping_secu_chg_his truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ibms_ttrd_bookkeeping_secu_chg_his_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_bookkeeping_secu_chg_his where 0=1;

insert /*+ append */ into ${iol_schema}.ibms_ttrd_bookkeeping_secu_chg_his_ex(
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
    ,periodic_ai -- 本周期应计利息
    ,periodic_amrt_ir -- 本周期利息调整
    ,periodic_chg_fv -- 本周期公允价值变动
    ,periodic_chg_fv_l -- 本周期公允价值变动(资产部分)
    ,periodic_chg_fv_s -- 本周期公允价值变动(负债部分)
    ,prft_fee -- 费用
    ,due_fee -- 应付费用
    ,fee -- 费用成本
    ,periodic_fee -- 本周期费用成本
    ,amrt_cost_cp -- 摊余净价成本
    ,amrt_cost_ai -- 摊余利息成本
    ,amrt_ytm -- 实际利率
    ,invest_ytm -- 投资收益率
    ,open_ytm -- 开仓收益率
    ,future_ai -- 预收息
    ,real_cp_noamrt -- 不摊销净价成本
    ,chg_fv_noamrt -- 不摊销公允价值变动
    ,prft_fv_noamrt -- 不摊销公允价值损益
    ,prft_trd_noamrt -- 不摊销买卖损益
    ,amrt_date_old -- 重置前摊销日期
    ,real_volume_termcur -- 货币对反向实际数量
    ,real_amount_termcur -- 货币对反向实际面值
    ,due_amount_termcur -- 货币对反向结转面值
    ,real_cp_termcur -- 货币对反向实际成本
    ,due_cp_termcur -- 货币对反向结转成本
    ,prft_ir_amrt_rc -- 重分类利息收入（摊销部分）
    ,prft_ir_amrt_hld_rc -- 重分类利息收入（当前持仓摊销部分）
    ,amrt_cost_cp_rc -- 重分类摊余净价成本
    ,amrt_ytm_rc -- 重分类实际利率
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
    ,prft_ir_fut_ai -- 预收息利息收入
    ,ipr_ai3 -- 阶段三减值利息
    ,ipr_prft_ai3 -- 阶段三利息减值损失
    ,deferred_fv_tax -- 估值递延税
    ,deferred_profit_fv_tax -- 损益递延税
    ,deferred_fv_tax_l -- 估值递延税（资产部分）
    ,deferred_fv_tax_s -- 估值递延税（负债部分）
    ,f_chg_fv_sub -- 公允价值变动（全冲全提冲减量）
    ,f_chg_fv_add -- 公允价值变动（全冲全提增加量）
    ,ipr_ai -- 利息减值准备
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
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
    ,periodic_ai -- 本周期应计利息
    ,periodic_amrt_ir -- 本周期利息调整
    ,periodic_chg_fv -- 本周期公允价值变动
    ,periodic_chg_fv_l -- 本周期公允价值变动(资产部分)
    ,periodic_chg_fv_s -- 本周期公允价值变动(负债部分)
    ,prft_fee -- 费用
    ,due_fee -- 应付费用
    ,fee -- 费用成本
    ,periodic_fee -- 本周期费用成本
    ,amrt_cost_cp -- 摊余净价成本
    ,amrt_cost_ai -- 摊余利息成本
    ,amrt_ytm -- 实际利率
    ,invest_ytm -- 投资收益率
    ,open_ytm -- 开仓收益率
    ,future_ai -- 预收息
    ,real_cp_noamrt -- 不摊销净价成本
    ,chg_fv_noamrt -- 不摊销公允价值变动
    ,prft_fv_noamrt -- 不摊销公允价值损益
    ,prft_trd_noamrt -- 不摊销买卖损益
    ,amrt_date_old -- 重置前摊销日期
    ,real_volume_termcur -- 货币对反向实际数量
    ,real_amount_termcur -- 货币对反向实际面值
    ,due_amount_termcur -- 货币对反向结转面值
    ,real_cp_termcur -- 货币对反向实际成本
    ,due_cp_termcur -- 货币对反向结转成本
    ,prft_ir_amrt_rc -- 重分类利息收入（摊销部分）
    ,prft_ir_amrt_hld_rc -- 重分类利息收入（当前持仓摊销部分）
    ,amrt_cost_cp_rc -- 重分类摊余净价成本
    ,amrt_ytm_rc -- 重分类实际利率
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
    ,prft_ir_fut_ai -- 预收息利息收入
    ,ipr_ai3 -- 阶段三减值利息
    ,ipr_prft_ai3 -- 阶段三利息减值损失
    ,deferred_fv_tax -- 估值递延税
    ,deferred_profit_fv_tax -- 损益递延税
    ,deferred_fv_tax_l -- 估值递延税（资产部分）
    ,deferred_fv_tax_s -- 估值递延税（负债部分）
    ,f_chg_fv_sub -- 公允价值变动（全冲全提冲减量）
    ,f_chg_fv_add -- 公允价值变动（全冲全提增加量）
    ,ipr_ai -- 利息减值准备
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ibms_ttrd_bookkeeping_secu_chg_his
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ibms_ttrd_bookkeeping_secu_chg_his exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_bookkeeping_secu_chg_his_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_bookkeeping_secu_chg_his to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ibms_ttrd_bookkeeping_secu_chg_his_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_bookkeeping_secu_chg_his',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);