/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_loan_rebuild_relative_ret1
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
                   where table_name = upper('icms_loan_rebuild_relative_bak${batch_date}')
                       and partition_name <> 'P_19000101'
                       --and substr(partition_name,3) = '${batch_date}'
             ) loop

  select count(*) into v_flag
    from all_tab_partitions
   where table_owner = upper('iol')
     and table_name = upper('icms_loan_rebuild_relative')
     and partition_name = tb.partition_name;

  if v_flag <> 0 then
    execute immediate 'alter table icms_loan_rebuild_relative drop partition '|| tb.partition_name ;
  end if;

    execute immediate 'alter table icms_loan_rebuild_relative add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';


-- 回插所有数据

insert /*+ append */ into ${iol_schema}.icms_loan_rebuild_relative (
	serialno -- 流水号
	,objecttype -- 对象类型
	,objectno -- 对象编号
	,balance -- 时点借据余额
	,businesssum -- 时点借据金额
	,classifyresult -- 时点五级分类
	,etl_dt -- ETL处理日期
	,etl_timestamp -- ETL处理时间戳
)
select
	serialno as serialno -- 流水号
	,objecttype as objecttype -- 对象类型
	,objectno as objectno -- 对象编号
	,0 as balance -- 时点借据余额
	,0 as businesssum -- 时点借据金额
	,' ' as classifyresult -- 时点五级分类
	,etl_dt as etl_dt -- ETL处理日期
	,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_loan_rebuild_relative_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;

end loop;
end;
/

