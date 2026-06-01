/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_int_rate_form_msg
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
                       FROM ncbs_rb_int_rate_form_msg_bak_${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ncbs_rb_int_rate_form_msg');
  
  if v_var <> 0 then 
    execute immediate 'alter table ncbs_rb_int_rate_form_msg drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ncbs_rb_int_rate_form_msg add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.ncbs_rb_int_rate_form_msg(
            base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,reason -- 原因
            ,company -- 法人
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,valid_from_date -- 有效期起始日期
            ,valid_thru_date -- 有效期截止日期
            ,disc_base_rate -- 基准利率1
            ,float_point -- 浮动点差
            ,real_rate -- 执行利率
            ,int_rate_term -- 利率协议期限
            ,add_agreement_flag -- 新增协议标志
            ,pre_int_rate_form_no -- 原审批单号
            ,auth_client_flag -- 是否为我行授信客户
            ,pri_amt_limit -- 申请本金金额上限
            ,int_valid_from_date -- 利率优惠有效期起始日期
            ,int_valid_thru_date -- 利率优惠有效期截止日期
            ,int_agreement_status -- 利率协议状态
            ,int_rate_form_apply_type -- 利率审批申请类别
            ,auth_client_payment -- 授信客户的综合收益请款
            ,new_acct_no_flag -- 是否为新账号
            ,rb_prod_term -- 存款期限
            ,int_rate_rb_prod_type -- 利率审批单存款品种
            ,int_rate_form_no -- 利率审批单单号
            ,acct_seq_no -- 账户子账号
            ,internal_key -- 账户内部键值
            ,diff_quote_rate -- 差异化利率
			,keep_min_bal -- 最小留存金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,reason -- 原因
            ,company -- 法人
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,valid_from_date -- 有效期起始日期
            ,valid_thru_date -- 有效期截止日期
            ,disc_base_rate -- 基准利率1
            ,float_point -- 浮动点差
            ,real_rate -- 执行利率
            ,int_rate_term -- 利率协议期限
            ,add_agreement_flag -- 新增协议标志
            ,pre_int_rate_form_no -- 原审批单号
            ,auth_client_flag -- 是否为我行授信客户
            ,pri_amt_limit -- 申请本金金额上限
            ,int_valid_from_date -- 利率优惠有效期起始日期
            ,int_valid_thru_date -- 利率优惠有效期截止日期
            ,int_agreement_status -- 利率协议状态
            ,int_rate_form_apply_type -- 利率审批申请类别
            ,auth_client_payment -- 授信客户的综合收益请款
            ,new_acct_no_flag -- 是否为新账号
            ,rb_prod_term -- 存款期限
            ,int_rate_rb_prod_type -- 利率审批单存款品种
            ,int_rate_form_no -- 利率审批单单号
            ,acct_seq_no -- 账户子账号
            ,internal_key -- 账户内部键值
            ,0 as diff_quote_rate -- 差异化利率
			,0 as keep_min_bal -- 最小留存金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ncbs_rb_int_rate_form_msg_bak_${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
