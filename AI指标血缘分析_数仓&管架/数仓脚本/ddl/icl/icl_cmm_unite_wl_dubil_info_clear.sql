/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_unite_wl_dubil_info_clear
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_unite_wl_dubil_info_clear
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_unite_wl_dubil_info_clear purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_unite_wl_dubil_info_clear(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,core_dubil_id varchar2(100) -- 核心借据编号
    ,cont_id varchar2(100) -- 合同编号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,prod_id varchar2(100) -- 产品编号
    ,cust_id varchar2(60) -- 客户编号
    ,subj_id varchar2(60) -- 科目编号
    ,acctnt_cate_cd varchar2(10) -- 会计类别代码
    ,enter_acct_acct_num varchar2(100) -- 入账账号
    ,repay_num varchar2(100) -- 还款账号
    ,rela_agt_id varchar2(100) -- 关联协议编号
    ,rela_appl_flow_num varchar2(100) -- 关联申请流水号
    ,curr_cd varchar2(10) -- 币种代码
    ,bus_breed_id varchar2(60) -- 业务品种编号
    ,loan_type_cd varchar2(10) -- 贷款类型代码
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,dubil_status_cd varchar2(10) -- 借据状态代码
    ,loan_usage_cd varchar2(10) -- 贷款用途代码
    ,dir_indus_cd varchar2(10) -- 贷款投向行业代码
    ,cont_status_cd varchar2(10) -- 合同状态代码
    ,loan_level4_cls_cd varchar2(10) -- 贷款四级分类代码
    ,loan_level5_cls_cd varchar2(10) -- 贷款五级分类代码
    ,loan_level10_cls_cd varchar2(10) -- 贷款十级分类代码
    ,loan_level12_cls_cd varchar2(10) -- 贷款十二级分类代码
    ,acru_non_acru_cd varchar2(10) -- 应计非应计代码
    ,repay_way_cd varchar2(10) -- 还款方式代码
    ,int_set_way_cd varchar2(10) -- 结息方式代码
    ,int_accr_way_cd varchar2(10) -- 计息方式代码
    ,int_rat_adj_way_cd varchar2(10) -- 利率调整方式代码
    ,int_rat_adj_ped_corp_cd varchar2(10) -- 利率调整周期单位代码
    ,int_rat_adj_ped_freq number(10,0) -- 利率调整周期频率
    ,int_rat_base_type_cd varchar2(10) -- 利率基准类型代码
    ,int_rat_float_way_cd varchar2(10) -- 利率浮动方式代码
    ,int_rat_float_dir_cd varchar2(10) -- 利率浮动方向代码
    ,int_rat_flo_val number(38,10) -- 利率浮动值
    ,pric_repay_freq_cd varchar2(10) -- 本金还款频率代码
    ,int_repay_freq_cd varchar2(10) -- 利息还款频率代码
    ,guar_way_cd varchar2(10) -- 担保方式代码
    ,cust_char_cd varchar2(30) -- 客户性质代码
    ,enter_acct_acct_num_type varchar2(30) -- 入账账号类型
    ,enter_acct_bank_name varchar2(500) --入账账户开户银行名称
    ,repay_num_type varchar2(30) -- 还款账号类型
    ,repay_open_acct_bank_id varchar2(100) --还款账户开户银行编号
    ,repay_open_acct_org_name varchar2(500) --还款账户开户机构名称
    ,intnal_carr_flg varchar2(10) -- 内部结转标志
    ,dom_overs_flg varchar2(10) -- 境内外标志
    ,white_list_cust_flg varchar2(10) -- 白户标志
    ,farm_flg varchar2(10) -- 农户标志
    ,agclt_flg varchar2(10) -- 涉农标志
    ,int_accr_flg varchar2(10) -- 计息标志
    ,comp_int_flg varchar2(10) -- 复息标志
    ,ovdue_flg varchar2(10) -- 逾期标志
    ,wrt_off_flg varchar2(10) -- 核销标志
	,pbc_inc_loan_flg varchar2(10) -- 人行普惠贷款标志
    ,cred_rht_turn_flg varchar2(10)  -- 债权直转标志
    ,regroup_flg varchar2(10)  --重组标志
    ,regroup_loan_type_cd varchar2(10)  --重组贷款类型代码
    ,regroup_dt date  --重组日期
    ,open_acct_dt date -- 开户日期
    ,distr_dt date -- 放款日期
    ,init_distr_dt date -- 原始放款日期
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,init_exp_dt date  --原始到期日期
    ,payoff_dt date -- 结清日期
    ,last_repay_dt date -- 上次还款日期
    ,next_repay_dt date -- 下次还款日期
    ,curr_int_rat_effect_dt date -- 当前利率生效日期
    ,next_int_rat_adj_dt date -- 下次利率调整日期
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,open_acct_org_id varchar2(60) -- 开户机构编号
    ,mgmt_org_id varchar2(60) -- 管理机构编号
    ,acct_instit_id varchar2(60) -- 账务机构编号
    ,init_tot_perds number(10, 0) -- 原始贷款期数
    ,tot_perds number(10,0) -- 贷款期数
    ,curr_issue_perds number(10,0) -- 当前期数
    ,surp_perds number(10,0) -- 剩余期数
    ,ovdue_perds number(10,0) -- 逾期期数
    ,pric_ovdue_flg varchar2(10) -- 本金逾期标志
    ,int_ovdue_flg varchar2(10) -- 利息逾期标志
    ,pric_ovdue_days number(10,0) -- 本金逾期天数
    ,int_ovdue_days number(10,0) -- 利息逾期天数
    ,grace_period_days number(10,0) -- 宽限期天数
    ,inst_comm_fee_rat number(18,6) -- 分期手续费费率
    ,base_rat number(38,8) -- 基准利率
    ,exec_int_rat number(38,8) -- 执行利率
    ,ovdue_int_rat number(38,8) -- 逾期利率
    ,daily_exec_int_rat number(38,8) -- 每日执行利率
    ,int_rat number(38,8) -- 固收利率
    ,cont_amt number(30,2) -- 合同金额
    ,dubil_amt number(30,2) -- 借据金额
    ,distr_amt number(30,2) -- 放款金额
    ,init_distr_amt number(30,2) -- 原始放款金额
    ,bank_contri_ratio number(18,8) -- 银行出资比例
    ,td_acru_int number(38,8) -- 当日应计利息
    ,currt_acru_int number(30,2) -- 当期应计利息
    ,nomal_pric number(30,2) -- 正常本金
    ,ovdue_pric number(30,2) -- 逾期本金
    ,idle_pric number(30,2) -- 呆滞本金
    ,bad_debt_pric number(30,2) -- 呆账本金
    ,wrt_off_pric number(30,2) -- 核销本金
    ,nomal_int number(30,2) -- 正常利息
    ,ovdue_int number(30,2) -- 逾期利息
    ,wrt_off_int number(30,2) -- 核销利息
    ,ovdue_pric_pnlt number(30,2) -- 逾期本金罚息
    ,ovdue_int_pnlt number(30,2) -- 逾期利息罚息
    ,recvbl_over_int number(30,2) -- 应收欠息
    ,recvbl_acru_pnlt number(30,2) -- 应收应计罚息
    ,recvbl_pnlt number(30,2) -- 应收罚息
    ,recvbl_fee number(30,2) -- 应收费用
    ,in_bs_over_int_bal number(30,2) -- 表内欠息余额
    ,off_bs_over_int_bal number(30,2) -- 表外欠息余额
    ,in_bs_int number(30,2) -- 表内利息
    ,off_bs_int number(30,2) -- 表外利息
    ,acm_recvbl_uncol_int_amt number(30,2) -- 累计应收未收利息金额
    ,repaid_nomal_pric number(30,2) -- 已偿还正常本金
    ,repaid_ovdue_pric number(30,2) -- 已偿还逾期本金
    ,repaid_nomal_int number(30,2) -- 已偿还正常利息
    ,repaid_ovdue_int number(30,2) -- 已偿还逾期利息
    ,repaid_ovdue_pric_pnlt number(30,2) -- 已偿还逾期本金罚息
    ,repaid_ovdue_int_pnlt number(30,2) -- 已偿还逾期利息罚息
    ,repaid_fee number(30,2) -- 已偿还费用
    ,pric_bal number(30,2) -- 本金余额
    ,currt_bal number(30,2) -- 当期余额
    ,cl_curr_currt_bal number(30,2) -- 折本币当期余额
    ,ear_d_bal number(30,2) -- 日初余额
    ,ear_m_bal number(30,2) -- 月初余额
    ,ear_s_bal number(30,2) -- 季初余额
    ,ear_y_bal number(30,2) -- 年初余额
    ,y_acm_bal number(30,2) -- 年累计余额
    ,s_acm_bal number(30,2) -- 季累计余额
    ,m_acm_bal number(30,2) -- 月累计余额
    ,cl_curr_ear_d_bal number(30,2) -- 折本币日初余额
    ,cl_curr_ear_m_bal number(30,2) -- 折本币月初余额
    ,cl_curr_ear_s_bal number(30,2) -- 折本币季初余额
    ,cl_curr_ear_y_bal number(30,2) -- 折本币年初余额
    ,cl_curr_y_acm_bal number(30,2) -- 折本币年累计余额
    ,cl_curr_ear_d_y_acm_bal number(30,2) -- 折本币日初年累计余额
    ,cl_curr_ear_m_y_acm_bal number(30,2) -- 折本币月初年累计余额
    ,cl_curr_ear_s_y_acm_bal number(30,2) -- 折本币季初年累计余额
    ,cl_curr_ear_y_y_acm_bal number(30,2) -- 折本币年初年累计余额
    ,cl_curr_s_acm_bal number(30,2) -- 折本币季累计余额
    ,cl_curr_ear_d_s_acm_bal number(30,2) -- 折本币日初季累计余额
    ,cl_curr_ear_s_s_acm_bal number(30,2) -- 折本币季初季累计余额
    ,cl_curr_ear_y_s_acm_bal number(30,2) -- 折本币年初季累计余额
    ,cl_curr_m_acm_bal number(30,2) -- 折本币月累计余额
    ,cl_curr_ear_d_m_acm_bal number(30,2) -- 折本币日初月累计余额
    ,cl_curr_ear_m_m_acm_bal number(30,2) -- 折本币月初月累计余额
    ,cl_curr_ear_y_m_acm_bal number(30,2) -- 折本币年初月累计余额
    ,y_avg_bal number(30,2) -- 年日均余额
    ,q_avg_bal number(30,2) -- 季日均余额
    ,m_avg_bal number(30,2) -- 月日均余额
    ,cl_curr_y_avg_bal number(30,2) -- 折本币年日均余额
    ,cl_curr_q_avg_bal number(30,2) -- 折本币季日均余额
    ,cl_curr_m_avg_bal number(30,2) -- 折本币月日均余额
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_unite_wl_dubil_info_clear to ${idl_schema};
grant select on ${icl_schema}.cmm_unite_wl_dubil_info_clear to ${iel_schema};
grant select on ${icl_schema}.cmm_unite_wl_dubil_info_clear to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_unite_wl_dubil_info_clear is '联合网贷借据信息';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.dubil_id is '借据编号';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.core_dubil_id is '核心借据编号';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cont_id is '合同编号';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.prod_id is '产品编号';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.acctnt_cate_cd is '会计类别代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.enter_acct_acct_num is '入账账号';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.repay_num is '还款账号';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.rela_agt_id is '关联协议编号';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.rela_appl_flow_num is '关联申请流水号';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.bus_breed_id is '业务品种编号';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.loan_type_cd is '贷款类型代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.asset_thd_cls_cd is '资产三分类代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.dubil_status_cd is '借据状态代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.loan_usage_cd is '贷款用途代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.dir_indus_cd is '贷款投向行业代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cont_status_cd is '合同状态代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.loan_level4_cls_cd is '贷款四级分类代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.loan_level5_cls_cd is '贷款五级分类代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.loan_level10_cls_cd is '贷款十级分类代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.loan_level12_cls_cd is '贷款十二级分类代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.acru_non_acru_cd is '应计非应计代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.repay_way_cd is '还款方式代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.int_set_way_cd is '结息方式代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.int_accr_way_cd is '计息方式代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.int_rat_adj_ped_corp_cd is '利率调整周期单位代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.int_rat_adj_ped_freq is '利率调整周期频率';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.int_rat_base_type_cd is '利率基准类型代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.int_rat_float_way_cd is '利率浮动方式代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.int_rat_float_dir_cd is '利率浮动方向代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.int_rat_flo_val is '利率浮动值';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.pric_repay_freq_cd is '本金还款频率代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.int_repay_freq_cd is '利息还款频率代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.guar_way_cd is '担保方式代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cust_char_cd is '客户性质代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.enter_acct_acct_num_type is '入账账号类型';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.enter_acct_bank_name is '入账账户开户银行名称';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.repay_num_type is '还款账号类型';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.repay_open_acct_bank_id  is '还款账户开户银行编号';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.repay_open_acct_org_name is '还款账户开户机构名称';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.intnal_carr_flg is '内部结转标志';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.dom_overs_flg is '境内外标志';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.white_list_cust_flg is '白户标志';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.farm_flg is '农户标志';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.agclt_flg is '涉农标志';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.int_accr_flg is '计息标志';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.comp_int_flg is '复息标志';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.ovdue_flg is '逾期标志';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.wrt_off_flg is '核销标志';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.pbc_inc_loan_flg is '人行普惠贷款标志';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cred_rht_turn_flg is '债权直转标志';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.regroup_flg is '重组标志';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.regroup_loan_type_cd is '重组贷款类型代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.regroup_dt is '重组日期';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.open_acct_dt is '开户日期';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.distr_dt is '放款日期';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.init_distr_dt is '原始放款日期';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.value_dt is '起息日期';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.init_exp_dt is '原始到期日期';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.payoff_dt is '结清日期';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.last_repay_dt is '上次还款日期';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.next_repay_dt is '下次还款日期';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.curr_int_rat_effect_dt is '当前利率生效日期';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.next_int_rat_adj_dt is '下次利率调整日期';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cust_mgr_id is '客户经理编号';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.open_acct_org_id is '开户机构编号';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.mgmt_org_id is '管理机构编号';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.acct_instit_id is '账务机构编号';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.init_tot_perds is '原始贷款期数';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.tot_perds is '贷款期数';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.curr_issue_perds is '当前期数';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.surp_perds is '剩余期数';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.ovdue_perds is '逾期期数';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.pric_ovdue_flg is '本金逾期标志';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.int_ovdue_flg is '利息逾期标志';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.pric_ovdue_days is '本金逾期天数';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.int_ovdue_days is '利息逾期天数';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.grace_period_days is '宽限期天数';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.inst_comm_fee_rat is '分期手续费费率';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.base_rat is '基准利率';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.exec_int_rat is '执行利率';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.ovdue_int_rat is '逾期利率';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.daily_exec_int_rat is '每日执行利率';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.int_rat is '固收利率';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cont_amt is '合同金额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.dubil_amt is '借据金额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.distr_amt is '放款金额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.init_distr_amt is '原始放款金额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.bank_contri_ratio is '银行出资比例';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.td_acru_int is '当日应计利息';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.currt_acru_int is '当期应计利息';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.nomal_pric is '正常本金';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.ovdue_pric is '逾期本金';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.idle_pric is '呆滞本金';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.bad_debt_pric is '呆账本金';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.wrt_off_pric is '核销本金';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.nomal_int is '正常利息';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.ovdue_int is '逾期利息';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.wrt_off_int is '核销利息';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.ovdue_pric_pnlt is '逾期本金罚息';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.ovdue_int_pnlt is '逾期利息罚息';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.recvbl_over_int is '应收欠息';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.recvbl_acru_pnlt is '应收应计罚息';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.recvbl_pnlt is '应收罚息';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.recvbl_fee is '应收费用';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.in_bs_over_int_bal is '表内欠息余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.off_bs_over_int_bal is '表外欠息余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.in_bs_int is '表内利息';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.off_bs_int is '表外利息';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.acm_recvbl_uncol_int_amt is '累计应收未收利息金额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.repaid_nomal_pric is '已偿还正常本金';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.repaid_ovdue_pric is '已偿还逾期本金';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.repaid_nomal_int is '已偿还正常利息';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.repaid_ovdue_int is '已偿还逾期利息';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.repaid_ovdue_pric_pnlt is '已偿还逾期本金罚息';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.repaid_ovdue_int_pnlt is '已偿还逾期利息罚息';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.repaid_fee is '已偿还费用';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.pric_bal is '本金余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.currt_bal is '当期余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cl_curr_currt_bal is '折本币当期余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.ear_d_bal is '日初余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.ear_m_bal is '月初余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.ear_s_bal is '季初余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.ear_y_bal is '年初余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.y_acm_bal is '年累计余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.s_acm_bal is '季累计余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.m_acm_bal is '月累计余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cl_curr_ear_d_bal is '折本币日初余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cl_curr_ear_m_bal is '折本币月初余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cl_curr_ear_s_bal is '折本币季初余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cl_curr_ear_y_bal is '折本币年初余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cl_curr_y_acm_bal is '折本币年累计余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cl_curr_ear_d_y_acm_bal is '折本币日初年累计余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cl_curr_ear_m_y_acm_bal is '折本币月初年累计余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cl_curr_ear_s_y_acm_bal is '折本币季初年累计余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cl_curr_ear_y_y_acm_bal is '折本币年初年累计余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cl_curr_s_acm_bal is '折本币季累计余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cl_curr_ear_d_s_acm_bal is '折本币日初季累计余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cl_curr_ear_s_s_acm_bal is '折本币季初季累计余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cl_curr_ear_y_s_acm_bal is '折本币年初季累计余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cl_curr_m_acm_bal is '折本币月累计余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cl_curr_ear_d_m_acm_bal is '折本币日初月累计余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cl_curr_ear_m_m_acm_bal is '折本币月初月累计余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cl_curr_ear_y_m_acm_bal is '折本币年初月累计余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.y_avg_bal is '年日均余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.q_avg_bal is '季日均余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.m_avg_bal is '月日均余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cl_curr_y_avg_bal is '折本币年日均余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cl_curr_q_avg_bal is '折本币季日均余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.cl_curr_m_avg_bal is '折本币月日均余额';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_unite_wl_dubil_info_clear.etl_timestamp is 'ETL处理时间戳';
