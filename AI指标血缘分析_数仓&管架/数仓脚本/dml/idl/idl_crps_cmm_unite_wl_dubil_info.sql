/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl crps_cmm_unite_wl_dubil_info
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.crps_cmm_unite_wl_dubil_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.crps_cmm_unite_wl_dubil_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.crps_cmm_unite_wl_dubil_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,lp_id  -- 法人编号
    ,dubil_id  -- 借据编号
    ,cont_id	-- 合同编号
    ,std_prod_id  -- 标准产品编号
    ,prod_id  -- 产品编号
    ,cust_id  -- 客户编号
    ,subj_id  -- 科目编号
    ,acctnt_cate_cd  -- 会计类别代码
    ,enter_acct_acct_num  -- 入账账号
    ,repay_num  -- 还款账号
    ,rela_agt_id  -- 关联协议编号
    ,rela_appl_flow_num  -- 关联申请流水号
    ,curr_cd  -- 币种代码
    ,bus_breed_id  -- 业务品种编号
    ,loan_type_cd  -- 贷款类型代码
    ,asset_thd_cls_cd  -- 资产三分类代码
    ,dubil_status_cd  -- 借据状态代码
    ,loan_usage_cd  -- 贷款用途代码
    ,dir_indus_cd  -- 投向行业代码
    ,cont_status_cd  -- 合同状态代码
    ,loan_level4_cls_cd  -- 贷款四级分类代码
    ,loan_level5_cls_cd  -- 贷款五级分类代码
    ,loan_level10_cls_cd  -- 贷款十级分类代码
    ,loan_level12_cls_cd  -- 贷款十二级分类代码
    ,acru_non_acru_cd  -- 应计非应计代码
    ,repay_way_cd  -- 还款方式代码
    ,int_set_way_cd  -- 结息方式代码
    ,int_accr_way_cd  -- 计息方式代码
    ,int_rat_adj_way_cd  -- 利率调整方式代码
    ,int_rat_adj_ped_corp_cd  -- 利率调整周期单位代码
    ,int_rat_adj_ped_freq  -- 利率调整周期频率
    ,int_rat_base_type_cd  -- 利率基准类型代码
    ,int_rat_float_way_cd  -- 利率浮动方式代码
    ,int_rat_float_dir_cd  -- 利率浮动方向代码
    ,int_rat_flo_val  -- 利率浮动值
    ,pric_repay_freq_cd  -- 本金还款频率代码
    ,int_repay_freq_cd  -- 利息还款频率代码
    ,guar_way_cd  -- 担保方式代码
    ,enter_acct_acct_num_type  -- 入账账号类型
    ,repay_num_type  -- 还款账号类型
    ,intnal_carr_flg  -- 内部结转标志
    ,dom_overs_flg  -- 境内外标志
    ,int_accr_flg  -- 计息标志
    ,comp_int_flg  -- 复息标志
    ,ovdue_flg  -- 逾期标志
    ,wrt_off_flg  -- 核销标志
    ,open_acct_dt  -- 开户日期
    ,distr_dt  -- 放款日期
    ,value_dt  -- 起息日期
    ,exp_dt  -- 到期日期
    ,payoff_dt  -- 结清日期
    ,last_repay_dt  -- 上次还款日期
    ,next_repay_dt  -- 下次还款日期
    ,curr_int_rat_effect_dt  -- 当前利率生效日期
    ,next_int_rat_adj_dt  -- 下次利率调整日期
    ,cust_mgr_id  -- 客户经理编号
    ,open_acct_org_id  -- 开户机构编号
    ,mgmt_org_id  -- 管理机构编号
    ,acct_instit_id  -- 账务机构编号
    ,tot_perds  -- 总期数
    ,curr_issue_perds  -- 本期期数
    ,surp_perds  -- 剩余期数
    ,ovdue_perds  -- 逾期期数
    ,pric_ovdue_flg  -- 本金逾期标志
    ,int_ovdue_flg  -- 利息逾期标志
    ,pric_ovdue_days  -- 本金逾期天数
    ,int_ovdue_days  -- 利息逾期天数
    ,grace_period_days  -- 宽限期天数
    ,inst_comm_fee_rat  -- 分期手续费费率
    ,base_rat  -- 基准利率
    ,exec_int_rat  -- 执行利率
    ,ovdue_int_rat  -- 逾期利率
    ,daily_exec_int_rat  -- 每日执行利率
    ,cont_amt  -- 合同金额
    ,dubil_amt  -- 借据金额
    ,distr_amt  -- 放款金额
    ,bank_contri_ratio  -- 银行出资比例
    ,td_acru_int  -- 当日应计利息
    ,currt_acru_int  -- 当期应计利息
    ,nomal_pric  -- 正常本金
    ,ovdue_pric  -- 逾期本金
    ,idle_pric  -- 呆滞本金
    ,bad_debt_pric  -- 呆账本金
    ,wrt_off_pric  -- 核销本金
    ,nomal_int  -- 正常利息
    ,ovdue_int  -- 逾期利息
    ,wrt_off_int  -- 核销利息
    ,ovdue_pric_pnlt  -- 逾期本金罚息
    ,ovdue_int_pnlt  -- 逾期利息罚息
    ,recvbl_over_int  -- 应收欠息
    ,recvbl_acru_pnlt  -- 应收应计罚息
    ,recvbl_pnlt  -- 应收罚息
    ,recvbl_fee  -- 应收费用
    ,in_bs_over_int_bal  -- 表内欠息余额
    ,off_bs_over_int_bal  -- 表外欠息余额
    ,in_bs_int  -- 表内利息
    ,off_bs_int  -- 表外利息
    ,acm_recvbl_uncol_int_amt  -- 累计应收未收利息金额
    ,repaid_nomal_pric  -- 已偿还正常本金
    ,repaid_ovdue_pric  -- 已偿还逾期本金
    ,repaid_nomal_int  -- 已偿还正常利息
    ,repaid_ovdue_int  -- 已偿还逾期利息
    ,repaid_ovdue_pric_pnlt  -- 已偿还逾期本金罚息
    ,repaid_ovdue_int_pnlt  -- 已偿还逾期利息罚息
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
    ,y_avg_bal  -- 年日均余额
    ,q_avg_bal  -- 季日均余额
    ,m_avg_bal  -- 月日均余额
    ,cl_curr_y_avg_bal  -- 折本币年日均余额
    ,cl_curr_q_avg_bal  -- 折本币季日均余额
    ,cl_curr_m_avg_bal  -- 折本币月日均余额
    ,init_tot_perds  -- 原始总期数
    ,white_list_cust_flg  -- 白户标志
    ,init_distr_amt  -- 原始放款金额
    ,core_dubil_id  -- 核心借据编号
    ,cust_char_cd  -- 客户性质代码
    ,enter_acct_bank_name  -- 入账账户开户银行名称
    ,repay_open_acct_bank_id  -- 还款账户开户银行编号
    ,repay_open_acct_org_name  -- 还款账户开户机构名称
    ,farm_flg  -- 农户标志
    ,agclt_flg  -- 涉农标志
    ,pbc_inc_loan_flg  -- 人行普惠贷款标志
    ,cred_rht_turn_flg  -- 债权直转标志
    ,regroup_flg  -- 重组标志
    ,regroup_loan_type_cd  -- 重组贷款类型代码
    ,regroup_dt  -- 重组日期
    ,init_distr_dt  -- 原始放款日期
    ,init_exp_dt  -- 原始到期日期
    ,int_rat  -- 固收利率
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- ETL处理日期
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id  -- 法人编号
    ,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id  -- 借据编号
    ,replace(replace(t.cont_id,chr(13),''),chr(10),'') as cont_id  -- 合同编号
    ,replace(replace(t.std_prod_id,chr(13),''),chr(10),'') as std_prod_id  -- 标准产品编号
    ,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id  -- 产品编号
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id  -- 客户编号
    ,replace(replace(t.subj_id,chr(13),''),chr(10),'') as subj_id  -- 科目编号
    ,replace(replace(t.acctnt_cate_cd,chr(13),''),chr(10),'') as acctnt_cate_cd  -- 会计类别代码
    ,replace(replace(t.enter_acct_acct_num,chr(13),''),chr(10),'') as enter_acct_acct_num  -- 入账账号
    ,replace(replace(t.repay_num,chr(13),''),chr(10),'') as repay_num  -- 还款账号
    ,replace(replace(t.rela_agt_id,chr(13),''),chr(10),'') as rela_agt_id  -- 关联协议编号
    ,replace(replace(t.rela_appl_flow_num,chr(13),''),chr(10),'') as rela_appl_flow_num  -- 关联申请流水号
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd  -- 币种代码
    ,replace(replace(t.bus_breed_id,chr(13),''),chr(10),'') as bus_breed_id  -- 业务品种编号
    ,replace(replace(t.loan_type_cd,chr(13),''),chr(10),'') as loan_type_cd  -- 贷款类型代码
    ,replace(replace(t.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd  -- 资产三分类代码
    ,replace(replace(t.dubil_status_cd,chr(13),''),chr(10),'') as dubil_status_cd  -- 借据状态代码
    ,replace(replace(t.loan_usage_cd,chr(13),''),chr(10),'') as loan_usage_cd  -- 贷款用途代码
    ,replace(replace(t.dir_indus_cd,chr(13),''),chr(10),'') as dir_indus_cd  -- 投向行业代码
    ,replace(replace(t.cont_status_cd,chr(13),''),chr(10),'') as cont_status_cd  -- 合同状态代码
    ,replace(replace(t.loan_level4_cls_cd,chr(13),''),chr(10),'') as loan_level4_cls_cd  -- 贷款四级分类代码
    ,replace(replace(t.loan_level5_cls_cd,chr(13),''),chr(10),'') as loan_level5_cls_cd  -- 贷款五级分类代码
    ,replace(replace(t.loan_level10_cls_cd,chr(13),''),chr(10),'') as loan_level10_cls_cd  -- 贷款十级分类代码
    ,replace(replace(t.loan_level12_cls_cd,chr(13),''),chr(10),'') as loan_level12_cls_cd  -- 贷款十二级分类代码
    ,replace(replace(t.acru_non_acru_cd,chr(13),''),chr(10),'') as acru_non_acru_cd  -- 应计非应计代码
    ,replace(replace(t.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd  -- 还款方式代码
    ,replace(replace(t.int_set_way_cd,chr(13),''),chr(10),'') as int_set_way_cd  -- 结息方式代码
    ,replace(replace(t.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd  -- 计息方式代码
    ,replace(replace(t.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd  -- 利率调整方式代码
    ,replace(replace(t.int_rat_adj_ped_corp_cd,chr(13),''),chr(10),'') as int_rat_adj_ped_corp_cd  -- 利率调整周期单位代码
    ,t.int_rat_adj_ped_freq as int_rat_adj_ped_freq  -- 利率调整周期频率
    ,replace(replace(t.int_rat_base_type_cd,chr(13),''),chr(10),'') as int_rat_base_type_cd  -- 利率基准类型代码
    ,replace(replace(t.int_rat_float_way_cd,chr(13),''),chr(10),'') as int_rat_float_way_cd  -- 利率浮动方式代码
    ,replace(replace(t.int_rat_float_dir_cd,chr(13),''),chr(10),'') as int_rat_float_dir_cd  -- 利率浮动方向代码
    ,t.int_rat_flo_val as int_rat_flo_val  -- 利率浮动值
    ,replace(replace(t.pric_repay_freq_cd,chr(13),''),chr(10),'') as pric_repay_freq_cd  -- 本金还款频率代码
    ,replace(replace(t.int_repay_freq_cd,chr(13),''),chr(10),'') as int_repay_freq_cd  -- 利息还款频率代码
    ,replace(replace(t.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd  -- 担保方式代码
    ,replace(replace(t.enter_acct_acct_num_type,chr(13),''),chr(10),'') as enter_acct_acct_num_type  -- 入账账号类型
    ,replace(replace(t.repay_num_type,chr(13),''),chr(10),'') as repay_num_type  -- 还款账号类型
    ,replace(replace(t.intnal_carr_flg,chr(13),''),chr(10),'') as intnal_carr_flg  -- 内部结转标志
    ,replace(replace(t.dom_overs_flg,chr(13),''),chr(10),'') as dom_overs_flg  -- 境内外标志
    ,replace(replace(t.int_accr_flg,chr(13),''),chr(10),'') as int_accr_flg  -- 计息标志
    ,replace(replace(t.comp_int_flg,chr(13),''),chr(10),'') as comp_int_flg  -- 复息标志
    ,replace(replace(t.ovdue_flg,chr(13),''),chr(10),'') as ovdue_flg  -- 逾期标志
    ,replace(replace(t.wrt_off_flg,chr(13),''),chr(10),'') as wrt_off_flg  -- 核销标志
    ,t.open_acct_dt as open_acct_dt  -- 开户日期
    ,t.distr_dt as distr_dt  -- 放款日期
    ,t.value_dt as value_dt  -- 起息日期
    ,t.exp_dt as exp_dt  -- 到期日期
    ,t.payoff_dt as payoff_dt  -- 结清日期
    ,t.last_repay_dt as last_repay_dt  -- 上次还款日期
    ,t.next_repay_dt as next_repay_dt  -- 下次还款日期
    ,t.curr_int_rat_effect_dt as curr_int_rat_effect_dt  -- 当前利率生效日期
    ,t.next_int_rat_adj_dt as next_int_rat_adj_dt  -- 下次利率调整日期
    ,replace(replace(t.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id  -- 客户经理编号
    ,replace(replace(t.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id  -- 开户机构编号
    ,replace(replace(t.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id  -- 管理机构编号
    ,replace(replace(t.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id  -- 账务机构编号
    ,t.tot_perds as tot_perds  -- 总期数
    ,t.curr_issue_perds as curr_issue_perds  -- 本期期数
    ,t.surp_perds as surp_perds  -- 剩余期数
    ,t.ovdue_perds as ovdue_perds  -- 逾期期数
    ,replace(replace(t.pric_ovdue_flg,chr(13),''),chr(10),'') as pric_ovdue_flg  -- 本金逾期标志
    ,replace(replace(t.int_ovdue_flg,chr(13),''),chr(10),'') as int_ovdue_flg  -- 利息逾期标志
    ,t.pric_ovdue_days as pric_ovdue_days  -- 本金逾期天数
    ,t.int_ovdue_days as int_ovdue_days  -- 利息逾期天数
    ,t.grace_period_days as grace_period_days  -- 宽限期天数
    ,t.inst_comm_fee_rat as inst_comm_fee_rat  -- 分期手续费费率
    ,t.base_rat as base_rat  -- 基准利率
    ,t.exec_int_rat as exec_int_rat  -- 执行利率
    ,t.ovdue_int_rat as ovdue_int_rat  -- 逾期利率
    ,t.daily_exec_int_rat as daily_exec_int_rat  -- 每日执行利率
    ,t.cont_amt as cont_amt  -- 合同金额
    ,t.dubil_amt as dubil_amt  -- 借据金额
    ,t.distr_amt as distr_amt  -- 放款金额
    ,t.bank_contri_ratio as bank_contri_ratio  -- 银行出资比例
    ,t.td_acru_int as td_acru_int  -- 当日应计利息
    ,t.currt_acru_int as currt_acru_int  -- 当期应计利息
    ,t.nomal_pric as nomal_pric  -- 正常本金
    ,t.ovdue_pric as ovdue_pric  -- 逾期本金
    ,t.idle_pric as idle_pric  -- 呆滞本金
    ,t.bad_debt_pric as bad_debt_pric  -- 呆账本金
    ,t.wrt_off_pric as wrt_off_pric  -- 核销本金
    ,t.nomal_int as nomal_int  -- 正常利息
    ,t.ovdue_int as ovdue_int  -- 逾期利息
    ,t.wrt_off_int as wrt_off_int  -- 核销利息
    ,t.ovdue_pric_pnlt as ovdue_pric_pnlt  -- 逾期本金罚息
    ,t.ovdue_int_pnlt as ovdue_int_pnlt  -- 逾期利息罚息
    ,t.recvbl_over_int as recvbl_over_int  -- 应收欠息
    ,t.recvbl_acru_pnlt as recvbl_acru_pnlt  -- 应收应计罚息
    ,t.recvbl_pnlt as recvbl_pnlt  -- 应收罚息
    ,t.recvbl_fee as recvbl_fee  -- 应收费用
    ,t.in_bs_over_int_bal as in_bs_over_int_bal  -- 表内欠息余额
    ,t.off_bs_over_int_bal as off_bs_over_int_bal  -- 表外欠息余额
    ,t.in_bs_int as in_bs_int  -- 表内利息
    ,t.off_bs_int as off_bs_int  -- 表外利息
    ,t.acm_recvbl_uncol_int_amt as acm_recvbl_uncol_int_amt  -- 累计应收未收利息金额
    ,t.repaid_nomal_pric as repaid_nomal_pric  -- 已偿还正常本金
    ,t.repaid_ovdue_pric as repaid_ovdue_pric  -- 已偿还逾期本金
    ,t.repaid_nomal_int as repaid_nomal_int  -- 已偿还正常利息
    ,t.repaid_ovdue_int as repaid_ovdue_int  -- 已偿还逾期利息
    ,t.repaid_ovdue_pric_pnlt as repaid_ovdue_pric_pnlt  -- 已偿还逾期本金罚息
    ,t.repaid_ovdue_int_pnlt as repaid_ovdue_int_pnlt  -- 已偿还逾期利息罚息
    ,t.repaid_fee as repaid_fee  -- 已偿还费用
    ,t.pric_bal as pric_bal  -- 本金余额
    ,t.currt_bal as currt_bal  -- 当期余额
    ,t.cl_curr_currt_bal as cl_curr_currt_bal  -- 折本币当期余额
    ,t.ear_d_bal as ear_d_bal  -- 日初余额
    ,t.ear_m_bal as ear_m_bal  -- 月初余额
    ,t.ear_s_bal as ear_s_bal  -- 季初余额
    ,t.ear_y_bal as ear_y_bal  -- 年初余额
    ,t.y_acm_bal as y_acm_bal  -- 年累计余额
    ,t.s_acm_bal as s_acm_bal  -- 季累计余额
    ,t.m_acm_bal as m_acm_bal  -- 月累计余额
    ,t.cl_curr_ear_d_bal as cl_curr_ear_d_bal  -- 折本币日初余额
    ,t.cl_curr_ear_m_bal as cl_curr_ear_m_bal  -- 折本币月初余额
    ,t.cl_curr_ear_s_bal as cl_curr_ear_s_bal  -- 折本币季初余额
    ,t.cl_curr_ear_y_bal as cl_curr_ear_y_bal  -- 折本币年初余额
    ,t.cl_curr_y_acm_bal as cl_curr_y_acm_bal  -- 折本币年累计余额
    ,t.cl_curr_ear_d_y_acm_bal as cl_curr_ear_d_y_acm_bal  -- 折本币日初年累计余额
    ,t.cl_curr_ear_m_y_acm_bal as cl_curr_ear_m_y_acm_bal  -- 折本币月初年累计余额
    ,t.cl_curr_ear_s_y_acm_bal as cl_curr_ear_s_y_acm_bal  -- 折本币季初年累计余额
    ,t.cl_curr_ear_y_y_acm_bal as cl_curr_ear_y_y_acm_bal  -- 折本币年初年累计余额
    ,t.cl_curr_s_acm_bal as cl_curr_s_acm_bal  -- 折本币季累计余额
    ,t.cl_curr_ear_d_s_acm_bal as cl_curr_ear_d_s_acm_bal  -- 折本币日初季累计余额
    ,t.cl_curr_ear_s_s_acm_bal as cl_curr_ear_s_s_acm_bal  -- 折本币季初季累计余额
    ,t.cl_curr_ear_y_s_acm_bal as cl_curr_ear_y_s_acm_bal  -- 折本币年初季累计余额
    ,t.cl_curr_m_acm_bal as cl_curr_m_acm_bal  -- 折本币月累计余额
    ,t.cl_curr_ear_d_m_acm_bal as cl_curr_ear_d_m_acm_bal  -- 折本币日初月累计余额
    ,t.cl_curr_ear_m_m_acm_bal as cl_curr_ear_m_m_acm_bal  -- 折本币月初月累计余额
    ,t.cl_curr_ear_y_m_acm_bal as cl_curr_ear_y_m_acm_bal  -- 折本币年初月累计余额
    ,t.y_avg_bal as y_avg_bal  -- 年日均余额
    ,t.q_avg_bal as q_avg_bal  -- 季日均余额
    ,t.m_avg_bal as m_avg_bal  -- 月日均余额
    ,t.cl_curr_y_avg_bal as cl_curr_y_avg_bal  -- 折本币年日均余额
    ,t.cl_curr_q_avg_bal as cl_curr_q_avg_bal  -- 折本币季日均余额
    ,t.cl_curr_m_avg_bal as cl_curr_m_avg_bal  -- 折本币月日均余额
    ,t.init_tot_perds as init_tot_perds  -- 原始总期数
    ,replace(replace(t.white_list_cust_flg,chr(13),''),chr(10),'') as white_list_cust_flg  -- 白户标志
    ,t.init_distr_amt as init_distr_amt  -- 原始放款金额
    ,replace(replace(t.core_dubil_id,chr(13),''),chr(10),'') as core_dubil_id  -- 核心借据编号
    ,replace(replace(t.cust_char_cd,chr(13),''),chr(10),'') as cust_char_cd  -- 客户性质代码
    ,replace(replace(t.enter_acct_bank_name,chr(13),''),chr(10),'') as enter_acct_bank_name  -- 入账账户开户银行名称
    ,replace(replace(t.repay_open_acct_bank_id,chr(13),''),chr(10),'') as repay_open_acct_bank_id  -- 还款账户开户银行编号
    ,replace(replace(t.repay_open_acct_org_name,chr(13),''),chr(10),'') as repay_open_acct_org_name  -- 还款账户开户机构名称
    ,replace(replace(t.farm_flg,chr(13),''),chr(10),'') as farm_flg  -- 农户标志
    ,replace(replace(t.agclt_flg,chr(13),''),chr(10),'') as agclt_flg  -- 涉农标志
    ,replace(replace(t.pbc_inc_loan_flg,chr(13),''),chr(10),'') as pbc_inc_loan_flg  -- 人行普惠贷款标志
    ,replace(replace(t.cred_rht_turn_flg,chr(13),''),chr(10),'') as cred_rht_turn_flg  -- 债权直转标志
    ,replace(replace(t.regroup_flg,chr(13),''),chr(10),'') as regroup_flg  -- 重组标志
    ,replace(replace(t.regroup_loan_type_cd,chr(13),''),chr(10),'') as regroup_loan_type_cd  -- 重组贷款类型代码
    ,t.regroup_dt as regroup_dt  -- 重组日期
    ,t.init_distr_dt as init_distr_dt  -- 原始放款日期
    ,t.init_exp_dt as init_exp_dt  -- 原始到期日期
    ,t.int_rat as int_rat  -- 固收利率
    ,replace(replace(t.job_cd,chr(13),''),chr(10),'') as job_cd  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 时间戳
 from ${icl_schema}.cmm_unite_wl_dubil_info t--联合网贷借据信息
where t.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;

-- 3 table grant
-- whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.crps_cmm_unite_wl_dubil_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'crps_cmm_unite_wl_dubil_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);