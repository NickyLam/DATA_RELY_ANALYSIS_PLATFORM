/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_nbzz_dfgzkhmx_ret1
CreateDate: 20250613
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
                   where table_name = upper('pams_nbzz_dfgzkhmx_bak${batch_date}')
                       and partition_name <> 'P_19000101'
                       --and substr(partition_name,3) = '${batch_date}'
             ) loop

  select count(*) into v_flag
    from all_tab_partitions
   where table_owner = upper('iol')
     and table_name = upper('pams_nbzz_dfgzkhmx')
     and partition_name = tb.partition_name;

  if v_flag <> 0 then
    execute immediate 'alter table pams_nbzz_dfgzkhmx drop partition '|| tb.partition_name ;
  end if;

    execute immediate 'alter table pams_nbzz_dfgzkhmx add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';


-- 回插所有数据

insert /*+ append */ into ${iol_schema}.pams_nbzz_dfgzkhmx (
    tjrq -- 统计日期
    ,sjbh -- 事件编号
    ,zckhh -- 转出客户号
    ,khdbbz -- 考核达标标志：0-达标；1-未达标
    ,zczhdh -- 转出账户代号
    ,zczhmc -- 转出账户名称
    ,dfly -- 代发来源：01-柜面；02-企业网银；03-小额交易
    ,zrkhh -- 转入客户号
    ,zrjyje -- 转入交易金额
    ,fpje -- 分配金额
    ,jyrq -- 交易日期
    ,fpjs -- 分配角色
    ,zlbl -- 增量比例
    ,khdxdh -- 行员考核对象代号
    ,jgkhdxdh -- 机构考核对象代号
    ,jddbbz -- 进度达标标志(0-达标 1-未达标)
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq as tjrq -- 统计日期
    ,sjbh as sjbh -- 事件编号
    ,zckhh as zckhh -- 转出客户号
    ,khdbbz as khdbbz -- 考核达标标志：0-达标；1-未达标
    ,zczhdh as zczhdh -- 转出账户代号
    ,zczhmc as zczhmc -- 转出账户名称
    ,dfly as dfly -- 代发来源：01-柜面；02-企业网银；03-小额交易
    ,zrkhh as zrkhh -- 转入客户号
    ,zrjyje as zrjyje -- 转入交易金额
    ,fpje as fpje -- 分配金额
    ,jyrq as jyrq -- 交易日期
    ,fpjs as fpjs -- 分配角色
    ,zlbl as zlbl -- 增量比例
    ,khdxdh as khdxdh -- 行员考核对象代号
    ,jgkhdxdh as jgkhdxdh -- 机构考核对象代号
    ,' ' as jddbbz -- 进度达标标志(0-达标 1-未达标)
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.pams_nbzz_dfgzkhmx_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;

end loop;
end;
/

