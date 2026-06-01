/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_ptl_raised_amt
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
	            where table_name = upper('fams_ptl_raised_amt_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('fams_ptl_raised_amt')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table fams_ptl_raised_amt drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table fams_ptl_raised_amt add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';

insert /*+ append */ into ${iol_schema}.fams_ptl_raised_amt(
    portfolio_id -- 产品ID
    ,cdate -- 计算日
    ,raise_amt -- 募集金额
    ,tdy_raise_amt -- 当日募集金额
    ,vdate -- 起始日
    ,create_user -- 创建人
    ,create_dept -- 创建部门
    ,create_time -- 创建时间
    ,update_user -- 更新人
    ,update_time -- 更新时间
    ,profit_type -- 收益类型
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    portfolio_id -- 产品ID
    ,cdate -- 计算日
    ,raise_amt -- 募集金额
    ,tdy_raise_amt -- 当日募集金额
    ,vdate -- 起始日
    ,create_user -- 创建人
    ,create_dept -- 创建部门
    ,create_time -- 创建时间
    ,update_user -- 更新人
    ,update_time -- 更新时间
    ,' ' as profit_type -- 收益类型
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from fams_ptl_raised_amt_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;
end loop;
end;
/