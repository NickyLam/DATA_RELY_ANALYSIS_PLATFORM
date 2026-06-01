/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_accounting_secu_obj
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_accounting_secu_obj
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_accounting_secu_obj purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_accounting_secu_obj(
    obj_id varchar2(45) -- 对象id
    ,tsk_id varchar2(45) -- 任务id
    ,beg_date varchar2(15) -- 开始日期
    ,end_date varchar2(15) -- 结束日期
    ,ext_secu_acct_id varchar2(30) -- 外部券账户
    ,secu_acct_id varchar2(45) -- 内部券账户
    ,trade_grp_id varchar2(30) -- 组合交易号
    ,i_code varchar2(120) -- 金融工具代码
    ,a_type varchar2(30) -- 金融工具资产类型
    ,m_type varchar2(30) -- 金融工具资产类型
    ,trade_id varchar2(45) -- 交易号
    ,extra_dim varchar2(15) -- 额外维度
    ,real_volume number(31,8) -- 数量
    ,real_amount number(31,8) -- 余额
    ,real_cp number(31,8) -- 净价成本
    ,ai number(31,8) -- 应计利息
    ,ai_cost number(31,8) -- 利息成本
    ,chg_fv number(31,8) -- 公允价值变动
    ,due_amount number(31,8) -- 应收未收余额
    ,due_cp number(31,8) -- 应收未收净价成本
    ,due_ai number(31,8) -- 应收未收应计利息
    ,amrt_count number(8,0) -- 当天摊销业务次数
    ,amrt_date varchar2(15) -- 摊销日期
    ,amrt_ir number(31,8) -- 利息调整
    ,prft_fv number(31,8) -- 公允价值损益
    ,prft_trd number(31,8) -- 买卖损益
    ,prft_ir number(31,8) -- 利息收入
    ,prft_ir_ai number(31,8) -- 应计利息利息收入
    ,prft_ir_amrt number(31,8) -- 摊销利息收入
    ,prft_ir_ai_hld number(31,8) -- 当前持仓应计利息利息收入
    ,prft_ir_amrt_hld number(31,8) -- 当前持仓摊销利息收入
    ,reclass_prft_fv number(31,8) -- 重分类公允价值损益
    ,impair number(31,8) -- 减值准备
    ,prft_impair number(31,8) -- 减值损失
    ,real_margin number(31,8) -- 期货保证金
    ,open_time varchar2(29) -- 开仓时间
    ,update_time varchar2(29) -- 更新时间
    ,prft_fee number(31,4) -- 费用
    ,due_fee number(31,4) -- 应付费用
    ,fee number(31,8) -- 费用成本
    ,amrt_cost_cp number(31,15) -- 摊余净价成本
    ,amrt_cost_ai number(31,15) -- 摊余利息成本
    ,amrt_ir_hp number(31,15) -- 利息调整(高精度)
    ,amrt_ytm number(31,15) -- 实际利率
    ,invest_ytm number(31,15) -- 投资收益率
    ,open_ytm number(31,15) -- 开仓收益率
    ,future_ai number(31,8) -- 预收息
    ,real_cp_noamrt number(31,8) -- 不摊销净价成本
    ,chg_fv_noamrt number(31,8) -- 不摊销公允价值变动
    ,prft_fv_noamrt number(31,8) -- 不摊销公允价值损益
    ,prft_trd_noamrt number(31,8) -- 不摊销买卖损益
    ,amrt_method number(22) -- 摊销算法
    ,real_volume_termcur number(31,8) -- 货币对反向实际数量
    ,real_amount_termcur number(31,8) -- 货币对反向实际面值
    ,due_amount_termcur number(31,8) -- 货币对反向结转面值
    ,real_cp_termcur number(31,8) -- 货币对反向实际成本
    ,due_cp_termcur number(31,8) -- 货币对反向结转成本
    ,prft_ir_amrt_rc number(31,8) -- 重分类利息收入（摊销部分）
    ,prft_ir_amrt_hld_rc number(31,8) -- 重分类利息收入（当前持仓摊销部分）
    ,amrt_cost_cp_rc number(31,15) -- 重分类摊余净价成本
    ,amrt_ytm_rc number(31,15) -- 重分类实际利率
    ,amrt_ir_hp_rc number(31,15) -- 重分类利息调整（高精度）
    ,calc_date varchar2(15) -- 计提摊销截止日期
    ,ipr_state number(4,0) -- 减值状态：0-未减值，1-减值，2-核销
    ,ipr_prft_cp number(31,8) -- 成本减值损失
    ,ipr_prft_ai number(31,8) -- 利息减值损失
    ,ipr_cp number(31,8) -- 成本减值准备
    ,ipr_hx_cp number(31,8) -- 已核销成本
    ,ipr_hx_ai number(31,8) -- 已核销应计利息
    ,ipr_hx_due_ai number(31,8) -- 已核销应收未收利息
    ,ipr_bw_ai number(31,8) -- 表外应计利息
    ,ipr_bw_due_ai number(31,8) -- 表外应收未收利息
    ,amrt_date_rc varchar2(15) -- 重分类摊销开始日期
    ,amrt_cost_ai_rc number(31,15) -- 重分类摊销开始日期利息成本
    ,open_date_rc varchar2(15) -- 重分类开仓日期
    ,prft_ir_ai_calc_tax number(31,8) -- 应计利息收入增量
    ,tax_ai number(31,8) -- 应计增值税
    ,tax_due_ai number(31,8) -- 应付增值税
    ,tax_fee number(31,8) -- 费用收入税/支出税
    ,fv_currency varchar2(5) -- 估值币种
    ,set_date varchar2(15) -- 结算日期
    ,prft_fv_cash number(31,8) -- 已实现公允价值变动损益
    ,tax_ai_hld number(31,8) -- 当前持仓利息收入税/支出税
    ,open_ai number(31,8) -- 开仓利息成本
    ,open_ytm_opt number(31,15) -- 开仓行权收益率
    ,prft_ir_ai_fut number(31,8) -- 预收利息收入
    ,prft_ir_ai_cur number(31,8) -- 计提利息收入
    ,prft_ir_ai_due number(31,8) -- 应收利息收入
    ,prft_ir_ai_cash number(31,8) -- 实收利息收入
    ,tax_fut_ai number(31,8) -- 计提利息收入预收税
    ,tax_due_amrt number(31,8) -- 摊销利息收入应付增值税
    ,tax_due_amrt_rc number(31,8) -- 重分类后资本公积摊销收入应付增值税
    ,tax_due_trd number(31,8) -- 买卖损益应付增值税
    ,tax_due_fv number(31,8) -- 公允价值损益应付增值税
    ,tax_due_fv_reclass number(31,8) -- 重分类公允价值损益应付增值税
    ,tax_due_fv_cash number(31,8) -- 已实现公允价值损益应付增值税
    ,tax_due_fee number(31,8) -- 费用损益应付增值税
    ,due_chg_fv number(31,8) -- 结转公允价值变动
    ,due_volume number(31,8) -- 结转数量
    ,amrt_verify_code varchar2(450) -- 摊销验证码
    ,amrt_verify_date varchar2(15) -- 摊销验证日期
    ,prft_reclass number(31,8) -- 重分类损益
    ,close_set_date varchar2(15) -- 平仓交割日期
    ,trade_inst_id number(16,0) -- 交易指令号
    ,custom_dim1 varchar2(300) -- 扩展维度1
    ,ipr_period number(22) -- 减值阶段
    ,ipr_cp1 number(31,8) -- 阶段一减值准备
    ,ipr_cp2 number(31,8) -- 阶段二减值准备
    ,ipr_cp3 number(31,8) -- 阶段三减值准备
    ,ipr_prft_cp1 number(31,8) -- 阶段一减值损失
    ,ipr_prft_cp2 number(31,8) -- 阶段二减值损失
    ,ipr_prft_cp3 number(31,8) -- 阶段三减值损失
    ,amrt_start_ir_hp number(31,15) -- 摊销开始日期初利息调整余额(高精度)
    ,tax_amrt number(31,8) -- 摊销利息收入暂估税
    ,calc_tax_amrt_cur number(31,8) -- 计提摊销利息收入
    ,calc_tax_amrt_due number(31,8) -- 应收摊销利息收入
    ,calc_tax_amrt_cash number(31,8) -- 实收摊销利息收入
    ,tax_fv number(31,8) -- 未实现损益暂估税
    ,tax_ir number(31,8) -- 利息收入暂估税
    ,tax_due_ir number(32,9) -- 利息收入应付增值税
    ,prft_id varchar2(45) -- 损益对象id
    ,deviation number(31,8) -- 偏离金额
    ,prft_ir_fut_ai number(31,8) -- 预收息利息收入
    ,obj_type varchar2(15) -- 余额类型 -1 正常余额 1 逾期豁免余额
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ibms_ttrd_accounting_secu_obj to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_accounting_secu_obj to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_accounting_secu_obj to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_accounting_secu_obj to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_accounting_secu_obj is '券核算余额表';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.obj_id is '对象id';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.tsk_id is '任务id';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.beg_date is '开始日期';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.end_date is '结束日期';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.ext_secu_acct_id is '外部券账户';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.secu_acct_id is '内部券账户';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.trade_grp_id is '组合交易号';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.a_type is '金融工具资产类型';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.m_type is '金融工具资产类型';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.trade_id is '交易号';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.extra_dim is '额外维度';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.real_volume is '数量';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.real_amount is '余额';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.real_cp is '净价成本';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.ai is '应计利息';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.ai_cost is '利息成本';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.chg_fv is '公允价值变动';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.due_amount is '应收未收余额';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.due_cp is '应收未收净价成本';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.due_ai is '应收未收应计利息';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.amrt_count is '当天摊销业务次数';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.amrt_date is '摊销日期';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.amrt_ir is '利息调整';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.prft_fv is '公允价值损益';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.prft_trd is '买卖损益';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.prft_ir is '利息收入';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.prft_ir_ai is '应计利息利息收入';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.prft_ir_amrt is '摊销利息收入';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.prft_ir_ai_hld is '当前持仓应计利息利息收入';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.prft_ir_amrt_hld is '当前持仓摊销利息收入';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.reclass_prft_fv is '重分类公允价值损益';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.impair is '减值准备';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.prft_impair is '减值损失';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.real_margin is '期货保证金';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.open_time is '开仓时间';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.update_time is '更新时间';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.prft_fee is '费用';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.due_fee is '应付费用';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.fee is '费用成本';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.amrt_cost_cp is '摊余净价成本';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.amrt_cost_ai is '摊余利息成本';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.amrt_ir_hp is '利息调整(高精度)';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.amrt_ytm is '实际利率';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.invest_ytm is '投资收益率';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.open_ytm is '开仓收益率';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.future_ai is '预收息';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.real_cp_noamrt is '不摊销净价成本';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.chg_fv_noamrt is '不摊销公允价值变动';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.prft_fv_noamrt is '不摊销公允价值损益';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.prft_trd_noamrt is '不摊销买卖损益';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.amrt_method is '摊销算法';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.real_volume_termcur is '货币对反向实际数量';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.real_amount_termcur is '货币对反向实际面值';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.due_amount_termcur is '货币对反向结转面值';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.real_cp_termcur is '货币对反向实际成本';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.due_cp_termcur is '货币对反向结转成本';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.prft_ir_amrt_rc is '重分类利息收入（摊销部分）';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.prft_ir_amrt_hld_rc is '重分类利息收入（当前持仓摊销部分）';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.amrt_cost_cp_rc is '重分类摊余净价成本';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.amrt_ytm_rc is '重分类实际利率';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.amrt_ir_hp_rc is '重分类利息调整（高精度）';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.calc_date is '计提摊销截止日期';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.ipr_state is '减值状态：0-未减值，1-减值，2-核销';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.ipr_prft_cp is '成本减值损失';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.ipr_prft_ai is '利息减值损失';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.ipr_cp is '成本减值准备';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.ipr_hx_cp is '已核销成本';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.ipr_hx_ai is '已核销应计利息';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.ipr_hx_due_ai is '已核销应收未收利息';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.ipr_bw_ai is '表外应计利息';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.ipr_bw_due_ai is '表外应收未收利息';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.amrt_date_rc is '重分类摊销开始日期';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.amrt_cost_ai_rc is '重分类摊销开始日期利息成本';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.open_date_rc is '重分类开仓日期';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.prft_ir_ai_calc_tax is '应计利息收入增量';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.tax_ai is '应计增值税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.tax_due_ai is '应付增值税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.tax_fee is '费用收入税/支出税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.fv_currency is '估值币种';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.set_date is '结算日期';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.prft_fv_cash is '已实现公允价值变动损益';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.tax_ai_hld is '当前持仓利息收入税/支出税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.open_ai is '开仓利息成本';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.open_ytm_opt is '开仓行权收益率';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.prft_ir_ai_fut is '预收利息收入';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.prft_ir_ai_cur is '计提利息收入';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.prft_ir_ai_due is '应收利息收入';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.prft_ir_ai_cash is '实收利息收入';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.tax_fut_ai is '计提利息收入预收税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.tax_due_amrt is '摊销利息收入应付增值税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.tax_due_amrt_rc is '重分类后资本公积摊销收入应付增值税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.tax_due_trd is '买卖损益应付增值税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.tax_due_fv is '公允价值损益应付增值税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.tax_due_fv_reclass is '重分类公允价值损益应付增值税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.tax_due_fv_cash is '已实现公允价值损益应付增值税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.tax_due_fee is '费用损益应付增值税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.due_chg_fv is '结转公允价值变动';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.due_volume is '结转数量';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.amrt_verify_code is '摊销验证码';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.amrt_verify_date is '摊销验证日期';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.prft_reclass is '重分类损益';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.close_set_date is '平仓交割日期';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.trade_inst_id is '交易指令号';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.custom_dim1 is '扩展维度1';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.ipr_period is '减值阶段';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.ipr_cp1 is '阶段一减值准备';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.ipr_cp2 is '阶段二减值准备';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.ipr_cp3 is '阶段三减值准备';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.ipr_prft_cp1 is '阶段一减值损失';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.ipr_prft_cp2 is '阶段二减值损失';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.ipr_prft_cp3 is '阶段三减值损失';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.amrt_start_ir_hp is '摊销开始日期初利息调整余额(高精度)';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.tax_amrt is '摊销利息收入暂估税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.calc_tax_amrt_cur is '计提摊销利息收入';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.calc_tax_amrt_due is '应收摊销利息收入';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.calc_tax_amrt_cash is '实收摊销利息收入';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.tax_fv is '未实现损益暂估税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.tax_ir is '利息收入暂估税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.tax_due_ir is '利息收入应付增值税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.prft_id is '损益对象id';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.deviation is '偏离金额';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.prft_ir_fut_ai is '预收息利息收入';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.obj_type is '余额类型 -1 正常余额 1 逾期豁免余额';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj.etl_timestamp is 'ETL处理时间戳';
