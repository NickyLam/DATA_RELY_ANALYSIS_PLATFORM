/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_dldxzsmx_ret1
CreateDate: 20241209
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
                   where table_name = upper('pams_jxbb_dldxzsmx_bak${batch_date}')
                       and partition_name <> 'P_19000101'
             ) loop

  select count(*) into v_flag
    from all_tab_partitions
   where table_owner = upper('iol')
     and table_name = upper('pams_jxbb_dldxzsmx')
     and partition_name = tb.partition_name;

  if v_flag <> 0 then
    execute immediate 'alter table pams_jxbb_dldxzsmx drop partition '|| tb.partition_name ;
  end if;

    execute immediate 'alter table pams_jxbb_dldxzsmx add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';


-- 回插所有数据
insert /*+ append */ into ${iol_schema}.pams_jxbb_dldxzsmx (
tjrq -- 统计日期
,sjly -- 数据来源
,cph -- 产品号
,khh -- 客户号
,khdxdh -- 考核对象代号
,jgkhdxdh -- 机构考核对象代号
,jgdh -- 机构代号
,fpjs -- 分配角色
,zhdh -- 账号代号
,tadm -- TA代码
,zlbl -- 增量比例
,zs -- 中收
,cpmc -- 产品名称
,ssjgdh -- 所属机构代号
,sshydh -- 所属员工工号
,etl_dt -- ETL处理日期
,etl_timestamp -- ETL处理时间戳
)
select
tjrq as tjrq -- 统计日期
,sjly as sjly -- 数据来源
,cph as cph -- 产品号
,khh as khh -- 客户号
,khdxdh as khdxdh -- 考核对象代号
,jgkhdxdh as jgkhdxdh -- 机构考核对象代号
,jgdh as jgdh -- 机构代号
,fpjs as fpjs -- 分配角色
,zhdh as zhdh -- 账号代号
,tadm as tadm -- TA代码
,zlbl as zlbl -- 增量比例
,zs as zs -- 中收
,cpmc as cpmc -- 产品名称
,' ' as ssjgdh -- 所属机构代号
,' ' as sshydh -- 所属员工工号
,etl_dt as etl_dt -- ETL处理日期
,etl_timestamp as etl_timestamp -- ETL处理时间戳
from pams_jxbb_dldxzsmx_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;

end loop;
end;
/

