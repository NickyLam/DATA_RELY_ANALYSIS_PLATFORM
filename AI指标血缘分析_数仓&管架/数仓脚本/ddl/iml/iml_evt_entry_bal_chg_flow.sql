/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_entry_bal_chg_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_entry_bal_chg_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_entry_bal_chg_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_entry_bal_chg_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,chg_id varchar2(100) -- 变动编号
    ,task_id varchar2(100) -- 任务编号
    ,revo_rela_chg_id varchar2(100) -- 撤销关联变动编号
    ,chg_dt date -- 变动日期
    ,chg_type_cd varchar2(30) -- 变动类型代码
    ,obj_id varchar2(100) -- 对象编号
    ,instr_id varchar2(100) -- 指令编号
    ,ext_secu_acct_id varchar2(100) -- 外部证券账户编号
    ,intnal_secu_acct_id varchar2(100) -- 内部证券账户编号
    ,fin_instm_id varchar2(100) -- 金融工具编号
    ,asset_type_id varchar2(100) -- 资产类型编号
    ,market_type_id varchar2(100) -- 市场类型编号
    ,tran_id varchar2(100) -- 交易编号
    ,extra_dimen_cd varchar2(30) -- 额外维度代码
    ,accti_type_cd varchar2(30) -- 核算类型代码
    ,actl_qtty number(32,8) -- 实际数量
    ,actl_bal number(32,8) -- 实际余额
    ,net_price_cost number(32,8) -- 净价成本
    ,acru_int number(32,8) -- 应计利息
    ,int_cost number(32,8) -- 利息成本
    ,acru_turn_recvbl_uncol number(32,8) -- 应计转应收未收
    ,recvbl_uncol_turn_actl_recv number(32,8) -- 应收未收转实收
    ,acru_int_theory_attach_provi number(32,8) -- 应计利息理论补计提
    ,acru_int_actl_attach_provi number(32,8) -- 应计利息实际补计提
    ,evha_val_chag number(32,8) -- 公允价值变动
    ,asset_fair_val_pl number(32,8) -- 资产公允价值损益
    ,liab_fair_val_pl number(32,8) -- 负债公允价值损益
    ,recvbl_uncol_bal number(32,8) -- 应收未收余额
    ,recvbl_uncol_net_price_cost number(32,8) -- 应收未收净价成本
    ,recvbl_uncol_acru_int number(32,8) -- 应收未收应计利息
    ,amort_dt date -- 摊销日期
    ,int_adj_amt number(32,8) -- 利息调整金额
    ,fair_val_pl number(32,8) -- 公允价值损益
    ,bs_pl number(32,8) -- 买卖损益
    ,int_income number(32,8) -- 利息收入
    ,acru_int_inco number(32,8) -- 应计利息收入
    ,amort_int_income number(32,8) -- 摊销利息收入
    ,curr_post_acru_int_inco number(32,8) -- 当前持仓应计利息收入
    ,curr_post_amort_int_income number(32,8) -- 当前持仓摊销利息收入
    ,update_tm timestamp -- 更新时间
    ,curr_issue_acru_int number(32,8) -- 本期应计利息
    ,curr_issue_int_adj number(32,8) -- 本期利息调整
    ,curr_issue_evha_val_chag number(32,8) -- 本期公允价值变动
    ,curr_issue_asset_evha_val_chag number(32,8) -- 本期资产公允价值变动
    ,curr_issue_liab_evha_val_chag number(32,8) -- 本期负债公允价值变动
    ,fee number(32,8) -- 费用
    ,amort_net_price_cost number(32,15) -- 摊余净价成本
    ,amort_int_cost number(32,15) -- 摊余利息成本
    ,actl_int_rat number(32,15) -- 实际利率
    ,invest_yld_rat number(32,15) -- 投资收益率
    ,open_yld_rat number(32,15) -- 开仓收益率
    ,pre_recv_int number(32,8) -- 预收息
    ,non_amort_net_price_cost number(32,8) -- 不摊销净价成本
    ,non_amort_evha_val_chag number(32,8) -- 不摊销公允价值变动
    ,non_amort_fair_val_pl number(32,8) -- 不摊销公允价值损益
    ,non_amort_bs_pl number(32,8) -- 不摊销买卖损益
    ,reset_bf_amort_dt date -- 重置前摊销日期
    ,reset_post_amort_closing_dt date -- 重置后计提摊销截止日期
    ,reset_bf_amort_closing_dt date -- 重置前计提摊销截止日期
    ,impam_status_cd varchar2(30) -- 减值状态代码
    ,cost_impam_loss number(32,8) -- 成本减值损失
    ,int_impam_loss number(32,8) -- 利息减值损失
    ,cost_impam_prep number(32,8) -- 成本减值准备
    ,wrtn_off_cost number(32,8) -- 已核销成本
    ,wrtn_off_acru_int number(32,8) -- 已核销应计利息
    ,wrtn_off_recvbl_uncol_int number(32,8) -- 已核销应收未收利息
    ,off_bs_acru_int number(32,8) -- 表外应计利息
    ,off_bs_recvbl_uncol_int number(32,8) -- 表外应收未收利息
    ,reset_bf_reclafy_amort_start_dt date -- 重置前重分类摊销开始日期
    ,reset_post_reclafy_amort_start_dt date -- 重置后重分类摊销开始日期
    ,reclafy_amort_start_dt_int_cost number(32,15) -- 重分类摊销开始日期利息成本
    ,acru_int_inco_incremt number(32,8) -- 应计利息收入增量
    ,acru_vat number(32,8) -- 应计增值税
    ,paybl_vat number(32,8) -- 应付增值税
    ,reset_bf_evltion_curr_cd varchar2(30) -- 重置前估值币种代码
    ,reset_post_evltion_curr_cd varchar2(500) -- 重置后估值币种代码
    ,open_int_cost number(32,8) -- 开仓利息成本
    ,open_ex_yld_rat number(32,15) -- 开仓行权收益率
    ,pre_recv_int_income number(32,8) -- 预收利息收入
    ,provi_int_income number(32,8) -- 计提利息收入
    ,int_recvbl_inco number(32,8) -- 应收利息收入
    ,actl_recv_int_income number(32,8) -- 实收利息收入
    ,at_pre_recv_int_income number(32,8) -- 税后预收利息收入
    ,amort_int_income_paybl_vat number(32,8) -- 摊销利息收入应付增值税
    ,bs_pl_paybl_vat number(32,8) -- 买卖损益应付增值税
    ,fee_pl_paybl_vat number(32,8) -- 费用损益应付增值税
    ,ovdue_flg varchar2(200) -- 逾期标志
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_entry_bal_chg_flow to ${icl_schema};
grant select on ${iml_schema}.evt_entry_bal_chg_flow to ${idl_schema};
grant select on ${iml_schema}.evt_entry_bal_chg_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_entry_bal_chg_flow is '记账余额变动流水';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.chg_id is '变动编号';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.task_id is '任务编号';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.revo_rela_chg_id is '撤销关联变动编号';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.chg_dt is '变动日期';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.chg_type_cd is '变动类型代码';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.obj_id is '对象编号';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.instr_id is '指令编号';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.ext_secu_acct_id is '外部证券账户编号';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.intnal_secu_acct_id is '内部证券账户编号';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.fin_instm_id is '金融工具编号';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.asset_type_id is '资产类型编号';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.market_type_id is '市场类型编号';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.tran_id is '交易编号';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.extra_dimen_cd is '额外维度代码';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.accti_type_cd is '核算类型代码';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.actl_qtty is '实际数量';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.actl_bal is '实际余额';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.net_price_cost is '净价成本';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.acru_int is '应计利息';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.int_cost is '利息成本';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.acru_turn_recvbl_uncol is '应计转应收未收';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.recvbl_uncol_turn_actl_recv is '应收未收转实收';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.acru_int_theory_attach_provi is '应计利息理论补计提';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.acru_int_actl_attach_provi is '应计利息实际补计提';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.evha_val_chag is '公允价值变动';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.asset_fair_val_pl is '资产公允价值损益';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.liab_fair_val_pl is '负债公允价值损益';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.recvbl_uncol_bal is '应收未收余额';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.recvbl_uncol_net_price_cost is '应收未收净价成本';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.recvbl_uncol_acru_int is '应收未收应计利息';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.amort_dt is '摊销日期';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.int_adj_amt is '利息调整金额';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.fair_val_pl is '公允价值损益';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.bs_pl is '买卖损益';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.int_income is '利息收入';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.acru_int_inco is '应计利息收入';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.amort_int_income is '摊销利息收入';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.curr_post_acru_int_inco is '当前持仓应计利息收入';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.curr_post_amort_int_income is '当前持仓摊销利息收入';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.update_tm is '更新时间';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.curr_issue_acru_int is '本期应计利息';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.curr_issue_int_adj is '本期利息调整';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.curr_issue_evha_val_chag is '本期公允价值变动';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.curr_issue_asset_evha_val_chag is '本期资产公允价值变动';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.curr_issue_liab_evha_val_chag is '本期负债公允价值变动';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.fee is '费用';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.amort_net_price_cost is '摊余净价成本';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.amort_int_cost is '摊余利息成本';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.actl_int_rat is '实际利率';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.invest_yld_rat is '投资收益率';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.open_yld_rat is '开仓收益率';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.pre_recv_int is '预收息';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.non_amort_net_price_cost is '不摊销净价成本';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.non_amort_evha_val_chag is '不摊销公允价值变动';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.non_amort_fair_val_pl is '不摊销公允价值损益';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.non_amort_bs_pl is '不摊销买卖损益';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.reset_bf_amort_dt is '重置前摊销日期';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.reset_post_amort_closing_dt is '重置后计提摊销截止日期';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.reset_bf_amort_closing_dt is '重置前计提摊销截止日期';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.impam_status_cd is '减值状态代码';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.cost_impam_loss is '成本减值损失';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.int_impam_loss is '利息减值损失';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.cost_impam_prep is '成本减值准备';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.wrtn_off_cost is '已核销成本';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.wrtn_off_acru_int is '已核销应计利息';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.wrtn_off_recvbl_uncol_int is '已核销应收未收利息';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.off_bs_acru_int is '表外应计利息';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.off_bs_recvbl_uncol_int is '表外应收未收利息';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.reset_bf_reclafy_amort_start_dt is '重置前重分类摊销开始日期';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.reset_post_reclafy_amort_start_dt is '重置后重分类摊销开始日期';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.reclafy_amort_start_dt_int_cost is '重分类摊销开始日期利息成本';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.acru_int_inco_incremt is '应计利息收入增量';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.acru_vat is '应计增值税';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.paybl_vat is '应付增值税';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.reset_bf_evltion_curr_cd is '重置前估值币种代码';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.reset_post_evltion_curr_cd is '重置后估值币种代码';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.open_int_cost is '开仓利息成本';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.open_ex_yld_rat is '开仓行权收益率';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.pre_recv_int_income is '预收利息收入';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.provi_int_income is '计提利息收入';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.int_recvbl_inco is '应收利息收入';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.actl_recv_int_income is '实收利息收入';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.at_pre_recv_int_income is '税后预收利息收入';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.amort_int_income_paybl_vat is '摊销利息收入应付增值税';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.bs_pl_paybl_vat is '买卖损益应付增值税';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.fee_pl_paybl_vat is '费用损益应付增值税';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.ovdue_flg is '逾期标志';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_entry_bal_chg_flow.etl_timestamp is 'ETL处理时间戳';
