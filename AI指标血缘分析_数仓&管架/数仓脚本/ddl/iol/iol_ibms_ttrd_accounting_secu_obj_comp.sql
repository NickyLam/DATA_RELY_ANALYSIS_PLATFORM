/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_accounting_secu_obj_comp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp(
    obj_id varchar2(45) -- 
    ,tsk_id varchar2(45) -- 
    ,beg_date varchar2(15) -- 
    ,end_date varchar2(15) -- 
    ,ext_secu_acct_id varchar2(30) -- 
    ,secu_acct_id varchar2(45) -- 
    ,trade_grp_id varchar2(30) -- 
    ,i_code varchar2(120) -- 
    ,a_type varchar2(30) -- 
    ,m_type varchar2(30) -- 
    ,trade_id varchar2(45) -- 
    ,extra_dim varchar2(15) -- 
    ,real_volume number(31,8) -- 
    ,real_amount number(31,8) -- 
    ,real_cp number(31,8) -- 
    ,ai number(31,8) -- 
    ,ai_cost number(31,8) -- 
    ,chg_fv number(31,8) -- 
    ,due_amount number(31,8) -- 
    ,due_cp number(31,8) -- 
    ,due_ai number(31,8) -- 
    ,amrt_count number(8,0) -- 
    ,amrt_date varchar2(15) -- 
    ,amrt_ir number(31,8) -- 
    ,prft_fv number(31,8) -- 
    ,prft_trd number(31,8) -- 
    ,prft_ir number(31,8) -- 
    ,prft_ir_ai number(31,8) -- 
    ,prft_ir_amrt number(31,8) -- 
    ,prft_ir_ai_hld number(31,8) -- 
    ,prft_ir_amrt_hld number(31,8) -- 
    ,reclass_prft_fv number(31,8) -- 
    ,impair number(31,8) -- 
    ,prft_impair number(31,8) -- 
    ,real_margin number(31,8) -- 
    ,open_time varchar2(29) -- 
    ,update_time varchar2(29) -- 
    ,prft_fee number(31,4) -- 
    ,due_fee number(31,4) -- 
    ,fee number(31,8) -- 
    ,amrt_cost_cp number(31,15) -- 
    ,amrt_cost_ai number(31,15) -- 
    ,amrt_ir_hp number(31,15) -- 
    ,amrt_ytm number(31,15) -- 
    ,invest_ytm number(31,15) -- 
    ,open_ytm number(31,15) -- 
    ,future_ai number(31,8) -- 
    ,real_cp_noamrt number(31,8) -- 
    ,chg_fv_noamrt number(31,8) -- 
    ,prft_fv_noamrt number(31,8) -- 
    ,prft_trd_noamrt number(31,8) -- 
    ,amrt_method number(22) -- 
    ,real_volume_termcur number(31,8) -- 
    ,real_amount_termcur number(31,8) -- 
    ,due_amount_termcur number(31,8) -- 
    ,real_cp_termcur number(31,8) -- 
    ,due_cp_termcur number(31,8) -- 
    ,prft_ir_amrt_rc number(31,8) -- 
    ,prft_ir_amrt_hld_rc number(31,8) -- 
    ,amrt_cost_cp_rc number(31,15) -- 
    ,amrt_ytm_rc number(31,15) -- 
    ,amrt_ir_hp_rc number(31,15) -- 
    ,calc_date varchar2(15) -- 
    ,ipr_state number(4,0) -- 
    ,ipr_prft_cp number(31,8) -- 
    ,ipr_prft_ai number(31,8) -- 
    ,ipr_cp number(31,8) -- 
    ,ipr_hx_cp number(31,8) -- 
    ,ipr_hx_ai number(31,8) -- 
    ,ipr_hx_due_ai number(31,8) -- 
    ,ipr_bw_ai number(31,8) -- 
    ,ipr_bw_due_ai number(31,8) -- 
    ,amrt_date_rc varchar2(15) -- 
    ,amrt_cost_ai_rc number(31,15) -- 
    ,open_date_rc varchar2(15) -- 
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
    ,calc_tax_amrt_cur number(31,8) -- 计提摊销利息收入税
    ,calc_tax_amrt_due number(31,8) -- 应收摊销利息收入税
    ,calc_tax_amrt_cash number(31,8) -- 实收摊销利息收入税
    ,tax_fv number(31,8) -- 未实现损益暂估税
    ,discount_ai number(31,15) -- 贴现利息单张值
    ,tax_due_ai_amrt number(31,8) -- 存储到期、行权、赎回摊销部分拆出来的税
    ,prft_ir_trd number(31,8) -- 买卖损益计为利息收入
    ,tax_due_ai_trd number(31,8) -- 买卖损益计入利息收入产生的税
    ,prft_ir_amrt_cur number(31,8) -- 计提摊销利息收入
    ,prft_ir_amrt_due number(31,8) -- 应收摊销利息收入
    ,prft_ir_amrt_cash number(31,8) -- 实收摊销利息收入
    ,tax_ir number(31,8) -- 利息收入暂估税
    ,tax_due_ir number(31,8) -- 利息收入应付增值税
    ,prft_id varchar2(45) -- 损益对象id
    ,deviation number(31,8) -- 偏离金额
    ,prft_ir_fut_ai number(31,8) -- 预收息利息收入
    ,is_ai_transfered number(22) -- 计利息是否结转
    ,ipr_ai3 number(31,8) -- 阶段三减值利息
    ,ipr_prft_ai3 number(31,8) -- 阶段三利息减值损失
    ,deferred_fv_tax number(31,8) -- 估值递延税
    ,deferred_profit_fv_tax number(31,8) -- 损益递延税
    ,ipr_ai number(31,8) -- 利息减值准备
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
grant select on ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.obj_id is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.tsk_id is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.beg_date is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.end_date is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.ext_secu_acct_id is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.secu_acct_id is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.trade_grp_id is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.i_code is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.a_type is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.m_type is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.trade_id is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.extra_dim is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.real_volume is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.real_amount is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.real_cp is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.ai is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.ai_cost is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.chg_fv is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.due_amount is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.due_cp is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.due_ai is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.amrt_count is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.amrt_date is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.amrt_ir is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_fv is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_trd is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_ir is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_ir_ai is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_ir_amrt is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_ir_ai_hld is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_ir_amrt_hld is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.reclass_prft_fv is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.impair is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_impair is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.real_margin is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.open_time is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.update_time is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_fee is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.due_fee is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.fee is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.amrt_cost_cp is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.amrt_cost_ai is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.amrt_ir_hp is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.amrt_ytm is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.invest_ytm is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.open_ytm is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.future_ai is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.real_cp_noamrt is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.chg_fv_noamrt is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_fv_noamrt is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_trd_noamrt is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.amrt_method is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.real_volume_termcur is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.real_amount_termcur is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.due_amount_termcur is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.real_cp_termcur is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.due_cp_termcur is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_ir_amrt_rc is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_ir_amrt_hld_rc is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.amrt_cost_cp_rc is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.amrt_ytm_rc is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.amrt_ir_hp_rc is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.calc_date is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.ipr_state is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.ipr_prft_cp is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.ipr_prft_ai is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.ipr_cp is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.ipr_hx_cp is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.ipr_hx_ai is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.ipr_hx_due_ai is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.ipr_bw_ai is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.ipr_bw_due_ai is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.amrt_date_rc is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.amrt_cost_ai_rc is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.open_date_rc is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_ir_ai_calc_tax is '应计利息收入增量';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.tax_ai is '应计增值税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.tax_due_ai is '应付增值税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.tax_fee is '费用收入税/支出税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.fv_currency is '估值币种';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.set_date is '结算日期';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_fv_cash is '已实现公允价值变动损益';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.tax_ai_hld is '当前持仓利息收入税/支出税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.open_ai is '开仓利息成本';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.open_ytm_opt is '开仓行权收益率';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_ir_ai_fut is '预收利息收入';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_ir_ai_cur is '计提利息收入';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_ir_ai_due is '应收利息收入';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_ir_ai_cash is '实收利息收入';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.tax_fut_ai is '计提利息收入预收税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.tax_due_amrt is '摊销利息收入应付增值税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.tax_due_amrt_rc is '重分类后资本公积摊销收入应付增值税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.tax_due_trd is '买卖损益应付增值税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.tax_due_fv is '公允价值损益应付增值税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.tax_due_fv_reclass is '重分类公允价值损益应付增值税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.tax_due_fv_cash is '已实现公允价值损益应付增值税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.tax_due_fee is '费用损益应付增值税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.due_chg_fv is '结转公允价值变动';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.due_volume is '结转数量';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.amrt_verify_code is '摊销验证码';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.amrt_verify_date is '摊销验证日期';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_reclass is '重分类损益';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.close_set_date is '平仓交割日期';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.trade_inst_id is '交易指令号';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.custom_dim1 is '扩展维度1';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.ipr_period is '减值阶段';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.ipr_cp1 is '阶段一减值准备';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.ipr_cp2 is '阶段二减值准备';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.ipr_cp3 is '阶段三减值准备';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.ipr_prft_cp1 is '阶段一减值损失';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.ipr_prft_cp2 is '阶段二减值损失';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.ipr_prft_cp3 is '阶段三减值损失';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.amrt_start_ir_hp is '摊销开始日期初利息调整余额(高精度)';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.tax_amrt is '摊销利息收入暂估税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.calc_tax_amrt_cur is '计提摊销利息收入税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.calc_tax_amrt_due is '应收摊销利息收入税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.calc_tax_amrt_cash is '实收摊销利息收入税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.tax_fv is '未实现损益暂估税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.discount_ai is '贴现利息单张值';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.tax_due_ai_amrt is '存储到期、行权、赎回摊销部分拆出来的税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_ir_trd is '买卖损益计为利息收入';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.tax_due_ai_trd is '买卖损益计入利息收入产生的税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_ir_amrt_cur is '计提摊销利息收入';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_ir_amrt_due is '应收摊销利息收入';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_ir_amrt_cash is '实收摊销利息收入';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.tax_ir is '利息收入暂估税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.tax_due_ir is '利息收入应付增值税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_id is '损益对象id';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.deviation is '偏离金额';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.prft_ir_fut_ai is '预收息利息收入';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.is_ai_transfered is '计利息是否结转';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.ipr_ai3 is '阶段三减值利息';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.ipr_prft_ai3 is '阶段三利息减值损失';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.deferred_fv_tax is '估值递延税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.deferred_profit_fv_tax is '损益递延税';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.ipr_ai is '利息减值准备';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.obj_type is '余额类型 -1 正常余额 1 逾期豁免余额';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_ttrd_accounting_secu_obj_comp.etl_timestamp is 'ETL处理时间戳';
