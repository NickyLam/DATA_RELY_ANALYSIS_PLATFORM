/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_acct_event_register
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
	            where table_name = upper('ncbs_rb_acct_event_register_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('ncbs_rb_acct_event_register')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table ncbs_rb_acct_event_register drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table ncbs_rb_acct_event_register add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';

insert /*+ append */ into ${iol_schema}.ncbs_rb_acct_event_register(
    acct_seq_no -- 账户子账号
    ,amt_type -- 金额类型
    ,base_acct_no -- 交易账号/卡号
    ,business_unit -- 账套
    ,client_no -- 客户编号
    ,client_type -- 客户类型
    ,doc_type -- 凭证类型
    ,int_type -- 利率类型
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,profit_center -- 利润中心
    ,reference -- 交易参考号
    ,user_id -- 交易柜员编号
    ,voucher_no -- 凭证号码
    ,term -- 存期
    ,term_type -- 期限单位
    ,company -- 法人
    ,gl_posted_flag -- 过账标记
    ,int_cap_flag -- 资本化标志
    ,movt_status -- 转存类型
    ,narrative -- 摘要
    ,prefix -- 前缀
    ,print_cnt -- 打印次数
    ,seq_no -- 序号
    ,seq_renew_rollover_no -- 转存序号
    ,source_module -- 源模块
    ,tax_type -- 税种
    ,tran_status -- 冲补抹标志
    ,int_class -- 利息分类
    ,accounting_status -- 核算状态
    ,acct_open_date -- 账户开户日期
    ,last_cycle_date -- 上一结息日
    ,maturity_date -- 到期日期
    ,reversal_date -- 冲正日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,acct_ccy -- 账户币种
    ,acct_level_int_rate -- 账户基础利率
    ,actual_rate -- 行内利率
    ,calc_days -- 算息天数
    ,calc_int_amt -- 算息金额
    ,debt_int_rate -- 支取利率
    ,float_rate -- 浮动利率
    ,gross_interest_amt -- 总利息金额
    ,int_adj -- 利息调增金额
    ,int_adj_ctd -- 计提日利息调整
    ,net_interest_amt -- 净利息
    ,principal_amt -- 交易本金
    ,real_rate -- 执行利率
    ,spread_rate -- 浮动点数
    ,tax_amt -- 税金
    ,tax_rate -- 税率
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,reaccount_cd -- 对账代码
    ,bus_seq_no -- 业务流水号
    ,calc_begin_date -- 利息计算起始日
    ,year_basis -- 年基准天数
    ,month_basis -- 月基准
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acct_seq_no -- 账户子账号
    ,amt_type -- 金额类型
    ,base_acct_no -- 交易账号/卡号
    ,business_unit -- 账套
    ,client_no -- 客户编号
    ,client_type -- 客户类型
    ,doc_type -- 凭证类型
    ,int_type -- 利率类型
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,profit_center -- 利润中心
    ,reference -- 交易参考号
    ,user_id -- 交易柜员编号
    ,voucher_no -- 凭证号码
    ,term -- 存期
    ,term_type -- 期限单位
    ,company -- 法人
    ,gl_posted_flag -- 过账标记
    ,int_cap_flag -- 资本化标志
    ,movt_status -- 转存类型
    ,narrative -- 摘要
    ,prefix -- 前缀
    ,print_cnt -- 打印次数
    ,seq_no -- 序号
    ,seq_renew_rollover_no -- 转存序号
    ,source_module -- 源模块
    ,tax_type -- 税种
    ,tran_status -- 冲补抹标志
    ,int_class -- 利息分类
    ,accounting_status -- 核算状态
    ,acct_open_date -- 账户开户日期
    ,last_cycle_date -- 上一结息日
    ,maturity_date -- 到期日期
    ,reversal_date -- 冲正日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,acct_ccy -- 账户币种
    ,acct_level_int_rate -- 账户基础利率
    ,actual_rate -- 行内利率
    ,calc_days -- 算息天数
    ,calc_int_amt -- 算息金额
    ,debt_int_rate -- 支取利率
    ,float_rate -- 浮动利率
    ,gross_interest_amt -- 总利息金额
    ,int_adj -- 利息调增金额
    ,int_adj_ctd -- 计提日利息调整
    ,net_interest_amt -- 净利息
    ,principal_amt -- 交易本金
    ,real_rate -- 执行利率
    ,spread_rate -- 浮动点数
    ,tax_amt -- 税金
    ,tax_rate -- 税率
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,reaccount_cd -- 对账代码
    ,bus_seq_no -- 业务流水号
    ,to_date('00010101','yyyymmdd') as calc_begin_date -- 利息计算起始日
    ,' ' as year_basis -- 年基准天数
    ,' ' as month_basis -- 月基准
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from ncbs_rb_acct_event_register_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;
end loop;
end;
/