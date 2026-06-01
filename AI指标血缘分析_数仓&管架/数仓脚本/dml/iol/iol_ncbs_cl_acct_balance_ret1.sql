/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_acct_balance
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
                       FROM ncbs_cl_acct_balance_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ncbs_cl_acct_balance');
  
  if v_var <> 0 then 
    execute immediate 'alter table ncbs_cl_acct_balance drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ncbs_cl_acct_balance add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.ncbs_cl_acct_balance(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,company -- 法人
            ,dac_value -- dac值防篡改加密
            ,last_bal_upd_date -- 上次动户日期
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,dd_amt -- 发放金额
            ,dda_amt_prev -- 上日发放金额
            ,gintp_amt -- 宽限期利息
            ,gintp_amt_prev -- 上日宽限期利息
            ,godip_amt -- 宽限期复利
            ,godip_amt_prev -- 上日宽限期复利
            ,godpp_amt -- 宽限期罚息
            ,godpp_amt_prev -- 上日宽限期罚息
            ,gprd_amt -- 宽限期本金
            ,gprd_amt_prev -- 上日宽限期本金
            ,intp_amt -- 逾期利息
            ,intp_amt_prev -- 账户上日逾期利息
            ,last_change_user_id -- 最后修改柜员
            ,odip_amt -- 复利余额
            ,odip_amt_prev -- 上日逾期复利
            ,odpp_amt -- 逾期罚息余额
            ,odpp_amt_prev -- 上日逾期罚息
            ,osl_amt -- 客户未到期本金
            ,osl_amt_prev -- 上日未到期本金
            ,prd_amt -- 逾期本金
            ,prd_amt_prev -- 上日逾期本金
            ,dd_amt_last_prev -- 上上日发放金额
            ,osl_amt_last_prev -- 上上日未到期本金
            ,prd_amt_last_prev -- 上上日逾期本金
            ,intp_amt_last_prev -- 上上日逾期利息
            ,odpp_amt_last_prev -- 上上日逾期罚息
            ,odip_amt_last_prev -- 上上日逾期复利
            ,gprd_amt_last_prev -- 上上日宽限期本金
            ,gintp_amt_last_prev -- 上上日宽限期利息
            ,godpp_amt_last_prev -- 上上日宽限期罚息
            ,godip_amt_last_prev -- 上上日宽限期复利
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,company -- 法人
            ,dac_value -- dac值防篡改加密
            ,last_bal_upd_date -- 上次动户日期
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,dd_amt -- 发放金额
            ,dda_amt_prev -- 上日发放金额
            ,gintp_amt -- 宽限期利息
            ,gintp_amt_prev -- 上日宽限期利息
            ,godip_amt -- 宽限期复利
            ,godip_amt_prev -- 上日宽限期复利
            ,godpp_amt -- 宽限期罚息
            ,godpp_amt_prev -- 上日宽限期罚息
            ,gprd_amt -- 宽限期本金
            ,gprd_amt_prev -- 上日宽限期本金
            ,intp_amt -- 逾期利息
            ,intp_amt_prev -- 账户上日逾期利息
            ,last_change_user_id -- 最后修改柜员
            ,odip_amt -- 复利余额
            ,odip_amt_prev -- 上日逾期复利
            ,odpp_amt -- 逾期罚息余额
            ,odpp_amt_prev -- 上日逾期罚息
            ,osl_amt -- 客户未到期本金
            ,osl_amt_prev -- 上日未到期本金
            ,prd_amt -- 逾期本金
            ,prd_amt_prev -- 上日逾期本金
            ,0 as dd_amt_last_prev -- 上上日发放金额
            ,0 as osl_amt_last_prev -- 上上日未到期本金
            ,0 as prd_amt_last_prev -- 上上日逾期本金
            ,0 as intp_amt_last_prev -- 上上日逾期利息
            ,0 as odpp_amt_last_prev -- 上上日逾期罚息
            ,0 as odip_amt_last_prev -- 上上日逾期复利
            ,0 as gprd_amt_last_prev -- 上上日宽限期本金
            ,0 as gintp_amt_last_prev -- 上上日宽限期利息
            ,0 as godpp_amt_last_prev -- 上上日宽限期罚息
            ,0 as godip_amt_last_prev -- 上上日宽限期复利
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_acct_balance_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
