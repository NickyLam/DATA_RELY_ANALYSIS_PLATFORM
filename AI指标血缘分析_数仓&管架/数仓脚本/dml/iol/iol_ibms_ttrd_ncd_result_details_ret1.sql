/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_ncd_result_details_ret1
CreateDate: 20250208
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
                       FROM ibms_ttrd_ncd_result_details_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var
    from user_tab_partitions
   where substr(partition_name,3) = tb.end_dt
     and table_name = upper('ibms_ttrd_ncd_result_details');

  if v_var <> 0 then
    execute immediate 'alter table ibms_ttrd_ncd_result_details drop partition p_' || tb.end_dt;
  end if;

    v_sql :='alter table ibms_ttrd_ncd_result_details add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';

    execute immediate v_sql;

-- 回插所有数据

insert /*+ append */ into ${iol_schema}.ibms_ttrd_ncd_result_details (
    seq_id -- 序列号
    ,sysordid -- 交易单号
    ,ref_sysordid -- 子交易单号
    ,i_code -- 存单代码
    ,a_type -- 存单资产类型
    ,m_type -- 存单市场类型
    ,issue_type -- 发行方式(1-报价发行,2-招标发行,3-浮息发行)
    ,partyid -- 认购人id
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
    ,sales_org_name -- 销售机构(华兴)
    ,real_party_id -- 实际认购方编码
    ,real_partyname -- 实际认购方名称
    ,belonger -- 业绩归属人
    ,head_belonger -- 总行业绩归属人
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_timestamp -- ETL处理时间戳
)
select
    seq_id as seq_id -- 序列号
    ,sysordid as sysordid -- 交易单号
    ,ref_sysordid as ref_sysordid -- 子交易单号
    ,i_code as i_code -- 存单代码
    ,a_type as a_type -- 存单资产类型
    ,m_type as m_type -- 存单市场类型
    ,issue_type as issue_type -- 发行方式(1-报价发行,2-招标发行,3-浮息发行)
    ,partyid as partyid -- 认购人id
    ,partyname as partyname -- 认购人名称
    ,bid_price as bid_price -- 投标价位(元)
    ,bid_amount as bid_amount -- 投标量(亿元)
    ,bidding_price as bidding_price -- 中标价位(元)
    ,bidding_amount as bidding_amount -- 中标量(亿元)
    ,bid_time as bid_time -- 认购时间
    ,username as username -- 提交用户
    ,bidding_actual_amount as bidding_actual_amount -- 实际认购量
    ,memo as memo -- 备注
    ,sales_organization as sales_organization -- 销售机构
    ,cost_calculate_rule as cost_calculate_rule -- 费用计算规则
    ,0 as bidding_pay_amount -- 缴款金额(元)
    ,' ' as bank_code -- 开户行行号
    ,' ' as trdacccode -- 交易账号
    ,' ' as sales_name -- 销售机构名称
    ,' ' as sales_org_name -- 销售机构(华兴)
    ,0 as real_party_id -- 实际认购方编码
    ,' ' as real_partyname -- 实际认购方名称
    ,' ' as belonger -- 业绩归属人
    ,' ' as head_belonger -- 总行业绩归属人
    ,start_dt as start_dt -- 开始时间
    ,end_dt as end_dt -- 结束时间
    ,id_mark as id_mark -- 增删标志
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_ncd_result_details_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');

commit;

end loop;
end;
/

