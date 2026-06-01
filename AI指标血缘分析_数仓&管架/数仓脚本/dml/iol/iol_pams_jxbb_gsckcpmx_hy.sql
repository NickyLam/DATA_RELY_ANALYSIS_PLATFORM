/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_gsckcpmx_hy
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxbb_gsckcpmx_hy_ex purge;
alter table ${iol_schema}.pams_jxbb_gsckcpmx_hy add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.pams_jxbb_gsckcpmx_hy truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_jxbb_gsckcpmx_hy_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_gsckcpmx_hy where 0=1;

insert /*+ append */ into ${iol_schema}.pams_jxbb_gsckcpmx_hy_ex(
    tjrq -- 数据日期
    ,khdxdh -- 行员考核对象代号
    ,fpjs -- 分配角色
    ,cpbh -- 产品编号
    ,cpmc -- 产品名称
    ,kmh -- 科目号
    ,bz -- 币种
    ,zzh -- 子账户
    ,zhdh -- 账户
    ,zhbs -- 账户标识
    ,khh -- 客户号
    ,bzbs -- 币种标识
    ,zhye -- 余额
    ,zhyrjye -- 月日均
    ,zhjrjye -- 季日均
    ,zhnrjye -- 年日均
    ,ftpsy -- ftp净收入
    ,ftpsyylj -- ftp净收入月累计
    ,ftpsyjlj -- ftp净收入季累计
    ,ftpsynlj -- ftp净收入年累计
    ,ftplxzc -- FTP利息支出
    ,ftplxzcylj -- FTP利息支出月累计
    ,ftplxzcjlj -- FTP利息支出季累计
    ,ftplxzcnlj -- FTP利息支出年累计
    ,ftpsr -- 累计利息收入时点
    ,ftpsrylj -- 累计利息收入月累计
    ,ftpsrjlj -- 累计利息收入季累计
    ,ftpsrnlj -- 累计利息收入年累计
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 数据日期
    ,khdxdh -- 行员考核对象代号
    ,fpjs -- 分配角色
    ,cpbh -- 产品编号
    ,cpmc -- 产品名称
    ,kmh -- 科目号
    ,bz -- 币种
    ,zzh -- 子账户
    ,zhdh -- 账户
    ,zhbs -- 账户标识
    ,khh -- 客户号
    ,bzbs -- 币种标识
    ,zhye -- 余额
    ,zhyrjye -- 月日均
    ,zhjrjye -- 季日均
    ,zhnrjye -- 年日均
    ,ftpsy -- ftp净收入
    ,ftpsyylj -- ftp净收入月累计
    ,ftpsyjlj -- ftp净收入季累计
    ,ftpsynlj -- ftp净收入年累计
    ,ftplxzc -- FTP利息支出
    ,ftplxzcylj -- FTP利息支出月累计
    ,ftplxzcjlj -- FTP利息支出季累计
    ,ftplxzcnlj -- FTP利息支出年累计
    ,ftpsr -- 累计利息收入时点
    ,ftpsrylj -- 累计利息收入月累计
    ,ftpsrjlj -- 累计利息收入季累计
    ,ftpsrnlj -- 累计利息收入年累计
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_jxbb_gsckcpmx_hy
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_jxbb_gsckcpmx_hy exchange partition p_${batch_date} with table ${iol_schema}.pams_jxbb_gsckcpmx_hy_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxbb_gsckcpmx_hy to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_jxbb_gsckcpmx_hy_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_gsckcpmx_hy',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);