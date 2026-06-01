/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_secu_acct_accti_bal_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_secu_acct_accti_bal_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_secu_acct_accti_bal_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_secu_acct_accti_bal_h(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,obj_id varchar2(60) -- 对象编号
    ,task_id varchar2(60) -- 任务编号
    ,ext_vch_acct_id varchar2(60) -- 外部券账户编号
    ,intnal_vch_acct_id varchar2(60) -- 内部券账户编号
    ,fin_instm_id varchar2(100) -- 金融工具编号
    ,asset_type_id varchar2(60) -- 资产类型编号
    ,market_type_id varchar2(60) -- 市场类型编号
    ,tran_num varchar2(60) -- 交易号
    ,extra_dimen_cd varchar2(10) -- 额外维度代码
    ,bal_type_cd varchar2(30) -- 余额类型代码
    ,actl_qtty number(38,8) -- 实际数量
    ,actl_bal number(30,8) -- 实际余额
    ,net_price_cost number(30,8) -- 净价成本
    ,acru_int number(30,8) -- 应计利息
    ,int_cost number(30,8) -- 利息成本
    ,evha_val_chag number(30,8) -- 公允价值变动
    ,recvbl_uncol_bal number(30,8) -- 应收未收余额
    ,recvbl_uncol_net_price_cost number(30,8) -- 应收未收净价成本
    ,recvbl_uncol_acru_int number(30,8) -- 应收未收应计利息
    ,td_amort_bus_cnt number(18,0) -- 当天摊销业务次数
    ,amort_dt date -- 摊销日期
    ,int_adj_amt number(30,8) -- 利息调整金额
    ,fair_val_pl number(30,8) -- 公允价值损益
    ,bs_pl number(30,8) -- 买卖损益
    ,int_income number(30,8) -- 利息收入
    ,acru_int_inco number(30,8) -- 应计利息收入
    ,amort_int_income number(30,8) -- 摊销利息收入
    ,curr_post_acru_int_int_income number(30,8) -- 当前持仓应计利息利息收入
    ,curr_post_amort_int_income number(30,8) -- 当前持仓摊销利息收入
    ,reclafy_fair_val_pl number(30,8) -- 重分类公允价值损益
    ,impam_prep number(30,8) -- 减值准备
    ,impam_loss number(30,8) -- 减值损失
    ,futures_margin number(30,8) -- 期货保证金
    ,open_dt date -- 开仓日期
    ,last_update_dt date -- 上次更新日期
    ,fee number(30,8) -- 费用
    ,paybl_fee number(30,8) -- 应付费用
    ,fee_cost number(30,8) -- 费用成本
    ,amort_net_price_cost number(30,8) -- 摊余净价成本
    ,amort_int_cost number(30,8) -- 摊余利息成本
    ,actl_int_rat number(18,8) -- 实际利率
    ,invest_yld_rat number(38,15) -- 投资收益率
    ,open_yld_rat number(18,8) -- 开仓收益率
    ,pre_recv_int number(30,8) -- 预收息
    ,non_amort_net_price_cost number(30,8) -- 不摊销净价成本
    ,non_amort_evha_val_chag number(30,8) -- 不摊销公允价值变动
    ,non_amort_fair_val_pl number(30,8) -- 不摊销公允价值损益
    ,non_amort_bs_pl number(30,8) -- 不摊销买卖损益
    ,provi_amort_closing_dt date -- 计提摊销截止日期
    ,impam_status_cd varchar2(10) -- 减值状态代码
    ,cost_impam_loss number(30,8) -- 成本减值损失
    ,int_impam_loss number(30,8) -- 利息减值损失
    ,cost_impam_prep number(30,8) -- 成本减值准备
    ,wrtn_off_cost number(30,8) -- 已核销成本
    ,wrtn_off_acru_int number(30,8) -- 已核销应计利息
    ,wrtn_off_recvbl_uncol_int number(30,8) -- 已核销应收未收利息
    ,off_bs_acru_int number(30,8) -- 表外应计利息
    ,off_bs_recvbl_uncol_int number(30,8) -- 表外应收未收利息
    ,acru_int_amt number(30,8) -- 应计利息发生额
    ,acru_vat number(30,8) -- 应计增值税
    ,paybl_vat number(30,8) -- 应付增值税
    ,curr_cd varchar2(10) -- 币种代码
    ,stl_dt date -- 结算日期
    ,rlizd_evha_val_chag_pl number(30,8) -- 已实现公允价值变动损益
    ,curr_post_int_tax number(30,8) -- 当前持仓利息税
    ,open_int_cost number(30,8) -- 开仓利息成本
    ,open_ex_yld_rat number(30,8) -- 开仓行权收益率
    ,pre_recv_int_income number(30,8) -- 税前预收利息收入
    ,provi_int_income number(30,8) -- 计提利息收入
    ,int_recvbl_inco number(30,8) -- 应收利息收入
    ,actl_recv_int_income number(30,8) -- 实收利息收入
    ,provi_int_income_pre_recv_tax number(30,8) -- 计提利息收入预收税
    ,amort_int_income_paybl_vat number(30,8) -- 摊销利息收入应付增值税
    ,offset_dlvy_dt date -- 平仓交割日期
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,at_pre_recv_int_income number(38,8) -- 税后预收利息收入
    ,ext_dimen_info varchar2(375) -- 扩展维度信息
    ,comb_tran_id varchar2(100) -- 组合交易编号
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
grant select on ${iml_schema}.agt_secu_acct_accti_bal_h to ${icl_schema};
grant select on ${iml_schema}.agt_secu_acct_accti_bal_h to ${idl_schema};
grant select on ${iml_schema}.agt_secu_acct_accti_bal_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_secu_acct_accti_bal_h is '证券账户核算余额历史';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.obj_id is '对象编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.task_id is '任务编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.ext_vch_acct_id is '外部券账户编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.intnal_vch_acct_id is '内部券账户编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.fin_instm_id is '金融工具编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.asset_type_id is '资产类型编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.market_type_id is '市场类型编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.tran_num is '交易号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.extra_dimen_cd is '额外维度代码';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.bal_type_cd is '余额类型代码';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.actl_qtty is '实际数量';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.actl_bal is '实际余额';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.net_price_cost is '净价成本';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.acru_int is '应计利息';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.int_cost is '利息成本';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.evha_val_chag is '公允价值变动';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.recvbl_uncol_bal is '应收未收余额';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.recvbl_uncol_net_price_cost is '应收未收净价成本';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.recvbl_uncol_acru_int is '应收未收应计利息';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.td_amort_bus_cnt is '当天摊销业务次数';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.amort_dt is '摊销日期';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.int_adj_amt is '利息调整金额';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.fair_val_pl is '公允价值损益';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.bs_pl is '买卖损益';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.int_income is '利息收入';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.acru_int_inco is '应计利息收入';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.amort_int_income is '摊销利息收入';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.curr_post_acru_int_int_income is '当前持仓应计利息利息收入';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.curr_post_amort_int_income is '当前持仓摊销利息收入';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.reclafy_fair_val_pl is '重分类公允价值损益';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.impam_prep is '减值准备';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.impam_loss is '减值损失';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.futures_margin is '期货保证金';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.open_dt is '开仓日期';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.last_update_dt is '上次更新日期';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.fee is '费用';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.paybl_fee is '应付费用';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.fee_cost is '费用成本';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.amort_net_price_cost is '摊余净价成本';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.amort_int_cost is '摊余利息成本';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.actl_int_rat is '实际利率';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.invest_yld_rat is '投资收益率';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.open_yld_rat is '开仓收益率';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.pre_recv_int is '预收息';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.non_amort_net_price_cost is '不摊销净价成本';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.non_amort_evha_val_chag is '不摊销公允价值变动';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.non_amort_fair_val_pl is '不摊销公允价值损益';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.non_amort_bs_pl is '不摊销买卖损益';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.provi_amort_closing_dt is '计提摊销截止日期';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.impam_status_cd is '减值状态代码';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.cost_impam_loss is '成本减值损失';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.int_impam_loss is '利息减值损失';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.cost_impam_prep is '成本减值准备';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.wrtn_off_cost is '已核销成本';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.wrtn_off_acru_int is '已核销应计利息';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.wrtn_off_recvbl_uncol_int is '已核销应收未收利息';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.off_bs_acru_int is '表外应计利息';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.off_bs_recvbl_uncol_int is '表外应收未收利息';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.acru_int_amt is '应计利息发生额';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.acru_vat is '应计增值税';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.paybl_vat is '应付增值税';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.stl_dt is '结算日期';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.rlizd_evha_val_chag_pl is '已实现公允价值变动损益';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.curr_post_int_tax is '当前持仓利息税';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.open_int_cost is '开仓利息成本';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.open_ex_yld_rat is '开仓行权收益率';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.pre_recv_int_income is '税前预收利息收入';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.provi_int_income is '计提利息收入';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.int_recvbl_inco is '应收利息收入';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.actl_recv_int_income is '实收利息收入';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.provi_int_income_pre_recv_tax is '计提利息收入预收税';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.amort_int_income_paybl_vat is '摊销利息收入应付增值税';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.offset_dlvy_dt is '平仓交割日期';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.std_prod_id is '标准产品编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.asset_thd_cls_cd is '资产三分类代码';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.at_pre_recv_int_income is '税后预收利息收入';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.ext_dimen_info is '扩展维度信息';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.comb_tran_id is '组合交易编号';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_secu_acct_accti_bal_h.etl_timestamp is 'ETL处理时间戳';
