/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_wlckftpmx_xy
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
drop table ${iol_schema}.pams_jxbb_wlckftpmx_xy_ex purge;
alter table ${iol_schema}.pams_jxbb_wlckftpmx_xy add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.pams_jxbb_wlckftpmx_xy truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_jxbb_wlckftpmx_xy_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_wlckftpmx_xy where 0=1;

insert /*+ append */ into ${iol_schema}.pams_jxbb_wlckftpmx_xy_ex(
    tjrq -- 统计日期
    ,zhhm -- 账户户名
    ,zhdh -- 账号代号
    ,zzh -- 子账号
    ,kh -- 卡号
    ,khh -- 客户号
    ,khjgdh -- 开户机构代号
    ,khjgmc -- 开户机构名称
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,qxmc -- 期限名称
    ,cph -- 产品号
    ,cpejfl -- 产品二级分类
    ,cpsjfl -- 产品三级分类
    ,cpsijfl -- 产品四级分类
    ,cpmc -- 产品中文名称
    ,zxll -- 账户执行利率
    ,sjll -- 新型存款实际利率
    ,qxrq -- 起息日期
    ,dqrq -- 到期日期
    ,xhrq -- 销户日期
    ,zzkzqr -- 最早可支取日
    ,sfzy -- 是否质押
    ,sfhx -- 是否核心存款
    ,bz -- 币种
    ,ye -- 余额
    ,dyrj -- 当月日均
    ,ljrj -- 累计日均
    ,dylxzc -- 当月利息支出
    ,ljlxzc -- 累计利息支出
    ,ftpjg -- FTP价格
    ,dyftpzysr -- 当月FTP转移收入
    ,ljftpzysr -- 累计FTP转移收入
    ,dyftpjsy -- 当月FTP净收益
    ,ljftpjsy -- 累计FTP净收益
    ,khjldh -- 客户经理工号
    ,zjywsr -- 中间业务收入
    ,ssjgdh -- 所属机构号
    ,bzdm -- 币种码值
    ,fpbl -- 分配比例
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,zhhm -- 账户户名
    ,zhdh -- 账号代号
    ,zzh -- 子账号
    ,kh -- 卡号
    ,khh -- 客户号
    ,khjgdh -- 开户机构代号
    ,khjgmc -- 开户机构名称
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,qxmc -- 期限名称
    ,cph -- 产品号
    ,cpejfl -- 产品二级分类
    ,cpsjfl -- 产品三级分类
    ,cpsijfl -- 产品四级分类
    ,cpmc -- 产品中文名称
    ,zxll -- 账户执行利率
    ,sjll -- 新型存款实际利率
    ,qxrq -- 起息日期
    ,dqrq -- 到期日期
    ,xhrq -- 销户日期
    ,zzkzqr -- 最早可支取日
    ,sfzy -- 是否质押
    ,sfhx -- 是否核心存款
    ,bz -- 币种
    ,ye -- 余额
    ,dyrj -- 当月日均
    ,ljrj -- 累计日均
    ,dylxzc -- 当月利息支出
    ,ljlxzc -- 累计利息支出
    ,ftpjg -- FTP价格
    ,dyftpzysr -- 当月FTP转移收入
    ,ljftpzysr -- 累计FTP转移收入
    ,dyftpjsy -- 当月FTP净收益
    ,ljftpjsy -- 累计FTP净收益
    ,khjldh -- 客户经理工号
    ,zjywsr -- 中间业务收入
    ,ssjgdh -- 所属机构号
    ,bzdm -- 币种码值
    ,fpbl -- 分配比例
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_jxbb_wlckftpmx_xy
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_jxbb_wlckftpmx_xy exchange partition p_${batch_date} with table ${iol_schema}.pams_jxbb_wlckftpmx_xy_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxbb_wlckftpmx_xy to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_jxbb_wlckftpmx_xy_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_wlckftpmx_xy',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);