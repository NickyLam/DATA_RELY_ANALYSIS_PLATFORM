/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cd_pos_auth_reg
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
	            where table_name = upper('ncbs_cd_pos_auth_reg_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('ncbs_cd_pos_auth_reg')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table ncbs_cd_pos_auth_reg drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table ncbs_cd_pos_auth_reg add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';

insert /*+ append */ into ${iol_schema}.ncbs_cd_pos_auth_reg(
    card_no -- 卡号
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,remark -- 备注
    ,auth_id -- 预授权码
    ,auth_seq_no -- 预授权登记簿流水号
    ,channel_tran_status -- 渠道业务处理状态
    ,company -- 法人
    ,cup_send_code -- 发送机构标识码
    ,merchant_code -- 商行编号
    ,res_seq_no -- 限制编号
    ,source_type -- 渠道编号
    ,terminal_id -- 交易终端编号
    ,auth_from_date -- 预授权有效起始日期
    ,auth_thru_date -- 预授权有效截止日期
    ,cup_date -- 银联日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,cup_area_code -- 受理方标识码
    ,full_amt -- 预授权完成金额
    ,tran_amt -- 交易金额
    ,sub_seq_no -- 系统子流水号
    ,channel_seq_no -- 全局流水号
    ,reference -- 交易参考号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    card_no -- 卡号
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,remark -- 备注
    ,auth_id -- 预授权码
    ,auth_seq_no -- 预授权登记簿流水号
    ,channel_tran_status -- 渠道业务处理状态
    ,company -- 法人
    ,cup_send_code -- 发送机构标识码
    ,merchant_code -- 商行编号
    ,res_seq_no -- 限制编号
    ,source_type -- 渠道编号
    ,terminal_id -- 交易终端编号
    ,auth_from_date -- 预授权有效起始日期
    ,auth_thru_date -- 预授权有效截止日期
    ,cup_date -- 银联日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,cup_area_code -- 受理方标识码
    ,full_amt -- 预授权完成金额
    ,tran_amt -- 交易金额
    ,sub_seq_no -- 系统子流水号
    ,' ' as channel_seq_no -- 全局流水号
    ,' ' as reference -- 交易参考号
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from ncbs_cd_pos_auth_reg_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;
end loop;
end;
/