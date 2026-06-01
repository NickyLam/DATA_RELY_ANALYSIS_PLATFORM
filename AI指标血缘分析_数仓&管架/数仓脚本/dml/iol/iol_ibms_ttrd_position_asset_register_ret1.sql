/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_position_asset_register
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
	            where table_name = upper('ibms_ttrd_position_asset_register_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('ibms_ttrd_position_asset_register')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table ibms_ttrd_position_asset_register drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table ibms_ttrd_position_asset_register add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';

insert /*+ append */ into ${iol_schema}.ibms_ttrd_position_asset_register(
    id -- 主键
    ,p_type -- 产品类型
    ,i_code -- 产品代码
    ,i_name -- 产品名称
    ,effective_date -- 生效日
    ,ftp_rate -- ftp利率
    ,remark -- 备注
    ,start_date -- 起息日
    ,mtr_date -- 到期日
    ,register_type -- 登记类型 0:ftp 1:风险资产 2:营销机构
    ,project -- 项目
    ,risk_weight -- 风险权重
    ,risk_assets_amount -- 风险资产总额
    ,register_date -- 登记日期
    ,market_inst -- 
    ,customer_manager -- 
    ,a_type -- 资产类型
    ,m_type -- 市场类型
    ,obj_id -- 券核算对象id
    ,amount -- 金额
    ,field1 -- 扩展字段1
    ,field2 -- 扩展字段2
    ,check_user -- 复核人
    ,usable_flag -- 
    ,update_user -- 
    ,secu_acct_id -- 内部证券账户ID
    ,provision_accrual_prop -- 拨备计提比例
    ,ensure_amt -- 保证金金额(元)
    ,deposit_receipt_amt -- 一般存单金额(元)
    ,wealth_treasure_amt -- 财富盈、财富宝(元)
    ,government_bond_amt -- 国债金额(元)
    ,policy_bank_amt -- 我国政策性银行(元)
    ,common_department_amt -- 我国公共部门实体(元)
    ,other_amt -- 其他(元)
    ,belonger -- 业绩归属人
    ,head_belonger -- 总行业绩归属人
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 主键
    ,p_type -- 产品类型
    ,i_code -- 产品代码
    ,i_name -- 产品名称
    ,effective_date -- 生效日
    ,ftp_rate -- ftp利率
    ,remark -- 备注
    ,start_date -- 起息日
    ,mtr_date -- 到期日
    ,register_type -- 登记类型 0:ftp 1:风险资产 2:营销机构
    ,project -- 项目
    ,risk_weight -- 风险权重
    ,risk_assets_amount -- 风险资产总额
    ,register_date -- 登记日期
    ,market_inst -- 
    ,customer_manager -- 
    ,a_type -- 资产类型
    ,m_type -- 市场类型
    ,obj_id -- 券核算对象id
    ,amount -- 金额
    ,field1 -- 扩展字段1
    ,field2 -- 扩展字段2
    ,check_user -- 复核人
    ,usable_flag -- 
    ,update_user -- 
    ,secu_acct_id -- 内部证券账户ID
    ,provision_accrual_prop -- 拨备计提比例
    ,ensure_amt -- 保证金金额(元)
    ,deposit_receipt_amt -- 一般存单金额(元)
    ,wealth_treasure_amt -- 财富盈、财富宝(元)
    ,government_bond_amt -- 国债金额(元)
    ,policy_bank_amt -- 我国政策性银行(元)
    ,common_department_amt -- 我国公共部门实体(元)
    ,other_amt -- 其他(元)
    ,' ' as belonger -- 业绩归属人
    ,' ' as head_belonger -- 总行业绩归属人
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from ibms_ttrd_position_asset_register_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;
end loop;
end;
/