/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_gsjzkhmx_recal_ret1
CreateDate: 20250812
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
                   where table_name = upper('pams_jxbb_gsjzkhmx_recal_bak${batch_date}')
                       and partition_name <> 'P_19000101'
                       --and substr(partition_name,3) = '${batch_date}'
             ) loop

  select count(*) into v_flag
    from all_tab_partitions
   where table_owner = upper('iol')
     and table_name = upper('pams_jxbb_gsjzkhmx_recal')
     and partition_name = tb.partition_name;

  if v_flag <> 0 then
    execute immediate 'alter table pams_jxbb_gsjzkhmx_recal drop partition '|| tb.partition_name ;
  end if;

    execute immediate 'alter table pams_jxbb_gsjzkhmx_recal add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';


-- 回插所有数据

insert /*+ append */ into ${iol_schema}.pams_jxbb_gsjzkhmx_recal (
	tjrq -- 统计日期
	,hydh -- 行员代号
	,hymc -- 行员名称
	,jgdh -- 机构代号
	,jgmc -- 机构名称
	,khh -- 客户号
	,khmc -- 客户名称
	,hyljrj -- 行员累计日均
	,hyftpsynlj -- 行员收入年累计
	,khljrj -- 客户累计日均
	,khftpsynlj -- 客户收入年累计
	,zjywsr -- 中间业务收入
	,khzjywsr -- 客户中间业务收入
	,jzkhs -- 价值客户数
	,recal_dt -- 重算日期
	,fhjzkhs -- 分行价值客户数
	,ckye -- 存款余额
	,ckzb -- 存款占比
	,yszb -- 营收占比
	,ld -- 粒度
	,etl_dt -- ETL处理日期
	,etl_timestamp -- ETL处理时间戳
)
select
	tjrq as tjrq -- 统计日期
	,hydh as hydh -- 行员代号
	,hymc as hymc -- 行员名称
	,jgdh as jgdh -- 机构代号
	,jgmc as jgmc -- 机构名称
	,khh as khh -- 客户号
	,khmc as khmc -- 客户名称
	,hyljrj as hyljrj -- 行员累计日均
	,hyftpsynlj as hyftpsynlj -- 行员收入年累计
	,khljrj as khljrj -- 客户累计日均
	,khftpsynlj as khftpsynlj -- 客户收入年累计
	,zjywsr as zjywsr -- 中间业务收入
	,khzjywsr as khzjywsr -- 客户中间业务收入
	,jzkhs as jzkhs -- 价值客户数
	,recal_dt as recal_dt -- 重算日期
	,0 as fhjzkhs -- 分行价值客户数
	,0 as ckye -- 存款余额
	,0 as ckzb -- 存款占比
	,0 as yszb -- 营收占比
	,' ' as ld -- 粒度
	,etl_dt as etl_dt -- ETL处理日期
	,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.pams_jxbb_gsjzkhmx_recal_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;

end loop;
end;
/

