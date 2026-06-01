/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_mb_fee_type
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
                       FROM ncbs_mb_fee_type_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ncbs_mb_fee_type');
  
  if v_var <> 0 then 
    execute immediate 'alter table ncbs_mb_fee_type drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ncbs_mb_fee_type add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.ncbs_mb_fee_type(
            amortize_month -- 摊销月
            ,amortize_time_type -- 摊销时间类型
            ,bo_ind -- 日终/联机标志
            ,boundary_amt_id -- 缺口计算金额编码
            ,boundary_desc -- 缺口描述
            ,ccy_flag -- 收费币种标识
            ,company -- 法人
            ,convert_flag -- 折算标志
            ,disc_type -- 折扣类型
            ,fee_amt_id -- 费用计算金额编码
            ,fee_desc -- 费用类型描述
            ,fee_item -- 费用项目代码
            ,fee_mode -- 收费定价方式
            ,fee_type -- 费率类型
            ,prod_grp -- 产品组
            ,profit_allot_flag -- 是否需要分润
            ,profit_amortize_flag -- 是否需要摊销
            ,tax_type -- 税种
            ,tran_timestamp -- 交易时间戳
            ,amortize_day -- 摊销日
            ,amortize_period_type -- 摊销期限类型
            ,mb_ccy_type -- 目标收费币种
            ,open_branch_percent -- 账户行比例
            ,tran_branch_percent -- 交易行比例,记录百分数
            ,accr_flag -- 是否需要计提
            ,fee_price_standard -- 
            ,fee_standard_discount_remark -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            amortize_month -- 摊销月
            ,amortize_time_type -- 摊销时间类型
            ,bo_ind -- 日终/联机标志
            ,boundary_amt_id -- 缺口计算金额编码
            ,boundary_desc -- 缺口描述
            ,ccy_flag -- 收费币种标识
            ,company -- 法人
            ,convert_flag -- 折算标志
            ,disc_type -- 折扣类型
            ,fee_amt_id -- 费用计算金额编码
            ,fee_desc -- 费用类型描述
            ,fee_item -- 费用项目代码
            ,fee_mode -- 收费定价方式
            ,fee_type -- 费率类型
            ,prod_grp -- 产品组
            ,profit_allot_flag -- 是否需要分润
            ,profit_amortize_flag -- 是否需要摊销
            ,tax_type -- 税种
            ,tran_timestamp -- 交易时间戳
            ,amortize_day -- 摊销日
            ,amortize_period_type -- 摊销期限类型
            ,mb_ccy_type -- 目标收费币种
            ,open_branch_percent -- 账户行比例
            ,tran_branch_percent -- 交易行比例,记录百分数
            ,accr_flag -- 是否需要计提
            ,' ' as fee_price_standard -- 
            ,' ' as fee_standard_discount_remark -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_mb_fee_type_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
