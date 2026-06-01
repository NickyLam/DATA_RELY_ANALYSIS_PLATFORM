/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_acct_int_detail
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);
  
begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM ncbs_cl_acct_int_detail_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ncbs_cl_acct_int_detail');
  
  if v_var <> 0 then 
    execute immediate 'alter table ncbs_cl_acct_int_detail drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ncbs_cl_acct_int_detail add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.ncbs_cl_acct_int_detail(
            last_int_calc_date -- 上一利息计算日期
            ,agg -- 积数
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,company -- 法人
            ,dac_value -- dac值防篡改加密
            ,discnt_ui_flag -- 折扣利息标志
            ,int_accrued_diff -- 计提金额差额
            ,tax_accrued_diff -- 利息税差额
            ,int_class -- 利息分类
            ,calc_begin_date -- 利息计算起始日
            ,calc_end_date -- 利息计算截止日
            ,last_accrual_date -- 上一利息计提日
            ,last_change_date -- 最后修改日期
            ,last_cycle_date -- 上一结息日
            ,last_cycle_date_pre -- 日切前上一结息日
            ,last_true_cycle_date -- 上一真实结息日
            ,next_accr_date -- 下一计提日期
            ,next_cycle_date -- 下一结息日
            ,settle_cycle_date -- 账户结算日期
            ,td_last_accr_date -- 当期上一计提日
            ,tran_timestamp -- 交易时间戳
            ,agree_agg -- 协议积数
            ,agree_int -- 协议利息
            ,agree_reduce_amt -- 协议优惠金额
            ,discnt_int -- 折扣利息
            ,discnt_int_prev -- 上日前付息
            ,discnt_retain_int -- 未实现利息
            ,follow_trace_natural_days -- 回溯自然日天数
            ,follow_trace_workday_days -- 回溯工作日天数
            ,int_accrued -- 累计计提
            ,int_accrued_calc_ctd -- 计提日计提实际金额
            ,int_accrued_ctd -- 计提日计提利息
            ,int_accrued_prev -- 上日累计计提利息
            ,int_adj -- 利息调增金额
            ,int_adj_ctd -- 计提日利息调整
            ,int_adj_prev -- 上日利息调整(累计)
            ,int_amt -- 利息金额
            ,int_cap_amt -- 利息资本化金额
            ,int_past_due -- 逾期利息值
            ,int_posted -- 结息金额
            ,int_posted_ctd -- 结息日利息金额
            ,int_rem_days -- 计息剩余天数
            ,int_tax_t -- 存量利息税
            ,last_change_user_id -- 最后修改柜员
            ,last_int_past_due -- 上日逾期利息
            ,tax_accrued -- 结息周期内利息税累计金额
            ,tax_accrued_calc_ctd -- 计提日利息税原金额
            ,tax_accrued_ctd -- 计提日利息税
            ,tax_posted -- 利息税累计金额
            ,tax_posted_ctd -- 结息日利息税
            ,td_accr_int_day -- 计提起始日
            ,td_int_num_days -- 当期累计计息天数
            ,ui_int -- 折扣付出利息
            ,ui_penalty_amt -- 折扣罚息金额
            ,cur_amortize_accrued -- 当期累计已摊销计提
            ,last_bal_upd_date -- 上次动户日期
            ,last_int_accrued_prev -- 上上日累计计提利息
            ,last_int_adj_prev -- 上上日利息累计计提调整
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            last_int_calc_date -- 上一利息计算日期
            ,agg -- 积数
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,company -- 法人
            ,dac_value -- dac值防篡改加密
            ,discnt_ui_flag -- 折扣利息标志
            ,int_accrued_diff -- 计提金额差额
            ,tax_accrued_diff -- 利息税差额
            ,int_class -- 利息分类
            ,calc_begin_date -- 利息计算起始日
            ,calc_end_date -- 利息计算截止日
            ,last_accrual_date -- 上一利息计提日
            ,last_change_date -- 最后修改日期
            ,last_cycle_date -- 上一结息日
            ,last_cycle_date_pre -- 日切前上一结息日
            ,last_true_cycle_date -- 上一真实结息日
            ,next_accr_date -- 下一计提日期
            ,next_cycle_date -- 下一结息日
            ,settle_cycle_date -- 账户结算日期
            ,td_last_accr_date -- 当期上一计提日
            ,tran_timestamp -- 交易时间戳
            ,agree_agg -- 协议积数
            ,agree_int -- 协议利息
            ,agree_reduce_amt -- 协议优惠金额
            ,discnt_int -- 折扣利息
            ,discnt_int_prev -- 上日前付息
            ,discnt_retain_int -- 未实现利息
            ,follow_trace_natural_days -- 回溯自然日天数
            ,follow_trace_workday_days -- 回溯工作日天数
            ,int_accrued -- 累计计提
            ,int_accrued_calc_ctd -- 计提日计提实际金额
            ,int_accrued_ctd -- 计提日计提利息
            ,int_accrued_prev -- 上日累计计提利息
            ,int_adj -- 利息调增金额
            ,int_adj_ctd -- 计提日利息调整
            ,int_adj_prev -- 上日利息调整(累计)
            ,int_amt -- 利息金额
            ,int_cap_amt -- 利息资本化金额
            ,int_past_due -- 逾期利息值
            ,int_posted -- 结息金额
            ,int_posted_ctd -- 结息日利息金额
            ,int_rem_days -- 计息剩余天数
            ,int_tax_t -- 存量利息税
            ,last_change_user_id -- 最后修改柜员
            ,last_int_past_due -- 上日逾期利息
            ,tax_accrued -- 结息周期内利息税累计金额
            ,tax_accrued_calc_ctd -- 计提日利息税原金额
            ,tax_accrued_ctd -- 计提日利息税
            ,tax_posted -- 利息税累计金额
            ,tax_posted_ctd -- 结息日利息税
            ,td_accr_int_day -- 计提起始日
            ,td_int_num_days -- 当期累计计息天数
            ,ui_int -- 折扣付出利息
            ,ui_penalty_amt -- 折扣罚息金额
            ,cur_amortize_accrued -- 当期累计已摊销计提
            ,to_date('00010101','yyyymmdd') as last_bal_upd_date -- 上次动户日期
            ,0 as last_int_accrued_prev -- 上上日累计计提利息
            ,0 as last_int_adj_prev -- 上上日利息累计计提调整
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_acct_int_detail_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
