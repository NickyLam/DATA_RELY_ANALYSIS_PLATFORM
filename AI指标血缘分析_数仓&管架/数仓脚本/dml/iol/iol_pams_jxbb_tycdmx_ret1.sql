/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_tycdmx
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;
truncate table pams_jxbb_tycdmx;

declare
     v_flag   number(10) :=0;
          
begin
	for tb in (select partition_name,table_name,substr(partition_name,3) as etl_dt 
	             from user_tab_partitions 
	            where table_name = upper('pams_jxbb_tycdmx_bak_${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('pams_jxbb_tycdmx')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table pams_jxbb_tycdmx drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table pams_jxbb_tycdmx add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';

insert /*+ append */ into ${iol_schema}.pams_jxbb_tycdmx(
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,khdxdh -- 考核对象代号
    ,jgkhdxdh -- 机构考核对象代号
    ,jgdh -- 机构代号
    ,jgmc -- 机构名称
    ,hydh -- 行员代号
    ,hymc -- 行员名称
    ,ywbh -- 业务编号
    ,cddm -- 存单代码
    ,cdjc -- 存单简称
    ,ssjgkhdxdh -- 所属机构考核对象代号
    ,ssjgdh -- 所属机构代号
    ,ssjgmc -- 所属机构名称
    ,fxrq -- 发行日期
    ,qxrq -- 起息日期
    ,dqrq -- 到期日期
    ,dfrq -- 兑付日
    ,qx -- 期限
    ,jxts -- 计息天数
    ,fxjg -- 发行机构
    ,nll -- 年利率
    ,fxl -- 发行量(元)
    ,fxje -- 发行金额(元)
    ,bqye -- 本期余额(元)
    ,sjtzrkhh -- 实际投资人客户号
    ,sjtzrqc -- 实际投资人全称
    ,fxjgmc -- 发行机构
    ,xsjgmc -- 销售机构
    ,nrj -- 年日均
    ,yrj -- 月日均
    ,nzc -- 年支出
    ,yzc -- 月支出
    ,ftpll -- 准备金ftp利率
    ,dyftpjsr -- 当月ftp季收入
    ,ljftpjsr -- 累计ftp季收入
    ,fpbl -- 分配比例
    ,fpjs -- 分配角色
    ,ftplxsrylj -- ftp利息收入月累计
    ,ftplxsrnlj -- ftp利息收入年累计
    ,rzc -- 日支出
    ,drftpjsr -- 当日FTP净收入
    ,dnftpjsr -- 当年FTP净收入
    ,ftplxsr -- ftp利息收入
    ,xsjgmczh -- 销售机构名称组合
    ,xsjgmczb -- 销售机构占比说明
    ,gsjgmczh -- 归属机构名称组合
    ,gsjgmczb -- 归属机构占比说明
    ,cpdm -- 产品代码
    ,fptx -- 所属条线
    ,txfpbl -- 条线分配比例
    ,cjdrgjgkhh -- 成交单认购机构客户号
    ,cjdrgjg -- 成交单认购机构
    ,sjrgfkhh -- 实际认购方客户号
    ,sjrgfqc -- 实际认购方全称
    ,tycb -- 摊余成本
    ,btje -- 
    ,btjeylj -- 
    ,btjejlj -- 
    ,btjenlj -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,khdxdh -- 考核对象代号
    ,jgkhdxdh -- 机构考核对象代号
    ,jgdh -- 机构代号
    ,jgmc -- 机构名称
    ,hydh -- 行员代号
    ,hymc -- 行员名称
    ,ywbh -- 业务编号
    ,cddm -- 存单代码
    ,cdjc -- 存单简称
    ,ssjgkhdxdh -- 所属机构考核对象代号
    ,ssjgdh -- 所属机构代号
    ,ssjgmc -- 所属机构名称
    ,fxrq -- 发行日期
    ,qxrq -- 起息日期
    ,dqrq -- 到期日期
    ,dfrq -- 兑付日
    ,qx -- 期限
    ,jxts -- 计息天数
    ,fxjg -- 发行机构
    ,nll -- 年利率
    ,fxl -- 发行量(元)
    ,fxje -- 发行金额(元)
    ,bqye -- 本期余额(元)
    ,sjtzrkhh -- 实际投资人客户号
    ,sjtzrqc -- 实际投资人全称
    ,fxjgmc -- 发行机构
    ,xsjgmc -- 销售机构
    ,nrj -- 年日均
    ,yrj -- 月日均
    ,nzc -- 年支出
    ,yzc -- 月支出
    ,ftpll -- 准备金ftp利率
    ,dyftpjsr -- 当月ftp季收入
    ,ljftpjsr -- 累计ftp季收入
    ,fpbl -- 分配比例
    ,fpjs -- 分配角色
    ,ftplxsrylj -- ftp利息收入月累计
    ,ftplxsrnlj -- ftp利息收入年累计
    ,rzc -- 日支出
    ,drftpjsr -- 当日FTP净收入
    ,dnftpjsr -- 当年FTP净收入
    ,ftplxsr -- ftp利息收入
    ,xsjgmczh -- 销售机构名称组合
    ,xsjgmczb -- 销售机构占比说明
    ,gsjgmczh -- 归属机构名称组合
    ,gsjgmczb -- 归属机构占比说明
    ,cpdm -- 产品代码
    ,fptx -- 所属条线
    ,txfpbl -- 条线分配比例
    ,' ' as cjdrgjgkhh -- 成交单认购机构客户号
    ,' ' as cjdrgjg -- 成交单认购机构
    ,' ' as sjrgfkhh -- 实际认购方客户号
    ,' ' as sjrgfqc -- 实际认购方全称
    ,0 as tycb -- 摊余成本
    ,0 as btje -- 
    ,0 as btjeylj -- 
    ,0 as btjejlj -- 
    ,0 as btjenlj -- 
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from pams_jxbb_tycdmx_bak_${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;
end loop;
end;
/