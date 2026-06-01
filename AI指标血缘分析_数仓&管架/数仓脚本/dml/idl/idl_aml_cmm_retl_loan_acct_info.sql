/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_cmm_retl_loan_acct_info
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.aml_cmm_retl_loan_acct_info drop partition p_${last_date};
alter table ${idl_schema}.aml_cmm_retl_loan_acct_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_cmm_retl_loan_acct_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_cmm_retl_loan_acct_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,acct_id  -- 账户编号
    ,acct_name  -- 账户名称
    ,cust_id  -- 客户编号
    ,cont_id  -- 合同编号
    ,dubil_num  -- 借据号
    ,loan_distr_acct_num  -- 贷款放款账号
    ,loan_repay_num  -- 贷款还款账号
    ,prod_id  -- 产品编号
    ,subj_id  -- 科目编号
    ,acctnt_cate_cd  -- 会计类别代码
    ,loan_modal_cd  -- 贷款形态代码
    ,loan_acct_status_cd  -- 贷款账户状态代码
    ,unite_loan_cd  -- 联合贷款代码
    ,priv_loan_flg  -- 对私贷款标志
    ,promis_loan_flg  -- 承诺贷款标志
    ,circl_loan_flg  -- 循环贷款标志
    ,deriv_loan_flg  -- 衍生贷款标志
    ,agent_loan_flg  -- 代理贷款标志
    ,oots_accti_flg  -- 按一逾两呆核算标志
    ,loan_modal_dg_subj_accti_flg  -- 贷款形态分科目核算标志
    ,loan_tenor  -- 贷款期限
    ,loan_tenor_type_cd  -- 贷款期限类型代码
    ,acru_non_acru_cd  -- 应计非应计代码
    ,final_fin_dt  -- 最后财务日期
    ,open_acct_teller_id  -- 开户柜员编号
    ,clos_acct_teller_id  -- 销户柜员编号
    ,open_acct_org_id  -- 开户机构编号
    ,mgmt_org_id  -- 管理机构编号
    ,acct_instit_id  -- 账务机构编号
    ,open_acct_dt  -- 开户日期
    ,distr_dt  -- 放款日期
    ,value_dt  -- 起息日期
    ,exp_dt  -- 到期日期
    ,clos_acct_dt  -- 销户日期
    ,renew_flg  -- 展期标志
    ,renew_cnt  -- 展期次数
    ,int_accr_rule  -- 计息规则
    ,int_accr_flg  -- 计息标志
    ,comp_int_flg  -- 复息标志
    ,pre_recv_int_way  -- 预收息方式
    ,int_rat_adj_way_cd  -- 利率调整方式代码
    ,int_rat_base_type_cd  -- 利率基准类型代码
    ,base_rat  -- 基准利率
    ,exec_int_rat  -- 执行利率
    ,int_rat_float_way_cd  -- 利率浮动方式代码
    ,int_rat_adj_ped_corp_cd  -- 利率调整周期单位代码
    ,int_rat_adj_ped_freq  -- 利率调整周期频率
    ,int_rat_flo_val  -- 利率浮动值
    ,curr_int_rat_effect_dt  -- 当前利率生效日期
    ,next_int_rat_adj_dt  -- 下次利率调整日期
    ,int_set_way_cd  -- 结息方式代码
    ,int_accr_way_cd  -- 计息方式代码
    ,ped_distr_flg  -- 周期性放款标志
    ,distr_way_cd  -- 放款方式代码
    ,repay_way_cd  -- 还款方式代码
    ,repay_ped_corp_cd  -- 还款周期单位代码
    ,repay_ped  -- 还款周期
    ,ovdue_flg  -- 逾期标志
    ,curr_ovdue_perds  -- 当前逾期期数
    ,ovdue_days  -- 逾期天数
    ,ovdue_pric_bal  -- 逾期本金余额
    ,ovdue_int_amt  -- 逾期利息金额
    ,ovdue_comp_int_amt  -- 逾期复利金额
    ,fir_ovdue_dt  -- 首次逾期日期
    ,ovdue_int_rat  -- 逾期利率
    ,ovdue_int_rat_flo_val  -- 逾期利率浮动值
    ,tot_perds  -- 总期数
    ,curr_issue_perds  -- 本期期数
    ,last_repay_dt  -- 上次还款日期
    ,curr_cd  -- 币种代码
    ,next_repay_dt  -- 下次还款日期
    ,next_rpp_amt  -- 下次还本金额
    ,next_repay_int_amt  -- 下次还息金额
    ,cont_amt  -- 合同金额
    ,dubil_amt  -- 借据金额
    ,distr_amt  -- 放款金额
    ,froz_distrd_amt  -- 冻结可发放金额
    ,distrd_amt  -- 可发放金额
    ,td_acru_int  -- 当日应计利息
    ,currt_acru_int  -- 当期应计利息
    ,nomal_pric  -- 正常本金
    ,ovdue_pric  -- 逾期本金
    ,idle_pric  -- 呆滞本金
    ,bad_debt_pric  -- 呆账本金
    ,loan_fund  -- 贷款基金
    ,coll_acru_int  -- 催收应计利息
    ,recvbl_acru_pnlt  -- 应收应计罚息
    ,coll_acru_pnlt  -- 催收应计罚息
    ,recvbl_pnlt  -- 应收罚息
    ,coll_pnlt  -- 催收罚息
    ,acru_comp_int  -- 应计复息
    ,recvbl_comp_int  -- 应收复息
    ,acru_int_sub  -- 应计贴息
    ,recvbl_int_sub  -- 应收贴息
    ,amorted_int  -- 待摊利息
    ,wrt_off_pric  -- 核销本金
    ,wrt_off_int  -- 核销利息
    ,int_income  -- 利息收入
    ,wrt_off_advc_fee_bal  -- 核销垫付费余额
    ,wrt_off_advc_fee_amt  -- 核销垫付费金额
    ,recvbl_fine  -- 应收罚金
    ,fine_inco  -- 罚金收入
    ,resv  -- 准备金
    ,recvbl_over_int  -- 应收欠息
    ,coll_over_int  -- 催收欠息
    ,in_bs_int  -- 表内利息
    ,off_bs_int  -- 表外利息
    ,acm_recvbl_uncol_int_amt  -- 累计应收未收利息金额
    ,repaid_pric  -- 已偿还本金
    ,repaid_int  -- 已偿还利息
    ,repaid_pnlt  -- 已偿还罚息
    ,repaid_comp_int  -- 已偿还复利
    ,repaid_fee  -- 已偿还费用
    ,pric_bal  -- 本金余额
    ,currt_bal  -- 当期余额
    ,cl_curr_currt_bal  -- 折本币当期余额
    ,ear_d_bal  -- 日初余额
    ,ear_m_bal  -- 月初余额
    ,ear_s_bal  -- 季初余额
    ,ear_y_bal  -- 年初余额
    ,y_acm_bal  -- 年累计余额
    ,s_acm_bal  -- 季累计余额
    ,m_acm_bal  -- 月累计余额
    ,cl_curr_ear_d_bal  -- 折本币日初余额
    ,cl_curr_ear_m_bal  -- 折本币月初余额
    ,cl_curr_ear_s_bal  -- 折本币季初余额
    ,cl_curr_ear_y_bal  -- 折本币年初余额
    ,cl_curr_y_acm_bal  -- 折本币年累计余额
    ,cl_curr_ear_d_y_acm_bal  -- 折本币日初年累计余额
    ,cl_curr_ear_m_y_acm_bal  -- 折本币月初年累计余额
    ,cl_curr_ear_s_y_acm_bal  -- 折本币季初年累计余额
    ,cl_curr_ear_y_y_acm_bal  -- 折本币年初年累计余额
    ,cl_curr_s_acm_bal  -- 折本币季累计余额
    ,cl_curr_ear_d_s_acm_bal  -- 折本币日初季累计余额
    ,cl_curr_ear_s_s_acm_bal  -- 折本币季初季累计余额
    ,cl_curr_ear_y_s_acm_bal  -- 折本币年初季累计余额
    ,cl_curr_m_acm_bal  -- 折本币月累计余额
    ,cl_curr_ear_d_m_acm_bal  -- 折本币日初月累计余额
    ,cl_curr_ear_m_m_acm_bal  -- 折本币月初月累计余额
    ,cl_curr_ear_y_m_acm_bal  -- 折本币年初月累计余额
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- ETL处理时间戳
)
select
    t1.etl_dt  -- 数据日期
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.acct_id,chr(13),''),chr(10),'')  -- 账户编号
    ,replace(replace(t1.acct_name,chr(13),''),chr(10),'')  -- 账户名称
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.cont_id,chr(13),''),chr(10),'')  -- 合同编号
    ,replace(replace(t1.dubil_num,chr(13),''),chr(10),'')  -- 借据号
    ,replace(replace(t1.loan_distr_acct_num,chr(13),''),chr(10),'')  -- 贷款放款账号
    ,replace(replace(t1.loan_repay_num,chr(13),''),chr(10),'')  -- 贷款还款账号
    ,replace(replace(t1.prod_id,chr(13),''),chr(10),'')  -- 产品编号
    ,replace(replace(t1.subj_id,chr(13),''),chr(10),'')  -- 科目编号
    ,replace(replace(t1.acctnt_cate_cd,chr(13),''),chr(10),'')  -- 会计类别代码
    ,replace(replace(t1.loan_modal_cd,chr(13),''),chr(10),'')  -- 贷款形态代码
    ,replace(replace(t1.loan_acct_status_cd,chr(13),''),chr(10),'')  -- 贷款账户状态代码
    ,replace(replace(t1.unite_loan_cd,chr(13),''),chr(10),'')  -- 联合贷款代码
    ,replace(replace(t1.priv_loan_flg,chr(13),''),chr(10),'')  -- 对私贷款标志
    ,replace(replace(t1.promis_loan_flg,chr(13),''),chr(10),'')  -- 承诺贷款标志
    ,replace(replace(t1.circl_loan_flg,chr(13),''),chr(10),'')  -- 循环贷款标志
    ,replace(replace(t1.deriv_loan_flg,chr(13),''),chr(10),'')  -- 衍生贷款标志
    ,replace(replace(t1.agent_loan_flg,chr(13),''),chr(10),'')  -- 代理贷款标志
    ,replace(replace(t1.oots_accti_flg,chr(13),''),chr(10),'')  -- 按一逾两呆核算标志
    ,replace(replace(t1.loan_modal_dg_subj_accti_flg,chr(13),''),chr(10),'')  -- 贷款形态分科目核算标志
    ,replace(replace(t1.loan_tenor,chr(13),''),chr(10),'')  -- 贷款期限
    ,replace(replace(t1.loan_tenor_type_cd,chr(13),''),chr(10),'')  -- 贷款期限类型代码
    ,replace(replace(t1.acru_non_acru_cd,chr(13),''),chr(10),'')  -- 应计非应计代码
    ,t1.final_fin_dt  -- 最后财务日期
    ,replace(replace(t1.open_acct_teller_id,chr(13),''),chr(10),'')  -- 开户柜员编号
    ,replace(replace(t1.clos_acct_teller_id,chr(13),''),chr(10),'')  -- 销户柜员编号
    ,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'')  -- 开户机构编号
    ,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'')  -- 管理机构编号
    ,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'')  -- 账务机构编号
    ,t1.open_acct_dt  -- 开户日期
    ,t1.distr_dt  -- 放款日期
    ,t1.value_dt  -- 起息日期
    ,t1.exp_dt  -- 到期日期
    ,t1.clos_acct_dt  -- 销户日期
    ,replace(replace(t1.renew_flg,chr(13),''),chr(10),'')  -- 展期标志
    ,t1.renew_cnt  -- 展期次数
    ,replace(replace(t1.int_accr_rule,chr(13),''),chr(10),'')  -- 计息规则
    ,replace(replace(t1.int_accr_flg,chr(13),''),chr(10),'')  -- 计息标志
    ,replace(replace(t1.comp_int_flg,chr(13),''),chr(10),'')  -- 复息标志
    ,replace(replace(t1.pre_recv_int_way,chr(13),''),chr(10),'')  -- 预收息方式
    ,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'')  -- 利率调整方式代码
    ,replace(replace(t1.int_rat_base_type_cd,chr(13),''),chr(10),'')  -- 利率基准类型代码
    ,t1.base_rat  -- 基准利率
    ,t1.exec_int_rat  -- 执行利率
    ,replace(replace(t1.int_rat_float_way_cd,chr(13),''),chr(10),'')  -- 利率浮动方式代码
    ,replace(replace(t1.int_rat_adj_ped_corp_cd,chr(13),''),chr(10),'')  -- 利率调整周期单位代码
    ,t1.int_rat_adj_ped_freq  -- 利率调整周期频率
    ,t1.int_rat_flo_val  -- 利率浮动值
    ,t1.curr_int_rat_effect_dt  -- 当前利率生效日期
    ,t1.next_int_rat_adj_dt  -- 下次利率调整日期
    ,replace(replace(t1.int_set_way_cd,chr(13),''),chr(10),'')  -- 结息方式代码
    ,replace(replace(t1.int_accr_way_cd,chr(13),''),chr(10),'')  -- 计息方式代码
    ,replace(replace(t1.ped_distr_flg,chr(13),''),chr(10),'')  -- 周期性放款标志
    ,replace(replace(t1.distr_way_cd,chr(13),''),chr(10),'')  -- 放款方式代码
    ,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'')  -- 还款方式代码
    ,replace(replace(t1.repay_ped_corp_cd,chr(13),''),chr(10),'')  -- 还款周期单位代码
    ,t1.repay_ped  -- 还款周期
    ,replace(replace(t1.ovdue_flg,chr(13),''),chr(10),'')  -- 逾期标志
    ,t1.curr_ovdue_perds  -- 当前逾期期数
    ,t1.pric_ovdue_days as ovdue_days  -- 逾期天数
    ,t1.ovdue_pric_bal  -- 逾期本金余额
    ,t1.ovdue_int_amt  -- 逾期利息金额
    ,t1.ovdue_comp_int_amt  -- 逾期复利金额
    ,t1.fir_ovdue_dt  -- 首次逾期日期
    ,t1.ovdue_int_rat  -- 逾期利率
    ,t1.ovdue_int_rat_flo_val  -- 逾期利率浮动值
    ,t1.tot_perds  -- 总期数
    ,t1.curr_issue_perds  -- 本期期数
    ,t1.last_repay_dt  -- 上次还款日期
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.next_repay_dt  -- 下次还款日期
    ,t1.next_rpp_amt  -- 下次还本金额
    ,t1.next_repay_int_amt  -- 下次还息金额
    ,t1.cont_amt  -- 合同金额
    ,t1.dubil_amt  -- 借据金额
    ,t1.distr_amt  -- 放款金额
    ,t1.froz_distrd_amt  -- 冻结可发放金额
    ,t1.distrd_amt  -- 可发放金额
    ,t1.td_acru_int  -- 当日应计利息
    ,t1.currt_acru_int  -- 当期应计利息
    ,t1.nomal_pric  -- 正常本金
    ,t1.ovdue_pric  -- 逾期本金
    ,t1.idle_pric  -- 呆滞本金
    ,t1.bad_debt_pric  -- 呆账本金
    ,t1.loan_fund  -- 贷款基金
    ,t1.coll_acru_int  -- 催收应计利息
    ,t1.recvbl_acru_pnlt  -- 应收应计罚息
    ,t1.coll_acru_pnlt  -- 催收应计罚息
    ,t1.recvbl_pnlt  -- 应收罚息
    ,t1.coll_pnlt  -- 催收罚息
    ,t1.acru_comp_int  -- 应计复息
    ,t1.recvbl_comp_int  -- 应收复息
    ,t1.acru_int_sub  -- 应计贴息
    ,t1.recvbl_int_sub  -- 应收贴息
    ,t1.amorted_int  -- 待摊利息
    ,t1.wrt_off_pric  -- 核销本金
    ,t1.wrt_off_int  -- 核销利息
    ,t1.int_income  -- 利息收入
    ,t1.wrt_off_advc_fee_bal  -- 核销垫付费余额
    ,t1.wrt_off_advc_fee_amt  -- 核销垫付费金额
    ,t1.recvbl_fine  -- 应收罚金
    ,t1.fine_inco  -- 罚金收入
    ,t1.resv  -- 准备金
    ,t1.recvbl_over_int  -- 应收欠息
    ,t1.coll_over_int  -- 催收欠息
    ,t1.in_bs_int  -- 表内利息
    ,t1.off_bs_int  -- 表外利息
    ,t1.acm_recvbl_uncol_int_amt  -- 累计应收未收利息金额
    ,t1.repaid_pric  -- 已偿还本金
    ,t1.repaid_int  -- 已偿还利息
    ,t1.repaid_pnlt  -- 已偿还罚息
    ,t1.repaid_comp_int  -- 已偿还复利
    ,t1.repaid_fee  -- 已偿还费用
    ,t1.pric_bal  -- 本金余额
    ,t1.currt_bal  -- 当期余额
    ,t1.cl_curr_currt_bal  -- 折本币当期余额
    ,t1.ear_d_bal  -- 日初余额
    ,t1.ear_m_bal  -- 月初余额
    ,t1.ear_s_bal  -- 季初余额
    ,t1.ear_y_bal  -- 年初余额
    ,t1.y_acm_bal  -- 年累计余额
    ,t1.s_acm_bal  -- 季累计余额
    ,t1.m_acm_bal  -- 月累计余额
    ,t1.cl_curr_ear_d_bal  -- 折本币日初余额
    ,t1.cl_curr_ear_m_bal  -- 折本币月初余额
    ,t1.cl_curr_ear_s_bal  -- 折本币季初余额
    ,t1.cl_curr_ear_y_bal  -- 折本币年初余额
    ,t1.cl_curr_y_acm_bal  -- 折本币年累计余额
    ,t1.cl_curr_ear_d_y_acm_bal  -- 折本币日初年累计余额
    ,t1.cl_curr_ear_m_y_acm_bal  -- 折本币月初年累计余额
    ,t1.cl_curr_ear_s_y_acm_bal  -- 折本币季初年累计余额
    ,t1.cl_curr_ear_y_y_acm_bal  -- 折本币年初年累计余额
    ,t1.cl_curr_s_acm_bal  -- 折本币季累计余额
    ,t1.cl_curr_ear_d_s_acm_bal  -- 折本币日初季累计余额
    ,t1.cl_curr_ear_s_s_acm_bal  -- 折本币季初季累计余额
    ,t1.cl_curr_ear_y_s_acm_bal  -- 折本币年初季累计余额
    ,t1.cl_curr_m_acm_bal  -- 折本币月累计余额
    ,t1.cl_curr_ear_d_m_acm_bal  -- 折本币日初月累计余额
    ,t1.cl_curr_ear_m_m_acm_bal  -- 折本币月初月累计余额
    ,t1.cl_curr_ear_y_m_acm_bal  -- 折本币年初月累计余额
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,t1.etl_timestamp  -- ETL处理时间戳
from ${icl_schema}.cmm_retl_loan_acct_info t1    --零售贷款账户信息
where t1.etl_dt= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_cmm_retl_loan_acct_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);