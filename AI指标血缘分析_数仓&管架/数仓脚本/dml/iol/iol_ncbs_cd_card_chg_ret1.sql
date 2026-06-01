/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cd_card_chg
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
	            where table_name = upper('ncbs_cd_card_chg_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('ncbs_cd_card_chg')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table ncbs_cd_card_chg drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table ncbs_cd_card_chg add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';

insert /*+ append */ into ${iol_schema}.ncbs_cd_card_chg(
    address -- 地址
    ,base_acct_no -- 交易账号/卡号
    ,client_no -- 客户编号
    ,prod_type -- 产品编号
    ,remark -- 备注
    ,user_id -- 交易柜员编号
    ,card_change_reason -- 卡片更换原因
    ,change_status -- 变更类型状态
    ,company -- 法人
    ,contact_tel -- 客户联系电话
    ,gain_type -- 卡片领取方式
    ,lost_no -- 挂失编号
    ,postal_code -- 邮政编码
    ,same_no_flag -- 同号换卡标识
    ,urgent_flag -- 加急标识
    ,apply_date -- 申请日期
    ,promissory_date -- 约定的领卡日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,apply_user_id -- 申请柜员
    ,new_card_no -- 新卡号
    ,old_card_no -- 原卡号
    ,tran_branch -- 核心交易机构编号
    ,deal_status -- 处理状态
    ,msg_notice_type -- 通知类型
    ,fee_reference -- 
    ,package_no -- 
    ,apply_no -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    address -- 地址
    ,base_acct_no -- 交易账号/卡号
    ,client_no -- 客户编号
    ,prod_type -- 产品编号
    ,remark -- 备注
    ,user_id -- 交易柜员编号
    ,card_change_reason -- 卡片更换原因
    ,change_status -- 变更类型状态
    ,company -- 法人
    ,contact_tel -- 客户联系电话
    ,gain_type -- 卡片领取方式
    ,lost_no -- 挂失编号
    ,postal_code -- 邮政编码
    ,same_no_flag -- 同号换卡标识
    ,urgent_flag -- 加急标识
    ,apply_date -- 申请日期
    ,promissory_date -- 约定的领卡日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,apply_user_id -- 申请柜员
    ,new_card_no -- 新卡号
    ,old_card_no -- 原卡号
    ,tran_branch -- 核心交易机构编号
    ,deal_status -- 处理状态
    ,msg_notice_type -- 通知类型
    ,' ' as fee_reference -- 
    ,' ' as package_no -- 
    ,' ' as apply_no -- 
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from ncbs_cd_card_chg_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;
end loop;
end;
/