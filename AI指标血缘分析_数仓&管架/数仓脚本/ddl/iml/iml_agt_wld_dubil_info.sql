/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wld_dubil_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wld_dubil_info
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wld_dubil_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wld_dubil_info(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,intnal_dubil_id varchar2(60) -- 内部借据编号
    ,dubil_id varchar2(60) -- 借据编号
    ,acct_id varchar2(60) -- 账户编号
    ,acct_type_cd varchar2(10) -- 账户类型代码
    ,cust_id varchar2(60) -- 客户编号
    ,cust_lmt_id varchar2(60) -- 客户额度编号
    ,apot_repay_deduct_acct_num varchar2(60) -- 约定还款扣款账号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,card_no varchar2(60) -- 卡号
    ,renew_effect_dt date -- 展期生效日期
    ,loan_rgst_dt date -- 贷款注册日期
    ,loan_exp_dt date -- 贷款到期日期
    ,appl_tm timestamp -- 申请时间
    ,payoff_dt date -- 结清日期
    ,adv_termnt_dt date -- 提前终止日期
    ,grace_dt_term date -- 宽限日期
    ,init_tran_dt date -- 原始交易日期
    ,fir_exp_repay_dt date -- 首个到期还款日期
    ,last_behav_dt date -- 上次行动日期
    ,actv_dt date -- 激活日期
    ,curr_ovdue_days number(10) -- 当前逾期天数
    ,loan_type_cd varchar2(10) -- 贷款类型代码
    ,loan_status_cd varchar2(10) -- 贷款状态代码
    ,loan_tot_perds number(10) -- 贷款总期数
    ,curr_perds number(10) -- 当前期数
    ,surp_perds number(10) -- 剩余期数
    ,loan_pric number(30,2) -- 贷款本金
    ,loan_eh_issue_rpbl_pric number(30,2) -- 贷款每期应还本金
    ,loan_fst_rpbl_pric number(30,2) -- 贷款首期应还本金
    ,loan_late_rpbl_pric number(30,2) -- 贷款末期应还本金
    ,loan_tot_comm_fee number(30,2) -- 贷款总手续费
    ,loan_eh_issue_comm_fee number(30,2) -- 贷款每期手续费
    ,loan_fst_comm_fee number(30,2) -- 贷款首期手续费
    ,loan_late_comm_fee number(30,2) -- 贷款末期手续费
    ,loan_acct_bill_pric number(30,2) -- 贷款账单的本金
    ,loan_acct_bill_comm_fee number(30,2) -- 贷款账单手续费
    ,repaid_pric number(30,2) -- 已偿还本金
    ,repaid_int number(30,8) -- 已偿还利息
    ,repaid_fee number(30,2) -- 已偿还费用
    ,loan_curr_tot_bal number(30,2) -- 贷款当前总余额
    ,loan_unexp_bal number(30,2) -- 贷款未到期余额
    ,loan_expd_bal number(30,2) -- 贷款已到期余额
    ,debt_pric number(30,2) -- 欠款本金
    ,debt_int number(30,8) -- 欠款利息
    ,debt_pnlt number(30,8) -- 欠款罚息
    ,loan_unexp_pric number(30,2) -- 贷款未到期本金
    ,loan_expd_pric number(30,2) -- 贷款已到期本金
    ,loan_unexp_comm_fee number(30,2) -- 贷款未到期手续费
    ,loan_expd_comm_fee number(30,2) -- 贷款已到期手续费
    ,currt_repay_amt number(30,2) -- 当期还款金额
    ,adv_repay_amt number(30,2) -- 提前还款金额
    ,init_tran_curr_amt number(30,2) -- 原始交易币种金额
    ,renew_pric_amt number(30,2) -- 展期本金金额
    ,b_renew_eh_issue_rpbl_pric number(30,2) -- 展期前每期应还本金
    ,b_renew_tot_perds number(10) -- 展期前总期数
    ,b_renew_loan_fst_rpbl_pric number(30,2) -- 展期前贷款首期应还本金
    ,b_renew_loan_late_rpbl_pric number(30,2) -- 展期前贷款末期应还本金
    ,b_renew_loan_tot_comm_fee number(30,2) -- 展期前贷款总手续费
    ,b_renew_loan_eh_issue_comm_fee number(30,2) -- 展期前贷款每期手续费
    ,b_renew_loan_fst_comm_fee number(30,2) -- 展期前贷款首期手续费
    ,b_renew_loan_late_comm_fee number(30,2) -- 展期前贷款末期手续费
    ,a_renew_fst_comm_fee number(30,2) -- 展期后首期手续费
    ,loan_tot_int number(30,8) -- 贷款总利息
    ,init_loan_tot_int number(30,8) -- 原贷款总利息
    ,exec_int_rat number(18,8) -- 执行利率
    ,pnlt_int_rat number(38,8) -- 罚息利率
    ,comp_int_int_rat number(38,8) -- 复利利率
    ,int_rat_fl_rt number(18,6) -- 利率浮动比例
    ,loan_ovdue_max_perds number(10) -- 贷款逾期最大期数
    ,renewd_cnt number(10) -- 已展期次数
    ,sotermed_cnt number(10) -- 已缩期次数
    ,loan_comm_fee_coll_way_cd varchar2(10) -- 贷款手续费收取方式代码
    ,last_behav_type_cd varchar2(10) -- 上次行动类型代码
    ,int_accr_base_cd varchar2(10) -- 计息基准代码
    ,aging_cd varchar2(10) -- 账龄代码
    ,loan_termnt_rs_cd varchar2(10) -- 贷款终止原因代码
    ,syn_id varchar2(60) -- 银团编号
    ,loan_appl_seq_num varchar2(60) -- 贷款申请顺序号
    ,cont_edit_num varchar2(400) -- 合同版本号
    ,loan_prod_id varchar2(60) -- 贷款产品编号
    ,bank_contri_ratio number(18,6) -- 银行出资比例
    ,batch_doc_name varchar2(150) -- 批量文件名称
    ,ser_num varchar2(60) -- 序列号
    ,init_tran_auth_cd varchar2(45) -- 原始交易授权码
    ,optimit_lock_edit_num varchar2(60) -- 乐观锁版本号
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,revo_dt date -- 撤销日期
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
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
grant select on ${iml_schema}.agt_wld_dubil_info to ${icl_schema};
grant select on ${iml_schema}.agt_wld_dubil_info to ${idl_schema};
grant select on ${iml_schema}.agt_wld_dubil_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wld_dubil_info is '微粒贷借据信息';
comment on column ${iml_schema}.agt_wld_dubil_info.agt_id is '协议编号';
comment on column ${iml_schema}.agt_wld_dubil_info.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wld_dubil_info.intnal_dubil_id is '内部借据编号';
comment on column ${iml_schema}.agt_wld_dubil_info.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_wld_dubil_info.acct_id is '账户编号';
comment on column ${iml_schema}.agt_wld_dubil_info.acct_type_cd is '账户类型代码';
comment on column ${iml_schema}.agt_wld_dubil_info.cust_id is '客户编号';
comment on column ${iml_schema}.agt_wld_dubil_info.cust_lmt_id is '客户额度编号';
comment on column ${iml_schema}.agt_wld_dubil_info.apot_repay_deduct_acct_num is '约定还款扣款账号';
comment on column ${iml_schema}.agt_wld_dubil_info.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.agt_wld_dubil_info.card_no is '卡号';
comment on column ${iml_schema}.agt_wld_dubil_info.renew_effect_dt is '展期生效日期';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_rgst_dt is '贷款注册日期';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_exp_dt is '贷款到期日期';
comment on column ${iml_schema}.agt_wld_dubil_info.appl_tm is '申请时间';
comment on column ${iml_schema}.agt_wld_dubil_info.payoff_dt is '结清日期';
comment on column ${iml_schema}.agt_wld_dubil_info.adv_termnt_dt is '提前终止日期';
comment on column ${iml_schema}.agt_wld_dubil_info.grace_dt_term is '宽限日期';
comment on column ${iml_schema}.agt_wld_dubil_info.init_tran_dt is '原始交易日期';
comment on column ${iml_schema}.agt_wld_dubil_info.fir_exp_repay_dt is '首个到期还款日期';
comment on column ${iml_schema}.agt_wld_dubil_info.last_behav_dt is '上次行动日期';
comment on column ${iml_schema}.agt_wld_dubil_info.actv_dt is '激活日期';
comment on column ${iml_schema}.agt_wld_dubil_info.curr_ovdue_days is '当前逾期天数';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_type_cd is '贷款类型代码';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_status_cd is '贷款状态代码';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_tot_perds is '贷款总期数';
comment on column ${iml_schema}.agt_wld_dubil_info.curr_perds is '当前期数';
comment on column ${iml_schema}.agt_wld_dubil_info.surp_perds is '剩余期数';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_pric is '贷款本金';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_eh_issue_rpbl_pric is '贷款每期应还本金';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_fst_rpbl_pric is '贷款首期应还本金';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_late_rpbl_pric is '贷款末期应还本金';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_tot_comm_fee is '贷款总手续费';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_eh_issue_comm_fee is '贷款每期手续费';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_fst_comm_fee is '贷款首期手续费';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_late_comm_fee is '贷款末期手续费';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_acct_bill_pric is '贷款账单的本金';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_acct_bill_comm_fee is '贷款账单手续费';
comment on column ${iml_schema}.agt_wld_dubil_info.repaid_pric is '已偿还本金';
comment on column ${iml_schema}.agt_wld_dubil_info.repaid_int is '已偿还利息';
comment on column ${iml_schema}.agt_wld_dubil_info.repaid_fee is '已偿还费用';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_curr_tot_bal is '贷款当前总余额';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_unexp_bal is '贷款未到期余额';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_expd_bal is '贷款已到期余额';
comment on column ${iml_schema}.agt_wld_dubil_info.debt_pric is '欠款本金';
comment on column ${iml_schema}.agt_wld_dubil_info.debt_int is '欠款利息';
comment on column ${iml_schema}.agt_wld_dubil_info.debt_pnlt is '欠款罚息';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_unexp_pric is '贷款未到期本金';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_expd_pric is '贷款已到期本金';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_unexp_comm_fee is '贷款未到期手续费';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_expd_comm_fee is '贷款已到期手续费';
comment on column ${iml_schema}.agt_wld_dubil_info.currt_repay_amt is '当期还款金额';
comment on column ${iml_schema}.agt_wld_dubil_info.adv_repay_amt is '提前还款金额';
comment on column ${iml_schema}.agt_wld_dubil_info.init_tran_curr_amt is '原始交易币种金额';
comment on column ${iml_schema}.agt_wld_dubil_info.renew_pric_amt is '展期本金金额';
comment on column ${iml_schema}.agt_wld_dubil_info.b_renew_eh_issue_rpbl_pric is '展期前每期应还本金';
comment on column ${iml_schema}.agt_wld_dubil_info.b_renew_tot_perds is '展期前总期数';
comment on column ${iml_schema}.agt_wld_dubil_info.b_renew_loan_fst_rpbl_pric is '展期前贷款首期应还本金';
comment on column ${iml_schema}.agt_wld_dubil_info.b_renew_loan_late_rpbl_pric is '展期前贷款末期应还本金';
comment on column ${iml_schema}.agt_wld_dubil_info.b_renew_loan_tot_comm_fee is '展期前贷款总手续费';
comment on column ${iml_schema}.agt_wld_dubil_info.b_renew_loan_eh_issue_comm_fee is '展期前贷款每期手续费';
comment on column ${iml_schema}.agt_wld_dubil_info.b_renew_loan_fst_comm_fee is '展期前贷款首期手续费';
comment on column ${iml_schema}.agt_wld_dubil_info.b_renew_loan_late_comm_fee is '展期前贷款末期手续费';
comment on column ${iml_schema}.agt_wld_dubil_info.a_renew_fst_comm_fee is '展期后首期手续费';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_tot_int is '贷款总利息';
comment on column ${iml_schema}.agt_wld_dubil_info.init_loan_tot_int is '原贷款总利息';
comment on column ${iml_schema}.agt_wld_dubil_info.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_wld_dubil_info.pnlt_int_rat is '罚息利率';
comment on column ${iml_schema}.agt_wld_dubil_info.comp_int_int_rat is '复利利率';
comment on column ${iml_schema}.agt_wld_dubil_info.int_rat_fl_rt is '利率浮动比例';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_ovdue_max_perds is '贷款逾期最大期数';
comment on column ${iml_schema}.agt_wld_dubil_info.renewd_cnt is '已展期次数';
comment on column ${iml_schema}.agt_wld_dubil_info.sotermed_cnt is '已缩期次数';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_comm_fee_coll_way_cd is '贷款手续费收取方式代码';
comment on column ${iml_schema}.agt_wld_dubil_info.last_behav_type_cd is '上次行动类型代码';
comment on column ${iml_schema}.agt_wld_dubil_info.int_accr_base_cd is '计息基准代码';
comment on column ${iml_schema}.agt_wld_dubil_info.aging_cd is '账龄代码';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_termnt_rs_cd is '贷款终止原因代码';
comment on column ${iml_schema}.agt_wld_dubil_info.syn_id is '银团编号';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_appl_seq_num is '贷款申请顺序号';
comment on column ${iml_schema}.agt_wld_dubil_info.cont_edit_num is '合同版本号';
comment on column ${iml_schema}.agt_wld_dubil_info.loan_prod_id is '贷款产品编号';
comment on column ${iml_schema}.agt_wld_dubil_info.bank_contri_ratio is '银行出资比例';
comment on column ${iml_schema}.agt_wld_dubil_info.batch_doc_name is '批量文件名称';
comment on column ${iml_schema}.agt_wld_dubil_info.ser_num is '序列号';
comment on column ${iml_schema}.agt_wld_dubil_info.init_tran_auth_cd is '原始交易授权码';
comment on column ${iml_schema}.agt_wld_dubil_info.optimit_lock_edit_num is '乐观锁版本号';
comment on column ${iml_schema}.agt_wld_dubil_info.asset_thd_cls_cd is '资产三分类代码';
comment on column ${iml_schema}.agt_wld_dubil_info.revo_dt is '撤销日期';
comment on column ${iml_schema}.agt_wld_dubil_info.create_dt is '创建日期';
comment on column ${iml_schema}.agt_wld_dubil_info.update_dt is '更新日期';
comment on column ${iml_schema}.agt_wld_dubil_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_wld_dubil_info.id_mark is '增删标志';
comment on column ${iml_schema}.agt_wld_dubil_info.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wld_dubil_info.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wld_dubil_info.etl_timestamp is 'ETL处理时间戳';
