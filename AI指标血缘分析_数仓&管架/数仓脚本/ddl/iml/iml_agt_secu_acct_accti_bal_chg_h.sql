/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_secu_acct_accti_bal_chg_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_secu_acct_accti_bal_chg_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_secu_acct_accti_bal_chg_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_secu_acct_accti_bal_chg_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,chg_id varchar2(100) -- 变动编号
    ,task_id varchar2(60) -- 任务编号
    ,revo_rela_chg_id varchar2(100) -- 撤销关联变动编号
    ,chg_dt date -- 变动日期
    ,chg_type_cd varchar2(30) -- 变动类型代码
    ,accti_obj_id varchar2(100) -- 核算对象编号
    ,instr_id varchar2(100) -- 指令编号
    ,ext_vch_acct_id varchar2(60) -- 外部券账户编号
    ,intnal_vch_acct_id varchar2(60) -- 内部券账户编号
    ,comb_tran_id varchar2(100) -- 组合交易编号
    ,fin_instm_id varchar2(100) -- 金融工具编号
    ,asset_type_id varchar2(100) -- 资产类型编号
    ,market_type_id varchar2(100) -- 市场类型编号
    ,tran_num varchar2(60) -- 交易号
    ,extra_dimen_cd varchar2(30) -- 额外维度代码
    ,accti_type_cd varchar2(30) -- 核算类型代码
    ,actl_qtty number(38,8) -- 实际数量
    ,actl_bal number(38,8) -- 实际余额
    ,net_price_cost number(38,8) -- 净价成本
    ,acru_int number(38,8) -- 应计利息
    ,int_cost number(38,8) -- 利息成本
    ,acru_turn_recvbl_uncol number(38,8) -- 应计转应收未收
    ,recvbl_uncol_turn_actl_recv number(38,8) -- 应收未收转实收
    ,acru_int_theory_attach_provi number(38,8) -- 应计利息理论补计提
    ,acru_int_actl_attach_provi number(38,8) -- 应计利息实际补计提
    ,evha_val_chag number(38,8) -- 公允价值变动
    ,fair_val_pl_asset number(38,8) -- 公允价值损益(资产部分)
    ,fair_val_pl_liab number(38,8) -- 公允价值损益(负债部分)
    ,recvbl_uncol_bal number(38,8) -- 应收未收余额
    ,recvbl_uncol_net_price_cost number(38,8) -- 应收未收净价成本
    ,recvbl_uncol_acru_int number(38,8) -- 应收未收应计利息
    ,td_amort_bus_cnt number(18,0) -- 当天摊销业务次数
    ,amort_dt date -- 摊销日期
    ,int_adj_amt number(38,8) -- 利息调整金额
    ,fair_val_pl number(38,8) -- 公允价值损益
    ,bs_pl number(38,8) -- 买卖损益
    ,int_income number(38,8) -- 利息收入
    ,acru_int_int_income number(38,8) -- 应计利息利息收入
    ,amort_int_income number(38,8) -- 摊销利息收入
    ,curr_post_acru_int_int_income number(38,8) -- 当前持仓应计利息利息收入
    ,curr_post_amort_int_income number(38,8) -- 当前持仓摊销利息收入
    ,reclafy_fair_val_pl number(38,8) -- 重分类公允价值损益
    ,futures_margin number(38,8) -- 期货保证金
    ,update_tm timestamp -- 更新时间
    ,fee number(38,8) -- 费用
    ,paybl_fee number(38,8) -- 应付费用
    ,fee_cost number(38,8) -- 费用成本
    ,amort_net_price_cost number(38,15) -- 摊余净价成本
    ,amort_int_cost number(38,15) -- 摊余利息成本
    ,bus_dt date -- 业务日期
    ,h_amort_start_dt date -- 历史摊销开始日期
    ,actl_int_rat number(38,15) -- 实际利率
    ,invest_yld_rat number(38,15) -- 投资收益率
    ,open_yld_rat number(38,15) -- 开仓收益率
    ,pre_recv_int number(38,8) -- 预收息
    ,non_amort_net_price_cost number(38,8) -- 不摊销净价成本
    ,non_amort_evha_val_chag number(38,8) -- 不摊销公允价值变动
    ,non_amort_fair_val_pl number(38,8) -- 不摊销公允价值损益
    ,non_amort_bs_pl number(38,8) -- 不摊销买卖损益
    ,reset_bf_amort_dt date -- 重置前摊销日期
    ,reset_post_amort_closing_dt date -- 重置后计提摊销截止日期
    ,reset_bf_amort_closing_dt date -- 重置前计提摊销截止日期
    ,wrtn_off_cost number(38,8) -- 已核销成本
    ,wrtn_off_acru_int number(38,8) -- 已核销应计利息
    ,wrtn_off_recvbl_uncol_int number(38,8) -- 已核销应收未收利息
    ,off_bs_acru_int number(38,8) -- 表外应计利息
    ,off_bs_recvbl_uncol_int number(38,8) -- 表外应收未收利息
    ,acru_int_amt number(38,8) -- 应计利息发生额
    ,acru_vat number(38,8) -- 应计增值税
    ,paybl_vat number(38,8) -- 应付增值税
    ,reset_bf_evltion_curr_cd varchar2(30) -- 重置前估值币种代码
    ,reset_post_evltion_curr_cd varchar2(30) -- 重置后估值币种代码
    ,stl_dt date -- 结算日期
    ,rlizd_evha_val_chag_pl number(38,8) -- 已实现公允价值变动损益
    ,curr_post_int_tax number(38,8) -- 当前持仓利息税
    ,open_int_cost number(38,8) -- 开仓利息成本
    ,open_ex_yld_rat number(38,15) -- 开仓行权收益率
    ,pre_tax_pre_recv_int_income number(38,8) -- 税前预收利息收入
    ,provi_int_income number(38,8) -- 计提利息收入
    ,int_recvbl_inco number(38,8) -- 应收利息收入
    ,actl_recv_int_income number(38,8) -- 实收利息收入
    ,provi_int_income_pre_recv_tax number(38,8) -- 计提利息收入预收税
    ,amort_int_income_paybl_vat number(38,8) -- 摊销利息收入应付增值税
    ,bs_pl_paybl_vat number(38,8) -- 买卖损益应付增值税
    ,offset_dlvy_dt date -- 平仓交割日期
    ,reset_bf_offset_dlvy_dt date -- 重置前平仓交割日期
    ,ext_dimen_info varchar2(750) -- 扩展维度信息
    ,int_income_estim_tax number(38,8) -- 利息收入暂估税
    ,int_income_paybl_vat number(38,8) -- 利息收入应付增值税
    ,fee_pl_paybl_vat number(38,8) -- 费用损益应付增值税
    ,pl_obj_id varchar2(100) -- 损益对象编号
    ,old_pl_obj_id varchar2(100) -- 老损益对象编号
    ,at_pre_recv_int_income number(38,8) -- 税后预收息利息收入
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_secu_acct_accti_bal_chg_h to ${icl_schema};
grant select on ${iml_schema}.agt_secu_acct_accti_bal_chg_h to ${idl_schema};
grant select on ${iml_schema}.agt_secu_acct_accti_bal_chg_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_secu_acct_accti_bal_chg_h is '证券账户核算余额变动历史';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.chg_id is '变动编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.task_id is '任务编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.revo_rela_chg_id is '撤销关联变动编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.chg_dt is '变动日期';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.chg_type_cd is '变动类型代码';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.accti_obj_id is '核算对象编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.instr_id is '指令编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.ext_vch_acct_id is '外部券账户编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.intnal_vch_acct_id is '内部券账户编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.comb_tran_id is '组合交易编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.fin_instm_id is '金融工具编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.asset_type_id is '资产类型编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.market_type_id is '市场类型编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.tran_num is '交易号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.extra_dimen_cd is '额外维度代码';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.accti_type_cd is '核算类型代码';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.actl_qtty is '实际数量';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.actl_bal is '实际余额';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.net_price_cost is '净价成本';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.acru_int is '应计利息';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.int_cost is '利息成本';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.acru_turn_recvbl_uncol is '应计转应收未收';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.recvbl_uncol_turn_actl_recv is '应收未收转实收';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.acru_int_theory_attach_provi is '应计利息理论补计提';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.acru_int_actl_attach_provi is '应计利息实际补计提';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.evha_val_chag is '公允价值变动';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.fair_val_pl_asset is '公允价值损益(资产部分)';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.fair_val_pl_liab is '公允价值损益(负债部分)';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.recvbl_uncol_bal is '应收未收余额';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.recvbl_uncol_net_price_cost is '应收未收净价成本';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.recvbl_uncol_acru_int is '应收未收应计利息';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.td_amort_bus_cnt is '当天摊销业务次数';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.amort_dt is '摊销日期';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.int_adj_amt is '利息调整金额';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.fair_val_pl is '公允价值损益';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.bs_pl is '买卖损益';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.int_income is '利息收入';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.acru_int_int_income is '应计利息利息收入';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.amort_int_income is '摊销利息收入';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.curr_post_acru_int_int_income is '当前持仓应计利息利息收入';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.curr_post_amort_int_income is '当前持仓摊销利息收入';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.reclafy_fair_val_pl is '重分类公允价值损益';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.futures_margin is '期货保证金';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.update_tm is '更新时间';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.fee is '费用';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.paybl_fee is '应付费用';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.fee_cost is '费用成本';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.amort_net_price_cost is '摊余净价成本';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.amort_int_cost is '摊余利息成本';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.bus_dt is '业务日期';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.h_amort_start_dt is '历史摊销开始日期';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.actl_int_rat is '实际利率';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.invest_yld_rat is '投资收益率';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.open_yld_rat is '开仓收益率';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.pre_recv_int is '预收息';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.non_amort_net_price_cost is '不摊销净价成本';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.non_amort_evha_val_chag is '不摊销公允价值变动';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.non_amort_fair_val_pl is '不摊销公允价值损益';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.non_amort_bs_pl is '不摊销买卖损益';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.reset_bf_amort_dt is '重置前摊销日期';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.reset_post_amort_closing_dt is '重置后计提摊销截止日期';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.reset_bf_amort_closing_dt is '重置前计提摊销截止日期';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.wrtn_off_cost is '已核销成本';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.wrtn_off_acru_int is '已核销应计利息';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.wrtn_off_recvbl_uncol_int is '已核销应收未收利息';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.off_bs_acru_int is '表外应计利息';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.off_bs_recvbl_uncol_int is '表外应收未收利息';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.acru_int_amt is '应计利息发生额';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.acru_vat is '应计增值税';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.paybl_vat is '应付增值税';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.reset_bf_evltion_curr_cd is '重置前估值币种代码';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.reset_post_evltion_curr_cd is '重置后估值币种代码';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.stl_dt is '结算日期';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.rlizd_evha_val_chag_pl is '已实现公允价值变动损益';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.curr_post_int_tax is '当前持仓利息税';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.open_int_cost is '开仓利息成本';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.open_ex_yld_rat is '开仓行权收益率';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.pre_tax_pre_recv_int_income is '税前预收利息收入';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.provi_int_income is '计提利息收入';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.int_recvbl_inco is '应收利息收入';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.actl_recv_int_income is '实收利息收入';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.provi_int_income_pre_recv_tax is '计提利息收入预收税';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.amort_int_income_paybl_vat is '摊销利息收入应付增值税';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.bs_pl_paybl_vat is '买卖损益应付增值税';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.offset_dlvy_dt is '平仓交割日期';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.reset_bf_offset_dlvy_dt is '重置前平仓交割日期';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.ext_dimen_info is '扩展维度信息';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.int_income_estim_tax is '利息收入暂估税';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.int_income_paybl_vat is '利息收入应付增值税';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.fee_pl_paybl_vat is '费用损益应付增值税';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.pl_obj_id is '损益对象编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.old_pl_obj_id is '老损益对象编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.at_pre_recv_int_income is '税后预收息利息收入';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_chg_h.etl_timestamp is 'ETL处理时间戳';
