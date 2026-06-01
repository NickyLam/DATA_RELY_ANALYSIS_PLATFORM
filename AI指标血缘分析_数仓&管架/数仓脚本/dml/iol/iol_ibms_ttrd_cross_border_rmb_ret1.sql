/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_cross_border_rmb
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
                       FROM ibms_ttrd_cross_border_rmb_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ibms_ttrd_cross_border_rmb');
  
  if v_var <> 0 then 
    execute immediate 'alter table ibms_ttrd_cross_border_rmb drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ibms_ttrd_cross_border_rmb add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.ibms_ttrd_cross_border_rmb(
            accid -- 账户代码
            ,accname -- 账户名称
            ,exhacc -- 交易所账户（账号）
            ,customer_id -- 客户（交易对手）编码
            ,customer_name -- 客户（交易对手）名称
            ,start_date -- 开始日
            ,mtr_date -- 到期日
            ,interest_acc_mode -- 结息周期
            ,early_end_date -- 提前结束日
            ,is_agree_amount_fixed -- 约定金额是否固定，0：是，1：否
            ,agree_amount -- 约定金额
            ,agree_amount_rate -- 约定金额利率
            ,agree_current_rate -- 约定活期利率
            ,agree_break_contract_rate -- 约定违约利率
            ,contract_no -- 合约号
            ,id -- 唯一标识
            ,is_delete -- 是否删除
            ,first_payment_date -- 首次付息日
            ,break_info_flag -- 是否有违约条款
            ,gear_prod_flag -- 是否支持靠档模式
            ,agree_freq -- 约期结息频率
            ,end_date -- 协议结束日
            ,remark -- 备注
            ,is_monthly_mode -- 是否月均模式
            ,stride_month_rate -- 跨月利率
            ,not_stride_month_rate -- 不跨月利率
            ,stride_month_remark -- 跨月说明
            ,not_stride_month_remark -- 不跨月说明
            ,near_rate_json -- 靠档利率JSON(按余额)
            ,multy_mode -- 多档模式
            ,core_status -- 核心状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            accid -- 账户代码
            ,accname -- 账户名称
            ,exhacc -- 交易所账户（账号）
            ,customer_id -- 客户（交易对手）编码
            ,customer_name -- 客户（交易对手）名称
            ,start_date -- 开始日
            ,mtr_date -- 到期日
            ,interest_acc_mode -- 结息周期
            ,early_end_date -- 提前结束日
            ,is_agree_amount_fixed -- 约定金额是否固定，0：是，1：否
            ,agree_amount -- 约定金额
            ,agree_amount_rate -- 约定金额利率
            ,agree_current_rate -- 约定活期利率
            ,agree_break_contract_rate -- 约定违约利率
            ,contract_no -- 合约号
            ,id -- 唯一标识
            ,' ' as is_delete -- 是否删除
            ,' ' as first_payment_date -- 首次付息日
            ,' ' as break_info_flag -- 是否有违约条款
            ,' ' as gear_prod_flag -- 是否支持靠档模式
            ,' ' as agree_freq -- 约期结息频率
            ,' ' as end_date -- 协议结束日
            ,' ' as remark -- 备注
            ,' ' as is_monthly_mode -- 是否月均模式
            ,0 as stride_month_rate -- 跨月利率
            ,0 as not_stride_month_rate -- 不跨月利率
            ,' ' as stride_month_remark -- 跨月说明
            ,' ' as not_stride_month_remark -- 不跨月说明
            ,' ' as near_rate_json -- 靠档利率JSON(按余额)
            ,' ' as multy_mode -- 多档模式
            ,' ' as core_status -- 核心状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ibms_ttrd_cross_border_rmb_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
