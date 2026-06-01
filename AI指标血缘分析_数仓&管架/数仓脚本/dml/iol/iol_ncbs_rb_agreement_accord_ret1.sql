/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_agreement_accord
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
                       FROM ncbs_rb_agreement_accord_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ncbs_rb_agreement_accord');
  
  if v_var <> 0 then 
    execute immediate 'alter table ncbs_rb_agreement_accord drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ncbs_rb_agreement_accord add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.ncbs_rb_agreement_accord(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,company -- 法人
            ,month_basis -- 月基准
            ,seq_no -- 序号
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,accord_prod_type -- 协定协议产品类型
            ,acct_ccy -- 账户币种
            ,acct_fixed_rate -- 分户级固定利率
            ,acct_percent_rate -- 分户级利率浮动百分比
            ,acct_spread_rate -- 分户级利率浮动百分点
            ,actual_rate -- 行内利率
            ,float_rate -- 浮动利率
            ,near_amt -- 靠档金额
            ,int_rate_form_no -- 利率审批单单号
            ,last_start_date -- 上一开始日
            ,last_end_date -- 上一结束日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,company -- 法人
            ,month_basis -- 月基准
            ,seq_no -- 序号
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,accord_prod_type -- 协定协议产品类型
            ,acct_ccy -- 账户币种
            ,acct_fixed_rate -- 分户级固定利率
            ,to_char(acct_percent_rate) -- 分户级利率浮动百分比
            ,to_char(acct_spread_rate) -- 分户级利率浮动百分点
            ,actual_rate -- 行内利率
            ,float_rate -- 浮动利率
            ,near_amt -- 靠档金额
            ,int_rate_form_no -- 利率审批单单号
            ,last_start_date -- 上一开始日
            ,last_end_date -- 上一结束日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_agreement_accord_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
