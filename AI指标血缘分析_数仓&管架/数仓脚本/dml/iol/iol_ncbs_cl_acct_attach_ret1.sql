/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_acct_attach
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
                       FROM ncbs_cl_acct_attach_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ncbs_cl_acct_attach');
  
  if v_var <> 0 then 
    execute immediate 'alter table ncbs_cl_acct_attach drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ncbs_cl_acct_attach add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.ncbs_cl_acct_attach(
            internal_key -- 账户内部键值
            ,client_no -- 客户编号
            ,tran_timestamp -- 交易时间戳
            ,pri_due_days -- 本金逾期天数（考虑宽限期）
            ,int_due_days -- 利息逾期天数（考虑宽限期）
            ,pri_first_date -- 本金最早逾期日期
            ,int_first_date -- 利息最早逾期日期
            ,last_change_date -- 最后修改日期
            ,due_days -- 
            ,act_tran_amt -- 
            ,reference -- 
            ,remark -- 
            ,loan_type -- 
            ,hide_sched_flag -- 
            ,is_counter_fyj_flag -- 
            ,old_five_category -- 
            ,fyj_reason -- 
            ,change_reason -- 
            ,past_due_last_stage -- 
            ,past_due_stage_count -- 
            ,first_overdue_date -- 
            ,comp_flag -- 
            ,receipt_type -- 
            ,rec_amt_ctrl -- 
            ,inp_eod_flag -- 
            ,comp_rule -- 
            ,comp_highest -- 
            ,comp_effect_flag -- 
            ,open_tran_timestamp -- 开户时间戳
            ,close_tran_timestamp -- 销户时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            internal_key -- 账户内部键值
            ,client_no -- 客户编号
            ,tran_timestamp -- 交易时间戳
            ,pri_due_days -- 本金逾期天数（考虑宽限期）
            ,int_due_days -- 利息逾期天数（考虑宽限期）
            ,pri_first_date -- 本金最早逾期日期
            ,int_first_date -- 利息最早逾期日期
            ,last_change_date -- 最后修改日期
            ,0 as due_days -- 
            ,0 as act_tran_amt -- 
            ,' ' as reference -- 
            ,' ' as remark -- 
            ,' ' as loan_type -- 
            ,' ' as hide_sched_flag -- 
            ,' ' as is_counter_fyj_flag -- 
            ,' ' as old_five_category -- 
            ,' ' as fyj_reason -- 
            ,' ' as change_reason -- 
            ,0 as past_due_last_stage -- 
            ,0 as past_due_stage_count -- 
            ,to_date('00010101','yyyymmdd') as first_overdue_date -- 
            ,' ' as comp_flag -- 
            ,' ' as receipt_type -- 
            ,' ' as rec_amt_ctrl -- 
            ,' ' as inp_eod_flag -- 
            ,' ' as comp_rule -- 
            ,' ' as comp_highest -- 
            ,' ' as comp_effect_flag -- 
            ,' ' as open_tran_timestamp -- 开户时间戳
            ,' ' as close_tran_timestamp -- 销户时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ncbs_cl_acct_attach_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
