/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_nbzz_lcmx
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
	            where table_name = upper('pams_nbzz_lcmx_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('pams_nbzz_lcmx')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table pams_nbzz_lcmx drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table pams_nbzz_lcmx add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';

insert /*+ append */ into ${iol_schema}.pams_nbzz_lcmx(
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,khdxdh -- 考核对象代号
    ,jgkhdxdh -- 机构考核对象代号
    ,kmh -- 科目号
    ,bz -- 币种
    ,fpjs -- 分配角色
    ,zhye -- 账户余额_0A
    ,zlbl -- 增量比例
    ,hyye -- 行员余额_0A
    ,hyylj -- 行员月累计_0A
    ,hyjlj -- 行员季累计_0A
    ,hybnlj -- 行员半年累计_0A
    ,hynlj -- 行员年累计_0A
    ,hyymlj -- 行员月末累计_0A
    ,zlblylj -- 增量比例月累计
    ,zlbljlj -- 增量比例季累计
    ,zlblnlj -- 增量比例年累计
    ,zlblymlj -- 增量比例月末累计
    ,gxsj -- 更新时间
    ,zhnrjye -- 账户年日均余额
    ,zhjrjye -- 账户季日均余额
    ,zhyrjye -- 账户月日均余额
    ,kzhlcbz -- 跨支行理财标志
    ,ztbz -- 在途标志：0-否，1-是
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,khdxdh -- 考核对象代号
    ,jgkhdxdh -- 机构考核对象代号
    ,kmh -- 科目号
    ,bz -- 币种
    ,fpjs -- 分配角色
    ,zhye -- 账户余额_0A
    ,zlbl -- 增量比例
    ,hyye -- 行员余额_0A
    ,hyylj -- 行员月累计_0A
    ,hyjlj -- 行员季累计_0A
    ,hybnlj -- 行员半年累计_0A
    ,hynlj -- 行员年累计_0A
    ,hyymlj -- 行员月末累计_0A
    ,zlblylj -- 增量比例月累计
    ,zlbljlj -- 增量比例季累计
    ,zlblnlj -- 增量比例年累计
    ,zlblymlj -- 增量比例月末累计
    ,gxsj -- 更新时间
    ,zhnrjye -- 账户年日均余额
    ,zhjrjye -- 账户季日均余额
    ,zhyrjye -- 账户月日均余额
    ,kzhlcbz -- 跨支行理财标志
    ,' ' as ztbz -- 在途标志：0-否，1-是
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from pams_nbzz_lcmx_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;
end loop;
end;
/