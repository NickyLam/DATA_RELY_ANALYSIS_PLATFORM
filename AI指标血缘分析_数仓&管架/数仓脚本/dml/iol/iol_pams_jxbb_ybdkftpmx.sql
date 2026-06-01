/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_ybdkftpmx
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
drop table ${iol_schema}.pams_jxbb_ybdkftpmx_ex purge;
alter table ${iol_schema}.pams_jxbb_ybdkftpmx add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.pams_jxbb_ybdkftpmx truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_jxbb_ybdkftpmx_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_ybdkftpmx where 0=1;

insert /*+ append */ into ${iol_schema}.pams_jxbb_ybdkftpmx_ex(
    tjrq -- 统计日期
    ,khm -- 客户名称
    ,khh -- 客户号
    ,khjgkhdxdh -- 开户机构考核对象代号
    ,khjgh -- 开户机构号
    ,khjgmc -- 开户机构名称
    ,ssjgkhdxdh -- 所属机构考核对象代号
    ,ssjgh -- 所属机构号
    ,ssjgmc -- 所属机构名称
    ,khjlgh -- 客户经理工号
    ,khjlxm -- 客户经理姓名
    ,fpbl -- 分配比例
    ,zhbs -- 账户标识
    ,xwdkbs -- 小微贷款标识
    ,jjh -- 借据号
    ,jjzt -- 借据状态
    ,dqzxll -- 当前执行利率
    ,jzll -- 基准利率
    ,fdbl -- 浮动比率
    ,fdfs -- 浮动方式
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,cpbh -- 产品编号
    ,cpejfl -- 产品二级分类
    ,cpsjfl -- 产品三级分类
    ,cpsijfl -- 产品四级分类
    ,cpzwmc -- 产品中文名称
    ,sfxw -- 是否小微
    ,qx -- 期限
    ,fkr -- 放款日
    ,dqr -- 到期日
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
    ,ftplxsr -- FTP利息收入
    ,ftpzycb -- FTP转移成本
    ,ftpsy -- FTP净收益
    ,lxkm -- 利息科目号
    ,lxkmmc -- 利息科目名称
    ,wjfl -- 五级分类
    ,pjh -- 票据号
    ,yqxyss -- 预期信用损失
    ,fxjqzcje -- 风险加权资产金额
    ,bzdm -- 币种码值
    ,ljtzysje -- 累计调整营收金额
    ,tzhljftpjsy -- 调整后累计ftp净收益
    ,ljtzfyje -- 累计调整费用金额
    ,jjljftpjsy -- 计奖累计ftp净收益
    ,dytzysje -- 月累计调整营收金额
    ,tzhdyftpjsy -- 调整后月累计FTP净收益
    ,dytzfyje -- 月累计调整费用金额
    ,jjdyftpjsy -- 计奖月累计FTP净收益
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,khm -- 客户名称
    ,khh -- 客户号
    ,khjgkhdxdh -- 开户机构考核对象代号
    ,khjgh -- 开户机构号
    ,khjgmc -- 开户机构名称
    ,ssjgkhdxdh -- 所属机构考核对象代号
    ,ssjgh -- 所属机构号
    ,ssjgmc -- 所属机构名称
    ,khjlgh -- 客户经理工号
    ,khjlxm -- 客户经理姓名
    ,fpbl -- 分配比例
    ,zhbs -- 账户标识
    ,xwdkbs -- 小微贷款标识
    ,jjh -- 借据号
    ,jjzt -- 借据状态
    ,dqzxll -- 当前执行利率
    ,jzll -- 基准利率
    ,fdbl -- 浮动比率
    ,fdfs -- 浮动方式
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,cpbh -- 产品编号
    ,cpejfl -- 产品二级分类
    ,cpsjfl -- 产品三级分类
    ,cpsijfl -- 产品四级分类
    ,cpzwmc -- 产品中文名称
    ,sfxw -- 是否小微
    ,qx -- 期限
    ,fkr -- 放款日
    ,dqr -- 到期日
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
    ,ftplxsr -- FTP利息收入
    ,ftpzycb -- FTP转移成本
    ,ftpsy -- FTP净收益
    ,lxkm -- 利息科目号
    ,lxkmmc -- 利息科目名称
    ,wjfl -- 五级分类
    ,pjh -- 票据号
    ,yqxyss -- 预期信用损失
    ,fxjqzcje -- 风险加权资产金额
    ,bzdm -- 币种码值
    ,ljtzysje -- 累计调整营收金额
    ,tzhljftpjsy -- 调整后累计ftp净收益
    ,ljtzfyje -- 累计调整费用金额
    ,jjljftpjsy -- 计奖累计ftp净收益
    ,dytzysje -- 月累计调整营收金额
    ,tzhdyftpjsy -- 调整后月累计FTP净收益
    ,dytzfyje -- 月累计调整费用金额
    ,jjdyftpjsy -- 计奖月累计FTP净收益
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_jxbb_ybdkftpmx
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_jxbb_ybdkftpmx exchange partition p_${batch_date} with table ${iol_schema}.pams_jxbb_ybdkftpmx_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxbb_ybdkftpmx to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_jxbb_ybdkftpmx_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_ybdkftpmx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);