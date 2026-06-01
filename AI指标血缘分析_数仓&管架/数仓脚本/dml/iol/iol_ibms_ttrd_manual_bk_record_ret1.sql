/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_manual_bk_record
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
	            where table_name = upper('ibms_ttrd_manual_bk_record_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('ibms_ttrd_manual_bk_record')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table ibms_ttrd_manual_bk_record drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table ibms_ttrd_manual_bk_record add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';


insert /*+ append */ into ${iol_schema}.ibms_ttrd_manual_bk_record(
    record_id -- 记录id
    ,account_date -- 记账日期
    ,bkkpg_org_id -- 记账机构号
    ,flow_id -- 分录流水号
    ,hostflow_no -- 核心流水号
    ,create_user -- 录入柜员id
    ,create_user_name -- 录入柜员名称
    ,acct_user -- 记账柜员id
    ,acct_user_name -- 记账柜员名称
    ,erase_user -- 抹账授权柜员id
    ,erase_user_name -- 抹账授权柜员名称
    ,create_time -- 录入时间
    ,account_time -- 记账时间
    ,erase_time -- 抹账时间
    ,state -- 状态:0,新建 1,未记账 2,已记账
    ,remark -- 备注
    ,inst_id -- 券/资金指令号
    ,acct_review_user -- 记账复核人
    ,acct_review_user_name -- 记账复核人名称
    ,eraseuser -- 抹账人
    ,eraseuser_name -- 抹账人名称
    ,acct_type -- 状态:0,仅核心记账  1,核心、资金系统记账
    ,trade_id -- 
    ,bk_flag -- 记账标识，0：内部户，1：科目
    ,obj_id -- 核算余额id
    ,party_id -- 当事人编号
    ,party_name -- 当事人编号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    record_id -- 记录id
    ,account_date -- 记账日期
    ,bkkpg_org_id -- 记账机构号
    ,flow_id -- 分录流水号
    ,hostflow_no -- 核心流水号
    ,create_user -- 录入柜员id
    ,create_user_name -- 录入柜员名称
    ,acct_user -- 记账柜员id
    ,acct_user_name -- 记账柜员名称
    ,erase_user -- 抹账授权柜员id
    ,erase_user_name -- 抹账授权柜员名称
    ,create_time -- 录入时间
    ,account_time -- 记账时间
    ,erase_time -- 抹账时间
    ,state -- 状态:0,新建 1,未记账 2,已记账
    ,remark -- 备注
    ,inst_id -- 券/资金指令号
    ,acct_review_user -- 记账复核人
    ,acct_review_user_name -- 记账复核人名称
    ,eraseuser -- 抹账人
    ,eraseuser_name -- 抹账人名称
    ,acct_type -- 状态:0,仅核心记账  1,核心、资金系统记账
    ,trade_id -- 
    ,bk_flag -- 记账标识，0：内部户，1：科目
    ,obj_id -- 核算余额id
    ,' ' as party_id -- 当事人编号
    ,' ' as party_name -- 当事人编号
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from ibms_ttrd_manual_bk_record_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;
end loop;
end;
/