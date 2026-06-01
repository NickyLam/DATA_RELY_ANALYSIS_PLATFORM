/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_tk_management_message_ret1
CreateDate: 20250723
*/

set timing on
-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;

declare
  v_flag   number(10) :=0;

begin
  for tb in (select partition_name,table_name,substr(partition_name,3) as etl_dt
               from user_tab_partitions
                   where table_name = upper('icms_tk_management_message_bak${batch_date}')
                       and partition_name <> 'P_19000101'
                       --and substr(partition_name,3) = '${batch_date}'
             ) loop

  select count(*) into v_flag
    from all_tab_partitions
   where table_owner = upper('iol')
     and table_name = upper('icms_tk_management_message')
     and partition_name = tb.partition_name;

  if v_flag <> 0 then
    execute immediate 'alter table icms_tk_management_message drop partition '|| tb.partition_name ;
  end if;

    execute immediate 'alter table icms_tk_management_message add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';


-- 回插所有数据

insert /*+ append */ into ${iol_schema}.icms_tk_management_message (
	serialno -- 流水号
	,objectno -- 对象流水
	,asstaskno -- 关联任务流水号
	,objecttype -- 消息大类(CRWAL：客户风险贷后预警;ALC：投贷后检查任务)
	,messagetype -- 消息小类
	,subject -- 消息主题
	,content -- 消息主体内容
	,inputdate -- 登记日期
	,datacount -- 明细数据行数(对应TK_MANAGEMENT_DATA_DETAIL关联行数)
	,etl_dt -- ETL处理日期
	,etl_timestamp -- ETL处理时间戳
)
select
	serialno as serialno -- 流水号
	,objectno as objectno -- 对象流水
	,asstaskno as asstaskno -- 关联任务流水号
	,objecttype as objecttype -- 消息大类(CRWAL：客户风险贷后预警;ALC：投贷后检查任务)
	,messagetype as messagetype -- 消息小类
	,subject as subject -- 消息主题
	,content as content -- 消息主体内容
	,inputdate as inputdate -- 登记日期
	,0 as datacount -- 明细数据行数(对应TK_MANAGEMENT_DATA_DETAIL关联行数)
	,etl_dt as etl_dt -- ETL处理日期
	,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_tk_management_message_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;

end loop;
end;
/

