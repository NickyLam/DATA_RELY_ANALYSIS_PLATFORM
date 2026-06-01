/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_out_acct_corp_loan_attach_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h(
    appl_id varchar2(100) -- 申请编号
    ,lp_id varchar2(100) -- 法人编号
    ,out_acct_flow_num varchar2(100) -- 出账流水号
    ,loan_type_cd varchar2(30) -- 贷款类型代码
    ,entr_dep_acct_id varchar2(100) -- 委托存款账户账号
    ,entr_dep_sub_acct_num varchar2(60) -- 委托存款子账号
    ,csner_dep_acct_id varchar2(100) -- 委托人存款账户编号
    ,pric_auto_rtn_flg varchar2(10) -- 本金自动归还标志
    ,int_auto_rtn_flg varchar2(10) -- 利息自动归还标志
    ,comn_inst_repay_flg varchar2(10) -- 普通分期还款标志
    ,inst_loan_tot_perds number(10) -- 分期贷款总期数
    ,tenor_type_cd varchar2(30) -- 期限类型代码
    ,entr_loan_comm_fee_rat number(18,6) -- 委托贷款手续费率
    ,crdt_distr_repay_plan_flg varchar2(10) -- 信贷发放还款计划标志
    ,stop_accr_int_flg varchar2(10) -- 停息标志
    ,margin_int_rat_type_cd varchar2(30) -- 保证金利率类型代码
    ,margin_int_rat_float_type_cd varchar2(30) -- 保证金利率浮动类型代码
    ,margin_int_rat_float_way_cd varchar2(30) -- 保证金利率浮动方式代码
    ,margin_flo_val number(18,6) -- 保证金浮动值
    ,margin_int_accr_method_cd varchar2(30) -- 保证金计息方法代码
    ,margin_int_rat_level_cd varchar2(30) -- 保证金利率档次代码
    ,margin_agt_rat number(30,8) -- 保证金协议利率
    ,margin_exp_dt date -- 保证金到期日期
    ,bill_uniq_ind_no varchar2(100) -- 票据唯一标识号
    ,lc_amt number(30,8) -- 信用证金额
    ,exp_lc_issue_bank_name varchar2(500) -- 出口信用证开证行名称
    ,lc_issuer varchar2(250) -- 信用证开证人
    ,lc_benefc varchar2(100) -- 信用证受益人
    ,lc_benefc_name varchar2(500) -- 信用证受益人名称
    ,ibank_payfan_pric number(30,2) -- 同业代付本金
    ,discnt_bus_accptor_name varchar2(500) -- 贴现业务承兑人名称
    ,bill_id varchar2(100) -- 票据编号
    ,strk_bal_flg varchar2(10) -- 冲账标志
    ,int_accr_days number(10) -- 计息天数
    ,ibank_payfan_provi_int_rat number(18,8) -- 同业代付计提利率
    ,todos number(30,8) -- 工本费
    ,bill_comm_fee_charge_way_cd varchar2(30) -- 票据手续费收费方式代码
    ,log_mode_pay_cd varchar2(30) -- 保函支付方式代码
    ,acpt_bus_accptor_name varchar2(500) -- 承兑业务承兑人名称
    ,draw_dt date -- 出票日期
    ,bill_type_cd varchar2(30) -- 票据类型代码
    ,trust_flg varchar2(10) -- 托管标志
    ,bill_cls_cd varchar2(30) -- 票据分类代码
    ,intstl_bus_id varchar2(100) -- 国结业务编号
    ,accpt_bil_comm_fee_amt number(30,8) -- 承兑汇票手续费金额
    ,trade_fin_rela_amt_one number(30,8) -- 贸易融资相关金额一
    ,trade_fin_rela_amt_two number(30,8) -- 贸易融资相关金额二
    ,trade_fin_rela_amt_three number(30,8) -- 贸易融资相关金额三
    ,trade_fin_rela_dt_one date -- 贸易融资相关日期一
    ,trade_fin_rela_dt_two date -- 贸易融资相关日期二
    ,trade_fin_ratio number(18,6) -- 贸易融资比例
    ,coll_type_cd varchar2(30) -- 代收类型代码
    ,bill_rgst_status_flg varchar2(30) -- 票据登记状态标志
    ,guar_org_id varchar2(100) -- 担保机构编号
    ,int_amt number(30,8) -- 利息金额
    ,recv_bank_name varchar2(500) -- 收款行名称
    ,trade_fin_type_cd varchar2(30) -- 贸易融资类型代码
    ,recver_open_bank_name varchar2(500) -- 收款人开户行名称
    ,accept_ps_name varchar2(500) -- 收票人名称
    ,inv_id varchar2(100) -- 发票号码
    ,enter_id varchar2(100) -- 入账账户编号
    ,distr_cond_impt_flg varchar2(10) -- 放款条件落实标志
    ,trade_fin_rela_curr_cd_one varchar2(30) -- 贸易融资相关币种代码一
    ,trade_fin_rela_curr_cd_two varchar2(30) -- 贸易融资相关币种代码二
    ,trade_fin_rela_curr_cd_three varchar2(30) -- 贸易融资相关币种代码三
    ,log_bnft_bank_name varchar2(500) -- 保函受益行名称
    ,fft_acpt_bank_no varchar2(100) -- 福费廷承兑行行号
    ,accptor_open_bank_no varchar2(60) -- 承兑人开户行行号
    ,fft_cfm_bank_bank_no varchar2(100) -- 福费廷保兑行行号
    ,buyer_pay_int_amt number(30,2) -- 买方付息金额
    ,redem_flg varchar2(10) -- 赎回标志
    ,trade_fin_bus_id_one varchar2(100) -- 贸易融资业务编号一
    ,trade_fin_bus_id_two varchar2(100) -- 贸易融资业务编号二
    ,era_pay_bank_name varchar2(500) -- 代付行名称
    ,log_type_cd varchar2(30) -- 保函类型代码
    ,trade_fin_tenor_type_cd_one varchar2(30) -- 贸易融资期限类型代码一
    ,trade_fin_tenor_type_cd_two varchar2(30) -- 贸易融资期限类型代码二
    ,accptor_open_bank_name varchar2(500) -- 承兑人开户行名称
    ,stl_acct_open_bank_name varchar2(500) -- 结算帐号开户行名称
    ,stl_acct_cust_name varchar2(500) -- 结算帐号客户名称
    ,buyer_pay_int_acct_id varchar2(100) -- 买方付息账户编号
    ,fin_log_flg varchar2(10) -- 融资性保函标志
    ,enter_open_bank_name varchar2(500) -- 入账账户开户行名称
    ,enter_cust_name varchar2(500) -- 入账账户客户名称
    ,payfan_pric_repay_way_cd varchar2(30) -- 代付本金还款方式代码
    ,lmt_cont_id varchar2(100) -- 额度合同编号
    ,pre_recv_int_flg varchar2(10) -- 预收息标志
    ,coll_comp_int_flg varchar2(10) -- 收复息标志
    ,fix_int_rat_flg varchar2(30) -- 固定利率标志
    ,out_acct_tran_code varchar2(60) -- 出帐交易码
    ,check_org_id varchar2(100) -- 复核机构编号
    ,check_teller_id varchar2(100) -- 复核柜员编号
    ,check_dt date -- 复核日期
    ,margin_tran_status_cd varchar2(30) -- 保证金交易状态代码
    ,repay_plan_tran_status_cd varchar2(30) -- 还款计划交易状态代码
    ,core_out_acct_flow_num varchar2(100) -- 核心出账流水号
    ,fin_sys_out_acct_flg varchar2(10) -- 融资系统出账标志
    ,cap_src_cd varchar2(30) -- 资金来源代码
    ,acpt_entry_tran_dt date -- 承兑记账交易日期
    ,acpt_entry_tran_flow_num varchar2(100) -- 承兑记账交易流水号
    ,file_int_flg varchar2(10) -- 靠档计息标志
    ,comm_fee number(30,6) -- 签约手续费
    ,sell_status_cd varchar2(30) -- 卖出状态代码
    ,cntpty_recvbl_acct_id varchar2(100) -- 交易对手收款账户编号
    ,cntpty_recvbl_acct_name varchar2(500) -- 交易对手收款账户名称
    ,cntpty_recvbl_bank_no varchar2(100) -- 交易对手收款行行号
    ,cntpty_recvbl_bank_name varchar2(500) -- 交易对手收款行名称
    ,level1_fft_actl_enter_id varchar2(100) -- 一级福费廷实际入账账户编号
    ,int_rat_start_use_way_cd varchar2(30) -- 利率启用方式代码
    ,repl_old_bond_flg varchar2(10) -- 置换旧债标志
    ,agent_present_flg varchar2(10) -- 代理交单标志
    ,loan_card_td_que_excep_flg varchar2(10) -- 贷款卡当日查询异常标志
    ,proc_sys_check_flg varchar2(10) -- 进行系统校验标志
    ,auto_callbk_ctrl_open_flg varchar2(10) -- 自动回收控制打开标志
    ,subtn_deduct_flg varchar2(10) -- 持续扣款标志
    ,lpr_ref_way_cd varchar2(30) -- LPR参照方式代码
    ,comp_int_int_rat_float_ratio number(30,2) -- 复利利率浮动比例
    ,comp_int_int_rat number(18,8) -- 复利利率
    ,dep_base_rat number(18,8) -- 存款基准利率
    ,dep_tenor number(10) -- 存款期限
    ,ghb_benefc_acct_num_flg varchar2(10) -- 本行受益人账号标志
    ,aldy_sign_pool_fin_agt_flg varchar2(10) -- 已签订池融资协议标志
    ,centr_out_acct_flg varchar2(10) -- 集中出账标志
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
grant select on ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h is '贷款出账对公贷款附属信息历史';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.appl_id is '申请编号';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.out_acct_flow_num is '出账流水号';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.loan_type_cd is '贷款类型代码';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.entr_dep_acct_id is '委托存款账户账号';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.entr_dep_sub_acct_num is '委托存款子账号';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.csner_dep_acct_id is '委托人存款账户编号';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.pric_auto_rtn_flg is '本金自动归还标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.int_auto_rtn_flg is '利息自动归还标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.comn_inst_repay_flg is '普通分期还款标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.inst_loan_tot_perds is '分期贷款总期数';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.tenor_type_cd is '期限类型代码';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.entr_loan_comm_fee_rat is '委托贷款手续费率';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.crdt_distr_repay_plan_flg is '信贷发放还款计划标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.stop_accr_int_flg is '停息标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.margin_int_rat_type_cd is '保证金利率类型代码';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.margin_int_rat_float_type_cd is '保证金利率浮动类型代码';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.margin_int_rat_float_way_cd is '保证金利率浮动方式代码';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.margin_flo_val is '保证金浮动值';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.margin_int_accr_method_cd is '保证金计息方法代码';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.margin_int_rat_level_cd is '保证金利率档次代码';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.margin_agt_rat is '保证金协议利率';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.margin_exp_dt is '保证金到期日期';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.bill_uniq_ind_no is '票据唯一标识号';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.lc_amt is '信用证金额';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.exp_lc_issue_bank_name is '出口信用证开证行名称';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.lc_issuer is '信用证开证人';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.lc_benefc is '信用证受益人';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.lc_benefc_name is '信用证受益人名称';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.ibank_payfan_pric is '同业代付本金';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.discnt_bus_accptor_name is '贴现业务承兑人名称';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.bill_id is '票据编号';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.strk_bal_flg is '冲账标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.int_accr_days is '计息天数';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.ibank_payfan_provi_int_rat is '同业代付计提利率';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.todos is '工本费';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.bill_comm_fee_charge_way_cd is '票据手续费收费方式代码';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.log_mode_pay_cd is '保函支付方式代码';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.acpt_bus_accptor_name is '承兑业务承兑人名称';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.draw_dt is '出票日期';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.bill_type_cd is '票据类型代码';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.trust_flg is '托管标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.bill_cls_cd is '票据分类代码';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.intstl_bus_id is '国结业务编号';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.accpt_bil_comm_fee_amt is '承兑汇票手续费金额';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.trade_fin_rela_amt_one is '贸易融资相关金额一';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.trade_fin_rela_amt_two is '贸易融资相关金额二';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.trade_fin_rela_amt_three is '贸易融资相关金额三';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.trade_fin_rela_dt_one is '贸易融资相关日期一';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.trade_fin_rela_dt_two is '贸易融资相关日期二';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.trade_fin_ratio is '贸易融资比例';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.coll_type_cd is '代收类型代码';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.bill_rgst_status_flg is '票据登记状态标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.guar_org_id is '担保机构编号';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.int_amt is '利息金额';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.recv_bank_name is '收款行名称';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.trade_fin_type_cd is '贸易融资类型代码';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.recver_open_bank_name is '收款人开户行名称';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.accept_ps_name is '收票人名称';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.inv_id is '发票号码';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.enter_id is '入账账户编号';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.distr_cond_impt_flg is '放款条件落实标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.trade_fin_rela_curr_cd_one is '贸易融资相关币种代码一';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.trade_fin_rela_curr_cd_two is '贸易融资相关币种代码二';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.trade_fin_rela_curr_cd_three is '贸易融资相关币种代码三';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.log_bnft_bank_name is '保函受益行名称';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.fft_acpt_bank_no is '福费廷承兑行行号';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.accptor_open_bank_no is '承兑人开户行行号';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.fft_cfm_bank_bank_no is '福费廷保兑行行号';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.buyer_pay_int_amt is '买方付息金额';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.redem_flg is '赎回标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.trade_fin_bus_id_one is '贸易融资业务编号一';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.trade_fin_bus_id_two is '贸易融资业务编号二';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.era_pay_bank_name is '代付行名称';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.log_type_cd is '保函类型代码';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.trade_fin_tenor_type_cd_one is '贸易融资期限类型代码一';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.trade_fin_tenor_type_cd_two is '贸易融资期限类型代码二';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.accptor_open_bank_name is '承兑人开户行名称';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.stl_acct_open_bank_name is '结算帐号开户行名称';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.stl_acct_cust_name is '结算帐号客户名称';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.buyer_pay_int_acct_id is '买方付息账户编号';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.fin_log_flg is '融资性保函标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.enter_open_bank_name is '入账账户开户行名称';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.enter_cust_name is '入账账户客户名称';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.payfan_pric_repay_way_cd is '代付本金还款方式代码';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.lmt_cont_id is '额度合同编号';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.pre_recv_int_flg is '预收息标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.coll_comp_int_flg is '收复息标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.fix_int_rat_flg is '固定利率标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.out_acct_tran_code is '出帐交易码';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.check_org_id is '复核机构编号';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.check_teller_id is '复核柜员编号';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.check_dt is '复核日期';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.margin_tran_status_cd is '保证金交易状态代码';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.repay_plan_tran_status_cd is '还款计划交易状态代码';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.core_out_acct_flow_num is '核心出账流水号';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.fin_sys_out_acct_flg is '融资系统出账标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.cap_src_cd is '资金来源代码';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.acpt_entry_tran_dt is '承兑记账交易日期';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.acpt_entry_tran_flow_num is '承兑记账交易流水号';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.file_int_flg is '靠档计息标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.comm_fee is '签约手续费';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.sell_status_cd is '卖出状态代码';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.cntpty_recvbl_acct_id is '交易对手收款账户编号';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.cntpty_recvbl_acct_name is '交易对手收款账户名称';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.cntpty_recvbl_bank_no is '交易对手收款行行号';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.cntpty_recvbl_bank_name is '交易对手收款行名称';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.level1_fft_actl_enter_id is '一级福费廷实际入账账户编号';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.int_rat_start_use_way_cd is '利率启用方式代码';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.repl_old_bond_flg is '置换旧债标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.agent_present_flg is '代理交单标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.loan_card_td_que_excep_flg is '贷款卡当日查询异常标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.proc_sys_check_flg is '进行系统校验标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.auto_callbk_ctrl_open_flg is '自动回收控制打开标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.subtn_deduct_flg is '持续扣款标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.lpr_ref_way_cd is 'LPR参照方式代码';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.comp_int_int_rat_float_ratio is '复利利率浮动比例';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.comp_int_int_rat is '复利利率';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.dep_base_rat is '存款基准利率';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.dep_tenor is '存款期限';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.ghb_benefc_acct_num_flg is '本行受益人账号标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.aldy_sign_pool_fin_agt_flg is '已签订池融资协议标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.centr_out_acct_flg is '集中出账标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h.etl_timestamp is 'ETL处理时间戳';
