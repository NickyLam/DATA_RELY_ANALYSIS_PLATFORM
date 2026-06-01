/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_serv_pre_accr
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
                       FROM ncbs_rb_serv_pre_accr_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ncbs_rb_serv_pre_accr');
  
  if v_var <> 0 then 
    execute immediate 'alter table ncbs_rb_serv_pre_accr drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ncbs_rb_serv_pre_accr add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.ncbs_rb_serv_pre_accr(
            pre_accr_no -- 预提摊销编号
            ,pre_accr_status -- 预提状态
            ,gl_code -- 科目代码
            ,fee_type -- 费率类型
            ,cur_pre_accr_amt -- 当日预提金额
            ,total_pre_accr_amt -- 预提总金额
            ,agg_pre_accr_amt -- 累计已预提金额
            ,can_pay_accr_amt -- 可支出金额
            ,paid_pre_accr_amt -- 已支出金额
            ,int_accrued_diff -- 计提金额差额
            ,amortize_period_type -- 摊销期限类型
            ,amortize_day -- 摊销日
            ,amortize_month -- 摊销月
            ,pre_accr_date -- 预提日期
            ,supplement_date -- 补账日期
            ,start_date -- 开始日期
            ,end_date -- 结束日期
            ,oper_date -- 操作日期
            ,oper_user_id -- 操作柜员
            ,auth_user_id -- 授权柜员
            ,branch -- 交易机构编号
            ,ext_trade_no -- 原业务编号
            ,remark -- 备注
            ,client_no -- 客户编号
            ,reference -- 交易参考号
            ,ccy -- 币种
            ,recalc_start_date -- 利息重算起始日
            ,recalc_int_amt -- 重算利息总金额
            ,acct_exec -- 银行客户经理编号
            ,acct_exec_name -- 客户经理姓名
            ,oth_client_no -- 对手客户
            ,oth_client_name -- 对手客户名称
            ,oth_business_no -- 对手业务编号
            ,oth_client_type -- 对手客户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            pre_accr_no -- 预提摊销编号
            ,pre_accr_status -- 预提状态
            ,gl_code -- 科目代码
            ,fee_type -- 费率类型
            ,cur_pre_accr_amt -- 当日预提金额
            ,total_pre_accr_amt -- 预提总金额
            ,agg_pre_accr_amt -- 累计已预提金额
            ,can_pay_accr_amt -- 可支出金额
            ,paid_pre_accr_amt -- 已支出金额
            ,int_accrued_diff -- 计提金额差额
            ,amortize_period_type -- 摊销期限类型
            ,amortize_day -- 摊销日
            ,amortize_month -- 摊销月
            ,pre_accr_date -- 预提日期
            ,supplement_date -- 补账日期
            ,start_date -- 开始日期
            ,end_date -- 结束日期
            ,oper_date -- 操作日期
            ,oper_user_id -- 操作柜员
            ,auth_user_id -- 授权柜员
            ,branch -- 交易机构编号
            ,ext_trade_no -- 原业务编号
            ,remark -- 备注
            ,client_no -- 客户编号
            ,reference -- 交易参考号
            ,ccy -- 币种
            ,recalc_start_date -- 利息重算起始日
            ,recalc_int_amt -- 重算利息总金额
            ,acct_exec -- 银行客户经理编号
            ,acct_exec_name -- 客户经理姓名
            ,oth_client_no -- 对手客户
            ,oth_client_name -- 对手客户名称
            ,oth_business_no -- 对手业务编号
            ,' ' as oth_client_type -- 对手客户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ncbs_rb_serv_pre_accr_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
