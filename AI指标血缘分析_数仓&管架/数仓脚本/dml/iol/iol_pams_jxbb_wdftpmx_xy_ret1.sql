/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_wdftpmx_xy
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
	            where table_name = upper('pams_jxbb_wdftpmx_xy_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('pams_jxbb_wdftpmx_xy')
     and partition_name = tb.partition_name;

  if v_flag <> 0 then
     execute immediate 'alter table pams_jxbb_wdftpmx_xy drop partition '|| tb.partition_name ;

  end if;
  
     execute immediate 'alter table pams_jxbb_wdftpmx_xy add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';

insert /*+ append */ into ${iol_schema}.pams_jxbb_wdftpmx_xy(
    tjrq -- 统计日期
    ,khjgh -- 开户机构代号
    ,khjgmc -- 开户机构名称
    ,jjh -- 借据号
    ,cpbh -- 产品编号
    ,cpejfl -- 产品二级分类
    ,cpsjfl -- 产品三级分类
    ,cpsijfl -- 产品四级分类
    ,cpzwmc -- 产品中文名称
    ,bz -- 币种
    ,ye -- 余额
    ,yrj -- 月日均
    ,nrj -- 年日均
    ,ylx -- 月利息
    ,nlx -- 年利息
    ,ftpjg -- FTP价格
    ,dyftpzycb -- 当月FTP转移成本
    ,ljftpzycb -- 累计FTP转移成本
    ,dyftpjsy -- 当月FTP净收益
    ,ljftpjsy -- 累计FTP净收益
    ,jgkhdxdh -- 机构考核对象代号
    ,xwdkbs -- 小微贷款标识
    ,zhbs -- 账户标识
    ,khm -- 客户名称
    ,khh -- 客户号
    ,bzdm -- 币种码值
    ,khjldh -- 客户经理工号
    ,ssjgdh -- 所属机构号
    ,fpbl -- 分配比例
    ,dbgsbh -- 担保公司编号
    ,dbmc -- 担保名称
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,khjgh -- 开户机构代号
    ,khjgmc -- 开户机构名称
    ,jjh -- 借据号
    ,cpbh -- 产品编号
    ,cpejfl -- 产品二级分类
    ,cpsjfl -- 产品三级分类
    ,cpsijfl -- 产品四级分类
    ,cpzwmc -- 产品中文名称
    ,bz -- 币种
    ,ye -- 余额
    ,yrj -- 月日均
    ,nrj -- 年日均
    ,ylx -- 月利息
    ,nlx -- 年利息
    ,ftpjg -- FTP价格
    ,dyftpzycb -- 当月FTP转移成本
    ,ljftpzycb -- 累计FTP转移成本
    ,dyftpjsy -- 当月FTP净收益
    ,ljftpjsy -- 累计FTP净收益
    ,jgkhdxdh -- 机构考核对象代号
    ,xwdkbs -- 小微贷款标识
    ,zhbs -- 账户标识
    ,khm -- 客户名称
    ,khh -- 客户号
    ,bzdm -- 币种码值
    ,khjldh -- 客户经理工号
    ,ssjgdh -- 所属机构号
    ,fpbl -- 分配比例
    ,' ' as dbgsbh -- 担保公司编号
    ,' ' as dbmc -- 担保名称
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
from pams_jxbb_wdftpmx_xy_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;
end loop;
end;
/
