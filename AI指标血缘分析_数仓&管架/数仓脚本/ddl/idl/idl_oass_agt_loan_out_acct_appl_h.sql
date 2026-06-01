/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_loan_out_acct_appl_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_loan_out_acct_appl_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_loan_out_acct_appl_h(
etl_dt date --数据日期
,cont_id varchar2(100) --合同编号
,cust_id varchar2(100) --客户编号
,cust_name varchar2(500) --客户名称
,prod_id varchar2(100) --产品编号
,curr_cd varchar2(30) --币种代码
,cont_amt number(30,2) --合同金额
,ths_tm_distr_amt number(30,2) --本次放款金额
,loan_distr_type_cd varchar2(30) --贷款发放类型代码
,happ_dt date --发生日期
,distr_dt date --发放日期
,exp_dt date --到期日期
,int_rat_mode_cd varchar2(30) --利率模式代码
,fix_int_rat number(18,8) --固定利率
,base_rat_type_cd varchar2(30) --基准利率类型代码
,base_rat number(18,8) --基准利率
,int_rat_float_type_cd varchar2(30) --利率浮动类型代码
,int_rat_adj_way_cd varchar2(30) --利率调整方式代码
,int_rat_flo_val number(18,6) --利率浮动值
,exec_int_rat number(18,8) --执行利率
,stl_acct_id varchar2(100) --结算账户编号
,enter_id varchar2(100) --入账账户编号
,secd_repay_acct_id varchar2(100) --第二还款账户编号
,distr_mode_pay_cd varchar2(30) --放款支付方式代码
,appl_way_cd varchar2(30) --申请方式代码
,apv_status_cd varchar2(30) --审批状态代码
,belong_strip_line_cd varchar2(30) --所属条线代码
,off_bs_flg varchar2(10) --表外标志
,low_risk_flg varchar2(10) --低风险标志
,lmt_id varchar2(100) --额度编号
,spec_ped_corp_cd varchar2(30) --指定周期单位代码
,spec_ped_cd varchar2(30) --指定周期代码
,repay_way_cd varchar2(30) --还款方式代码
,repay_ped varchar2(10) --还款周期
,repay_ped_cd varchar2(30) --还款周期单位代码
,deflt_repay_day number(22,0) --默认还款日
,ovdue_exec_int_rat number(18,8) --逾期执行利率
,ovdue_int_rat_float_way_cd varchar2(30) --逾期利率浮动方式代码
,ovdue_int_rat_flo_val number(18,6) --逾期利率浮动值
,oper_org_id varchar2(100) --经办机构编号
,bus_oper_teller_id varchar2(100) --业务经办人编号
,oper_dt date --经办日期
,rgst_teller_id varchar2(100) --登记柜员编号
,rgst_org_id varchar2(100) --登记机构编号
,rgst_dt date --登记日期
,update_teller_id varchar2(100) --更新柜员编号
,update_org_id varchar2(100) --更新机构编号
,modif_dt date --变更日期
,lp_id varchar2(100) --法人编号
,text_cont_id varchar2(500) --文本合同编号
,margin_acct_id varchar2(100) --保证金账户编号
,margin_tran_out_acct_id varchar2(100) --保证金转出账户编号
,margin_curr_cd varchar2(30) --保证金币种代码
,margin_ratio number(18,6) --保证金比例
,margin_sub_acct_num varchar2(60) --保证金子账号
,margin_amt number(30,2) --保证金金额
,dubil_id varchar2(100) --借据编号
,subj_id varchar2(100) --科目编号
,out_acct_org_id varchar2(100) --出账机构编号
,loan_org_id varchar2(100) --贷款机构编号
,int_accr_way_cd varchar2(30) --计息方式代码
,enter_open_acct_org_id varchar2(100) --入账账户开户机构编号
,enter_name varchar2(500) --入账账户名称
,enter_sub_acct_num varchar2(60) --入账账户子账号
,comm_fee_collect_way_cd varchar2(30) --手续费计收方式代码
,comm_fee_deduct_acct_id varchar2(100) --手续费扣费账户编号
,comm_fee_amort_flg varchar2(10) --手续费摊销标志
,comm_fee_rat number(18,6) --手续费率
,comm_fee_amt number(30,2) --手续费金额
,loan_usage_cd varchar2(30) --贷款用途代码
,entr_pay_amt number(30,2) --受托支付金额
,entr_pay_stop_pay_flow_num varchar2(100) --受托支付止付流水号
,file_dt date --归档日期
,major_guar_way_cd varchar2(30) --主要担保方式代码
,mon_tenor number(22,0) --月期限
,day_tenor number(22,0) --日期限
,tran_status_cd varchar2(30) --交易状态代码
,tran_tm timestamp(6) --交易时间
,core_tran_dt date --核心交易日期
,core_tran_flow_num varchar2(100) --核心交易流水号
,stl_acct_name varchar2(500) --结算账户名称
,int_rat_adj_ped_cd varchar2(30) --利率调整周期代码
,move_remark varchar2(500) --迁移备注
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,agt_id varchar2(100) --申请编号
,out_acct_flow_num varchar2(100) --出账流水号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_agt_loan_out_acct_appl_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_loan_out_acct_appl_h is '贷款出账申请历史';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.cont_id is '合同编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.cust_id is '客户编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.cust_name is '客户名称';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.prod_id is '产品编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.curr_cd is '币种代码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.cont_amt is '合同金额';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.ths_tm_distr_amt is '本次放款金额';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.loan_distr_type_cd is '贷款发放类型代码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.happ_dt is '发生日期';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.distr_dt is '发放日期';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.exp_dt is '到期日期';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.int_rat_mode_cd is '利率模式代码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.fix_int_rat is '固定利率';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.base_rat_type_cd is '基准利率类型代码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.base_rat is '基准利率';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.int_rat_float_type_cd is '利率浮动类型代码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.int_rat_flo_val is '利率浮动值';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.exec_int_rat is '执行利率';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.stl_acct_id is '结算账户编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.enter_id is '入账账户编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.secd_repay_acct_id is '第二还款账户编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.distr_mode_pay_cd is '放款支付方式代码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.appl_way_cd is '申请方式代码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.apv_status_cd is '审批状态代码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.belong_strip_line_cd is '所属条线代码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.off_bs_flg is '表外标志';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.low_risk_flg is '低风险标志';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.lmt_id is '额度编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.spec_ped_corp_cd is '指定周期单位代码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.spec_ped_cd is '指定周期代码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.repay_way_cd is '还款方式代码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.repay_ped is '还款周期';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.repay_ped_cd is '还款周期单位代码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.deflt_repay_day is '默认还款日';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.ovdue_exec_int_rat is '逾期执行利率';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.ovdue_int_rat_float_way_cd is '逾期利率浮动方式代码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.ovdue_int_rat_flo_val is '逾期利率浮动值';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.oper_org_id is '经办机构编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.bus_oper_teller_id is '业务经办人编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.oper_dt is '经办日期';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.rgst_teller_id is '登记柜员编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.rgst_org_id is '登记机构编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.rgst_dt is '登记日期';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.update_teller_id is '更新柜员编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.update_org_id is '更新机构编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.modif_dt is '变更日期';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.lp_id is '法人编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.text_cont_id is '文本合同编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.margin_acct_id is '保证金账户编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.margin_tran_out_acct_id is '保证金转出账户编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.margin_curr_cd is '保证金币种代码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.margin_ratio is '保证金比例';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.margin_sub_acct_num is '保证金子账号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.margin_amt is '保证金金额';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.dubil_id is '借据编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.subj_id is '科目编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.out_acct_org_id is '出账机构编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.loan_org_id is '贷款机构编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.int_accr_way_cd is '计息方式代码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.enter_open_acct_org_id is '入账账户开户机构编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.enter_name is '入账账户名称';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.enter_sub_acct_num is '入账账户子账号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.comm_fee_collect_way_cd is '手续费计收方式代码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.comm_fee_deduct_acct_id is '手续费扣费账户编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.comm_fee_amort_flg is '手续费摊销标志';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.comm_fee_rat is '手续费率';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.comm_fee_amt is '手续费金额';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.loan_usage_cd is '贷款用途代码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.entr_pay_amt is '受托支付金额';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.entr_pay_stop_pay_flow_num is '受托支付止付流水号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.file_dt is '归档日期';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.major_guar_way_cd is '主要担保方式代码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.mon_tenor is '月期限';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.day_tenor is '日期限';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.tran_status_cd is '交易状态代码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.tran_tm is '交易时间';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.core_tran_dt is '核心交易日期';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.core_tran_flow_num is '核心交易流水号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.stl_acct_name is '结算账户名称';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.int_rat_adj_ped_cd is '利率调整周期代码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.move_remark is '迁移备注';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.agt_id is '申请编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_appl_h.out_acct_flow_num is '出账流水号';

