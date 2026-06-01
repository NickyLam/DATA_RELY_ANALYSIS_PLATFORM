/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_receipt
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

declare
     v_flag   number(10) :=0;
          
begin
	for tb in (select partition_name,table_name,substr(partition_name,3) as etl_dt 
	             from user_tab_partitions 
	            where table_name = upper('ncbs_cl_receipt_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('ncbs_cl_receipt')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table ncbs_cl_receipt drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table ncbs_cl_receipt add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';


insert /*+ append */ into ${iol_schema}.ncbs_cl_receipt(
    ccy -- 币种
    ,client_no -- 客户编号
    ,reason_code -- 账户用途
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,appr_flag -- 复核标志
    ,company -- 法人
    ,event_type -- 事件类型
    ,last_pre_repay_deal -- 提前还款前的还款计划变更方式
    ,narrative -- 摘要
    ,pre_repay_deal -- 还款计划变更方式
    ,receipt_gen_code -- 回收产生方式
    ,receipt_no -- 回收号
    ,reversal -- 是否冲正标志
    ,sell_not_flag -- 是否卖断式
    ,settle -- 结算标志
    ,xrate_id -- 汇兑方式
    ,approval_date -- 复核日期
    ,last_change_date -- 最后修改日期
    ,last_contraction_date -- 提前还款前的到期日期
    ,receipt_date -- 贷款还款日期
    ,settle_date -- 结算日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,appr_user_id -- 复核柜员
    ,auth_user_id -- 授权柜员
    ,last_formula_amt -- 提前还款前的期供
    ,loan_no -- 贷款号
    ,local_xrate -- 对人民币汇率
    ,payer_client_no -- 付款人客户号
    ,pre_fee_amt -- 提前还款费用金额
    ,pre_pri_amt -- 提前还款本金金额
    ,rec_amt -- 回收金额(指回收的本金)
    ,reversal_reason -- 冲正原因
    ,settle_user_id -- 结算柜员
    ,tran_branch -- 核心交易机构编号
    ,receipt_type -- 还款类型
    ,reaccount_cd -- 对账代码
    ,repay_restraint -- 还款约束
    ,rec_mode -- 回收模式:T-转账,C-现金
    ,receipt_reason -- 回收原因
    ,reversal_date -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    ccy -- 币种
    ,client_no -- 客户编号
    ,reason_code -- 账户用途
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,appr_flag -- 复核标志
    ,company -- 法人
    ,event_type -- 事件类型
    ,last_pre_repay_deal -- 提前还款前的还款计划变更方式
    ,narrative -- 摘要
    ,pre_repay_deal -- 还款计划变更方式
    ,receipt_gen_code -- 回收产生方式
    ,receipt_no -- 回收号
    ,reversal -- 是否冲正标志
    ,sell_not_flag -- 是否卖断式
    ,settle -- 结算标志
    ,xrate_id -- 汇兑方式
    ,approval_date -- 复核日期
    ,last_change_date -- 最后修改日期
    ,last_contraction_date -- 提前还款前的到期日期
    ,receipt_date -- 贷款还款日期
    ,settle_date -- 结算日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,appr_user_id -- 复核柜员
    ,auth_user_id -- 授权柜员
    ,last_formula_amt -- 提前还款前的期供
    ,loan_no -- 贷款号
    ,local_xrate -- 对人民币汇率
    ,payer_client_no -- 付款人客户号
    ,pre_fee_amt -- 提前还款费用金额
    ,pre_pri_amt -- 提前还款本金金额
    ,rec_amt -- 回收金额(指回收的本金)
    ,reversal_reason -- 冲正原因
    ,settle_user_id -- 结算柜员
    ,tran_branch -- 核心交易机构编号
    ,receipt_type -- 还款类型
    ,reaccount_cd -- 对账代码
    ,repay_restraint -- 还款约束
    ,rec_mode -- 回收模式:T-转账,C-现金
    ,receipt_reason -- 回收原因
    ,to_date('00010101','yyyymmdd') as reversal_date -- 
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from ncbs_cl_receipt_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;
end loop;
end;
/