/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_vtrd_ncd_result_details
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
                       FROM ibms_vtrd_ncd_result_details_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ibms_vtrd_ncd_result_details');
  
  if v_var <> 0 then 
    execute immediate 'alter table ibms_vtrd_ncd_result_details drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ibms_vtrd_ncd_result_details add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
 
insert /*+ append */ into ${iol_schema}.ibms_vtrd_ncd_result_details(
            seq_id -- 序列号
            ,sysordid -- 交易单号
            ,ref_sysordid -- 子交易单号
            ,i_code -- 存单代码
            ,a_type -- 存单资产类型
            ,m_type -- 存单市场类型
            ,issue_type -- 发行方式(1-报价发行,2-招标发行,3-浮息发行)
            ,partyid -- 认购人ID
            ,partyname -- 认购人名称
            ,bid_price -- 投标价位(元)
            ,bid_amount -- 投标量(亿元)
            ,bidding_price -- 中标价位(元)
            ,bidding_amount -- 中标量(亿元)
            ,bid_time -- 认购时间
            ,username -- 提交用户
            ,bidding_actual_amount -- 实际认购量
            ,memo -- 备注
            ,sales_organization -- 销售机构
            ,cost_calculate_rule -- 费用计算规则
            ,bidding_pay_amount -- 缴款金额(元)
            ,bank_code -- 开户行行号
            ,trdacccode -- 交易账号
            ,sales_name -- 销售机构名称
            ,sales_org_name -- 
            ,sales_ratio -- 
            ,sales_org_ratio -- 
            ,sales_name_rate -- 
            ,sales_org_name_rate -- 
            ,belonger -- 业绩归属人
            ,head_belonger -- 总行业绩归属人
            ,real_partyname -- 实际认购方名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            seq_id -- 序列号
            ,sysordid -- 交易单号
            ,ref_sysordid -- 子交易单号
            ,i_code -- 存单代码
            ,a_type -- 存单资产类型
            ,m_type -- 存单市场类型
            ,issue_type -- 发行方式(1-报价发行,2-招标发行,3-浮息发行)
            ,partyid -- 认购人ID
            ,partyname -- 认购人名称
            ,bid_price -- 投标价位(元)
            ,bid_amount -- 投标量(亿元)
            ,bidding_price -- 中标价位(元)
            ,bidding_amount -- 中标量(亿元)
            ,bid_time -- 认购时间
            ,username -- 提交用户
            ,bidding_actual_amount -- 实际认购量
            ,memo -- 备注
            ,sales_organization -- 销售机构
            ,cost_calculate_rule -- 费用计算规则
            ,bidding_pay_amount -- 缴款金额(元)
            ,bank_code -- 开户行行号
            ,trdacccode -- 交易账号
            ,sales_name -- 销售机构名称
            ,sales_org_name -- 
            ,sales_ratio -- 
            ,sales_org_ratio -- 
            ,sales_name_rate -- 
            ,sales_org_name_rate -- 
            ,' ' as belonger -- 业绩归属人
            ,' ' as head_belonger -- 总行业绩归属人
            ,' ' as real_partyname -- 实际认购方名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_vtrd_ncd_result_details_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
