/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_agreement_financial
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
                       FROM ncbs_rb_agreement_financial_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ncbs_rb_agreement_financial');
  
  if v_var <> 0 then 
    execute immediate 'alter table ncbs_rb_agreement_financial drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ncbs_rb_agreement_financial add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.ncbs_rb_agreement_financial(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_exec -- 银行客户经理编号
            ,acct_exec_name -- 客户经理姓名
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,auto_extend -- 是否自动延期
            ,auto_renew_rollover -- 自动转存方式
            ,auto_settle_flag -- 自动结清标志
            ,company -- 法人
            ,failure_times -- 累积失败次数
            ,fin_prod_desc -- 理财产品类型描述
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,last_transfer_date -- 上次划转日期
            ,next_transfer_date -- 下次划转日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,failure_reason -- 失败原因
            ,fin_prod_type -- 理财产品编号
            ,financial_amount -- 理财产品金额
            ,int_min_amt -- 最小起存金额
            ,out_sign_branch -- 解约机构
            ,out_sign_user_id -- 解约柜员
            ,remain_amt -- 协议留存金额
            ,sign_branch -- 签约机构
            ,sign_user_id -- 签约柜员
            ,tda_acct_ccy -- 定期账户币种
            ,tda_acct_prod_type -- 定期账户产品类型
            ,tda_acct_seq_no -- 定期账户序列号
            ,tda_base_acct_no -- 定期账号
            ,transfer_day -- 划转日
            ,transfer_freq -- 划转频率
            ,deposit_nature -- 核心存款性质
            ,failure_total_times -- 失败总次数
            ,unsign_reference -- 解约流水
            ,fin_fixed_amt -- 理财固定金额
            ,sign_reference -- 签约流水
            ,transfer_start_date -- 转存起始日期
            ,transfer_freq_type -- 划转频率类型
            ,last_transfer_reference -- 上一转存流水
            ,transfer_end_date -- 转存结束日期或终止日期
            ,success_times -- 累积成功次数
            ,success_total_times -- 成功总次数
            ,unsign_operate_date -- 解约操作日期|解约操作日期
            ,retry_transfer_date -- 重新尝试转存日重新尝试转存日
            ,limit_period_freq -- 限额周期限额周期
            ,limit_max_amt -- 最大限额最大限额
            ,next_calc_date -- 下一计算日期下一计算日期
            ,holding_limit -- 已占用额度已占用额度
            ,backup_date -- 
            ,month_total_amount -- 
            ,is_auto_sign -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_exec -- 银行客户经理编号
            ,acct_exec_name -- 客户经理姓名
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,auto_extend -- 是否自动延期
            ,auto_renew_rollover -- 自动转存方式
            ,auto_settle_flag -- 自动结清标志
            ,company -- 法人
            ,failure_times -- 累积失败次数
            ,fin_prod_desc -- 理财产品类型描述
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,last_transfer_date -- 上次划转日期
            ,next_transfer_date -- 下次划转日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,failure_reason -- 失败原因
            ,fin_prod_type -- 理财产品编号
            ,financial_amount -- 理财产品金额
            ,int_min_amt -- 最小起存金额
            ,out_sign_branch -- 解约机构
            ,out_sign_user_id -- 解约柜员
            ,remain_amt -- 协议留存金额
            ,sign_branch -- 签约机构
            ,sign_user_id -- 签约柜员
            ,tda_acct_ccy -- 定期账户币种
            ,tda_acct_prod_type -- 定期账户产品类型
            ,tda_acct_seq_no -- 定期账户序列号
            ,tda_base_acct_no -- 定期账号
            ,transfer_day -- 划转日
            ,transfer_freq -- 划转频率
            ,deposit_nature -- 核心存款性质
            ,failure_total_times -- 失败总次数
            ,unsign_reference -- 解约流水
            ,fin_fixed_amt -- 理财固定金额
            ,sign_reference -- 签约流水
            ,transfer_start_date -- 转存起始日期
            ,transfer_freq_type -- 划转频率类型
            ,last_transfer_reference -- 上一转存流水
            ,transfer_end_date -- 转存结束日期或终止日期
            ,success_times -- 累积成功次数
            ,success_total_times -- 成功总次数
            ,unsign_operate_date -- 解约操作日期|解约操作日期
            ,retry_transfer_date -- 重新尝试转存日重新尝试转存日
            ,limit_period_freq -- 限额周期限额周期
            ,limit_max_amt -- 最大限额最大限额
            ,next_calc_date -- 下一计算日期下一计算日期
            ,holding_limit -- 已占用额度已占用额度
            ,to_date('00010101','yyyymmdd') as backup_date -- 
            ,0 as month_total_amount -- 
            ,' ' as is_auto_sign -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_agreement_financial_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
