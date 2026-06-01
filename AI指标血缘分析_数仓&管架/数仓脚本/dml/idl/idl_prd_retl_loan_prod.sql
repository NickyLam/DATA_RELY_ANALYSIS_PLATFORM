/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_prd_retl_loan_prod
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
--alter table ${idl_schema}.prd_retl_loan_prod drop partition p_${last_date};
alter table ${idl_schema}.prd_retl_loan_prod drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.prd_retl_loan_prod add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.prd_retl_loan_prod (
    etl_dt  -- 数据日期
    ,prod_id  -- 产品编号
    ,lp_id  -- 法人编号
    ,prod_cate_cd  -- 产品类别代码
    ,prod_name  -- 产品名称
    ,valid_flg  -- 有效标志
    ,guar_way_comb_cd  -- 担保方式组合代码
    ,curr_cd  -- 币种代码
    ,prod_tenor_cd  -- 产品期限代码
    ,min_mon_tenor  -- 最小月期限
    ,max_mon_tenor  -- 最大月期限
    ,sig_loan_amt_uplmi  -- 单笔贷款金额上限
    ,repay_way_comb_cd  -- 还款方式组合代码
    ,insuf_deduct_way_cd  -- 余额不足扣款方式代码
    ,min_adv_repay_amt  -- 最小提前还款金额
    ,min_adv_repay_tenor  -- 最小提前还款期限
    ,int_calc_way_cd  -- 利息计算方式代码
    ,int_rat_adj_way_cd  -- 利率调整方式组合代码
    ,min_cu_int_rat_fl_rt  -- 最小上浮利率浮动比例
    ,max_cu_int_rat_fl_rt  -- 最大上浮利率浮动比例
    ,min_ovdue_pnlt_amt  -- 最小逾期罚息金额
    ,comp_int_flg  -- 计复利标志
    ,min_pnlt_ratio  -- 最小罚息比例
    ,max_pnlt_ratio  -- 最大罚息比例
    ,int_sub_flg  -- 贴息标志
    ,int_sub_way_cd  -- 贴息方式代码
    ,int_sub_enter_way_cd  -- 贴息入账方式代码
    ,int_sub_int_rat  -- 贴息利率
    ,fix_int_sub_amt  -- 固定贴息金额
    ,max_int_sub_amt  -- 最大贴息金额
    ,loan_bus_kind_cd  -- 贷款业务种类代码
    ,exec_year_int_rat  -- 执行年利率
    ,circl_flg  -- 循环标志
    ,max_lower_int_rat_fl_rt  -- 最大下浮利率浮动比例
    ,min_lower_int_rat_fl_rt  -- 最小下浮利率浮动比例
    ,int_accr_rule  -- 计息规则
    ,int_rat_type_cd  -- 利率类型代码
    ,int_rat_ped_cd  -- 利率周期代码
    ,int_rat_adj_ped_comb_cd  -- 利率调整周期组合代码
    ,int_rat_float_way_comb_cd  -- 利率浮动方式组合代码
    ,int_rat_flo_val  -- 利率浮动值
    ,allow_dep_card_flg  -- 允许以存抵贷标志
    ,int_accr_flg  -- 计息标志
    ,comp_int_accr_flg  -- 复息计息标志
    ,ovdue_int_accr_way_cd  -- 逾期计息方式代码
    ,ovdue_pnlt_float_way_cd  -- 逾期罚息浮动方式代码
    ,ovdue_pnlt_flo_val  -- 逾期罚息浮动值
    ,adv_repay_flg  -- 提前还款标志
    ,adv_repay_int_way_cd  -- 提前还款还息方式代码
    ,adv_repay_int_sub_flg  -- 提前还款还贴息标志
    ,auto_deduct_flg  -- 自动扣款标志
    ,auto_payoff_loan_flg  -- 自动结清贷款标志
    ,allow_loan_renew_flg  -- 允许贷款展期标志
    ,renew_max_cnt  -- 展期最大次数
    ,blon_loan_flg  -- 气球贷标志
    ,borw_usage_type_comb_cd  -- 借款用途类型组合代码
    ,nomal_int_rat_float_way_cd  -- 正常利率浮动方式代码
    ,nomal_int_rat_fl_rt  -- 正常利率浮动比例
    ,asset_thd_cls_cd  -- 资产三分类代码
    ,comp_flg  -- 代偿标志
    ,lowt_exec_int_rat  -- 最低执行利率
    ,higt_exec_int_rat  -- 最高执行利率
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,init_prod_id  -- 原产品编号
    ,job_cd -- 任务编码

)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.prod_id,chr(13),''),chr(10),'')  -- 产品编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.prod_cate_cd,chr(13),''),chr(10),'')  -- 产品类别代码
    ,replace(replace(t1.prod_name,chr(13),''),chr(10),'')  -- 产品名称
    ,replace(replace(t1.valid_flg,chr(13),''),chr(10),'')  -- 有效标志
    ,replace(replace(t1.guar_way_comb_cd,chr(13),''),chr(10),'')  -- 担保方式组合代码
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,replace(replace(t1.prod_tenor_cd,chr(13),''),chr(10),'')  -- 产品期限代码
    ,t1.min_mon_tenor  -- 最小月期限
    ,t1.max_mon_tenor  -- 最大月期限
    ,t1.sig_loan_amt_uplmi  -- 单笔贷款金额上限
    ,replace(replace(t1.repay_way_comb_cd,chr(13),''),chr(10),'')  -- 还款方式组合代码
    ,replace(replace(t1.insuf_deduct_way_cd,chr(13),''),chr(10),'')  -- 余额不足扣款方式代码
    ,t1.min_adv_repay_amt  -- 最小提前还款金额
    ,t1.min_adv_repay_tenor  -- 最小提前还款期限
    ,replace(replace(t1.int_calc_way_cd,chr(13),''),chr(10),'')  -- 利息计算方式代码
    ,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'')  -- 利率调整方式组合代码
    ,t1.min_cu_int_rat_fl_rt  -- 最小上浮利率浮动比例
    ,t1.max_cu_int_rat_fl_rt  -- 最大上浮利率浮动比例
    ,t1.min_ovdue_pnlt_amt  -- 最小逾期罚息金额
    ,replace(replace(t1.comp_int_flg,chr(13),''),chr(10),'')  -- 计复利标志
    ,t1.min_pnlt_ratio  -- 最小罚息比例
    ,t1.max_pnlt_ratio  -- 最大罚息比例
    ,replace(replace(t1.int_sub_flg,chr(13),''),chr(10),'')  -- 贴息标志
    ,replace(replace(t1.int_sub_way_cd,chr(13),''),chr(10),'')  -- 贴息方式代码
    ,replace(replace(t1.int_sub_enter_way_cd,chr(13),''),chr(10),'')  -- 贴息入账方式代码
    ,t1.int_sub_int_rat  -- 贴息利率
    ,t1.fix_int_sub_amt  -- 固定贴息金额
    ,t1.max_int_sub_amt  -- 最大贴息金额
    ,replace(replace(t1.loan_bus_kind_cd,chr(13),''),chr(10),'')  -- 贷款业务种类代码
    ,t1.exec_year_int_rat  -- 执行年利率
    ,replace(replace(t1.circl_flg,chr(13),''),chr(10),'')  -- 循环标志
    ,t1.max_lower_int_rat_fl_rt  -- 最大下浮利率浮动比例
    ,t1.min_lower_int_rat_fl_rt  -- 最小下浮利率浮动比例
    ,replace(replace(t1.int_accr_rule,chr(13),''),chr(10),'')  -- 计息规则
    ,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'')  -- 利率类型代码
    ,replace(replace(t1.int_rat_ped_cd,chr(13),''),chr(10),'')  -- 利率周期代码
    ,replace(replace(t1.int_rat_adj_ped_comb_cd,chr(13),''),chr(10),'')  -- 利率调整周期组合代码
    ,replace(replace(t1.int_rat_float_way_comb_cd,chr(13),''),chr(10),'')  -- 利率浮动方式组合代码
    ,t1.int_rat_flo_val  -- 利率浮动值
    ,replace(replace(t1.allow_dep_card_flg,chr(13),''),chr(10),'')  -- 允许以存抵贷标志
    ,replace(replace(t1.int_accr_flg,chr(13),''),chr(10),'')  -- 计息标志
    ,replace(replace(t1.comp_int_accr_flg,chr(13),''),chr(10),'')  -- 复息计息标志
    ,replace(replace(t1.ovdue_int_accr_way_cd,chr(13),''),chr(10),'')  -- 逾期计息方式代码
    ,replace(replace(t1.ovdue_pnlt_float_way_cd,chr(13),''),chr(10),'')  -- 逾期罚息浮动方式代码
    ,t1.ovdue_pnlt_flo_val  -- 逾期罚息浮动值
    ,replace(replace(t1.adv_repay_flg,chr(13),''),chr(10),'')  -- 提前还款标志
    ,replace(replace(t1.adv_repay_int_way_cd,chr(13),''),chr(10),'')  -- 提前还款还息方式代码
    ,replace(replace(t1.adv_repay_int_sub_flg,chr(13),''),chr(10),'')  -- 提前还款还贴息标志
    ,replace(replace(t1.auto_deduct_flg,chr(13),''),chr(10),'')  -- 自动扣款标志
    ,replace(replace(t1.auto_payoff_loan_flg,chr(13),''),chr(10),'')  -- 自动结清贷款标志
    ,replace(replace(t1.allow_loan_renew_flg,chr(13),''),chr(10),'')  -- 允许贷款展期标志
    ,t1.renew_max_cnt  -- 展期最大次数
    ,replace(replace(t1.blon_loan_flg,chr(13),''),chr(10),'')  -- 气球贷标志
    ,replace(replace(t1.borw_usage_type_comb_cd,chr(13),''),chr(10),'')  -- 借款用途类型组合代码
    ,replace(replace(t1.nomal_int_rat_float_way_cd,chr(13),''),chr(10),'')  -- 正常利率浮动方式代码
    ,t1.nomal_int_rat_fl_rt  -- 正常利率浮动比例
    ,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'')  -- 资产三分类代码
    ,replace(replace(t1.comp_flg,chr(13),''),chr(10),'')  -- 代偿标志
    ,t1.lowt_exec_int_rat  -- 最低执行利率
    ,t1.higt_exec_int_rat  -- 最高执行利率
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.init_prod_id,chr(13),''),chr(10),'')  -- 原产品编号
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务编码

from ${iml_schema}.prd_retl_loan_prod t1    --零售贷款产品
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'prd_retl_loan_prod',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);