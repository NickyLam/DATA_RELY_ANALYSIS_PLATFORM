/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl prd_retl_loan_prod
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.prd_retl_loan_prod
whenever sqlerror continue none;
drop table ${idl_schema}.prd_retl_loan_prod purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.prd_retl_loan_prod(
    etl_dt date -- 数据日期   
    ,prod_id varchar2(100) -- 产品编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,prod_cate_cd varchar2(30) -- 产品类别代码   
    ,prod_name varchar2(500) -- 产品名称   
    ,valid_flg varchar2(10) -- 有效标志   
    ,guar_way_comb_cd varchar2(250) -- 担保方式组合代码   
    ,curr_cd varchar2(30) -- 币种代码   
    ,prod_tenor_cd varchar2(30) -- 产品期限代码   
    ,min_mon_tenor number(10) -- 最小月期限   
    ,max_mon_tenor number(10) -- 最大月期限   
    ,sig_loan_amt_uplmi number(30,8) -- 单笔贷款金额上限   
    ,repay_way_comb_cd varchar2(60) -- 还款方式组合代码   
    ,insuf_deduct_way_cd varchar2(30) -- 余额不足扣款方式代码   
    ,min_adv_repay_amt number(30,8) -- 最小提前还款金额   
    ,min_adv_repay_tenor number(30,8) -- 最小提前还款期限   
    ,int_calc_way_cd varchar2(30) -- 利息计算方式代码   
    ,int_rat_adj_way_cd varchar2(60) -- 利率调整方式组合代码   
    ,min_cu_int_rat_fl_rt number(18,8) -- 最小上浮利率浮动比例   
    ,max_cu_int_rat_fl_rt number(18,8) -- 最大上浮利率浮动比例   
    ,min_ovdue_pnlt_amt number(30,8) -- 最小逾期罚息金额   
    ,comp_int_flg varchar2(10) -- 计复利标志   
    ,min_pnlt_ratio number(18,6) -- 最小罚息比例   
    ,max_pnlt_ratio number(18,6) -- 最大罚息比例   
    ,int_sub_flg varchar2(10) -- 贴息标志   
    ,int_sub_way_cd varchar2(30) -- 贴息方式代码   
    ,int_sub_enter_way_cd varchar2(30) -- 贴息入账方式代码   
    ,int_sub_int_rat number(18,8) -- 贴息利率   
    ,fix_int_sub_amt number(30,2) -- 固定贴息金额   
    ,max_int_sub_amt number(30,2) -- 最大贴息金额   
    ,loan_bus_kind_cd varchar2(30) -- 贷款业务种类代码   
    ,exec_year_int_rat number(18,8) -- 执行年利率   
    ,circl_flg varchar2(10) -- 循环标志   
    ,max_lower_int_rat_fl_rt number(18,8) -- 最大下浮利率浮动比例   
    ,min_lower_int_rat_fl_rt number(18,8) -- 最小下浮利率浮动比例   
    ,int_accr_rule varchar2(30) -- 计息规则   
    ,int_rat_type_cd varchar2(30) -- 利率类型代码   
    ,int_rat_ped_cd varchar2(30) -- 利率周期代码   
    ,int_rat_adj_ped_comb_cd varchar2(30) -- 利率调整周期组合代码   
    ,int_rat_float_way_comb_cd varchar2(60) -- 利率浮动方式组合代码   
    ,int_rat_flo_val number(18,6) -- 利率浮动值   
    ,allow_dep_card_flg varchar2(10) -- 允许以存抵贷标志   
    ,int_accr_flg varchar2(10) -- 计息标志   
    ,comp_int_accr_flg varchar2(10) -- 复息计息标志   
    ,ovdue_int_accr_way_cd varchar2(250) -- 逾期计息方式代码   
    ,ovdue_pnlt_float_way_cd varchar2(250) -- 逾期罚息浮动方式代码   
    ,ovdue_pnlt_flo_val number(18,8) -- 逾期罚息浮动值   
    ,adv_repay_flg varchar2(10) -- 提前还款标志   
    ,adv_repay_int_way_cd varchar2(250) -- 提前还款还息方式代码   
    ,adv_repay_int_sub_flg varchar2(10) -- 提前还款还贴息标志   
    ,auto_deduct_flg varchar2(10) -- 自动扣款标志   
    ,auto_payoff_loan_flg varchar2(10) -- 自动结清贷款标志   
    ,allow_loan_renew_flg varchar2(10) -- 允许贷款展期标志   
    ,renew_max_cnt number(10) -- 展期最大次数   
    ,blon_loan_flg varchar2(10) -- 气球贷标志   
    ,borw_usage_type_comb_cd varchar2(250) -- 借款用途类型组合代码   
    ,nomal_int_rat_float_way_cd varchar2(60) -- 正常利率浮动方式代码   
    ,nomal_int_rat_fl_rt number(18,6) -- 正常利率浮动比例   
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码   
    ,comp_flg varchar2(10) -- 代偿标志   
    ,lowt_exec_int_rat number(18,8) -- 最低执行利率   
    ,higt_exec_int_rat number(18,8) -- 最高执行利率   
    ,create_dt date -- 创建日期   
    ,update_dt date -- 更新日期   
    ,id_mark varchar2(10) -- 删除标识   
    ,init_prod_id varchar2(100) -- 原产品编号
    ,job_cd varchar2(10) -- 任务编码   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.prd_retl_loan_prod to ${iel_schema};

-- comment
comment on table ${idl_schema}.prd_retl_loan_prod is '零售贷款产品';
comment on column ${idl_schema}.prd_retl_loan_prod.etl_dt is '数据日期';
comment on column ${idl_schema}.prd_retl_loan_prod.prod_id is '产品编号';
comment on column ${idl_schema}.prd_retl_loan_prod.lp_id is '法人编号';
comment on column ${idl_schema}.prd_retl_loan_prod.prod_cate_cd is '产品类别代码';
comment on column ${idl_schema}.prd_retl_loan_prod.prod_name is '产品名称';
comment on column ${idl_schema}.prd_retl_loan_prod.valid_flg is '有效标志';
comment on column ${idl_schema}.prd_retl_loan_prod.guar_way_comb_cd is '担保方式组合代码';
comment on column ${idl_schema}.prd_retl_loan_prod.curr_cd is '币种代码';
comment on column ${idl_schema}.prd_retl_loan_prod.prod_tenor_cd is '产品期限代码';
comment on column ${idl_schema}.prd_retl_loan_prod.min_mon_tenor is '最小月期限';
comment on column ${idl_schema}.prd_retl_loan_prod.max_mon_tenor is '最大月期限';
comment on column ${idl_schema}.prd_retl_loan_prod.sig_loan_amt_uplmi is '单笔贷款金额上限';
comment on column ${idl_schema}.prd_retl_loan_prod.repay_way_comb_cd is '还款方式组合代码';
comment on column ${idl_schema}.prd_retl_loan_prod.insuf_deduct_way_cd is '余额不足扣款方式代码';
comment on column ${idl_schema}.prd_retl_loan_prod.min_adv_repay_amt is '最小提前还款金额';
comment on column ${idl_schema}.prd_retl_loan_prod.min_adv_repay_tenor is '最小提前还款期限';
comment on column ${idl_schema}.prd_retl_loan_prod.int_calc_way_cd is '利息计算方式代码';
comment on column ${idl_schema}.prd_retl_loan_prod.int_rat_adj_way_cd is '利率调整方式组合代码';
comment on column ${idl_schema}.prd_retl_loan_prod.min_cu_int_rat_fl_rt is '最小上浮利率浮动比例';
comment on column ${idl_schema}.prd_retl_loan_prod.max_cu_int_rat_fl_rt is '最大上浮利率浮动比例';
comment on column ${idl_schema}.prd_retl_loan_prod.min_ovdue_pnlt_amt is '最小逾期罚息金额';
comment on column ${idl_schema}.prd_retl_loan_prod.comp_int_flg is '计复利标志';
comment on column ${idl_schema}.prd_retl_loan_prod.min_pnlt_ratio is '最小罚息比例';
comment on column ${idl_schema}.prd_retl_loan_prod.max_pnlt_ratio is '最大罚息比例';
comment on column ${idl_schema}.prd_retl_loan_prod.int_sub_flg is '贴息标志';
comment on column ${idl_schema}.prd_retl_loan_prod.int_sub_way_cd is '贴息方式代码';
comment on column ${idl_schema}.prd_retl_loan_prod.int_sub_enter_way_cd is '贴息入账方式代码';
comment on column ${idl_schema}.prd_retl_loan_prod.int_sub_int_rat is '贴息利率';
comment on column ${idl_schema}.prd_retl_loan_prod.fix_int_sub_amt is '固定贴息金额';
comment on column ${idl_schema}.prd_retl_loan_prod.max_int_sub_amt is '最大贴息金额';
comment on column ${idl_schema}.prd_retl_loan_prod.loan_bus_kind_cd is '贷款业务种类代码';
comment on column ${idl_schema}.prd_retl_loan_prod.exec_year_int_rat is '执行年利率';
comment on column ${idl_schema}.prd_retl_loan_prod.circl_flg is '循环标志';
comment on column ${idl_schema}.prd_retl_loan_prod.max_lower_int_rat_fl_rt is '最大下浮利率浮动比例';
comment on column ${idl_schema}.prd_retl_loan_prod.min_lower_int_rat_fl_rt is '最小下浮利率浮动比例';
comment on column ${idl_schema}.prd_retl_loan_prod.int_accr_rule is '计息规则';
comment on column ${idl_schema}.prd_retl_loan_prod.int_rat_type_cd is '利率类型代码';
comment on column ${idl_schema}.prd_retl_loan_prod.int_rat_ped_cd is '利率周期代码';
comment on column ${idl_schema}.prd_retl_loan_prod.int_rat_adj_ped_comb_cd is '利率调整周期组合代码';
comment on column ${idl_schema}.prd_retl_loan_prod.int_rat_float_way_comb_cd is '利率浮动方式组合代码';
comment on column ${idl_schema}.prd_retl_loan_prod.int_rat_flo_val is '利率浮动值';
comment on column ${idl_schema}.prd_retl_loan_prod.allow_dep_card_flg is '允许以存抵贷标志';
comment on column ${idl_schema}.prd_retl_loan_prod.int_accr_flg is '计息标志';
comment on column ${idl_schema}.prd_retl_loan_prod.comp_int_accr_flg is '复息计息标志';
comment on column ${idl_schema}.prd_retl_loan_prod.ovdue_int_accr_way_cd is '逾期计息方式代码';
comment on column ${idl_schema}.prd_retl_loan_prod.ovdue_pnlt_float_way_cd is '逾期罚息浮动方式代码';
comment on column ${idl_schema}.prd_retl_loan_prod.ovdue_pnlt_flo_val is '逾期罚息浮动值';
comment on column ${idl_schema}.prd_retl_loan_prod.adv_repay_flg is '提前还款标志';
comment on column ${idl_schema}.prd_retl_loan_prod.adv_repay_int_way_cd is '提前还款还息方式代码';
comment on column ${idl_schema}.prd_retl_loan_prod.adv_repay_int_sub_flg is '提前还款还贴息标志';
comment on column ${idl_schema}.prd_retl_loan_prod.auto_deduct_flg is '自动扣款标志';
comment on column ${idl_schema}.prd_retl_loan_prod.auto_payoff_loan_flg is '自动结清贷款标志';
comment on column ${idl_schema}.prd_retl_loan_prod.allow_loan_renew_flg is '允许贷款展期标志';
comment on column ${idl_schema}.prd_retl_loan_prod.renew_max_cnt is '展期最大次数';
comment on column ${idl_schema}.prd_retl_loan_prod.blon_loan_flg is '气球贷标志';
comment on column ${idl_schema}.prd_retl_loan_prod.borw_usage_type_comb_cd is '借款用途类型组合代码';
comment on column ${idl_schema}.prd_retl_loan_prod.nomal_int_rat_float_way_cd is '正常利率浮动方式代码';
comment on column ${idl_schema}.prd_retl_loan_prod.nomal_int_rat_fl_rt is '正常利率浮动比例';
comment on column ${idl_schema}.prd_retl_loan_prod.asset_thd_cls_cd is '资产三分类代码';
comment on column ${idl_schema}.prd_retl_loan_prod.comp_flg is '代偿标志';
comment on column ${idl_schema}.prd_retl_loan_prod.lowt_exec_int_rat is '最低执行利率';
comment on column ${idl_schema}.prd_retl_loan_prod.higt_exec_int_rat is '最高执行利率';
comment on column ${idl_schema}.prd_retl_loan_prod.create_dt is '创建日期';
comment on column ${idl_schema}.prd_retl_loan_prod.update_dt is '更新日期';
comment on column ${idl_schema}.prd_retl_loan_prod.id_mark is '删除标识';
comment on column ${idl_schema}.prd_retl_loan_prod.init_prod_id is '原产品编号';