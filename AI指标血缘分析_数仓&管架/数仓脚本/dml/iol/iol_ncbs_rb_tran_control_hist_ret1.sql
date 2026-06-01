/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_tran_control_hist
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
	            where table_name = upper('ncbs_rb_tran_control_hist_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('ncbs_rb_tran_control_hist')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table ncbs_rb_tran_control_hist drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table ncbs_rb_tran_control_hist add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';

insert /*+ append */ into ${iol_schema}.ncbs_rb_tran_control_hist(
    client_no -- 客户编号
    ,reference -- 交易参考号
    ,busi_sub_class -- 业务子细类
    ,channel_seq_no -- 全局流水号
    ,company -- 法人
    ,message_code -- 接口服务代码
    ,message_type -- 接口服务类型
    ,online_tran_status -- 联机业务处理状态
    ,service_code -- 服务代码
    ,source_module -- 源模块
    ,source_type -- 渠道编号
    ,sub_seq_no -- 系统流水号
    ,tran_desc -- 交易描述
    ,tran_event_type -- 交易时间类型
    ,channel_date -- 渠道日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,tran_branch -- 核心交易机构编号
    ,customer_seq_no -- 系统流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    client_no -- 客户编号
    ,reference -- 交易参考号
    ,busi_sub_class -- 业务子细类
    ,channel_seq_no -- 全局流水号
    ,company -- 法人
    ,message_code -- 接口服务代码
    ,message_type -- 接口服务类型
    ,online_tran_status -- 联机业务处理状态
    ,service_code -- 服务代码
    ,source_module -- 源模块
    ,source_type -- 渠道编号
    ,sub_seq_no -- 系统流水号
    ,tran_desc -- 交易描述
    ,tran_event_type -- 交易时间类型
    ,channel_date -- 渠道日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,tran_branch -- 核心交易机构编号
    ,' ' as customer_seq_no -- 系统流水号
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from ncbs_rb_tran_control_hist_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;
end loop;
end;
/