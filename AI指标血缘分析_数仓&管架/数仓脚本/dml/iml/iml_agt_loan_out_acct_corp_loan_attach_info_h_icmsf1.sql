/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_out_acct_corp_loan_attach_info_h_icmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,loan_type_cd -- 贷款类型代码
    ,entr_dep_acct_id -- 委托存款账户账号
    ,entr_dep_sub_acct_num -- 委托存款子账号
    ,csner_dep_acct_id -- 委托人存款账户编号
    ,pric_auto_rtn_flg -- 本金自动归还标志
    ,int_auto_rtn_flg -- 利息自动归还标志
    ,comn_inst_repay_flg -- 普通分期还款标志
    ,inst_loan_tot_perds -- 分期贷款总期数
    ,tenor_type_cd -- 期限类型代码
    ,entr_loan_comm_fee_rat -- 委托贷款手续费率
    ,crdt_distr_repay_plan_flg -- 信贷发放还款计划标志
    ,stop_accr_int_flg -- 停息标志
    ,margin_int_rat_type_cd -- 保证金利率类型代码
    ,margin_int_rat_float_type_cd -- 保证金利率浮动类型代码
    ,margin_int_rat_float_way_cd -- 保证金利率浮动方式代码
    ,margin_flo_val -- 保证金浮动值
    ,margin_int_accr_method_cd -- 保证金计息方法代码
    ,margin_int_rat_level_cd -- 保证金利率档次代码
    ,margin_agt_rat -- 保证金协议利率
    ,margin_exp_dt -- 保证金到期日期
    ,bill_uniq_ind_no -- 票据唯一标识号
    ,lc_amt -- 信用证金额
    ,exp_lc_issue_bank_name -- 出口信用证开证行名称
    ,lc_issuer -- 信用证开证人
    ,lc_benefc -- 信用证受益人
    ,lc_benefc_name -- 信用证受益人名称
    ,ibank_payfan_pric -- 同业代付本金
    ,discnt_bus_accptor_name -- 贴现业务承兑人名称
    ,bill_id -- 票据编号
    ,strk_bal_flg -- 冲账标志
    ,int_accr_days -- 计息天数
    ,ibank_payfan_provi_int_rat -- 同业代付计提利率
    ,todos -- 工本费
    ,bill_comm_fee_charge_way_cd -- 票据手续费收费方式代码
    ,log_mode_pay_cd -- 保函支付方式代码
    ,acpt_bus_accptor_name -- 承兑业务承兑人名称
    ,draw_dt -- 出票日期
    ,bill_type_cd -- 票据类型代码
    ,trust_flg -- 托管标志
    ,bill_cls_cd -- 票据分类代码
    ,intstl_bus_id -- 国结业务编号
    ,accpt_bil_comm_fee_amt -- 承兑汇票手续费金额
    ,trade_fin_rela_amt_one -- 贸易融资相关金额一
    ,trade_fin_rela_amt_two -- 贸易融资相关金额二
    ,trade_fin_rela_amt_three -- 贸易融资相关金额三
    ,trade_fin_rela_dt_one -- 贸易融资相关日期一
    ,trade_fin_rela_dt_two -- 贸易融资相关日期二
    ,trade_fin_ratio -- 贸易融资比例
    ,coll_type_cd -- 代收类型代码
    ,bill_rgst_status_flg -- 票据登记状态标志
    ,guar_org_id -- 担保机构编号
    ,int_amt -- 利息金额
    ,recv_bank_name -- 收款行名称
    ,trade_fin_type_cd -- 贸易融资类型代码
    ,recver_open_bank_name -- 收款人开户行名称
    ,accept_ps_name -- 收票人名称
    ,inv_id -- 发票号码
    ,enter_id -- 入账账户编号
    ,distr_cond_impt_flg -- 放款条件落实标志
    ,trade_fin_rela_curr_cd_one -- 贸易融资相关币种代码一
    ,trade_fin_rela_curr_cd_two -- 贸易融资相关币种代码二
    ,trade_fin_rela_curr_cd_three -- 贸易融资相关币种代码三
    ,log_bnft_bank_name -- 保函受益行名称
    ,fft_acpt_bank_no -- 福费廷承兑行行号
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,fft_cfm_bank_bank_no -- 福费廷保兑行行号
    ,buyer_pay_int_amt -- 买方付息金额
    ,redem_flg -- 赎回标志
    ,trade_fin_bus_id_one -- 贸易融资业务编号一
    ,trade_fin_bus_id_two -- 贸易融资业务编号二
    ,era_pay_bank_name -- 代付行名称
    ,log_type_cd -- 保函类型代码
    ,trade_fin_tenor_type_cd_one -- 贸易融资期限类型代码一
    ,trade_fin_tenor_type_cd_two -- 贸易融资期限类型代码二
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,stl_acct_open_bank_name -- 结算帐号开户行名称
    ,stl_acct_cust_name -- 结算帐号客户名称
    ,buyer_pay_int_acct_id -- 买方付息账户编号
    ,fin_log_flg -- 融资性保函标志
    ,enter_open_bank_name -- 入账账户开户行名称
    ,enter_cust_name -- 入账账户客户名称
    ,payfan_pric_repay_way_cd -- 代付本金还款方式代码
    ,lmt_cont_id -- 额度合同编号
    ,pre_recv_int_flg -- 预收息标志
    ,coll_comp_int_flg -- 收复息标志
    ,fix_int_rat_flg -- 固定利率标志
    ,out_acct_tran_code -- 出帐交易码
    ,check_org_id -- 复核机构编号
    ,check_teller_id -- 复核柜员编号
    ,check_dt -- 复核日期
    ,margin_tran_status_cd -- 保证金交易状态代码
    ,repay_plan_tran_status_cd -- 还款计划交易状态代码
    ,core_out_acct_flow_num -- 核心出账流水号
    ,fin_sys_out_acct_flg -- 融资系统出账标志
    ,cap_src_cd -- 资金来源代码
    ,acpt_entry_tran_dt -- 承兑记账交易日期
    ,acpt_entry_tran_flow_num -- 承兑记账交易流水号
    ,file_int_flg -- 靠档计息标志
    ,comm_fee -- 签约手续费
    ,sell_status_cd -- 卖出状态代码
    ,cntpty_recvbl_acct_id -- 交易对手收款账户编号
    ,cntpty_recvbl_acct_name -- 交易对手收款账户名称
    ,cntpty_recvbl_bank_no -- 交易对手收款行行号
    ,cntpty_recvbl_bank_name -- 交易对手收款行名称
    ,level1_fft_actl_enter_id -- 一级福费廷实际入账账户编号
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,repl_old_bond_flg -- 置换旧债标志
    ,agent_present_flg -- 代理交单标志
    ,loan_card_td_que_excep_flg -- 贷款卡当日查询异常标志
    ,proc_sys_check_flg -- 进行系统校验标志
    ,auto_callbk_ctrl_open_flg -- 自动回收控制打开标志
    ,subtn_deduct_flg -- 持续扣款标志
    ,lpr_ref_way_cd -- LPR参照方式代码
    ,comp_int_int_rat_float_ratio -- 复利利率浮动比例
    ,comp_int_int_rat -- 复利利率
    ,dep_base_rat -- 存款基准利率
    ,dep_tenor -- 存款期限
    ,ghb_benefc_acct_num_flg -- 本行受益人账号标志
    ,aldy_sign_pool_fin_agt_flg -- 已签订池融资协议标志
    ,centr_out_acct_flg -- 集中出账标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_bp_extend_d-1
insert into ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h_icmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,loan_type_cd -- 贷款类型代码
    ,entr_dep_acct_id -- 委托存款账户账号
    ,entr_dep_sub_acct_num -- 委托存款子账号
    ,csner_dep_acct_id -- 委托人存款账户编号
    ,pric_auto_rtn_flg -- 本金自动归还标志
    ,int_auto_rtn_flg -- 利息自动归还标志
    ,comn_inst_repay_flg -- 普通分期还款标志
    ,inst_loan_tot_perds -- 分期贷款总期数
    ,tenor_type_cd -- 期限类型代码
    ,entr_loan_comm_fee_rat -- 委托贷款手续费率
    ,crdt_distr_repay_plan_flg -- 信贷发放还款计划标志
    ,stop_accr_int_flg -- 停息标志
    ,margin_int_rat_type_cd -- 保证金利率类型代码
    ,margin_int_rat_float_type_cd -- 保证金利率浮动类型代码
    ,margin_int_rat_float_way_cd -- 保证金利率浮动方式代码
    ,margin_flo_val -- 保证金浮动值
    ,margin_int_accr_method_cd -- 保证金计息方法代码
    ,margin_int_rat_level_cd -- 保证金利率档次代码
    ,margin_agt_rat -- 保证金协议利率
    ,margin_exp_dt -- 保证金到期日期
    ,bill_uniq_ind_no -- 票据唯一标识号
    ,lc_amt -- 信用证金额
    ,exp_lc_issue_bank_name -- 出口信用证开证行名称
    ,lc_issuer -- 信用证开证人
    ,lc_benefc -- 信用证受益人
    ,lc_benefc_name -- 信用证受益人名称
    ,ibank_payfan_pric -- 同业代付本金
    ,discnt_bus_accptor_name -- 贴现业务承兑人名称
    ,bill_id -- 票据编号
    ,strk_bal_flg -- 冲账标志
    ,int_accr_days -- 计息天数
    ,ibank_payfan_provi_int_rat -- 同业代付计提利率
    ,todos -- 工本费
    ,bill_comm_fee_charge_way_cd -- 票据手续费收费方式代码
    ,log_mode_pay_cd -- 保函支付方式代码
    ,acpt_bus_accptor_name -- 承兑业务承兑人名称
    ,draw_dt -- 出票日期
    ,bill_type_cd -- 票据类型代码
    ,trust_flg -- 托管标志
    ,bill_cls_cd -- 票据分类代码
    ,intstl_bus_id -- 国结业务编号
    ,accpt_bil_comm_fee_amt -- 承兑汇票手续费金额
    ,trade_fin_rela_amt_one -- 贸易融资相关金额一
    ,trade_fin_rela_amt_two -- 贸易融资相关金额二
    ,trade_fin_rela_amt_three -- 贸易融资相关金额三
    ,trade_fin_rela_dt_one -- 贸易融资相关日期一
    ,trade_fin_rela_dt_two -- 贸易融资相关日期二
    ,trade_fin_ratio -- 贸易融资比例
    ,coll_type_cd -- 代收类型代码
    ,bill_rgst_status_flg -- 票据登记状态标志
    ,guar_org_id -- 担保机构编号
    ,int_amt -- 利息金额
    ,recv_bank_name -- 收款行名称
    ,trade_fin_type_cd -- 贸易融资类型代码
    ,recver_open_bank_name -- 收款人开户行名称
    ,accept_ps_name -- 收票人名称
    ,inv_id -- 发票号码
    ,enter_id -- 入账账户编号
    ,distr_cond_impt_flg -- 放款条件落实标志
    ,trade_fin_rela_curr_cd_one -- 贸易融资相关币种代码一
    ,trade_fin_rela_curr_cd_two -- 贸易融资相关币种代码二
    ,trade_fin_rela_curr_cd_three -- 贸易融资相关币种代码三
    ,log_bnft_bank_name -- 保函受益行名称
    ,fft_acpt_bank_no -- 福费廷承兑行行号
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,fft_cfm_bank_bank_no -- 福费廷保兑行行号
    ,buyer_pay_int_amt -- 买方付息金额
    ,redem_flg -- 赎回标志
    ,trade_fin_bus_id_one -- 贸易融资业务编号一
    ,trade_fin_bus_id_two -- 贸易融资业务编号二
    ,era_pay_bank_name -- 代付行名称
    ,log_type_cd -- 保函类型代码
    ,trade_fin_tenor_type_cd_one -- 贸易融资期限类型代码一
    ,trade_fin_tenor_type_cd_two -- 贸易融资期限类型代码二
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,stl_acct_open_bank_name -- 结算帐号开户行名称
    ,stl_acct_cust_name -- 结算帐号客户名称
    ,buyer_pay_int_acct_id -- 买方付息账户编号
    ,fin_log_flg -- 融资性保函标志
    ,enter_open_bank_name -- 入账账户开户行名称
    ,enter_cust_name -- 入账账户客户名称
    ,payfan_pric_repay_way_cd -- 代付本金还款方式代码
    ,lmt_cont_id -- 额度合同编号
    ,pre_recv_int_flg -- 预收息标志
    ,coll_comp_int_flg -- 收复息标志
    ,fix_int_rat_flg -- 固定利率标志
    ,out_acct_tran_code -- 出帐交易码
    ,check_org_id -- 复核机构编号
    ,check_teller_id -- 复核柜员编号
    ,check_dt -- 复核日期
    ,margin_tran_status_cd -- 保证金交易状态代码
    ,repay_plan_tran_status_cd -- 还款计划交易状态代码
    ,core_out_acct_flow_num -- 核心出账流水号
    ,fin_sys_out_acct_flg -- 融资系统出账标志
    ,cap_src_cd -- 资金来源代码
    ,acpt_entry_tran_dt -- 承兑记账交易日期
    ,acpt_entry_tran_flow_num -- 承兑记账交易流水号
    ,file_int_flg -- 靠档计息标志
    ,comm_fee -- 签约手续费
    ,sell_status_cd -- 卖出状态代码
    ,cntpty_recvbl_acct_id -- 交易对手收款账户编号
    ,cntpty_recvbl_acct_name -- 交易对手收款账户名称
    ,cntpty_recvbl_bank_no -- 交易对手收款行行号
    ,cntpty_recvbl_bank_name -- 交易对手收款行名称
    ,level1_fft_actl_enter_id -- 一级福费廷实际入账账户编号
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,repl_old_bond_flg -- 置换旧债标志
    ,agent_present_flg -- 代理交单标志
    ,loan_card_td_que_excep_flg -- 贷款卡当日查询异常标志
    ,proc_sys_check_flg -- 进行系统校验标志
    ,auto_callbk_ctrl_open_flg -- 自动回收控制打开标志
    ,subtn_deduct_flg -- 持续扣款标志
    ,lpr_ref_way_cd -- LPR参照方式代码
    ,comp_int_int_rat_float_ratio -- 复利利率浮动比例
    ,comp_int_int_rat -- 复利利率
    ,dep_base_rat -- 存款基准利率
    ,dep_tenor -- 存款期限
    ,ghb_benefc_acct_num_flg -- 本行受益人账号标志
    ,aldy_sign_pool_fin_agt_flg -- 已签订池融资协议标志
    ,centr_out_acct_flg -- 集中出账标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206001'||P1.SERIALNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 出账流水号
    ,nvl(trim(P1.LOANTYPE),'LN000') -- 贷款类型代码
    ,P1.PRINCIPALACCOUNTNO -- 委托存款账户账号
    ,P1.PRINCIPALSUBACCOUNTNO -- 委托存款子账号
    ,P1.CLIENTACCOUNTNO -- 委托人存款账户编号
    ,nvl(trim(P1.CAPITALRETURNFLAG),'-') -- 本金自动归还标志
    ,nvl(trim(P1.INTERESTRETURNFLAG),'-') -- 利息自动归还标志
    ,nvl(trim(P1.ORDINARYORMONTHLY),'-') -- 普通分期还款标志
    ,P1.PERIOD -- 分期贷款总期数
    ,nvl(trim(P1.TERMTYPE),'-') -- 期限类型代码
    ,P1.PDGPAYPERCENT2 -- 委托贷款手续费率
    ,nvl(trim(P1.REPAYMENTPLANFLAG),'-') -- 信贷发放还款计划标志
    ,nvl(trim(P1.STOPINTFLAG),'-') -- 停息标志
    ,nvl(trim(P1.BAILFXFLTP),'-') -- 保证金利率类型代码
    ,nvl(trim(P1.BAILPDRIFD),'-') -- 保证金利率浮动类型代码
    ,nvl(trim(P1.BAILPDRIFM),'-') -- 保证金利率浮动方式代码
    ,P1.BAILPDRIFV -- 保证金浮动值
    ,nvl(trim(P1.BAILINTERESTMETHOD),'-') -- 保证金计息方法代码
    ,nvl(trim(P1.BAILTERM),'-') -- 保证金利率档次代码
    ,P1.BAILINTERESTRATE -- 保证金协议利率
    ,${iml_schema}.dateformat_max2(P1.BAILMATURITY) -- 保证金到期日期
    ,P1.KEYNO -- 票据唯一标识号
    ,P1.LCSUM -- 信用证金额
    ,P1.OPENBANKNAME -- 出口信用证开证行名称
    ,P1.OPENCUSTOMER -- 信用证开证人
    ,P1.ABOUTBANKID -- 信用证受益人
    ,P1.CREDITBENEFICIARY -- 信用证受益人名称
    ,P1.LNBAL -- 同业代付本金
    ,P1.NAME1 -- 贴现业务承兑人名称
    ,P1.BILLNO -- 票据编号
    ,nvl(trim(P1.CZFLAG),'-') -- 冲账标志
    ,P1.FIXCYC -- 计息天数
    ,P1.INSTRT -- 同业代付计提利率
    ,P1.PAYSUM -- 工本费
    ,nvl(trim(P1.TRANTP),'-') -- 票据手续费收费方式代码
    ,nvl(trim(P1.PAYMODE),'0') -- 保函支付方式代码
    ,P1.ACCEPTORNAME -- 承兑业务承兑人名称
    ,${iml_schema}.dateformat_max2(P1.ACPTDATE) -- 出票日期
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.BILLTYPE END -- 票据类型代码
    ,nvl(trim(P1.CAREFLAG),'-') -- 托管标志
    ,nvl(trim(P1.BILLCLASS),'0') -- 票据分类代码
    ,P1.FBSNUMBER -- 国结业务编号
    ,P1.PDGSUM2 -- 承兑汇票手续费金额
    ,P1.TRADESUM1 -- 贸易融资相关金额一
    ,P1.TRADESUM2 -- 贸易融资相关金额二
    ,P1.TRADESUM3 -- 贸易融资相关金额三
    ,${iml_schema}.dateformat_max2(P1.TRADEDATE1) -- 贸易融资相关日期一
    ,${iml_schema}.dateformat_max2(P1.TRADEDATE2) -- 贸易融资相关日期二
    ,P1.TRADERATE2 -- 贸易融资比例
    ,nvl(trim(P1.TRADETYPE1),'-') -- 代收类型代码
    ,nvl(trim(P1.TXREGISTER),'-') -- 票据登记状态标志
    ,P1.ASSUREORGID -- 担保机构编号
    ,P1.DISCOUNTSUM -- 利息金额
    ,P1.PAYBANKNAME -- 收款行名称
    ,nvl(trim(P1.COMMERCETYPE),'-') -- 贸易融资类型代码
    ,P1.ABOUTBANKNAME -- 收款人开户行名称
    ,P1.GATHERINGNAME -- 收票人名称
    ,P1.INVOICENUMBER -- 发票号码
    ,P1.LOANACCOUNTNO2 -- 入账账户编号
    ,nvl(trim(P1.LOANTERMTHING),'-') -- 放款条件落实标志
    ,nvl(trim(P1.TRADECURRECY1),'-') -- 贸易融资相关币种代码一
    ,nvl(trim(P1.TRADECURRECY2),'-') -- 贸易融资相关币种代码二
    ,nvl(trim(P1.TRADECURRECY3),'-') -- 贸易融资相关币种代码三
    ,P1.ABOUTBANKNAME2 -- 保函受益行名称
    ,P1.ACCEPTANCEBANK -- 福费廷承兑行行号
    ,P1.ACCEPTORBANKNO -- 承兑人开户行行号
    ,P1.CONFIRMINGBANK -- 福费廷保兑行行号
    ,P1.OTHERTXBALANCE -- 买方付息金额
    ,nvl(trim(P1.REPURCHASEFLAG),'-') -- 赎回标志
    ,P1.TRADESERIALNO1 -- 贸易融资业务编号一
    ,P1.TRADESERIALNO2 -- 贸易融资业务编号二
    ,P1.UNPAIDBANKNAME -- 代付行名称
    ,nvl(trim(P1.BUSINESSSUBTYPE),'-') -- 保函类型代码
    ,nvl(trim(P1.TRADETERMMONTH1),'-') -- 贸易融资期限类型代码一
    ,nvl(trim(P1.TRADETERMMONTH2),'-') -- 贸易融资期限类型代码二
    ,P1.ACCEPTORBANKNAME -- 承兑人开户行名称
    ,P1.ACCOUNTOPENBANKNAME -- 结算帐号开户行名称
    ,P1.ACCOUNTNOCUSTOMER -- 结算帐号客户名称
    ,P1.OTHERDRAWERACCTNO -- 买方付息账户编号
    ,nvl(trim(P1.ISFINANCEGUARANTEE),'-') -- 融资性保函标志
    ,P1.LOANACCOUNTNOORGNAME -- 入账账户开户行名称
    ,P1.LOANACCOUNTNOCUSTOMER -- 入账账户客户名称
    ,nvl(trim(P1.DPRINPAYMETHOD),'-') -- 代付本金还款方式代码
    ,P1.CREDITAGGREEMENT -- 额度合同编号
    ,nvl(trim(P1.BFINTG),'-') -- 预收息标志
    ,nvl(trim(P1.COMPOUNDINTFLAG),'-') -- 收复息标志
    ,nvl(trim(P1.ISFIXEDRATE),'-') -- 固定利率标志
    ,P1.EXCHANGETYPE -- 出帐交易码
    ,P1.APPROVEORGID -- 复核机构编号
    ,P1.APPROVEUSERID -- 复核柜员编号
    ,${iml_schema}.dateformat_max2(P1.APPROVEDATE) -- 复核日期
    ,nvl(trim(P1.BAILEXCHANGESTATE),'-') -- 保证金交易状态代码
    ,nvl(trim(P1.REPAYEXCHANGESTATE),'-') -- 还款计划交易状态代码
    ,P1.PUTOUTNO -- 核心出账流水号
    ,nvl(trim(P1.ISRZ),'-') -- 融资系统出账标志
    ,nvl(trim(P1.FUNDSOURCE),'-') -- 资金来源代码
    ,${iml_schema}.dateformat_max2(P1.CDEXCHANGEDATE) -- 承兑记账交易日期
    ,P1.CDEXCHANGENO -- 承兑记账交易流水号
    ,nvl(trim(P1.ISBELONGTERM),'-') -- 靠档计息标志
    ,nvl(trim(P1.CONTRACTSIGNFEE),'0.000000') -- 签约手续费
    ,decode(trim(p1.sellstatus),'','-','020','040','010','-',p1.sellstatus) -- 卖出状态代码
    ,P1.OTHERRECEIVEDNAME -- 交易对手收款账户编号
    ,P1.OTHERRECEIVEDACCNAME -- 交易对手收款账户名称
    ,P1.OTHERRECEIVEDBANKNO -- 交易对手收款行行号
    ,P1.OTHERRECEIVEDBANKNAME -- 交易对手收款行名称
    ,P1.ACTUALLOANACCOUNTNO -- 一级福费廷实际入账账户编号
    ,nvl(trim(P1.RATESTARTMODE),'-') -- 利率启用方式代码
    ,nvl(trim(P1.REPLACEOLDDEPT),'-') -- 置换旧债标志
    ,nvl(trim(P1.ISPROXYDP),'-') -- 代理交单标志
    ,nvl(trim(P1.QUERYABNORMITYTHING),'-') -- 贷款卡当日查询异常标志
    ,nvl(trim(P1.LOANTERMCONTROLFLAG),'-') -- 进行系统校验标志
    ,decode(P1.AUTOCONTROLFLAG,'N','0','Y','1',' ','-',P1.AUTOCONTROLFLAG) -- 自动回收控制打开标志
    ,decode(P1.CONTINUEPAYFLAG,'N','0','Y','1',' ','-',P1.CONTINUEPAYFLAG) -- 持续扣款标志
    ,nvl(trim(P1.LPRTYPE),'-') -- LPR参照方式代码
    ,P1.COMPOUNDINTFLOATVALUE -- 复利利率浮动比例
    ,P1.COMPOUNDINTRATIO -- 复利利率
    ,P1.DEPOSITBASERATE -- 存款基准利率
    ,P1.DEPOSITTERM -- 存款期限
    ,nvl(trim(P1.ISBANKACCOUNT),'-') -- 本行受益人账号标志
    ,nvl(trim(P1.POOLFINANCINGFLAG),'-') -- 已签订池融资协议标志
    ,nvl(trim(P1.ISCENTRALIZEDACCOUNT),'-') -- 集中出账标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_bp_extend_d' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_bp_extend_d p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.BILLTYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD='ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_BP_EXTEND_D'
        AND R1.SRC_FIELD_EN_NAME= 'BILLTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_LOAN_OUT_ACCT_CORP_LOAN_ATTACH_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'BILL_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h_icmsf1_tm 
  	                                group by 
  	                                        appl_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,loan_type_cd -- 贷款类型代码
    ,entr_dep_acct_id -- 委托存款账户账号
    ,entr_dep_sub_acct_num -- 委托存款子账号
    ,csner_dep_acct_id -- 委托人存款账户编号
    ,pric_auto_rtn_flg -- 本金自动归还标志
    ,int_auto_rtn_flg -- 利息自动归还标志
    ,comn_inst_repay_flg -- 普通分期还款标志
    ,inst_loan_tot_perds -- 分期贷款总期数
    ,tenor_type_cd -- 期限类型代码
    ,entr_loan_comm_fee_rat -- 委托贷款手续费率
    ,crdt_distr_repay_plan_flg -- 信贷发放还款计划标志
    ,stop_accr_int_flg -- 停息标志
    ,margin_int_rat_type_cd -- 保证金利率类型代码
    ,margin_int_rat_float_type_cd -- 保证金利率浮动类型代码
    ,margin_int_rat_float_way_cd -- 保证金利率浮动方式代码
    ,margin_flo_val -- 保证金浮动值
    ,margin_int_accr_method_cd -- 保证金计息方法代码
    ,margin_int_rat_level_cd -- 保证金利率档次代码
    ,margin_agt_rat -- 保证金协议利率
    ,margin_exp_dt -- 保证金到期日期
    ,bill_uniq_ind_no -- 票据唯一标识号
    ,lc_amt -- 信用证金额
    ,exp_lc_issue_bank_name -- 出口信用证开证行名称
    ,lc_issuer -- 信用证开证人
    ,lc_benefc -- 信用证受益人
    ,lc_benefc_name -- 信用证受益人名称
    ,ibank_payfan_pric -- 同业代付本金
    ,discnt_bus_accptor_name -- 贴现业务承兑人名称
    ,bill_id -- 票据编号
    ,strk_bal_flg -- 冲账标志
    ,int_accr_days -- 计息天数
    ,ibank_payfan_provi_int_rat -- 同业代付计提利率
    ,todos -- 工本费
    ,bill_comm_fee_charge_way_cd -- 票据手续费收费方式代码
    ,log_mode_pay_cd -- 保函支付方式代码
    ,acpt_bus_accptor_name -- 承兑业务承兑人名称
    ,draw_dt -- 出票日期
    ,bill_type_cd -- 票据类型代码
    ,trust_flg -- 托管标志
    ,bill_cls_cd -- 票据分类代码
    ,intstl_bus_id -- 国结业务编号
    ,accpt_bil_comm_fee_amt -- 承兑汇票手续费金额
    ,trade_fin_rela_amt_one -- 贸易融资相关金额一
    ,trade_fin_rela_amt_two -- 贸易融资相关金额二
    ,trade_fin_rela_amt_three -- 贸易融资相关金额三
    ,trade_fin_rela_dt_one -- 贸易融资相关日期一
    ,trade_fin_rela_dt_two -- 贸易融资相关日期二
    ,trade_fin_ratio -- 贸易融资比例
    ,coll_type_cd -- 代收类型代码
    ,bill_rgst_status_flg -- 票据登记状态标志
    ,guar_org_id -- 担保机构编号
    ,int_amt -- 利息金额
    ,recv_bank_name -- 收款行名称
    ,trade_fin_type_cd -- 贸易融资类型代码
    ,recver_open_bank_name -- 收款人开户行名称
    ,accept_ps_name -- 收票人名称
    ,inv_id -- 发票号码
    ,enter_id -- 入账账户编号
    ,distr_cond_impt_flg -- 放款条件落实标志
    ,trade_fin_rela_curr_cd_one -- 贸易融资相关币种代码一
    ,trade_fin_rela_curr_cd_two -- 贸易融资相关币种代码二
    ,trade_fin_rela_curr_cd_three -- 贸易融资相关币种代码三
    ,log_bnft_bank_name -- 保函受益行名称
    ,fft_acpt_bank_no -- 福费廷承兑行行号
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,fft_cfm_bank_bank_no -- 福费廷保兑行行号
    ,buyer_pay_int_amt -- 买方付息金额
    ,redem_flg -- 赎回标志
    ,trade_fin_bus_id_one -- 贸易融资业务编号一
    ,trade_fin_bus_id_two -- 贸易融资业务编号二
    ,era_pay_bank_name -- 代付行名称
    ,log_type_cd -- 保函类型代码
    ,trade_fin_tenor_type_cd_one -- 贸易融资期限类型代码一
    ,trade_fin_tenor_type_cd_two -- 贸易融资期限类型代码二
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,stl_acct_open_bank_name -- 结算帐号开户行名称
    ,stl_acct_cust_name -- 结算帐号客户名称
    ,buyer_pay_int_acct_id -- 买方付息账户编号
    ,fin_log_flg -- 融资性保函标志
    ,enter_open_bank_name -- 入账账户开户行名称
    ,enter_cust_name -- 入账账户客户名称
    ,payfan_pric_repay_way_cd -- 代付本金还款方式代码
    ,lmt_cont_id -- 额度合同编号
    ,pre_recv_int_flg -- 预收息标志
    ,coll_comp_int_flg -- 收复息标志
    ,fix_int_rat_flg -- 固定利率标志
    ,out_acct_tran_code -- 出帐交易码
    ,check_org_id -- 复核机构编号
    ,check_teller_id -- 复核柜员编号
    ,check_dt -- 复核日期
    ,margin_tran_status_cd -- 保证金交易状态代码
    ,repay_plan_tran_status_cd -- 还款计划交易状态代码
    ,core_out_acct_flow_num -- 核心出账流水号
    ,fin_sys_out_acct_flg -- 融资系统出账标志
    ,cap_src_cd -- 资金来源代码
    ,acpt_entry_tran_dt -- 承兑记账交易日期
    ,acpt_entry_tran_flow_num -- 承兑记账交易流水号
    ,file_int_flg -- 靠档计息标志
    ,comm_fee -- 签约手续费
    ,sell_status_cd -- 卖出状态代码
    ,cntpty_recvbl_acct_id -- 交易对手收款账户编号
    ,cntpty_recvbl_acct_name -- 交易对手收款账户名称
    ,cntpty_recvbl_bank_no -- 交易对手收款行行号
    ,cntpty_recvbl_bank_name -- 交易对手收款行名称
    ,level1_fft_actl_enter_id -- 一级福费廷实际入账账户编号
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,repl_old_bond_flg -- 置换旧债标志
    ,agent_present_flg -- 代理交单标志
    ,loan_card_td_que_excep_flg -- 贷款卡当日查询异常标志
    ,proc_sys_check_flg -- 进行系统校验标志
    ,auto_callbk_ctrl_open_flg -- 自动回收控制打开标志
    ,subtn_deduct_flg -- 持续扣款标志
    ,lpr_ref_way_cd -- LPR参照方式代码
    ,comp_int_int_rat_float_ratio -- 复利利率浮动比例
    ,comp_int_int_rat -- 复利利率
    ,dep_base_rat -- 存款基准利率
    ,dep_tenor -- 存款期限
    ,ghb_benefc_acct_num_flg -- 本行受益人账号标志
    ,aldy_sign_pool_fin_agt_flg -- 已签订池融资协议标志
    ,centr_out_acct_flg -- 集中出账标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,loan_type_cd -- 贷款类型代码
    ,entr_dep_acct_id -- 委托存款账户账号
    ,entr_dep_sub_acct_num -- 委托存款子账号
    ,csner_dep_acct_id -- 委托人存款账户编号
    ,pric_auto_rtn_flg -- 本金自动归还标志
    ,int_auto_rtn_flg -- 利息自动归还标志
    ,comn_inst_repay_flg -- 普通分期还款标志
    ,inst_loan_tot_perds -- 分期贷款总期数
    ,tenor_type_cd -- 期限类型代码
    ,entr_loan_comm_fee_rat -- 委托贷款手续费率
    ,crdt_distr_repay_plan_flg -- 信贷发放还款计划标志
    ,stop_accr_int_flg -- 停息标志
    ,margin_int_rat_type_cd -- 保证金利率类型代码
    ,margin_int_rat_float_type_cd -- 保证金利率浮动类型代码
    ,margin_int_rat_float_way_cd -- 保证金利率浮动方式代码
    ,margin_flo_val -- 保证金浮动值
    ,margin_int_accr_method_cd -- 保证金计息方法代码
    ,margin_int_rat_level_cd -- 保证金利率档次代码
    ,margin_agt_rat -- 保证金协议利率
    ,margin_exp_dt -- 保证金到期日期
    ,bill_uniq_ind_no -- 票据唯一标识号
    ,lc_amt -- 信用证金额
    ,exp_lc_issue_bank_name -- 出口信用证开证行名称
    ,lc_issuer -- 信用证开证人
    ,lc_benefc -- 信用证受益人
    ,lc_benefc_name -- 信用证受益人名称
    ,ibank_payfan_pric -- 同业代付本金
    ,discnt_bus_accptor_name -- 贴现业务承兑人名称
    ,bill_id -- 票据编号
    ,strk_bal_flg -- 冲账标志
    ,int_accr_days -- 计息天数
    ,ibank_payfan_provi_int_rat -- 同业代付计提利率
    ,todos -- 工本费
    ,bill_comm_fee_charge_way_cd -- 票据手续费收费方式代码
    ,log_mode_pay_cd -- 保函支付方式代码
    ,acpt_bus_accptor_name -- 承兑业务承兑人名称
    ,draw_dt -- 出票日期
    ,bill_type_cd -- 票据类型代码
    ,trust_flg -- 托管标志
    ,bill_cls_cd -- 票据分类代码
    ,intstl_bus_id -- 国结业务编号
    ,accpt_bil_comm_fee_amt -- 承兑汇票手续费金额
    ,trade_fin_rela_amt_one -- 贸易融资相关金额一
    ,trade_fin_rela_amt_two -- 贸易融资相关金额二
    ,trade_fin_rela_amt_three -- 贸易融资相关金额三
    ,trade_fin_rela_dt_one -- 贸易融资相关日期一
    ,trade_fin_rela_dt_two -- 贸易融资相关日期二
    ,trade_fin_ratio -- 贸易融资比例
    ,coll_type_cd -- 代收类型代码
    ,bill_rgst_status_flg -- 票据登记状态标志
    ,guar_org_id -- 担保机构编号
    ,int_amt -- 利息金额
    ,recv_bank_name -- 收款行名称
    ,trade_fin_type_cd -- 贸易融资类型代码
    ,recver_open_bank_name -- 收款人开户行名称
    ,accept_ps_name -- 收票人名称
    ,inv_id -- 发票号码
    ,enter_id -- 入账账户编号
    ,distr_cond_impt_flg -- 放款条件落实标志
    ,trade_fin_rela_curr_cd_one -- 贸易融资相关币种代码一
    ,trade_fin_rela_curr_cd_two -- 贸易融资相关币种代码二
    ,trade_fin_rela_curr_cd_three -- 贸易融资相关币种代码三
    ,log_bnft_bank_name -- 保函受益行名称
    ,fft_acpt_bank_no -- 福费廷承兑行行号
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,fft_cfm_bank_bank_no -- 福费廷保兑行行号
    ,buyer_pay_int_amt -- 买方付息金额
    ,redem_flg -- 赎回标志
    ,trade_fin_bus_id_one -- 贸易融资业务编号一
    ,trade_fin_bus_id_two -- 贸易融资业务编号二
    ,era_pay_bank_name -- 代付行名称
    ,log_type_cd -- 保函类型代码
    ,trade_fin_tenor_type_cd_one -- 贸易融资期限类型代码一
    ,trade_fin_tenor_type_cd_two -- 贸易融资期限类型代码二
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,stl_acct_open_bank_name -- 结算帐号开户行名称
    ,stl_acct_cust_name -- 结算帐号客户名称
    ,buyer_pay_int_acct_id -- 买方付息账户编号
    ,fin_log_flg -- 融资性保函标志
    ,enter_open_bank_name -- 入账账户开户行名称
    ,enter_cust_name -- 入账账户客户名称
    ,payfan_pric_repay_way_cd -- 代付本金还款方式代码
    ,lmt_cont_id -- 额度合同编号
    ,pre_recv_int_flg -- 预收息标志
    ,coll_comp_int_flg -- 收复息标志
    ,fix_int_rat_flg -- 固定利率标志
    ,out_acct_tran_code -- 出帐交易码
    ,check_org_id -- 复核机构编号
    ,check_teller_id -- 复核柜员编号
    ,check_dt -- 复核日期
    ,margin_tran_status_cd -- 保证金交易状态代码
    ,repay_plan_tran_status_cd -- 还款计划交易状态代码
    ,core_out_acct_flow_num -- 核心出账流水号
    ,fin_sys_out_acct_flg -- 融资系统出账标志
    ,cap_src_cd -- 资金来源代码
    ,acpt_entry_tran_dt -- 承兑记账交易日期
    ,acpt_entry_tran_flow_num -- 承兑记账交易流水号
    ,file_int_flg -- 靠档计息标志
    ,comm_fee -- 签约手续费
    ,sell_status_cd -- 卖出状态代码
    ,cntpty_recvbl_acct_id -- 交易对手收款账户编号
    ,cntpty_recvbl_acct_name -- 交易对手收款账户名称
    ,cntpty_recvbl_bank_no -- 交易对手收款行行号
    ,cntpty_recvbl_bank_name -- 交易对手收款行名称
    ,level1_fft_actl_enter_id -- 一级福费廷实际入账账户编号
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,repl_old_bond_flg -- 置换旧债标志
    ,agent_present_flg -- 代理交单标志
    ,loan_card_td_que_excep_flg -- 贷款卡当日查询异常标志
    ,proc_sys_check_flg -- 进行系统校验标志
    ,auto_callbk_ctrl_open_flg -- 自动回收控制打开标志
    ,subtn_deduct_flg -- 持续扣款标志
    ,lpr_ref_way_cd -- LPR参照方式代码
    ,comp_int_int_rat_float_ratio -- 复利利率浮动比例
    ,comp_int_int_rat -- 复利利率
    ,dep_base_rat -- 存款基准利率
    ,dep_tenor -- 存款期限
    ,ghb_benefc_acct_num_flg -- 本行受益人账号标志
    ,aldy_sign_pool_fin_agt_flg -- 已签订池融资协议标志
    ,centr_out_acct_flg -- 集中出账标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.out_acct_flow_num, o.out_acct_flow_num) as out_acct_flow_num -- 出账流水号
    ,nvl(n.loan_type_cd, o.loan_type_cd) as loan_type_cd -- 贷款类型代码
    ,nvl(n.entr_dep_acct_id, o.entr_dep_acct_id) as entr_dep_acct_id -- 委托存款账户账号
    ,nvl(n.entr_dep_sub_acct_num, o.entr_dep_sub_acct_num) as entr_dep_sub_acct_num -- 委托存款子账号
    ,nvl(n.csner_dep_acct_id, o.csner_dep_acct_id) as csner_dep_acct_id -- 委托人存款账户编号
    ,nvl(n.pric_auto_rtn_flg, o.pric_auto_rtn_flg) as pric_auto_rtn_flg -- 本金自动归还标志
    ,nvl(n.int_auto_rtn_flg, o.int_auto_rtn_flg) as int_auto_rtn_flg -- 利息自动归还标志
    ,nvl(n.comn_inst_repay_flg, o.comn_inst_repay_flg) as comn_inst_repay_flg -- 普通分期还款标志
    ,nvl(n.inst_loan_tot_perds, o.inst_loan_tot_perds) as inst_loan_tot_perds -- 分期贷款总期数
    ,nvl(n.tenor_type_cd, o.tenor_type_cd) as tenor_type_cd -- 期限类型代码
    ,nvl(n.entr_loan_comm_fee_rat, o.entr_loan_comm_fee_rat) as entr_loan_comm_fee_rat -- 委托贷款手续费率
    ,nvl(n.crdt_distr_repay_plan_flg, o.crdt_distr_repay_plan_flg) as crdt_distr_repay_plan_flg -- 信贷发放还款计划标志
    ,nvl(n.stop_accr_int_flg, o.stop_accr_int_flg) as stop_accr_int_flg -- 停息标志
    ,nvl(n.margin_int_rat_type_cd, o.margin_int_rat_type_cd) as margin_int_rat_type_cd -- 保证金利率类型代码
    ,nvl(n.margin_int_rat_float_type_cd, o.margin_int_rat_float_type_cd) as margin_int_rat_float_type_cd -- 保证金利率浮动类型代码
    ,nvl(n.margin_int_rat_float_way_cd, o.margin_int_rat_float_way_cd) as margin_int_rat_float_way_cd -- 保证金利率浮动方式代码
    ,nvl(n.margin_flo_val, o.margin_flo_val) as margin_flo_val -- 保证金浮动值
    ,nvl(n.margin_int_accr_method_cd, o.margin_int_accr_method_cd) as margin_int_accr_method_cd -- 保证金计息方法代码
    ,nvl(n.margin_int_rat_level_cd, o.margin_int_rat_level_cd) as margin_int_rat_level_cd -- 保证金利率档次代码
    ,nvl(n.margin_agt_rat, o.margin_agt_rat) as margin_agt_rat -- 保证金协议利率
    ,nvl(n.margin_exp_dt, o.margin_exp_dt) as margin_exp_dt -- 保证金到期日期
    ,nvl(n.bill_uniq_ind_no, o.bill_uniq_ind_no) as bill_uniq_ind_no -- 票据唯一标识号
    ,nvl(n.lc_amt, o.lc_amt) as lc_amt -- 信用证金额
    ,nvl(n.exp_lc_issue_bank_name, o.exp_lc_issue_bank_name) as exp_lc_issue_bank_name -- 出口信用证开证行名称
    ,nvl(n.lc_issuer, o.lc_issuer) as lc_issuer -- 信用证开证人
    ,nvl(n.lc_benefc, o.lc_benefc) as lc_benefc -- 信用证受益人
    ,nvl(n.lc_benefc_name, o.lc_benefc_name) as lc_benefc_name -- 信用证受益人名称
    ,nvl(n.ibank_payfan_pric, o.ibank_payfan_pric) as ibank_payfan_pric -- 同业代付本金
    ,nvl(n.discnt_bus_accptor_name, o.discnt_bus_accptor_name) as discnt_bus_accptor_name -- 贴现业务承兑人名称
    ,nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.strk_bal_flg, o.strk_bal_flg) as strk_bal_flg -- 冲账标志
    ,nvl(n.int_accr_days, o.int_accr_days) as int_accr_days -- 计息天数
    ,nvl(n.ibank_payfan_provi_int_rat, o.ibank_payfan_provi_int_rat) as ibank_payfan_provi_int_rat -- 同业代付计提利率
    ,nvl(n.todos, o.todos) as todos -- 工本费
    ,nvl(n.bill_comm_fee_charge_way_cd, o.bill_comm_fee_charge_way_cd) as bill_comm_fee_charge_way_cd -- 票据手续费收费方式代码
    ,nvl(n.log_mode_pay_cd, o.log_mode_pay_cd) as log_mode_pay_cd -- 保函支付方式代码
    ,nvl(n.acpt_bus_accptor_name, o.acpt_bus_accptor_name) as acpt_bus_accptor_name -- 承兑业务承兑人名称
    ,nvl(n.draw_dt, o.draw_dt) as draw_dt -- 出票日期
    ,nvl(n.bill_type_cd, o.bill_type_cd) as bill_type_cd -- 票据类型代码
    ,nvl(n.trust_flg, o.trust_flg) as trust_flg -- 托管标志
    ,nvl(n.bill_cls_cd, o.bill_cls_cd) as bill_cls_cd -- 票据分类代码
    ,nvl(n.intstl_bus_id, o.intstl_bus_id) as intstl_bus_id -- 国结业务编号
    ,nvl(n.accpt_bil_comm_fee_amt, o.accpt_bil_comm_fee_amt) as accpt_bil_comm_fee_amt -- 承兑汇票手续费金额
    ,nvl(n.trade_fin_rela_amt_one, o.trade_fin_rela_amt_one) as trade_fin_rela_amt_one -- 贸易融资相关金额一
    ,nvl(n.trade_fin_rela_amt_two, o.trade_fin_rela_amt_two) as trade_fin_rela_amt_two -- 贸易融资相关金额二
    ,nvl(n.trade_fin_rela_amt_three, o.trade_fin_rela_amt_three) as trade_fin_rela_amt_three -- 贸易融资相关金额三
    ,nvl(n.trade_fin_rela_dt_one, o.trade_fin_rela_dt_one) as trade_fin_rela_dt_one -- 贸易融资相关日期一
    ,nvl(n.trade_fin_rela_dt_two, o.trade_fin_rela_dt_two) as trade_fin_rela_dt_two -- 贸易融资相关日期二
    ,nvl(n.trade_fin_ratio, o.trade_fin_ratio) as trade_fin_ratio -- 贸易融资比例
    ,nvl(n.coll_type_cd, o.coll_type_cd) as coll_type_cd -- 代收类型代码
    ,nvl(n.bill_rgst_status_flg, o.bill_rgst_status_flg) as bill_rgst_status_flg -- 票据登记状态标志
    ,nvl(n.guar_org_id, o.guar_org_id) as guar_org_id -- 担保机构编号
    ,nvl(n.int_amt, o.int_amt) as int_amt -- 利息金额
    ,nvl(n.recv_bank_name, o.recv_bank_name) as recv_bank_name -- 收款行名称
    ,nvl(n.trade_fin_type_cd, o.trade_fin_type_cd) as trade_fin_type_cd -- 贸易融资类型代码
    ,nvl(n.recver_open_bank_name, o.recver_open_bank_name) as recver_open_bank_name -- 收款人开户行名称
    ,nvl(n.accept_ps_name, o.accept_ps_name) as accept_ps_name -- 收票人名称
    ,nvl(n.inv_id, o.inv_id) as inv_id -- 发票号码
    ,nvl(n.enter_id, o.enter_id) as enter_id -- 入账账户编号
    ,nvl(n.distr_cond_impt_flg, o.distr_cond_impt_flg) as distr_cond_impt_flg -- 放款条件落实标志
    ,nvl(n.trade_fin_rela_curr_cd_one, o.trade_fin_rela_curr_cd_one) as trade_fin_rela_curr_cd_one -- 贸易融资相关币种代码一
    ,nvl(n.trade_fin_rela_curr_cd_two, o.trade_fin_rela_curr_cd_two) as trade_fin_rela_curr_cd_two -- 贸易融资相关币种代码二
    ,nvl(n.trade_fin_rela_curr_cd_three, o.trade_fin_rela_curr_cd_three) as trade_fin_rela_curr_cd_three -- 贸易融资相关币种代码三
    ,nvl(n.log_bnft_bank_name, o.log_bnft_bank_name) as log_bnft_bank_name -- 保函受益行名称
    ,nvl(n.fft_acpt_bank_no, o.fft_acpt_bank_no) as fft_acpt_bank_no -- 福费廷承兑行行号
    ,nvl(n.accptor_open_bank_no, o.accptor_open_bank_no) as accptor_open_bank_no -- 承兑人开户行行号
    ,nvl(n.fft_cfm_bank_bank_no, o.fft_cfm_bank_bank_no) as fft_cfm_bank_bank_no -- 福费廷保兑行行号
    ,nvl(n.buyer_pay_int_amt, o.buyer_pay_int_amt) as buyer_pay_int_amt -- 买方付息金额
    ,nvl(n.redem_flg, o.redem_flg) as redem_flg -- 赎回标志
    ,nvl(n.trade_fin_bus_id_one, o.trade_fin_bus_id_one) as trade_fin_bus_id_one -- 贸易融资业务编号一
    ,nvl(n.trade_fin_bus_id_two, o.trade_fin_bus_id_two) as trade_fin_bus_id_two -- 贸易融资业务编号二
    ,nvl(n.era_pay_bank_name, o.era_pay_bank_name) as era_pay_bank_name -- 代付行名称
    ,nvl(n.log_type_cd, o.log_type_cd) as log_type_cd -- 保函类型代码
    ,nvl(n.trade_fin_tenor_type_cd_one, o.trade_fin_tenor_type_cd_one) as trade_fin_tenor_type_cd_one -- 贸易融资期限类型代码一
    ,nvl(n.trade_fin_tenor_type_cd_two, o.trade_fin_tenor_type_cd_two) as trade_fin_tenor_type_cd_two -- 贸易融资期限类型代码二
    ,nvl(n.accptor_open_bank_name, o.accptor_open_bank_name) as accptor_open_bank_name -- 承兑人开户行名称
    ,nvl(n.stl_acct_open_bank_name, o.stl_acct_open_bank_name) as stl_acct_open_bank_name -- 结算帐号开户行名称
    ,nvl(n.stl_acct_cust_name, o.stl_acct_cust_name) as stl_acct_cust_name -- 结算帐号客户名称
    ,nvl(n.buyer_pay_int_acct_id, o.buyer_pay_int_acct_id) as buyer_pay_int_acct_id -- 买方付息账户编号
    ,nvl(n.fin_log_flg, o.fin_log_flg) as fin_log_flg -- 融资性保函标志
    ,nvl(n.enter_open_bank_name, o.enter_open_bank_name) as enter_open_bank_name -- 入账账户开户行名称
    ,nvl(n.enter_cust_name, o.enter_cust_name) as enter_cust_name -- 入账账户客户名称
    ,nvl(n.payfan_pric_repay_way_cd, o.payfan_pric_repay_way_cd) as payfan_pric_repay_way_cd -- 代付本金还款方式代码
    ,nvl(n.lmt_cont_id, o.lmt_cont_id) as lmt_cont_id -- 额度合同编号
    ,nvl(n.pre_recv_int_flg, o.pre_recv_int_flg) as pre_recv_int_flg -- 预收息标志
    ,nvl(n.coll_comp_int_flg, o.coll_comp_int_flg) as coll_comp_int_flg -- 收复息标志
    ,nvl(n.fix_int_rat_flg, o.fix_int_rat_flg) as fix_int_rat_flg -- 固定利率标志
    ,nvl(n.out_acct_tran_code, o.out_acct_tran_code) as out_acct_tran_code -- 出帐交易码
    ,nvl(n.check_org_id, o.check_org_id) as check_org_id -- 复核机构编号
    ,nvl(n.check_teller_id, o.check_teller_id) as check_teller_id -- 复核柜员编号
    ,nvl(n.check_dt, o.check_dt) as check_dt -- 复核日期
    ,nvl(n.margin_tran_status_cd, o.margin_tran_status_cd) as margin_tran_status_cd -- 保证金交易状态代码
    ,nvl(n.repay_plan_tran_status_cd, o.repay_plan_tran_status_cd) as repay_plan_tran_status_cd -- 还款计划交易状态代码
    ,nvl(n.core_out_acct_flow_num, o.core_out_acct_flow_num) as core_out_acct_flow_num -- 核心出账流水号
    ,nvl(n.fin_sys_out_acct_flg, o.fin_sys_out_acct_flg) as fin_sys_out_acct_flg -- 融资系统出账标志
    ,nvl(n.cap_src_cd, o.cap_src_cd) as cap_src_cd -- 资金来源代码
    ,nvl(n.acpt_entry_tran_dt, o.acpt_entry_tran_dt) as acpt_entry_tran_dt -- 承兑记账交易日期
    ,nvl(n.acpt_entry_tran_flow_num, o.acpt_entry_tran_flow_num) as acpt_entry_tran_flow_num -- 承兑记账交易流水号
    ,nvl(n.file_int_flg, o.file_int_flg) as file_int_flg -- 靠档计息标志
    ,nvl(n.comm_fee, o.comm_fee) as comm_fee -- 签约手续费
    ,nvl(n.sell_status_cd, o.sell_status_cd) as sell_status_cd -- 卖出状态代码
    ,nvl(n.cntpty_recvbl_acct_id, o.cntpty_recvbl_acct_id) as cntpty_recvbl_acct_id -- 交易对手收款账户编号
    ,nvl(n.cntpty_recvbl_acct_name, o.cntpty_recvbl_acct_name) as cntpty_recvbl_acct_name -- 交易对手收款账户名称
    ,nvl(n.cntpty_recvbl_bank_no, o.cntpty_recvbl_bank_no) as cntpty_recvbl_bank_no -- 交易对手收款行行号
    ,nvl(n.cntpty_recvbl_bank_name, o.cntpty_recvbl_bank_name) as cntpty_recvbl_bank_name -- 交易对手收款行名称
    ,nvl(n.level1_fft_actl_enter_id, o.level1_fft_actl_enter_id) as level1_fft_actl_enter_id -- 一级福费廷实际入账账户编号
    ,nvl(n.int_rat_start_use_way_cd, o.int_rat_start_use_way_cd) as int_rat_start_use_way_cd -- 利率启用方式代码
    ,nvl(n.repl_old_bond_flg, o.repl_old_bond_flg) as repl_old_bond_flg -- 置换旧债标志
    ,nvl(n.agent_present_flg, o.agent_present_flg) as agent_present_flg -- 代理交单标志
    ,nvl(n.loan_card_td_que_excep_flg, o.loan_card_td_que_excep_flg) as loan_card_td_que_excep_flg -- 贷款卡当日查询异常标志
    ,nvl(n.proc_sys_check_flg, o.proc_sys_check_flg) as proc_sys_check_flg -- 进行系统校验标志
    ,nvl(n.auto_callbk_ctrl_open_flg, o.auto_callbk_ctrl_open_flg) as auto_callbk_ctrl_open_flg -- 自动回收控制打开标志
    ,nvl(n.subtn_deduct_flg, o.subtn_deduct_flg) as subtn_deduct_flg -- 持续扣款标志
    ,nvl(n.lpr_ref_way_cd, o.lpr_ref_way_cd) as lpr_ref_way_cd -- LPR参照方式代码
    ,nvl(n.comp_int_int_rat_float_ratio, o.comp_int_int_rat_float_ratio) as comp_int_int_rat_float_ratio -- 复利利率浮动比例
    ,nvl(n.comp_int_int_rat, o.comp_int_int_rat) as comp_int_int_rat -- 复利利率
    ,nvl(n.dep_base_rat, o.dep_base_rat) as dep_base_rat -- 存款基准利率
    ,nvl(n.dep_tenor, o.dep_tenor) as dep_tenor -- 存款期限
    ,nvl(n.ghb_benefc_acct_num_flg, o.ghb_benefc_acct_num_flg) as ghb_benefc_acct_num_flg -- 本行受益人账号标志
    ,nvl(n.aldy_sign_pool_fin_agt_flg, o.aldy_sign_pool_fin_agt_flg) as aldy_sign_pool_fin_agt_flg -- 已签订池融资协议标志
    ,nvl(n.centr_out_acct_flg, o.centr_out_acct_flg) as centr_out_acct_flg -- 集中出账标志
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
where (
        o.appl_id is null
        and o.lp_id is null
    )
    or (
        n.appl_id is null
        and n.lp_id is null
    )
    or (
        o.out_acct_flow_num <> n.out_acct_flow_num
        or o.loan_type_cd <> n.loan_type_cd
        or o.entr_dep_acct_id <> n.entr_dep_acct_id
        or o.entr_dep_sub_acct_num <> n.entr_dep_sub_acct_num
        or o.csner_dep_acct_id <> n.csner_dep_acct_id
        or o.pric_auto_rtn_flg <> n.pric_auto_rtn_flg
        or o.int_auto_rtn_flg <> n.int_auto_rtn_flg
        or o.comn_inst_repay_flg <> n.comn_inst_repay_flg
        or o.inst_loan_tot_perds <> n.inst_loan_tot_perds
        or o.tenor_type_cd <> n.tenor_type_cd
        or o.entr_loan_comm_fee_rat <> n.entr_loan_comm_fee_rat
        or o.crdt_distr_repay_plan_flg <> n.crdt_distr_repay_plan_flg
        or o.stop_accr_int_flg <> n.stop_accr_int_flg
        or o.margin_int_rat_type_cd <> n.margin_int_rat_type_cd
        or o.margin_int_rat_float_type_cd <> n.margin_int_rat_float_type_cd
        or o.margin_int_rat_float_way_cd <> n.margin_int_rat_float_way_cd
        or o.margin_flo_val <> n.margin_flo_val
        or o.margin_int_accr_method_cd <> n.margin_int_accr_method_cd
        or o.margin_int_rat_level_cd <> n.margin_int_rat_level_cd
        or o.margin_agt_rat <> n.margin_agt_rat
        or o.margin_exp_dt <> n.margin_exp_dt
        or o.bill_uniq_ind_no <> n.bill_uniq_ind_no
        or o.lc_amt <> n.lc_amt
        or o.exp_lc_issue_bank_name <> n.exp_lc_issue_bank_name
        or o.lc_issuer <> n.lc_issuer
        or o.lc_benefc <> n.lc_benefc
        or o.lc_benefc_name <> n.lc_benefc_name
        or o.ibank_payfan_pric <> n.ibank_payfan_pric
        or o.discnt_bus_accptor_name <> n.discnt_bus_accptor_name
        or o.bill_id <> n.bill_id
        or o.strk_bal_flg <> n.strk_bal_flg
        or o.int_accr_days <> n.int_accr_days
        or o.ibank_payfan_provi_int_rat <> n.ibank_payfan_provi_int_rat
        or o.todos <> n.todos
        or o.bill_comm_fee_charge_way_cd <> n.bill_comm_fee_charge_way_cd
        or o.log_mode_pay_cd <> n.log_mode_pay_cd
        or o.acpt_bus_accptor_name <> n.acpt_bus_accptor_name
        or o.draw_dt <> n.draw_dt
        or o.bill_type_cd <> n.bill_type_cd
        or o.trust_flg <> n.trust_flg
        or o.bill_cls_cd <> n.bill_cls_cd
        or o.intstl_bus_id <> n.intstl_bus_id
        or o.accpt_bil_comm_fee_amt <> n.accpt_bil_comm_fee_amt
        or o.trade_fin_rela_amt_one <> n.trade_fin_rela_amt_one
        or o.trade_fin_rela_amt_two <> n.trade_fin_rela_amt_two
        or o.trade_fin_rela_amt_three <> n.trade_fin_rela_amt_three
        or o.trade_fin_rela_dt_one <> n.trade_fin_rela_dt_one
        or o.trade_fin_rela_dt_two <> n.trade_fin_rela_dt_two
        or o.trade_fin_ratio <> n.trade_fin_ratio
        or o.coll_type_cd <> n.coll_type_cd
        or o.bill_rgst_status_flg <> n.bill_rgst_status_flg
        or o.guar_org_id <> n.guar_org_id
        or o.int_amt <> n.int_amt
        or o.recv_bank_name <> n.recv_bank_name
        or o.trade_fin_type_cd <> n.trade_fin_type_cd
        or o.recver_open_bank_name <> n.recver_open_bank_name
        or o.accept_ps_name <> n.accept_ps_name
        or o.inv_id <> n.inv_id
        or o.enter_id <> n.enter_id
        or o.distr_cond_impt_flg <> n.distr_cond_impt_flg
        or o.trade_fin_rela_curr_cd_one <> n.trade_fin_rela_curr_cd_one
        or o.trade_fin_rela_curr_cd_two <> n.trade_fin_rela_curr_cd_two
        or o.trade_fin_rela_curr_cd_three <> n.trade_fin_rela_curr_cd_three
        or o.log_bnft_bank_name <> n.log_bnft_bank_name
        or o.fft_acpt_bank_no <> n.fft_acpt_bank_no
        or o.accptor_open_bank_no <> n.accptor_open_bank_no
        or o.fft_cfm_bank_bank_no <> n.fft_cfm_bank_bank_no
        or o.buyer_pay_int_amt <> n.buyer_pay_int_amt
        or o.redem_flg <> n.redem_flg
        or o.trade_fin_bus_id_one <> n.trade_fin_bus_id_one
        or o.trade_fin_bus_id_two <> n.trade_fin_bus_id_two
        or o.era_pay_bank_name <> n.era_pay_bank_name
        or o.log_type_cd <> n.log_type_cd
        or o.trade_fin_tenor_type_cd_one <> n.trade_fin_tenor_type_cd_one
        or o.trade_fin_tenor_type_cd_two <> n.trade_fin_tenor_type_cd_two
        or o.accptor_open_bank_name <> n.accptor_open_bank_name
        or o.stl_acct_open_bank_name <> n.stl_acct_open_bank_name
        or o.stl_acct_cust_name <> n.stl_acct_cust_name
        or o.buyer_pay_int_acct_id <> n.buyer_pay_int_acct_id
        or o.fin_log_flg <> n.fin_log_flg
        or o.enter_open_bank_name <> n.enter_open_bank_name
        or o.enter_cust_name <> n.enter_cust_name
        or o.payfan_pric_repay_way_cd <> n.payfan_pric_repay_way_cd
        or o.lmt_cont_id <> n.lmt_cont_id
        or o.pre_recv_int_flg <> n.pre_recv_int_flg
        or o.coll_comp_int_flg <> n.coll_comp_int_flg
        or o.fix_int_rat_flg <> n.fix_int_rat_flg
        or o.out_acct_tran_code <> n.out_acct_tran_code
        or o.check_org_id <> n.check_org_id
        or o.check_teller_id <> n.check_teller_id
        or o.check_dt <> n.check_dt
        or o.margin_tran_status_cd <> n.margin_tran_status_cd
        or o.repay_plan_tran_status_cd <> n.repay_plan_tran_status_cd
        or o.core_out_acct_flow_num <> n.core_out_acct_flow_num
        or o.fin_sys_out_acct_flg <> n.fin_sys_out_acct_flg
        or o.cap_src_cd <> n.cap_src_cd
        or o.acpt_entry_tran_dt <> n.acpt_entry_tran_dt
        or o.acpt_entry_tran_flow_num <> n.acpt_entry_tran_flow_num
        or o.file_int_flg <> n.file_int_flg
        or o.comm_fee <> n.comm_fee
        or o.sell_status_cd <> n.sell_status_cd
        or o.cntpty_recvbl_acct_id <> n.cntpty_recvbl_acct_id
        or o.cntpty_recvbl_acct_name <> n.cntpty_recvbl_acct_name
        or o.cntpty_recvbl_bank_no <> n.cntpty_recvbl_bank_no
        or o.cntpty_recvbl_bank_name <> n.cntpty_recvbl_bank_name
        or o.level1_fft_actl_enter_id <> n.level1_fft_actl_enter_id
        or o.int_rat_start_use_way_cd <> n.int_rat_start_use_way_cd
        or o.repl_old_bond_flg <> n.repl_old_bond_flg
        or o.agent_present_flg <> n.agent_present_flg
        or o.loan_card_td_que_excep_flg <> n.loan_card_td_que_excep_flg
        or o.proc_sys_check_flg <> n.proc_sys_check_flg
        or o.auto_callbk_ctrl_open_flg <> n.auto_callbk_ctrl_open_flg
        or o.subtn_deduct_flg <> n.subtn_deduct_flg
        or o.lpr_ref_way_cd <> n.lpr_ref_way_cd
        or o.comp_int_int_rat_float_ratio <> n.comp_int_int_rat_float_ratio
        or o.comp_int_int_rat <> n.comp_int_int_rat
        or o.dep_base_rat <> n.dep_base_rat
        or o.dep_tenor <> n.dep_tenor
        or o.ghb_benefc_acct_num_flg <> n.ghb_benefc_acct_num_flg
        or o.aldy_sign_pool_fin_agt_flg <> n.aldy_sign_pool_fin_agt_flg
        or o.centr_out_acct_flg <> n.centr_out_acct_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,loan_type_cd -- 贷款类型代码
    ,entr_dep_acct_id -- 委托存款账户账号
    ,entr_dep_sub_acct_num -- 委托存款子账号
    ,csner_dep_acct_id -- 委托人存款账户编号
    ,pric_auto_rtn_flg -- 本金自动归还标志
    ,int_auto_rtn_flg -- 利息自动归还标志
    ,comn_inst_repay_flg -- 普通分期还款标志
    ,inst_loan_tot_perds -- 分期贷款总期数
    ,tenor_type_cd -- 期限类型代码
    ,entr_loan_comm_fee_rat -- 委托贷款手续费率
    ,crdt_distr_repay_plan_flg -- 信贷发放还款计划标志
    ,stop_accr_int_flg -- 停息标志
    ,margin_int_rat_type_cd -- 保证金利率类型代码
    ,margin_int_rat_float_type_cd -- 保证金利率浮动类型代码
    ,margin_int_rat_float_way_cd -- 保证金利率浮动方式代码
    ,margin_flo_val -- 保证金浮动值
    ,margin_int_accr_method_cd -- 保证金计息方法代码
    ,margin_int_rat_level_cd -- 保证金利率档次代码
    ,margin_agt_rat -- 保证金协议利率
    ,margin_exp_dt -- 保证金到期日期
    ,bill_uniq_ind_no -- 票据唯一标识号
    ,lc_amt -- 信用证金额
    ,exp_lc_issue_bank_name -- 出口信用证开证行名称
    ,lc_issuer -- 信用证开证人
    ,lc_benefc -- 信用证受益人
    ,lc_benefc_name -- 信用证受益人名称
    ,ibank_payfan_pric -- 同业代付本金
    ,discnt_bus_accptor_name -- 贴现业务承兑人名称
    ,bill_id -- 票据编号
    ,strk_bal_flg -- 冲账标志
    ,int_accr_days -- 计息天数
    ,ibank_payfan_provi_int_rat -- 同业代付计提利率
    ,todos -- 工本费
    ,bill_comm_fee_charge_way_cd -- 票据手续费收费方式代码
    ,log_mode_pay_cd -- 保函支付方式代码
    ,acpt_bus_accptor_name -- 承兑业务承兑人名称
    ,draw_dt -- 出票日期
    ,bill_type_cd -- 票据类型代码
    ,trust_flg -- 托管标志
    ,bill_cls_cd -- 票据分类代码
    ,intstl_bus_id -- 国结业务编号
    ,accpt_bil_comm_fee_amt -- 承兑汇票手续费金额
    ,trade_fin_rela_amt_one -- 贸易融资相关金额一
    ,trade_fin_rela_amt_two -- 贸易融资相关金额二
    ,trade_fin_rela_amt_three -- 贸易融资相关金额三
    ,trade_fin_rela_dt_one -- 贸易融资相关日期一
    ,trade_fin_rela_dt_two -- 贸易融资相关日期二
    ,trade_fin_ratio -- 贸易融资比例
    ,coll_type_cd -- 代收类型代码
    ,bill_rgst_status_flg -- 票据登记状态标志
    ,guar_org_id -- 担保机构编号
    ,int_amt -- 利息金额
    ,recv_bank_name -- 收款行名称
    ,trade_fin_type_cd -- 贸易融资类型代码
    ,recver_open_bank_name -- 收款人开户行名称
    ,accept_ps_name -- 收票人名称
    ,inv_id -- 发票号码
    ,enter_id -- 入账账户编号
    ,distr_cond_impt_flg -- 放款条件落实标志
    ,trade_fin_rela_curr_cd_one -- 贸易融资相关币种代码一
    ,trade_fin_rela_curr_cd_two -- 贸易融资相关币种代码二
    ,trade_fin_rela_curr_cd_three -- 贸易融资相关币种代码三
    ,log_bnft_bank_name -- 保函受益行名称
    ,fft_acpt_bank_no -- 福费廷承兑行行号
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,fft_cfm_bank_bank_no -- 福费廷保兑行行号
    ,buyer_pay_int_amt -- 买方付息金额
    ,redem_flg -- 赎回标志
    ,trade_fin_bus_id_one -- 贸易融资业务编号一
    ,trade_fin_bus_id_two -- 贸易融资业务编号二
    ,era_pay_bank_name -- 代付行名称
    ,log_type_cd -- 保函类型代码
    ,trade_fin_tenor_type_cd_one -- 贸易融资期限类型代码一
    ,trade_fin_tenor_type_cd_two -- 贸易融资期限类型代码二
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,stl_acct_open_bank_name -- 结算帐号开户行名称
    ,stl_acct_cust_name -- 结算帐号客户名称
    ,buyer_pay_int_acct_id -- 买方付息账户编号
    ,fin_log_flg -- 融资性保函标志
    ,enter_open_bank_name -- 入账账户开户行名称
    ,enter_cust_name -- 入账账户客户名称
    ,payfan_pric_repay_way_cd -- 代付本金还款方式代码
    ,lmt_cont_id -- 额度合同编号
    ,pre_recv_int_flg -- 预收息标志
    ,coll_comp_int_flg -- 收复息标志
    ,fix_int_rat_flg -- 固定利率标志
    ,out_acct_tran_code -- 出帐交易码
    ,check_org_id -- 复核机构编号
    ,check_teller_id -- 复核柜员编号
    ,check_dt -- 复核日期
    ,margin_tran_status_cd -- 保证金交易状态代码
    ,repay_plan_tran_status_cd -- 还款计划交易状态代码
    ,core_out_acct_flow_num -- 核心出账流水号
    ,fin_sys_out_acct_flg -- 融资系统出账标志
    ,cap_src_cd -- 资金来源代码
    ,acpt_entry_tran_dt -- 承兑记账交易日期
    ,acpt_entry_tran_flow_num -- 承兑记账交易流水号
    ,file_int_flg -- 靠档计息标志
    ,comm_fee -- 签约手续费
    ,sell_status_cd -- 卖出状态代码
    ,cntpty_recvbl_acct_id -- 交易对手收款账户编号
    ,cntpty_recvbl_acct_name -- 交易对手收款账户名称
    ,cntpty_recvbl_bank_no -- 交易对手收款行行号
    ,cntpty_recvbl_bank_name -- 交易对手收款行名称
    ,level1_fft_actl_enter_id -- 一级福费廷实际入账账户编号
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,repl_old_bond_flg -- 置换旧债标志
    ,agent_present_flg -- 代理交单标志
    ,loan_card_td_que_excep_flg -- 贷款卡当日查询异常标志
    ,proc_sys_check_flg -- 进行系统校验标志
    ,auto_callbk_ctrl_open_flg -- 自动回收控制打开标志
    ,subtn_deduct_flg -- 持续扣款标志
    ,lpr_ref_way_cd -- LPR参照方式代码
    ,comp_int_int_rat_float_ratio -- 复利利率浮动比例
    ,comp_int_int_rat -- 复利利率
    ,dep_base_rat -- 存款基准利率
    ,dep_tenor -- 存款期限
    ,ghb_benefc_acct_num_flg -- 本行受益人账号标志
    ,aldy_sign_pool_fin_agt_flg -- 已签订池融资协议标志
    ,centr_out_acct_flg -- 集中出账标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,loan_type_cd -- 贷款类型代码
    ,entr_dep_acct_id -- 委托存款账户账号
    ,entr_dep_sub_acct_num -- 委托存款子账号
    ,csner_dep_acct_id -- 委托人存款账户编号
    ,pric_auto_rtn_flg -- 本金自动归还标志
    ,int_auto_rtn_flg -- 利息自动归还标志
    ,comn_inst_repay_flg -- 普通分期还款标志
    ,inst_loan_tot_perds -- 分期贷款总期数
    ,tenor_type_cd -- 期限类型代码
    ,entr_loan_comm_fee_rat -- 委托贷款手续费率
    ,crdt_distr_repay_plan_flg -- 信贷发放还款计划标志
    ,stop_accr_int_flg -- 停息标志
    ,margin_int_rat_type_cd -- 保证金利率类型代码
    ,margin_int_rat_float_type_cd -- 保证金利率浮动类型代码
    ,margin_int_rat_float_way_cd -- 保证金利率浮动方式代码
    ,margin_flo_val -- 保证金浮动值
    ,margin_int_accr_method_cd -- 保证金计息方法代码
    ,margin_int_rat_level_cd -- 保证金利率档次代码
    ,margin_agt_rat -- 保证金协议利率
    ,margin_exp_dt -- 保证金到期日期
    ,bill_uniq_ind_no -- 票据唯一标识号
    ,lc_amt -- 信用证金额
    ,exp_lc_issue_bank_name -- 出口信用证开证行名称
    ,lc_issuer -- 信用证开证人
    ,lc_benefc -- 信用证受益人
    ,lc_benefc_name -- 信用证受益人名称
    ,ibank_payfan_pric -- 同业代付本金
    ,discnt_bus_accptor_name -- 贴现业务承兑人名称
    ,bill_id -- 票据编号
    ,strk_bal_flg -- 冲账标志
    ,int_accr_days -- 计息天数
    ,ibank_payfan_provi_int_rat -- 同业代付计提利率
    ,todos -- 工本费
    ,bill_comm_fee_charge_way_cd -- 票据手续费收费方式代码
    ,log_mode_pay_cd -- 保函支付方式代码
    ,acpt_bus_accptor_name -- 承兑业务承兑人名称
    ,draw_dt -- 出票日期
    ,bill_type_cd -- 票据类型代码
    ,trust_flg -- 托管标志
    ,bill_cls_cd -- 票据分类代码
    ,intstl_bus_id -- 国结业务编号
    ,accpt_bil_comm_fee_amt -- 承兑汇票手续费金额
    ,trade_fin_rela_amt_one -- 贸易融资相关金额一
    ,trade_fin_rela_amt_two -- 贸易融资相关金额二
    ,trade_fin_rela_amt_three -- 贸易融资相关金额三
    ,trade_fin_rela_dt_one -- 贸易融资相关日期一
    ,trade_fin_rela_dt_two -- 贸易融资相关日期二
    ,trade_fin_ratio -- 贸易融资比例
    ,coll_type_cd -- 代收类型代码
    ,bill_rgst_status_flg -- 票据登记状态标志
    ,guar_org_id -- 担保机构编号
    ,int_amt -- 利息金额
    ,recv_bank_name -- 收款行名称
    ,trade_fin_type_cd -- 贸易融资类型代码
    ,recver_open_bank_name -- 收款人开户行名称
    ,accept_ps_name -- 收票人名称
    ,inv_id -- 发票号码
    ,enter_id -- 入账账户编号
    ,distr_cond_impt_flg -- 放款条件落实标志
    ,trade_fin_rela_curr_cd_one -- 贸易融资相关币种代码一
    ,trade_fin_rela_curr_cd_two -- 贸易融资相关币种代码二
    ,trade_fin_rela_curr_cd_three -- 贸易融资相关币种代码三
    ,log_bnft_bank_name -- 保函受益行名称
    ,fft_acpt_bank_no -- 福费廷承兑行行号
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,fft_cfm_bank_bank_no -- 福费廷保兑行行号
    ,buyer_pay_int_amt -- 买方付息金额
    ,redem_flg -- 赎回标志
    ,trade_fin_bus_id_one -- 贸易融资业务编号一
    ,trade_fin_bus_id_two -- 贸易融资业务编号二
    ,era_pay_bank_name -- 代付行名称
    ,log_type_cd -- 保函类型代码
    ,trade_fin_tenor_type_cd_one -- 贸易融资期限类型代码一
    ,trade_fin_tenor_type_cd_two -- 贸易融资期限类型代码二
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,stl_acct_open_bank_name -- 结算帐号开户行名称
    ,stl_acct_cust_name -- 结算帐号客户名称
    ,buyer_pay_int_acct_id -- 买方付息账户编号
    ,fin_log_flg -- 融资性保函标志
    ,enter_open_bank_name -- 入账账户开户行名称
    ,enter_cust_name -- 入账账户客户名称
    ,payfan_pric_repay_way_cd -- 代付本金还款方式代码
    ,lmt_cont_id -- 额度合同编号
    ,pre_recv_int_flg -- 预收息标志
    ,coll_comp_int_flg -- 收复息标志
    ,fix_int_rat_flg -- 固定利率标志
    ,out_acct_tran_code -- 出帐交易码
    ,check_org_id -- 复核机构编号
    ,check_teller_id -- 复核柜员编号
    ,check_dt -- 复核日期
    ,margin_tran_status_cd -- 保证金交易状态代码
    ,repay_plan_tran_status_cd -- 还款计划交易状态代码
    ,core_out_acct_flow_num -- 核心出账流水号
    ,fin_sys_out_acct_flg -- 融资系统出账标志
    ,cap_src_cd -- 资金来源代码
    ,acpt_entry_tran_dt -- 承兑记账交易日期
    ,acpt_entry_tran_flow_num -- 承兑记账交易流水号
    ,file_int_flg -- 靠档计息标志
    ,comm_fee -- 签约手续费
    ,sell_status_cd -- 卖出状态代码
    ,cntpty_recvbl_acct_id -- 交易对手收款账户编号
    ,cntpty_recvbl_acct_name -- 交易对手收款账户名称
    ,cntpty_recvbl_bank_no -- 交易对手收款行行号
    ,cntpty_recvbl_bank_name -- 交易对手收款行名称
    ,level1_fft_actl_enter_id -- 一级福费廷实际入账账户编号
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,repl_old_bond_flg -- 置换旧债标志
    ,agent_present_flg -- 代理交单标志
    ,loan_card_td_que_excep_flg -- 贷款卡当日查询异常标志
    ,proc_sys_check_flg -- 进行系统校验标志
    ,auto_callbk_ctrl_open_flg -- 自动回收控制打开标志
    ,subtn_deduct_flg -- 持续扣款标志
    ,lpr_ref_way_cd -- LPR参照方式代码
    ,comp_int_int_rat_float_ratio -- 复利利率浮动比例
    ,comp_int_int_rat -- 复利利率
    ,dep_base_rat -- 存款基准利率
    ,dep_tenor -- 存款期限
    ,ghb_benefc_acct_num_flg -- 本行受益人账号标志
    ,aldy_sign_pool_fin_agt_flg -- 已签订池融资协议标志
    ,centr_out_acct_flg -- 集中出账标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.appl_id -- 申请编号
    ,o.lp_id -- 法人编号
    ,o.out_acct_flow_num -- 出账流水号
    ,o.loan_type_cd -- 贷款类型代码
    ,o.entr_dep_acct_id -- 委托存款账户账号
    ,o.entr_dep_sub_acct_num -- 委托存款子账号
    ,o.csner_dep_acct_id -- 委托人存款账户编号
    ,o.pric_auto_rtn_flg -- 本金自动归还标志
    ,o.int_auto_rtn_flg -- 利息自动归还标志
    ,o.comn_inst_repay_flg -- 普通分期还款标志
    ,o.inst_loan_tot_perds -- 分期贷款总期数
    ,o.tenor_type_cd -- 期限类型代码
    ,o.entr_loan_comm_fee_rat -- 委托贷款手续费率
    ,o.crdt_distr_repay_plan_flg -- 信贷发放还款计划标志
    ,o.stop_accr_int_flg -- 停息标志
    ,o.margin_int_rat_type_cd -- 保证金利率类型代码
    ,o.margin_int_rat_float_type_cd -- 保证金利率浮动类型代码
    ,o.margin_int_rat_float_way_cd -- 保证金利率浮动方式代码
    ,o.margin_flo_val -- 保证金浮动值
    ,o.margin_int_accr_method_cd -- 保证金计息方法代码
    ,o.margin_int_rat_level_cd -- 保证金利率档次代码
    ,o.margin_agt_rat -- 保证金协议利率
    ,o.margin_exp_dt -- 保证金到期日期
    ,o.bill_uniq_ind_no -- 票据唯一标识号
    ,o.lc_amt -- 信用证金额
    ,o.exp_lc_issue_bank_name -- 出口信用证开证行名称
    ,o.lc_issuer -- 信用证开证人
    ,o.lc_benefc -- 信用证受益人
    ,o.lc_benefc_name -- 信用证受益人名称
    ,o.ibank_payfan_pric -- 同业代付本金
    ,o.discnt_bus_accptor_name -- 贴现业务承兑人名称
    ,o.bill_id -- 票据编号
    ,o.strk_bal_flg -- 冲账标志
    ,o.int_accr_days -- 计息天数
    ,o.ibank_payfan_provi_int_rat -- 同业代付计提利率
    ,o.todos -- 工本费
    ,o.bill_comm_fee_charge_way_cd -- 票据手续费收费方式代码
    ,o.log_mode_pay_cd -- 保函支付方式代码
    ,o.acpt_bus_accptor_name -- 承兑业务承兑人名称
    ,o.draw_dt -- 出票日期
    ,o.bill_type_cd -- 票据类型代码
    ,o.trust_flg -- 托管标志
    ,o.bill_cls_cd -- 票据分类代码
    ,o.intstl_bus_id -- 国结业务编号
    ,o.accpt_bil_comm_fee_amt -- 承兑汇票手续费金额
    ,o.trade_fin_rela_amt_one -- 贸易融资相关金额一
    ,o.trade_fin_rela_amt_two -- 贸易融资相关金额二
    ,o.trade_fin_rela_amt_three -- 贸易融资相关金额三
    ,o.trade_fin_rela_dt_one -- 贸易融资相关日期一
    ,o.trade_fin_rela_dt_two -- 贸易融资相关日期二
    ,o.trade_fin_ratio -- 贸易融资比例
    ,o.coll_type_cd -- 代收类型代码
    ,o.bill_rgst_status_flg -- 票据登记状态标志
    ,o.guar_org_id -- 担保机构编号
    ,o.int_amt -- 利息金额
    ,o.recv_bank_name -- 收款行名称
    ,o.trade_fin_type_cd -- 贸易融资类型代码
    ,o.recver_open_bank_name -- 收款人开户行名称
    ,o.accept_ps_name -- 收票人名称
    ,o.inv_id -- 发票号码
    ,o.enter_id -- 入账账户编号
    ,o.distr_cond_impt_flg -- 放款条件落实标志
    ,o.trade_fin_rela_curr_cd_one -- 贸易融资相关币种代码一
    ,o.trade_fin_rela_curr_cd_two -- 贸易融资相关币种代码二
    ,o.trade_fin_rela_curr_cd_three -- 贸易融资相关币种代码三
    ,o.log_bnft_bank_name -- 保函受益行名称
    ,o.fft_acpt_bank_no -- 福费廷承兑行行号
    ,o.accptor_open_bank_no -- 承兑人开户行行号
    ,o.fft_cfm_bank_bank_no -- 福费廷保兑行行号
    ,o.buyer_pay_int_amt -- 买方付息金额
    ,o.redem_flg -- 赎回标志
    ,o.trade_fin_bus_id_one -- 贸易融资业务编号一
    ,o.trade_fin_bus_id_two -- 贸易融资业务编号二
    ,o.era_pay_bank_name -- 代付行名称
    ,o.log_type_cd -- 保函类型代码
    ,o.trade_fin_tenor_type_cd_one -- 贸易融资期限类型代码一
    ,o.trade_fin_tenor_type_cd_two -- 贸易融资期限类型代码二
    ,o.accptor_open_bank_name -- 承兑人开户行名称
    ,o.stl_acct_open_bank_name -- 结算帐号开户行名称
    ,o.stl_acct_cust_name -- 结算帐号客户名称
    ,o.buyer_pay_int_acct_id -- 买方付息账户编号
    ,o.fin_log_flg -- 融资性保函标志
    ,o.enter_open_bank_name -- 入账账户开户行名称
    ,o.enter_cust_name -- 入账账户客户名称
    ,o.payfan_pric_repay_way_cd -- 代付本金还款方式代码
    ,o.lmt_cont_id -- 额度合同编号
    ,o.pre_recv_int_flg -- 预收息标志
    ,o.coll_comp_int_flg -- 收复息标志
    ,o.fix_int_rat_flg -- 固定利率标志
    ,o.out_acct_tran_code -- 出帐交易码
    ,o.check_org_id -- 复核机构编号
    ,o.check_teller_id -- 复核柜员编号
    ,o.check_dt -- 复核日期
    ,o.margin_tran_status_cd -- 保证金交易状态代码
    ,o.repay_plan_tran_status_cd -- 还款计划交易状态代码
    ,o.core_out_acct_flow_num -- 核心出账流水号
    ,o.fin_sys_out_acct_flg -- 融资系统出账标志
    ,o.cap_src_cd -- 资金来源代码
    ,o.acpt_entry_tran_dt -- 承兑记账交易日期
    ,o.acpt_entry_tran_flow_num -- 承兑记账交易流水号
    ,o.file_int_flg -- 靠档计息标志
    ,o.comm_fee -- 签约手续费
    ,o.sell_status_cd -- 卖出状态代码
    ,o.cntpty_recvbl_acct_id -- 交易对手收款账户编号
    ,o.cntpty_recvbl_acct_name -- 交易对手收款账户名称
    ,o.cntpty_recvbl_bank_no -- 交易对手收款行行号
    ,o.cntpty_recvbl_bank_name -- 交易对手收款行名称
    ,o.level1_fft_actl_enter_id -- 一级福费廷实际入账账户编号
    ,o.int_rat_start_use_way_cd -- 利率启用方式代码
    ,o.repl_old_bond_flg -- 置换旧债标志
    ,o.agent_present_flg -- 代理交单标志
    ,o.loan_card_td_que_excep_flg -- 贷款卡当日查询异常标志
    ,o.proc_sys_check_flg -- 进行系统校验标志
    ,o.auto_callbk_ctrl_open_flg -- 自动回收控制打开标志
    ,o.subtn_deduct_flg -- 持续扣款标志
    ,o.lpr_ref_way_cd -- LPR参照方式代码
    ,o.comp_int_int_rat_float_ratio -- 复利利率浮动比例
    ,o.comp_int_int_rat -- 复利利率
    ,o.dep_base_rat -- 存款基准利率
    ,o.dep_tenor -- 存款期限
    ,o.ghb_benefc_acct_num_flg -- 本行受益人账号标志
    ,o.aldy_sign_pool_fin_agt_flg -- 已签订池融资协议标志
    ,o.centr_out_acct_flg -- 集中出账标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h_icmsf1_cl d
        on
            o.appl_id = d.appl_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h;
--alter table ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_out_acct_corp_loan_attach_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_out_acct_corp_loan_attach_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
