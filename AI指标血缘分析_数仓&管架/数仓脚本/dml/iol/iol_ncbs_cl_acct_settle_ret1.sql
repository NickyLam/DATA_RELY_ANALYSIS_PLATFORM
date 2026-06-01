/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_acct_settle
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
                       FROM ncbs_cl_acct_settle_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ncbs_cl_acct_settle');
  
  if v_var <> 0 then 
    execute immediate 'alter table ncbs_cl_acct_settle drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ncbs_cl_acct_settle add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.ncbs_cl_acct_settle(
            amt_type -- 金额类型
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,tran_type -- 交易类型
            ,user_id -- 交易柜员编号
            ,auto_blocking -- 自动锁定标志
            ,bank_in_out -- 是否行内行外
            ,company -- 法人
            ,dac_value -- dac值防篡改加密
            ,event_type -- 事件类型
            ,freeze_type -- 受托人账户冻结方式
            ,pay_rec_ind -- 收付款标志
            ,priority -- 优先级
            ,receipt_no -- 回收号
            ,recover_flag -- 实时追缴标志字段
            ,restraint_seq_no -- 冻结编号
            ,self_support_flag -- 是否自营
            ,settle_acct_class -- 结算账户分类
            ,settle_bank_flag -- 资金转移账户银行标识
            ,settle_method -- 结算方法
            ,settle_mobile_phone -- 绑定账户手机号码
            ,settle_no -- 结算编号
            ,settle_weight -- 结算权重
            ,settle_xrate_id -- 结算汇兑方式
            ,trusted_pay_no -- 受托支付编号
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,contributive_ratio -- 出资比例
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,payee_bank_code -- 收款人开户行行号
            ,payee_bank_name -- 收款行名称
            ,profit_ratio -- 分润比例
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_internal_key -- 结算账户标志符
            ,settle_acct_name -- 结算账户户名
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_amt -- 结算金额
            ,settle_bank_name -- 清算账号开户行行名
            ,settle_base_acct_no -- 结算账号
            ,settle_branch -- 清算机构
            ,settle_ccy -- 结算币种
            ,settle_client -- 结算客户号
            ,settle_prod_type -- 结算账户产品类型
            ,settle_xrate -- 结算汇率
            ,hang_seq_no -- 挂账序列号
            ,hang_operate_type1 -- 挂账操作类型
            ,acct_res_operate_type -- 账户限制操作类型|账户限制操作类型|01-新增,02-修改,03-解限,04-追加,05-部分解限,06-续冻
            ,acct_nature_desc -- 账户属性描述
            ,acct_nature -- 存款账户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            amt_type -- 金额类型
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,tran_type -- 交易类型
            ,user_id -- 交易柜员编号
            ,auto_blocking -- 自动锁定标志
            ,bank_in_out -- 是否行内行外
            ,company -- 法人
            ,dac_value -- dac值防篡改加密
            ,event_type -- 事件类型
            ,freeze_type -- 受托人账户冻结方式
            ,pay_rec_ind -- 收付款标志
            ,priority -- 优先级
            ,receipt_no -- 回收号
            ,recover_flag -- 实时追缴标志字段
            ,restraint_seq_no -- 冻结编号
            ,self_support_flag -- 是否自营
            ,settle_acct_class -- 结算账户分类
            ,settle_bank_flag -- 资金转移账户银行标识
            ,settle_method -- 结算方法
            ,settle_mobile_phone -- 绑定账户手机号码
            ,settle_no -- 结算编号
            ,settle_weight -- 结算权重
            ,settle_xrate_id -- 结算汇兑方式
            ,trusted_pay_no -- 受托支付编号
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,contributive_ratio -- 出资比例
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,payee_bank_code -- 收款人开户行行号
            ,payee_bank_name -- 收款行名称
            ,profit_ratio -- 分润比例
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_internal_key -- 结算账户标志符
            ,settle_acct_name -- 结算账户户名
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_amt -- 结算金额
            ,settle_bank_name -- 清算账号开户行行名
            ,settle_base_acct_no -- 结算账号
            ,settle_branch -- 清算机构
            ,settle_ccy -- 结算币种
            ,settle_client -- 结算客户号
            ,settle_prod_type -- 结算账户产品类型
            ,settle_xrate -- 结算汇率
            ,hang_seq_no -- 挂账序列号
            ,hang_operate_type1 -- 挂账操作类型
            ,acct_res_operate_type -- 账户限制操作类型|账户限制操作类型|01-新增,02-修改,03-解限,04-追加,05-部分解限,06-续冻
            ,' ' as acct_nature_desc -- 账户属性描述
            ,' ' as acct_nature -- 存款账户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_acct_settle_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
