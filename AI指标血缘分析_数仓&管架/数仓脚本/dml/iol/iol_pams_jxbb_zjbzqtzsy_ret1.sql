/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_zjbzqtzsy_ret1
CreateDate: 20250527
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
                   where table_name = upper('pams_jxbb_zjbzqtzsy_bak${batch_date}')
                       and partition_name <> 'P_19000101'
                       --and substr(partition_name,3) = '${batch_date}'
             ) loop

  select count(*) into v_flag
    from all_tab_partitions
   where table_owner = upper('iol')
     and table_name = upper('pams_jxbb_zjbzqtzsy')
     and partition_name = tb.partition_name;

  if v_flag <> 0 then
    execute immediate 'alter table pams_jxbb_zjbzqtzsy drop partition '|| tb.partition_name ;
  end if;

    execute immediate 'alter table pams_jxbb_zjbzqtzsy add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';


-- 回插所有数据

insert /*+ append */ into ${iol_schema}.pams_jxbb_zjbzqtzsy (
    tjrq -- 统计日期
    ,zqdm -- 债券代码
    ,jxdxdh -- 绩效对象代号
    ,jgdh -- 机构代号
    ,jgmc -- 机构名称
    ,ldpz -- 联动品种
    ,khh -- 客户号
    ,khmc -- 客户名称
    ,tzsy -- 调整收益
    ,tzsyylj -- 调整收益月累计
    ,tzsyjlj -- 调整收益季累计
    ,tzsynlj -- 调整收益年累计
    ,khjlgh -- 客户经理工号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq as tjrq -- 统计日期
    ,zqdm as zqdm -- 债券代码
    ,jxdxdh as jxdxdh -- 绩效对象代号
    ,jgdh as jgdh -- 机构代号
    ,jgmc as jgmc -- 机构名称
    ,ldpz as ldpz -- 联动品种
    ,khh as khh -- 客户号
    ,khmc as khmc -- 客户名称
    ,tzsy as tzsy -- 调整收益
    ,tzsyylj as tzsyylj -- 调整收益月累计
    ,tzsyjlj as tzsyjlj -- 调整收益季累计
    ,tzsynlj as tzsynlj -- 调整收益年累计
    ,' ' as khjlgh -- 客户经理工号
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.pams_jxbb_zjbzqtzsy_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;

end loop;
end;
/

