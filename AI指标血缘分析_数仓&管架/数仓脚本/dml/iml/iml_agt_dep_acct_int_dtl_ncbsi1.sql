/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_dep_acct_int_dtl_ncbsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_dep_acct_int_dtl_ncbsi1_tm purge;
alter table ${iml_schema}.agt_dep_acct_int_dtl add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_dep_acct_int_dtl modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_acct_int_dtl_ncbsi1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,int_cls_cd -- 利息分类代码
    ,int_provi_ped -- 利息计提周期
    ,next_provi_dt -- 下一计提日期
    ,last_provi_dt -- 上一计提日期
    ,int_set_flg -- 结息标志
    ,cap_flg -- 资本化标志
    ,next_int_set_dt -- 下一结息日期
    ,last_int_set_dt -- 上一结息日期
    ,last_real_int_set_dt -- 上一真实结息日期
    ,day_bf_last_int_set_dt -- 日切前上一结息日期
    ,int_set_freq_cd -- 结息频率代码
    ,provi_day -- 计提日
    ,pay_int_day -- 付息日
    ,int_rat_type_cd -- 利率类型代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,bank_int_int_rat -- 行内利率
    ,int_rat_float_cate_cd -- 利率浮动类别代码
    ,float_int_rat -- 浮动利率
    ,int_rat_float_ratio -- 利率浮动比例
    ,int_rat_float_point -- 利率浮动点数
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,exec_int_rat -- 执行利率
    ,deflt_int_rat -- 违约利率
    ,int_rat_seg_flg -- 利率分段标志
    ,exec_int_rat_lolmi -- 执行利率下限
    ,exec_int_rat_uplmi -- 执行利率上限
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,year_int_accr_base_cd -- 年计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,acm_provi_int -- 累计计提利息
    ,accum -- 积数
    ,provi_day_provi_actl_amt -- 计提日计提实际金额
    ,provi_day_provi_int -- 计提日计提利息
    ,provi_amt_bal -- 计提金额差额
    ,ld_acm_provi_int -- 上日累计计提利息
    ,dep_term_provi_acm_int -- 存期计提累计利息
    ,int_adj_add_amt -- 利息调增金额
    ,provi_day_int_adj_amt -- 计提日利息调整金额
    ,ld_acm_int_adj_amt -- 上日累计利息调整金额
    ,int_accr_way_cd -- 计息方式代码
    ,int_set_amt -- 结息金额
    ,int_set_day_int_amt -- 结息日利息金额
    ,int_accr_surp_days -- 计息剩余天数
    ,ld_bf_pay_int_amt -- 上日前付息金额
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,last_int_rat_start_use_way_cd -- 上一利率启用方式代码
    ,int_rat_modif_day -- 利率变更日
    ,int_rat_modif_ped -- 利率变更周期
    ,accrd_nomal_int_rat_float_flg -- 按正常利率浮动标志
    ,last_int_rat_modif_dt -- 上一利率变更日期
    ,next_int_rat_modif_dt -- 下一利率变更日期
    ,provi_begin_day -- 计提起始日
    ,currt_acm_int_accr_days -- 当期累计计息天数
    ,currt_last_provi_dt -- 当期上一计提日期
    ,agt_prefr_amt -- 协议优惠金额
    ,int_amt -- 利息金额
    ,tax_category_cd -- 税种代码
    ,tax_rat -- 税率
    ,sub_acct_fix_tax_rat -- 分户级固定税率
    ,sub_acct_tax_rat_float_ratio -- 分户级税率浮动比例
    ,sub_acct_tax_rat_float_point -- 分户级税率浮动点数
    ,curr_int_tax_acm_amt -- 本期利息税累计金额
    ,provi_day_int_tax_init_amt -- 计提日利息税原金额
    ,provi_day_int_tax -- 计提日利息税
    ,int_tax_bal -- 利息税差额
    ,int_set_day_int_tax -- 结息日利息税
    ,int_tax_acm_amt -- 利息税累计金额
    ,stock_int_tax -- 存量利息税
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_accum -- 协议积数
    ,agt_float_ratio -- 协议浮动比例
    ,sign_layered_int_rat_type_cd -- 签约分层利率类型代码
    ,back_nature_day_days -- 回溯自然日天数
    ,back_wd_days -- 回溯工作日天数
    ,deduct_int_flg -- 扣划利息标志
    ,cust_id -- 客户编号
    ,tran_tm -- 交易时间
    ,int_rat_chg_flg -- 利率变化标志
    ,discnt_int -- 折扣利息
    ,discnt_int_flg -- 折扣利息标志
    ,int_rat_get_val_day -- 利率取值日
    ,acalc_flg -- 重算标志
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,ld_acm_adj_dt -- 上日累计调整日期
    ,ld_acm_paid_dt -- 上日累计已付日期
    ,delay_pay_int_acm_amt -- 延迟付息累计金额
    ,up_ld_bf_pay_int -- 上上日前付息
    ,up_ld_acm_provi_int -- 上上日累计计提利息
    ,up_ld_int_adj -- 上上日利息调整
    ,delay_pay_int_acm_accti_amt -- 延迟付息累计供核算金额
    ,ld_delay_pay_int_acm_accti_amt -- 上日延迟付息累计供核算金额
    ,up_ld_delay_pay_int_acm_accti_amt -- 上上日延迟付息累计供核算金额
    ,curr_mon_daily_end_day_bal_sum -- 当前月份每日日终余额之和
    ,last_mon_daily_end_day_bal_sum -- 上月每日日终余额之和
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_acct_int_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_rb_acct_int_detail-1
insert into ${iml_schema}.agt_dep_acct_int_dtl_ncbsi1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,int_cls_cd -- 利息分类代码
    ,int_provi_ped -- 利息计提周期
    ,next_provi_dt -- 下一计提日期
    ,last_provi_dt -- 上一计提日期
    ,int_set_flg -- 结息标志
    ,cap_flg -- 资本化标志
    ,next_int_set_dt -- 下一结息日期
    ,last_int_set_dt -- 上一结息日期
    ,last_real_int_set_dt -- 上一真实结息日期
    ,day_bf_last_int_set_dt -- 日切前上一结息日期
    ,int_set_freq_cd -- 结息频率代码
    ,provi_day -- 计提日
    ,pay_int_day -- 付息日
    ,int_rat_type_cd -- 利率类型代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,bank_int_int_rat -- 行内利率
    ,int_rat_float_cate_cd -- 利率浮动类别代码
    ,float_int_rat -- 浮动利率
    ,int_rat_float_ratio -- 利率浮动比例
    ,int_rat_float_point -- 利率浮动点数
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,exec_int_rat -- 执行利率
    ,deflt_int_rat -- 违约利率
    ,int_rat_seg_flg -- 利率分段标志
    ,exec_int_rat_lolmi -- 执行利率下限
    ,exec_int_rat_uplmi -- 执行利率上限
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,year_int_accr_base_cd -- 年计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,acm_provi_int -- 累计计提利息
    ,accum -- 积数
    ,provi_day_provi_actl_amt -- 计提日计提实际金额
    ,provi_day_provi_int -- 计提日计提利息
    ,provi_amt_bal -- 计提金额差额
    ,ld_acm_provi_int -- 上日累计计提利息
    ,dep_term_provi_acm_int -- 存期计提累计利息
    ,int_adj_add_amt -- 利息调增金额
    ,provi_day_int_adj_amt -- 计提日利息调整金额
    ,ld_acm_int_adj_amt -- 上日累计利息调整金额
    ,int_accr_way_cd -- 计息方式代码
    ,int_set_amt -- 结息金额
    ,int_set_day_int_amt -- 结息日利息金额
    ,int_accr_surp_days -- 计息剩余天数
    ,ld_bf_pay_int_amt -- 上日前付息金额
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,last_int_rat_start_use_way_cd -- 上一利率启用方式代码
    ,int_rat_modif_day -- 利率变更日
    ,int_rat_modif_ped -- 利率变更周期
    ,accrd_nomal_int_rat_float_flg -- 按正常利率浮动标志
    ,last_int_rat_modif_dt -- 上一利率变更日期
    ,next_int_rat_modif_dt -- 下一利率变更日期
    ,provi_begin_day -- 计提起始日
    ,currt_acm_int_accr_days -- 当期累计计息天数
    ,currt_last_provi_dt -- 当期上一计提日期
    ,agt_prefr_amt -- 协议优惠金额
    ,int_amt -- 利息金额
    ,tax_category_cd -- 税种代码
    ,tax_rat -- 税率
    ,sub_acct_fix_tax_rat -- 分户级固定税率
    ,sub_acct_tax_rat_float_ratio -- 分户级税率浮动比例
    ,sub_acct_tax_rat_float_point -- 分户级税率浮动点数
    ,curr_int_tax_acm_amt -- 本期利息税累计金额
    ,provi_day_int_tax_init_amt -- 计提日利息税原金额
    ,provi_day_int_tax -- 计提日利息税
    ,int_tax_bal -- 利息税差额
    ,int_set_day_int_tax -- 结息日利息税
    ,int_tax_acm_amt -- 利息税累计金额
    ,stock_int_tax -- 存量利息税
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_accum -- 协议积数
    ,agt_float_ratio -- 协议浮动比例
    ,sign_layered_int_rat_type_cd -- 签约分层利率类型代码
    ,back_nature_day_days -- 回溯自然日天数
    ,back_wd_days -- 回溯工作日天数
    ,deduct_int_flg -- 扣划利息标志
    ,cust_id -- 客户编号
    ,tran_tm -- 交易时间
    ,int_rat_chg_flg -- 利率变化标志
    ,discnt_int -- 折扣利息
    ,discnt_int_flg -- 折扣利息标志
    ,int_rat_get_val_day -- 利率取值日
    ,acalc_flg -- 重算标志
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,ld_acm_adj_dt -- 上日累计调整日期
    ,ld_acm_paid_dt -- 上日累计已付日期
    ,delay_pay_int_acm_amt -- 延迟付息累计金额
    ,up_ld_bf_pay_int -- 上上日前付息
    ,up_ld_acm_provi_int -- 上上日累计计提利息
    ,up_ld_int_adj -- 上上日利息调整
    ,delay_pay_int_acm_accti_amt -- 延迟付息累计供核算金额
    ,ld_delay_pay_int_acm_accti_amt -- 上日延迟付息累计供核算金额
    ,up_ld_delay_pay_int_acm_accti_amt -- 上上日延迟付息累计供核算金额
    ,curr_mon_daily_end_day_bal_sum -- 当前月份每日日终余额之和
    ,last_mon_daily_end_day_bal_sum -- 上月每日日终余额之和
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '120010'||P1.INTERNAL_KEY -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.INT_CLASS -- 利息分类代码
    ,P1.ACCR_PERIOD_FREQ -- 利息计提周期
    ,P1.NEXT_ACCR_DATE -- 下一计提日期
    ,P1.LAST_ACCRUAL_DATE -- 上一计提日期
    ,decode(trim(p1.CYCLE_FLAG),'','-','Y','1','N','0',p1.CYCLE_FLAG) -- 结息标志
    ,decode(trim(p1.INT_CAP_FLAG),'','-','Y','1','N','0',p1.INT_CAP_FLAG) -- 资本化标志
    ,P1.NEXT_CYCLE_DATE -- 下一结息日期
    ,P1.LAST_CYCLE_DATE -- 上一结息日期
    ,P1.LAST_TRUE_CYCLE_DATE -- 上一真实结息日期
    ,P1.LAST_CYCLE_DATE_PRE -- 日切前上一结息日期
    ,nvl(trim(P1.CYCLE_FREQ),'-') -- 结息频率代码
    ,TO_NUMBER(NVL(TRIM(P1.ACCR_INT_DAY),0)) -- 计提日
    ,TO_NUMBER(NVL(TRIM(P1.INT_DAY),0)) -- 付息日
    ,nvl(trim(P1.INT_TYPE),'-') -- 利率类型代码
    ,nvl(trim(P1.RATE_EFFECT_TYPE),'-') -- 利率生效方式代码
    ,P1.ACTUAL_RATE -- 行内利率
    ,P1.FLOAT_TYPE -- 利率浮动类别代码
    ,P1.FLOAT_RATE -- 浮动利率
    ,P1.SPREAD_PERCENT -- 利率浮动比例
    ,P1.SPREAD_RATE -- 利率浮动点数
    ,P1.ACCT_FIXED_RATE -- 分户级固定利率
    ,P1.ACCT_PERCENT_RATE -- 分户级利率浮动比例
    ,P1.ACCT_SPREAD_RATE -- 分户级利率浮动点数
    ,P1.REAL_RATE -- 执行利率
    ,P1.PAST_FAD_RATE -- 违约利率
    ,decode(trim(p1.SPLIT_RATE_FLAG),'','-','Y','1','N','0',p1.SPLIT_RATE_FLAG) -- 利率分段标志
    ,P1.MIN_INT_RATE -- 执行利率下限
    ,P1.MAX_INT_RATE -- 执行利率上限
    ,nvl(trim(P1.MONTH_BASIS),'-') -- 月计息基准代码
    ,nvl(trim(P1.YEAR_BASIS),'-') -- 年计息基准代码
    ,case when p1.MONTH_BASIS='ACT' and p1.YEAR_BASIS='360'  then 'A/360'
     when p1.MONTH_BASIS='D30' and p1.YEAR_BASIS='360'  then '30/360'
     when p1.MONTH_BASIS='ACT' and p1.YEAR_BASIS='365'  then 'A/365'
     when p1.MONTH_BASIS='D30' and p1.YEAR_BASIS='365'  then '30/365'
     when p1.MONTH_BASIS='ACT' and p1.YEAR_BASIS='366'  then  'A/366'
     else '-'  end -- 计息基准代码 -- 计息基准代码
    ,P1.INT_ACCRUED -- 累计计提利息
    ,P1.AGG -- 积数
    ,P1.INT_ACCRUED_CALC_CTD -- 计提日计提实际金额
    ,P1.INT_ACCRUED_CTD -- 计提日计提利息
    ,P1.INT_ACCRUED_DIFF -- 计提金额差额
    ,P1.INT_ACCRUED_PREV -- 上日累计计提利息
    ,P1.INT_ACCRUED_T -- 存期计提累计利息
    ,P1.INT_ADJ -- 利息调增金额
    ,P1.INT_ADJ_CTD -- 计提日利息调整金额
    ,P1.INT_ADJ_PREV -- 上日累计利息调整金额
    ,nvl(trim(P1.INT_CALC_BAL),'-') -- 计息方式代码
    ,P1.INT_POSTED -- 结息金额
    ,P1.INT_POSTED_CTD -- 结息日利息金额
    ,P1.INT_REM_DAYS -- 计息剩余天数
    ,P1.DISCNT_INT_PREV -- 上日前付息金额
    ,P1.CALC_BEGIN_DATE -- 起息日期
    ,P1.CALC_END_DATE -- 到期日期
    ,nvl(trim(P1.INT_APPL_TYPE),'-') -- 利率启用方式代码
    ,nvl(trim(P1.INT_APPL_TYPE_PREV),'-') -- 上一利率启用方式代码
    ,TO_NUMBER(NVL(TRIM(P1.ROLL_DAY),0)) -- 利率变更日
    ,TO_NUMBER(NVL(TRIM(P1.ROLL_FREQ),0)) -- 利率变更周期
    ,decode(trim(p1.CALC_BY_INT),'','-','Y','1','N','0',p1.CALC_BY_INT) -- 按正常利率浮动标志
    ,P1.LAST_ROLL_DATE -- 上一利率变更日期
    ,P1.NEXT_ROLL_DATE -- 下一利率变更日期
    ,TO_NUMBER(NVL(TRIM(P1.TD_ACCR_INT_DAY),0)) -- 计提起始日
    ,P1.TD_INT_NUM_DAYS -- 当期累计计息天数
    ,P1.TD_LAST_ACCR_DATE -- 当期上一计提日期
    ,P1.AGREE_REDUCE_AMT -- 协议优惠金额
    ,P1.INT_AMT -- 利息金额
    ,P1.TAX_TYPE -- 税种代码
    ,P1.TAX_RATE -- 税率
    ,P1.ACCT_FIXED_TAX_RATE -- 分户级固定税率
    ,P1.ACCT_PERCENT_TAX_RATE -- 分户级税率浮动比例
    ,P1.ACCT_SPREAD_TAX_RATE -- 分户级税率浮动点数
    ,P1.TAX_ACCRUED -- 本期利息税累计金额
    ,P1.TAX_ACCRUED_CALC_CTD -- 计提日利息税原金额
    ,P1.TAX_ACCRUED_CTD -- 计提日利息税
    ,P1.TAX_ACCRUED_DIFF -- 利息税差额
    ,P1.TAX_POSTED_CTD -- 结息日利息税
    ,P1.TAX_POSTED -- 利息税累计金额
    ,P1.INT_TAX_T -- 存量利息税
    ,nvl(trim(P1.AGREE_CHANGE_TYPE),'-') -- 协议变动方式代码
    ,P1.AGREE_AGG -- 协议积数
    ,P1.AGREE_PERCENT_RATE -- 协议浮动比例
    ,nvl(trim(P1.LAYER_AGREEMENT),'-') -- 签约分层利率类型代码
    ,P1.FOLLOW_TRACE_NATURAL_DAYS -- 回溯自然日天数
    ,P1.FOLLOW_TRACE_WORKDAY_DAYS -- 回溯工作日天数
    ,decode(trim(p1.INT_FLAG),'','-','Y','1','N','0',p1.INT_FLAG) -- 扣划利息标志
    ,P1.CLIENT_NO -- 客户编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,decode(P1.RATE_CHANGE_IND,'Y','1','N','0',' ','-',P1.RATE_CHANGE_IND) -- 利率变化标志
    ,P1.DISCNT_INT -- 折扣利息
    ,decode(P1.DISCNT_UI_FLAG,'Y','1','N','0',' ','-',P1.DISCNT_UI_FLAG) -- 折扣利息标志
    ,to_number(nvl(trim(P1.FOLLOW_INT_DAY_TYPE),'0')) -- 利率取值日
    ,decode(P1.RETRY_FLAG,'Y','1','N','0',' ','-',P1.RETRY_FLAG) -- 重算标志
    ,P1.LAST_CHANGE_DATE -- 最后修改日期
    ,P1.LAST_CHANGE_USER_ID -- 最后修改柜员编号
    ,P1.ADJ_UPD_LAST_DATE -- 上日累计调整日期
    ,P1.ADV_UPD_LAST_DATE -- 上日累计已付日期
    ,P1.DELAY_TOTAL_AMT -- 延迟付息累计金额
    ,P1.DISCNT_INT_LAST_PREV -- 上上日前付息
    ,P1.INT_ACCRUED_LAST_PREV -- 上上日累计计提利息
    ,P1.INT_ADJ_LAST_PREV -- 上上日利息调整
    ,P1.DELAY_INT_AMOUNT -- 延迟付息累计供核算金额
    ,P1.DELAY_INT_AMOUNT_PREV -- 上日延迟付息累计供核算金额
    ,P1.DELAY_INT_AMOUNT_LAST_PREV -- 上上日延迟付息累计供核算金额
    ,P1.MONTH_TOTAL_AMOUNT -- 当前月份每日日终余额之和
    ,P1.LAST_MONTH_TOTAL_AMOUNT -- 上月每日日终余额之和
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_acct_int_detail' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_acct_int_detail p1
where  1 = 1 
    and P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.agt_dep_acct_int_dtl truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.agt_dep_acct_int_dtl exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.agt_dep_acct_int_dtl_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_dep_acct_int_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_dep_acct_int_dtl_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_dep_acct_int_dtl', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);