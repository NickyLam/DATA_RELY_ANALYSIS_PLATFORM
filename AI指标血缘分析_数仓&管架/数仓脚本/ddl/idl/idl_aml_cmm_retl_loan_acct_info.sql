/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_cmm_retl_loan_acct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_cmm_retl_loan_acct_info
whenever sqlerror continue none;
drop table ${idl_schema}.aml_cmm_retl_loan_acct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_cmm_retl_loan_acct_info(
    etl_dt date           -- 数据日期
    ,lp_id varchar2(60)   -- 法人编号
    ,acct_id varchar2(60)   -- 账户编号
    ,acct_name varchar2(100)  -- 账户名称
    ,cust_id varchar2(60)   -- 客户编号
    ,cont_id varchar2(60)   -- 合同编号
    ,dubil_num varchar2(60)   -- 借据号
    ,loan_distr_acct_num varchar2(60)   -- 贷款放款账号
    ,loan_repay_num varchar2(60)   -- 贷款还款账号
    ,prod_id varchar2(60)   -- 产品编号
    ,subj_id varchar2(60)   -- 科目编号
    ,acctnt_cate_cd varchar2(10)   -- 会计类别代码
    ,loan_modal_cd varchar2(10)   -- 贷款形态代码
    ,loan_acct_status_cd varchar2(10)   -- 贷款账户状态代码
    ,unite_loan_cd varchar2(10)   -- 联合贷款代码
    ,priv_loan_flg varchar2(10)   -- 对私贷款标志
    ,promis_loan_flg varchar2(10)   -- 承诺贷款标志
    ,circl_loan_flg varchar2(10)   -- 循环贷款标志
    ,deriv_loan_flg varchar2(10)   -- 衍生贷款标志
    ,agent_loan_flg varchar2(10)   -- 代理贷款标志
    ,oots_accti_flg varchar2(10)   -- 按一逾两呆核算标志
    ,loan_modal_dg_subj_accti_flg varchar2(10)   -- 贷款形态分科目核算标志
    ,loan_tenor varchar2(10)   -- 贷款期限
    ,loan_tenor_type_cd varchar2(10)   -- 贷款期限类型代码
    ,acru_non_acru_cd varchar2(10)   -- 应计非应计代码
    ,final_fin_dt date           -- 最后财务日期
    ,open_acct_teller_id varchar2(60)   -- 开户柜员编号
    ,clos_acct_teller_id varchar2(60)   -- 销户柜员编号
    ,open_acct_org_id varchar2(60)   -- 开户机构编号
    ,mgmt_org_id varchar2(60)   -- 管理机构编号
    ,acct_instit_id varchar2(60)   -- 账务机构编号
    ,open_acct_dt date           -- 开户日期
    ,distr_dt date           -- 放款日期
    ,value_dt date           -- 起息日期
    ,exp_dt date           -- 到期日期
    ,clos_acct_dt date           -- 销户日期
    ,renew_flg varchar2(10)   -- 展期标志
    ,renew_cnt number(10)     -- 展期次数
    ,int_accr_rule varchar2(10)   -- 计息规则
    ,int_accr_flg varchar2(10)   -- 计息标志
    ,comp_int_flg varchar2(10)   -- 复息标志
    ,pre_recv_int_way varchar2(10)   -- 预收息方式
    ,int_rat_adj_way_cd varchar2(10)   -- 利率调整方式代码
    ,int_rat_base_type_cd varchar2(10)   -- 利率基准类型代码
    ,base_rat number(18,8)   -- 基准利率
    ,exec_int_rat number(18,8)   -- 执行利率
    ,int_rat_float_way_cd varchar2(10)   -- 利率浮动方式代码
    ,int_rat_adj_ped_corp_cd varchar2(10)   -- 利率调整周期单位代码
    ,int_rat_adj_ped_freq number(10)     -- 利率调整周期频率
    ,int_rat_flo_val number(18,6)   -- 利率浮动值
    ,curr_int_rat_effect_dt date           -- 当前利率生效日期
    ,next_int_rat_adj_dt date           -- 下次利率调整日期
    ,int_set_way_cd varchar2(10)   -- 结息方式代码
    ,int_accr_way_cd varchar2(10)   -- 计息方式代码
    ,ped_distr_flg varchar2(10)   -- 周期性放款标志
    ,distr_way_cd varchar2(10)   -- 放款方式代码
    ,repay_way_cd varchar2(10)   -- 还款方式代码
    ,repay_ped_corp_cd varchar2(10)   -- 还款周期单位代码
    ,repay_ped number(10,2)   -- 还款周期
    ,ovdue_flg varchar2(10)   -- 逾期标志
    ,curr_ovdue_perds number(10)     -- 当前逾期期数
    ,ovdue_days number(10)     -- 逾期天数
    ,ovdue_pric_bal number(30,2)   -- 逾期本金余额
    ,ovdue_int_amt number(30,2)   -- 逾期利息金额
    ,ovdue_comp_int_amt number(30,2)   -- 逾期复利金额
    ,fir_ovdue_dt date           -- 首次逾期日期
    ,ovdue_int_rat number(18,8)   -- 逾期利率
    ,ovdue_int_rat_flo_val number(18,6)   -- 逾期利率浮动值
    ,tot_perds number(10)     -- 总期数
    ,curr_issue_perds number(10)     -- 本期期数
    ,last_repay_dt date           -- 上次还款日期
    ,curr_cd varchar2(10)   -- 币种代码
    ,next_repay_dt date           -- 下次还款日期
    ,next_rpp_amt number(30,2)   -- 下次还本金额
    ,next_repay_int_amt number(30,2)   -- 下次还息金额
    ,cont_amt number(30,2)   -- 合同金额
    ,dubil_amt number(30,2)   -- 借据金额
    ,distr_amt number(30,2)   -- 放款金额
    ,froz_distrd_amt number(30,2)   -- 冻结可发放金额
    ,distrd_amt number(30,2)   -- 可发放金额
    ,td_acru_int number(30,8)   -- 当日应计利息
    ,currt_acru_int number(30,8)   -- 当期应计利息
    ,nomal_pric number(30,2)   -- 正常本金
    ,ovdue_pric number(30,2)   -- 逾期本金
    ,idle_pric number(30,2)   -- 呆滞本金
    ,bad_debt_pric number(30,2)   -- 呆账本金
    ,loan_fund number(30,2)   -- 贷款基金
    ,coll_acru_int number(30,2)   -- 催收应计利息
    ,recvbl_acru_pnlt number(30,2)   -- 应收应计罚息
    ,coll_acru_pnlt number(30,2)   -- 催收应计罚息
    ,recvbl_pnlt number(30,2)   -- 应收罚息
    ,coll_pnlt number(30,2)   -- 催收罚息
    ,acru_comp_int number(30,2)   -- 应计复息
    ,recvbl_comp_int number(30,2)   -- 应收复息
    ,acru_int_sub number(30,2)   -- 应计贴息
    ,recvbl_int_sub number(30,2)   -- 应收贴息
    ,amorted_int number(30,2)   -- 待摊利息
    ,wrt_off_pric number(30,2)   -- 核销本金
    ,wrt_off_int number(30,2)   -- 核销利息
    ,int_income number(30,2)   -- 利息收入
    ,wrt_off_advc_fee_bal number(30,2)   -- 核销垫付费余额
    ,wrt_off_advc_fee_amt number(30,2)   -- 核销垫付费金额
    ,recvbl_fine number(30,2)   -- 应收罚金
    ,fine_inco number(30,2)   -- 罚金收入
    ,resv number(30,2)   -- 准备金
    ,recvbl_over_int number(30,2)   -- 应收欠息
    ,coll_over_int number(30,2)   -- 催收欠息
    ,in_bs_int number(30,2)   -- 表内利息
    ,off_bs_int number(30,2)   -- 表外利息
    ,acm_recvbl_uncol_int_amt number(30,2)   -- 累计应收未收利息金额
    ,repaid_pric number(30,2)   -- 已偿还本金
    ,repaid_int number(30,2)   -- 已偿还利息
    ,repaid_pnlt number(30,2)   -- 已偿还罚息
    ,repaid_comp_int number(30,2)   -- 已偿还复利
    ,repaid_fee number(30,2)   -- 已偿还费用
    ,pric_bal number(30,2)   -- 本金余额
    ,currt_bal number(30,2)   -- 当期余额
    ,cl_curr_currt_bal number(30,2)   -- 折本币当期余额
    ,ear_d_bal number(30,2)   -- 日初余额
    ,ear_m_bal number(30,2)   -- 月初余额
    ,ear_s_bal number(30,2)   -- 季初余额
    ,ear_y_bal number(30,2)   -- 年初余额
    ,y_acm_bal number(30,2)   -- 年累计余额
    ,s_acm_bal number(30,2)   -- 季累计余额
    ,m_acm_bal number(30,2)   -- 月累计余额
    ,cl_curr_ear_d_bal number(30,2)   -- 折本币日初余额
    ,cl_curr_ear_m_bal number(30,2)   -- 折本币月初余额
    ,cl_curr_ear_s_bal number(30,2)   -- 折本币季初余额
    ,cl_curr_ear_y_bal number(30,2)   -- 折本币年初余额
    ,cl_curr_y_acm_bal number(30,2)   -- 折本币年累计余额
    ,cl_curr_ear_d_y_acm_bal number(30,2)   -- 折本币日初年累计余额
    ,cl_curr_ear_m_y_acm_bal number(30,2)   -- 折本币月初年累计余额
    ,cl_curr_ear_s_y_acm_bal number(30,2)   -- 折本币季初年累计余额
    ,cl_curr_ear_y_y_acm_bal number(30,2)   -- 折本币年初年累计余额
    ,cl_curr_s_acm_bal number(30,2)   -- 折本币季累计余额
    ,cl_curr_ear_d_s_acm_bal number(30,2)   -- 折本币日初季累计余额
    ,cl_curr_ear_s_s_acm_bal number(30,2)   -- 折本币季初季累计余额
    ,cl_curr_ear_y_s_acm_bal number(30,2)   -- 折本币年初季累计余额
    ,cl_curr_m_acm_bal number(30,2)   -- 折本币月累计余额
    ,cl_curr_ear_d_m_acm_bal number(30,2)   -- 折本币日初月累计余额
    ,cl_curr_ear_m_m_acm_bal number(30,2)   -- 折本币月初月累计余额
    ,cl_curr_ear_y_m_acm_bal number(30,2)   -- 折本币年初月累计余额
    ,job_cd varchar2(10)   -- 任务代码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_cmm_retl_loan_acct_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_cmm_retl_loan_acct_info is '零售贷款账户信息';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.lp_id is '法人编号';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.acct_id is '账户编号';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.acct_name is '账户名称';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.cust_id is '客户编号';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.cont_id is '合同编号';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.dubil_num is '借据号';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.loan_distr_acct_num is '贷款放款账号';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.loan_repay_num is '贷款还款账号';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.prod_id is '产品编号';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.subj_id is '科目编号';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.acctnt_cate_cd is '会计类别代码';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.loan_modal_cd is '贷款形态代码';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.loan_acct_status_cd is '贷款账户状态代码';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.unite_loan_cd is '联合贷款代码';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.priv_loan_flg is '对私贷款标志';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.promis_loan_flg is '承诺贷款标志';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.circl_loan_flg is '循环贷款标志';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.deriv_loan_flg is '衍生贷款标志';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.agent_loan_flg is '代理贷款标志';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.oots_accti_flg is '按一逾两呆核算标志';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.loan_modal_dg_subj_accti_flg is '贷款形态分科目核算标志';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.loan_tenor is '贷款期限';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.loan_tenor_type_cd is '贷款期限类型代码';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.acru_non_acru_cd is '应计非应计代码';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.final_fin_dt is '最后财务日期';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.open_acct_teller_id is '开户柜员编号';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.clos_acct_teller_id is '销户柜员编号';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.open_acct_org_id is '开户机构编号';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.mgmt_org_id is '管理机构编号';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.acct_instit_id is '账务机构编号';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.open_acct_dt is '开户日期';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.distr_dt is '放款日期';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.value_dt is '起息日期';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.exp_dt is '到期日期';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.clos_acct_dt is '销户日期';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.renew_flg is '展期标志';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.renew_cnt is '展期次数';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.int_accr_rule is '计息规则';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.int_accr_flg is '计息标志';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.comp_int_flg is '复息标志';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.pre_recv_int_way is '预收息方式';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.int_rat_base_type_cd is '利率基准类型代码';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.base_rat is '基准利率';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.exec_int_rat is '执行利率';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.int_rat_float_way_cd is '利率浮动方式代码';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.int_rat_adj_ped_corp_cd is '利率调整周期单位代码';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.int_rat_adj_ped_freq is '利率调整周期频率';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.int_rat_flo_val is '利率浮动值';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.curr_int_rat_effect_dt is '当前利率生效日期';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.next_int_rat_adj_dt is '下次利率调整日期';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.int_set_way_cd is '结息方式代码';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.int_accr_way_cd is '计息方式代码';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.ped_distr_flg is '周期性放款标志';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.distr_way_cd is '放款方式代码';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.repay_way_cd is '还款方式代码';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.repay_ped_corp_cd is '还款周期单位代码';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.repay_ped is '还款周期';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.ovdue_flg is '逾期标志';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.curr_ovdue_perds is '当前逾期期数';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.ovdue_days is '逾期天数';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.ovdue_pric_bal is '逾期本金余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.ovdue_int_amt is '逾期利息金额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.ovdue_comp_int_amt is '逾期复利金额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.fir_ovdue_dt is '首次逾期日期';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.ovdue_int_rat is '逾期利率';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.ovdue_int_rat_flo_val is '逾期利率浮动值';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.tot_perds is '总期数';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.curr_issue_perds is '本期期数';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.last_repay_dt is '上次还款日期';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.curr_cd is '币种代码';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.next_repay_dt is '下次还款日期';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.next_rpp_amt is '下次还本金额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.next_repay_int_amt is '下次还息金额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.cont_amt is '合同金额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.dubil_amt is '借据金额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.distr_amt is '放款金额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.froz_distrd_amt is '冻结可发放金额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.distrd_amt is '可发放金额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.td_acru_int is '当日应计利息';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.currt_acru_int is '当期应计利息';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.nomal_pric is '正常本金';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.ovdue_pric is '逾期本金';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.idle_pric is '呆滞本金';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.bad_debt_pric is '呆账本金';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.loan_fund is '贷款基金';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.coll_acru_int is '催收应计利息';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.recvbl_acru_pnlt is '应收应计罚息';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.coll_acru_pnlt is '催收应计罚息';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.recvbl_pnlt is '应收罚息';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.coll_pnlt is '催收罚息';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.acru_comp_int is '应计复息';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.recvbl_comp_int is '应收复息';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.acru_int_sub is '应计贴息';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.recvbl_int_sub is '应收贴息';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.amorted_int is '待摊利息';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.wrt_off_pric is '核销本金';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.wrt_off_int is '核销利息';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.int_income is '利息收入';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.wrt_off_advc_fee_bal is '核销垫付费余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.wrt_off_advc_fee_amt is '核销垫付费金额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.recvbl_fine is '应收罚金';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.fine_inco is '罚金收入';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.resv is '准备金';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.recvbl_over_int is '应收欠息';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.coll_over_int is '催收欠息';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.in_bs_int is '表内利息';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.off_bs_int is '表外利息';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.acm_recvbl_uncol_int_amt is '累计应收未收利息金额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.repaid_pric is '已偿还本金';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.repaid_int is '已偿还利息';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.repaid_pnlt is '已偿还罚息';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.repaid_comp_int is '已偿还复利';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.repaid_fee is '已偿还费用';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.pric_bal is '本金余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.currt_bal is '当期余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.cl_curr_currt_bal is '折本币当期余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.ear_d_bal is '日初余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.ear_m_bal is '月初余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.ear_s_bal is '季初余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.ear_y_bal is '年初余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.y_acm_bal is '年累计余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.s_acm_bal is '季累计余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.m_acm_bal is '月累计余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.cl_curr_ear_d_bal is '折本币日初余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.cl_curr_ear_m_bal is '折本币月初余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.cl_curr_ear_s_bal is '折本币季初余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.cl_curr_ear_y_bal is '折本币年初余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.cl_curr_y_acm_bal is '折本币年累计余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.cl_curr_ear_d_y_acm_bal is '折本币日初年累计余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.cl_curr_ear_m_y_acm_bal is '折本币月初年累计余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.cl_curr_ear_s_y_acm_bal is '折本币季初年累计余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.cl_curr_ear_y_y_acm_bal is '折本币年初年累计余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.cl_curr_s_acm_bal is '折本币季累计余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.cl_curr_ear_d_s_acm_bal is '折本币日初季累计余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.cl_curr_ear_s_s_acm_bal is '折本币季初季累计余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.cl_curr_ear_y_s_acm_bal is '折本币年初季累计余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.cl_curr_m_acm_bal is '折本币月累计余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.cl_curr_ear_d_m_acm_bal is '折本币日初月累计余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.cl_curr_ear_m_m_acm_bal is '折本币月初月累计余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.cl_curr_ear_y_m_acm_bal is '折本币年初月累计余额';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.job_cd is '任务代码';
comment on column ${idl_schema}.aml_cmm_retl_loan_acct_info.etl_timestamp is 'ETL处理时间戳';
