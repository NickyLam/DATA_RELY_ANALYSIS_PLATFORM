/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_acct_odi_detail
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
                       FROM ncbs_cl_acct_odi_detail_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ncbs_cl_acct_odi_detail');
  
  if v_var <> 0 then 
    execute immediate 'alter table ncbs_cl_acct_odi_detail drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ncbs_cl_acct_odi_detail add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.ncbs_cl_acct_odi_detail(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,int_accrued_diff -- 计提金额差额
            ,narrative -- 摘要
            ,stage_no -- 期次
            ,tax_type -- 税种
            ,int_class -- 利息分类
            ,calc_begin_date -- 利息计算起始日
            ,calc_end_date -- 利息计算截止日
            ,last_accrual_date -- 上一利息计提日
            ,last_change_date -- 最后修改日期
            ,last_cycle_date -- 上一结息日
            ,next_cycle_date -- 下一结息日
            ,tran_timestamp -- 交易时间戳
            ,int_accrued -- 累计计提
            ,int_accrued_calc_ctd -- 计提日计提实际金额
            ,int_accrued_ctd -- 计提日计提利息
            ,int_adj -- 利息调增金额
            ,int_adj_ctd -- 计提日利息调整
            ,int_adj_prev -- 上日利息调整(累计)
            ,int_amt -- 利息金额
            ,int_posted -- 结息金额
            ,int_posted_ctd -- 结息日利息金额
            ,tax_posted -- 利息税累计金额
            ,tax_posted_ctd -- 结息日利息税
            ,tax_rate -- 税率
            ,wrn_amt -- 贷款核销本金
            ,int_accrued_prev -- 上日累计计提利息|上日累计计提利息
            ,last_bal_upd_date -- 上次动户日期
            ,last_int_accrued_prev -- 上上日累计计提利息
            ,last_int_adj_prev -- 上上日利息累计计提调整
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,int_accrued_diff -- 计提金额差额
            ,narrative -- 摘要
            ,stage_no -- 期次
            ,tax_type -- 税种
            ,int_class -- 利息分类
            ,calc_begin_date -- 利息计算起始日
            ,calc_end_date -- 利息计算截止日
            ,last_accrual_date -- 上一利息计提日
            ,last_change_date -- 最后修改日期
            ,last_cycle_date -- 上一结息日
            ,next_cycle_date -- 下一结息日
            ,tran_timestamp -- 交易时间戳
            ,int_accrued -- 累计计提
            ,int_accrued_calc_ctd -- 计提日计提实际金额
            ,int_accrued_ctd -- 计提日计提利息
            ,int_adj -- 利息调增金额
            ,int_adj_ctd -- 计提日利息调整
            ,int_adj_prev -- 上日利息调整(累计)
            ,int_amt -- 利息金额
            ,int_posted -- 结息金额
            ,int_posted_ctd -- 结息日利息金额
            ,tax_posted -- 利息税累计金额
            ,tax_posted_ctd -- 结息日利息税
            ,tax_rate -- 税率
            ,wrn_amt -- 贷款核销本金
            ,int_accrued_prev -- 上日累计计提利息|上日累计计提利息
            ,to_date('00010101','yyyymmdd') as last_bal_upd_date -- 上次动户日期
            ,0 as last_int_accrued_prev -- 上上日累计计提利息
            ,0 as last_int_adj_prev -- 上上日利息累计计提调整
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_acct_odi_detail_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
