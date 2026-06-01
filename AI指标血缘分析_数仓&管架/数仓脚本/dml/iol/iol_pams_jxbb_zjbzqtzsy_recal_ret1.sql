/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_zjbzqtzsy_recal
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
	            where table_name = upper('pams_jxbb_zjbzqtzsy_recal_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('pams_jxbb_zjbzqtzsy_recal')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table pams_jxbb_zjbzqtzsy_recal drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table pams_jxbb_zjbzqtzsy_recal add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';
end loop;
end;
/
insert /*+ append */ into ${iol_schema}.pams_jxbb_zjbzqtzsy_recal(
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
    ,recal_dt -- 重算日期
    ,khjlgh -- 客户经理工号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
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
    ,recal_dt -- 重算日期
    ,' ' as khjlgh -- 客户经理工号
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from pams_jxbb_zjbzqtzsy_recal_bak${batch_date}

commit;
