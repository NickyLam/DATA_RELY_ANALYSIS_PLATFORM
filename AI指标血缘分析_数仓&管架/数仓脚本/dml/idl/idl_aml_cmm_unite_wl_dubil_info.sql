/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_cmm_unite_wl_dubil_info
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
alter table ${idl_schema}.aml_cmm_unite_wl_dubil_info drop partition p_${last_date};
alter table ${idl_schema}.aml_cmm_unite_wl_dubil_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_cmm_unite_wl_dubil_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_cmm_unite_wl_dubil_info (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,dubil_id  -- 借据编号
    ,prod_id  -- 产品编号
    ,cust_id  -- 客户编号
    ,subj_id  -- 科目编号
    ,acctnt_cate_cd  -- 会计类别代码
    ,enter_acct_acct_num  -- 入账账号
    ,repay_num  -- 还款账号
    ,rela_agt_id  -- 关联协议编号
    ,curr_cd  -- 币种代码
    ,bus_breed_id  -- 业务品种编号
    ,loan_type_cd  -- 贷款类型代码
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
    ,nomal_int  -- 正常利息
    ,ovdue_int  -- 逾期利息
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
    ,job_cd  -- 任务代码
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.dubil_id,chr(13),''),chr(10),'')  -- 借据编号
    ,replace(replace(t1.prod_id,chr(13),''),chr(10),'')  -- 产品编号
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.subj_id,chr(13),''),chr(10),'')  -- 科目编号
    ,replace(replace(t1.acctnt_cate_cd,chr(13),''),chr(10),'')  -- 会计类别代码
    ,replace(replace(t1.enter_acct_acct_num,chr(13),''),chr(10),'')  -- 入账账号
    ,replace(replace(t1.repay_num,chr(13),''),chr(10),'')  -- 还款账号
    ,replace(replace(t1.rela_agt_id,chr(13),''),chr(10),'')  -- 关联协议编号
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,replace(replace(t1.bus_breed_id,chr(13),''),chr(10),'')  -- 业务品种编号
    ,replace(replace(t1.loan_type_cd,chr(13),''),chr(10),'')  -- 贷款类型代码
    ,replace(replace(t1.dubil_status_cd,chr(13),''),chr(10),'')  -- 借据状态代码
    ,replace(replace(t1.loan_usage_cd,chr(13),''),chr(10),'')  -- 贷款用途代码
    ,replace(replace(t1.dir_indus_cd,chr(13),''),chr(10),'')  -- 投向行业代码
    ,replace(replace(t1.cont_status_cd,chr(13),''),chr(10),'')  -- 合同状态代码
    ,replace(replace(t1.loan_level4_cls_cd,chr(13),''),chr(10),'')  -- 贷款四级分类代码
    ,replace(replace(t1.loan_level5_cls_cd,chr(13),''),chr(10),'')  -- 贷款五级分类代码
    ,replace(replace(t1.loan_level10_cls_cd,chr(13),''),chr(10),'')  -- 贷款十级分类代码
    ,replace(replace(t1.loan_level12_cls_cd,chr(13),''),chr(10),'')  -- 贷款十二级分类代码
    ,replace(replace(t1.acru_non_acru_cd,chr(13),''),chr(10),'')  -- 应计非应计代码
    ,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'')  -- 还款方式代码
    ,replace(replace(t1.int_set_way_cd,chr(13),''),chr(10),'')  -- 结息方式代码
    ,replace(replace(t1.int_accr_way_cd,chr(13),''),chr(10),'')  -- 计息方式代码
    ,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'')  -- 利率调整方式代码
    ,replace(replace(t1.int_rat_adj_ped_corp_cd,chr(13),''),chr(10),'')  -- 利率调整周期单位代码
    ,t1.int_rat_adj_ped_freq  -- 利率调整周期频率
    ,replace(replace(t1.int_rat_base_type_cd,chr(13),''),chr(10),'')  -- 利率基准类型代码
    ,replace(replace(t1.pric_repay_freq_cd,chr(13),''),chr(10),'')  -- 本金还款频率代码
    ,replace(replace(t1.int_repay_freq_cd,chr(13),''),chr(10),'')  -- 利息还款频率代码
    ,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'')  -- 担保方式代码
    ,replace(replace(t1.enter_acct_acct_num_type,chr(13),''),chr(10),'')  -- 入账账号类型
    ,replace(replace(t1.repay_num_type,chr(13),''),chr(10),'')  -- 还款账号类型
    ,replace(replace(t1.intnal_carr_flg,chr(13),''),chr(10),'')  -- 内部结转标志
    ,replace(replace(t1.dom_overs_flg,chr(13),''),chr(10),'')  -- 境内外标志
    ,replace(replace(t1.int_accr_flg,chr(13),''),chr(10),'')  -- 计息标志
    ,replace(replace(t1.comp_int_flg,chr(13),''),chr(10),'')  -- 复息标志
    ,replace(replace(t1.ovdue_flg,chr(13),''),chr(10),'')  -- 逾期标志
    ,replace(replace(t1.wrt_off_flg,chr(13),''),chr(10),'')  -- 核销标志
    ,t1.open_acct_dt  -- 开户日期
    ,t1.distr_dt  -- 放款日期
    ,t1.value_dt  -- 起息日期
    ,t1.exp_dt  -- 到期日期
    ,t1.payoff_dt  -- 结清日期
    ,t1.last_repay_dt  -- 上次还款日期
    ,t1.next_repay_dt  -- 下次还款日期
    ,t1.curr_int_rat_effect_dt  -- 当前利率生效日期
    ,t1.next_int_rat_adj_dt  -- 下次利率调整日期
    ,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'')  -- 客户经理编号
    ,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'')  -- 开户机构编号
    ,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'')  -- 管理机构编号
    ,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'')  -- 账务机构编号
    ,t1.tot_perds  -- 总期数
    ,t1.curr_issue_perds  -- 本期期数
    ,t1.surp_perds  -- 剩余期数
    ,t1.ovdue_perds  -- 逾期期数
    ,t1.pric_ovdue_days  -- 本金逾期天数
    ,t1.int_ovdue_days  -- 利息逾期天数
    ,t1.grace_period_days  -- 宽限期天数
    ,t1.inst_comm_fee_rat  -- 分期手续费费率
    ,t1.base_rat  -- 基准利率
    ,t1.exec_int_rat  -- 执行利率
    ,t1.ovdue_int_rat  -- 逾期利率
    ,t1.daily_exec_int_rat  -- 每日执行利率
    ,t1.cont_amt  -- 合同金额
    ,t1.dubil_amt  -- 借据金额
    ,t1.distr_amt  -- 放款金额
    ,t1.bank_contri_ratio  -- 银行出资比例
    ,t1.td_acru_int  -- 当日应计利息
    ,t1.currt_acru_int  -- 当期应计利息
    ,t1.nomal_pric  -- 正常本金
    ,t1.ovdue_pric  -- 逾期本金
    ,t1.nomal_int  -- 正常利息
    ,t1.ovdue_int  -- 逾期利息
    ,t1.ovdue_pric_pnlt  -- 逾期本金罚息
    ,t1.ovdue_int_pnlt  -- 逾期利息罚息
    ,t1.recvbl_over_int  -- 应收欠息
    ,t1.recvbl_acru_pnlt  -- 应收应计罚息
    ,t1.recvbl_pnlt  -- 应收罚息
    ,t1.recvbl_fee  -- 应收费用
    ,t1.in_bs_over_int_bal  -- 表内欠息余额
    ,t1.off_bs_over_int_bal  -- 表外欠息余额
    ,t1.in_bs_int  -- 表内利息
    ,t1.off_bs_int  -- 表外利息
    ,t1.acm_recvbl_uncol_int_amt  -- 累计应收未收利息金额
    ,t1.repaid_nomal_pric  -- 已偿还正常本金
    ,t1.repaid_ovdue_pric  -- 已偿还逾期本金
    ,t1.repaid_nomal_int  -- 已偿还正常利息
    ,t1.repaid_ovdue_int  -- 已偿还逾期利息
    ,t1.repaid_ovdue_pric_pnlt  -- 已偿还逾期本金罚息
    ,t1.repaid_ovdue_int_pnlt  -- 已偿还逾期利息罚息
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
from ${icl_schema}.cmm_unite_wl_dubil_info t1    --联合网贷借据信息
where t1.etl_dt= to_date('${batch_date}','yyyymmdd') - 1 ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_cmm_unite_wl_dubil_info',partname => 'P_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);