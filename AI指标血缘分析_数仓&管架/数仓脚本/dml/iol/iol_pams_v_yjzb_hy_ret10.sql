/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_v_yjzb_hy_ret1
CreateDate: 20250617
*/

set timing on
-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;

--create partition 
--whenever sqlerror continue none ;
set serveroutput on
declare
  v_flag   number(10) :=0;

begin
  for tb in (select table_name,partition_name,substr(partition_name,3) as etl_dt
               from user_tab_partitions
                   where table_name = upper('pams_v_yjzb_hy_bak${batch_date}')
                and substr(partition_name, 3) <> '19000101'
                and substr(partition_name, 3) >= '20250215'
		and substr(partition_name, 3) < '20250311'
             ) loop

	  select count(1)
	    into v_flag
    from all_tab_partitions
   where table_owner = upper('iol')
     and table_name = upper('pams_v_yjzb_hy')
     and partition_name = tb.partition_name;

  if v_flag <> 0 then
    execute immediate 'alter table pams_v_yjzb_hy drop partition '|| tb.partition_name ;
  end if;

    execute immediate 'alter table pams_v_yjzb_hy add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';

  end loop;
  
   dbms_output.put_line('pams_v_yjzb_hy');
end;

/

insert /*+ append */ into ${iol_schema}.pams_v_yjzb_hy (
tjrq -- 统计日期
,zbdh -- 指标代号
,sdbs -- 时段标识
,bz -- 币种
,khdxdh -- 考核对象代号
,zbz -- 指标值
,zblxbz -- 指标类型标志(0-原指标；1-比去年末基数；2-同比基数；3-比去年末净增；4-同比净增)
,yszbdh -- 映射指标代号
,etl_dt -- ETL处理日期
,etl_timestamp -- ETL处理时间戳
)
select
/*+ parallel(a,8) */
tjrq as tjrq -- 统计日期
,zbdh as zbdh -- 指标代号
,sdbs as sdbs -- 时段标识
,bz as bz -- 币种
,khdxdh as khdxdh -- 考核对象代号
,zbz as zbz -- 指标值
,' ' as zblxbz -- 指标类型标志(0-原指标；1-比去年末基数；2-同比基数；3-比去年末净增；4-同比净增)
,0 as yszbdh -- 映射指标代号
,etl_dt as etl_dt -- ETL处理日期
,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.pams_v_yjzb_hy_bak${batch_date} t1
 where t1.etl_dt >= to_date('20250215', 'yyyymmdd')
 and t1.etl_dt < to_date('20250311', 'yyyymmdd');

commit;


