/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_acct_protocol_master
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
                       FROM ibms_ttrd_acct_protocol_master_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ibms_ttrd_acct_protocol_master');
  
  if v_var <> 0 then 
    execute immediate 'alter table ibms_ttrd_acct_protocol_master drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ibms_ttrd_acct_protocol_master add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.ibms_ttrd_acct_protocol_master(
            id -- 主键
            ,accid -- 同业赢活期账户id
            ,settle_period -- 结息周期
            ,start_date -- 开始日期
            ,expire_date -- 到期日期
            ,early_end_date -- 提前结束日期
            ,amount -- 约期金额
            ,amount_rate -- 约期金额利率
            ,break_rate -- 约期违约利率
            ,current_rate -- 约期活期利率
            ,contract_no -- 合约号
            ,usable_flag -- 是否已生效：1： 正常 0： 新增
            ,operate -- 操作状态 add 新增  edit 修改
            ,ctrct_id -- 确认单编号
            ,first_payment_date -- 首次付息日
            ,is_monthly_mode -- 是否月均模式
            ,is_near_rate_mode -- 是否支持靠档模式
            ,stride_month_rate -- 跨月利率
            ,not_stride_month_rate -- 不跨月利率
            ,stride_month_remark -- 跨月说明
            ,not_stride_month_remark -- 不跨月说明
            ,fix_settle_period -- 约期结息频率
            ,end_date -- 协议结束日
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            id -- 主键
            ,accid -- 同业赢活期账户id
            ,settle_period -- 结息周期
            ,start_date -- 开始日期
            ,expire_date -- 到期日期
            ,early_end_date -- 提前结束日期
            ,amount -- 约期金额
            ,amount_rate -- 约期金额利率
            ,break_rate -- 约期违约利率
            ,current_rate -- 约期活期利率
            ,contract_no -- 合约号
            ,usable_flag -- 是否已生效：1： 正常 0： 新增
            ,operate -- 操作状态 add 新增  edit 修改
            ,' ' as ctrct_id -- 确认单编号
            ,' ' as first_payment_date -- 首次付息日
            ,' ' as is_monthly_mode -- 是否月均模式
            ,' ' as is_near_rate_mode -- 是否支持靠档模式
            ,0 as stride_month_rate -- 跨月利率
            ,0 as not_stride_month_rate -- 不跨月利率
            ,' ' as stride_month_remark -- 跨月说明
            ,' ' as not_stride_month_remark -- 不跨月说明
            ,' ' as fix_settle_period -- 约期结息频率
            ,' ' as end_date -- 协议结束日
            ,' ' as remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_acct_protocol_master_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
