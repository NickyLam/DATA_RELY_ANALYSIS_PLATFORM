/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_agreement_overdraft
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
                       FROM ncbs_rb_agreement_overdraft_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ncbs_rb_agreement_overdraft');
  
  if v_var <> 0 then 
    execute immediate 'alter table ncbs_rb_agreement_overdraft drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ncbs_rb_agreement_overdraft add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.ncbs_rb_agreement_overdraft(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,prod_type -- 产品编号
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,company -- 法人
            ,fee_taken_mode -- 贷款手续费收取方式
            ,od_method -- 透支方式
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,fee_rate -- 费率
            ,loan_acct_ccy -- 贷款账户币种
            ,loan_base_acct_no -- 透支签约贷款账户编号
            ,loan_internal_key -- 贷款账户key值
            ,loan_prod_type -- 贷款产品类型
            ,loan_seq_no -- 贷款账户序列号
            ,od_amt -- 透支额度
            ,od_ccy -- 透支币种
            ,od_grace_period -- 透支免息期
            ,od_term -- 透支期限
            ,od_term_type -- 透支期限类型
            ,charge_day -- 收费日|收费日
            ,charge_period_freq -- 收费频率|收费频率
            ,cross_period_rate -- 跨月/季利率|靠当利率中的跨月/季利率，与跨月季标志同时存在
            ,fee_charge_type -- 费用收取方式|费用收取方式|T-转账 ,C-现金 ,F-暂不收费
            ,fee_percent -- 收费比例|收费比例
            ,is_over_month_season_od -- 靠档是否跨月/季|透支是否跨月/季
            ,od_maturity_rule -- 法透到期日计算规则|每笔法透放款的到期日计算规则|1-不跨月,2-不跨季,3-普通法透
            ,od_pay_method -- 透支还款方式|透支还款方式|0-到期自动还本,1-提前自动还本及结清
            ,od_start_amt -- 起透金额|起透金额
            ,profit_amortize_flag -- 是否需要摊销|是否需要摊销|Y-是,N-否
            ,white_client_name -- 白名单客户信息串|白名单客户信息串
            ,amortize_day -- 摊销日
            ,amortize_month -- 摊销月
            ,amortize_period_freq -- 摊销频率
            ,amortize_time_type -- 摊销时间类型 F-期初,L-期末,D-周期内固定日期
            ,remark -- 备注
            ,od_mode -- 透支模式|透支模式
            ,fee_type -- 费率类型|费率类型
            ,int_basis_rate -- 基准利率|基准利率
            ,real_rate -- 执行利率|执行利率
            ,past_due_rate -- 逾期利率
            ,email_box -- 
            ,gear_prod_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,prod_type -- 产品编号
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,company -- 法人
            ,fee_taken_mode -- 贷款手续费收取方式
            ,od_method -- 透支方式
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,fee_rate -- 费率
            ,loan_acct_ccy -- 贷款账户币种
            ,loan_base_acct_no -- 透支签约贷款账户编号
            ,loan_internal_key -- 贷款账户key值
            ,loan_prod_type -- 贷款产品类型
            ,loan_seq_no -- 贷款账户序列号
            ,od_amt -- 透支额度
            ,od_ccy -- 透支币种
            ,od_grace_period -- 透支免息期
            ,od_term -- 透支期限
            ,od_term_type -- 透支期限类型
            ,charge_day -- 收费日|收费日
            ,charge_period_freq -- 收费频率|收费频率
            ,cross_period_rate -- 跨月/季利率|靠当利率中的跨月/季利率，与跨月季标志同时存在
            ,fee_charge_type -- 费用收取方式|费用收取方式|T-转账 ,C-现金 ,F-暂不收费
            ,fee_percent -- 收费比例|收费比例
            ,is_over_month_season_od -- 靠档是否跨月/季|透支是否跨月/季
            ,od_maturity_rule -- 法透到期日计算规则|每笔法透放款的到期日计算规则|1-不跨月,2-不跨季,3-普通法透
            ,od_pay_method -- 透支还款方式|透支还款方式|0-到期自动还本,1-提前自动还本及结清
            ,od_start_amt -- 起透金额|起透金额
            ,profit_amortize_flag -- 是否需要摊销|是否需要摊销|Y-是,N-否
            ,white_client_name -- 白名单客户信息串|白名单客户信息串
            ,amortize_day -- 摊销日
            ,amortize_month -- 摊销月
            ,amortize_period_freq -- 摊销频率
            ,amortize_time_type -- 摊销时间类型 F-期初,L-期末,D-周期内固定日期
            ,remark -- 备注
            ,od_mode -- 透支模式|透支模式
            ,fee_type -- 费率类型|费率类型
            ,int_basis_rate -- 基准利率|基准利率
            ,real_rate -- 执行利率|执行利率
            ,0 as past_due_rate -- 逾期利率
            ,' ' as email_box -- 
            ,' ' as gear_prod_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_agreement_overdraft_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
