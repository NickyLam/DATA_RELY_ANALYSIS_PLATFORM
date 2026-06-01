/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_nbzz_dklrmx_recal
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
drop table ${iol_schema}.pams_nbzz_dklrmx_recal_ex purge;
alter table ${iol_schema}.pams_nbzz_dklrmx_recal add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.pams_nbzz_dklrmx_recal truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_nbzz_dklrmx_recal_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_nbzz_dklrmx_recal where 0=1;

insert /*+ append */ into ${iol_schema}.pams_nbzz_dklrmx_recal_ex(
    tjrq -- 统计日期
    ,khdxdh -- 考核对象代号
    ,jxdxdh -- 绩效对象代号
    ,jgkhdxdh -- 机构考核对象代号
    ,kmh -- 科目号
    ,cph -- 产品号
    ,ywpz -- 业务品种
    ,fpjs -- 分配角色
    ,zhdh -- 账户代号
    ,zzh -- 子账号
    ,zhhm -- 账户名称
    ,khh -- 客户号
    ,jgdh -- 机构代号
    ,qx -- 期限
    ,zhbs -- 账户标识
    ,bz -- 币种
    ,nll -- 年利率
    ,zyjg -- 转移价格
    ,ftplc -- FTP利差
    ,zlbl -- 认领比例
    ,zhye -- 账户余额
    ,hyye -- 行员余额
    ,hyylj -- 行员月累计
    ,hyjlj -- 行员季累计
    ,hybnlj -- 行员半年累计
    ,hynlj -- 行员年累计
    ,wjfl -- 五级分类
    ,khdkje -- 客户贷款金额
    ,ftpzycb -- FTP转移成本
    ,ftpzycbylj -- FTP转移成本月累计
    ,ftpzycbjlj -- FTP转移成本季累计
    ,ftpzycbbnlj -- FTP转移成本半年累计
    ,ftpzycbnlj -- FTP转移成本年累计
    ,ftplxsr -- FTP利息收入
    ,ftplxsrylj -- FTP利息收入月累计
    ,ftplxsrjlj -- FTP利息收入季累计
    ,ftplxsrbnlj -- FTP利息收入半年累计
    ,ftplxsrnlj -- FTP利息收入年累计
    ,ftpsy -- FTP收益
    ,ftpsyylj -- FTP收益月累计
    ,ftpsyjlj -- FTP收益季累计
    ,ftpsybnlj -- FTP收益半年累计
    ,ftpsynlj -- FTP收益年累计
    ,hxbz -- 核销标志
    ,xwdkbs -- 小微贷款标识
    ,zxzdkztdm -- 支小再贷款状态代码
    ,recal_dt -- 重算日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,khdxdh -- 考核对象代号
    ,jxdxdh -- 绩效对象代号
    ,jgkhdxdh -- 机构考核对象代号
    ,kmh -- 科目号
    ,cph -- 产品号
    ,ywpz -- 业务品种
    ,fpjs -- 分配角色
    ,zhdh -- 账户代号
    ,zzh -- 子账号
    ,zhhm -- 账户名称
    ,khh -- 客户号
    ,jgdh -- 机构代号
    ,qx -- 期限
    ,zhbs -- 账户标识
    ,bz -- 币种
    ,nll -- 年利率
    ,zyjg -- 转移价格
    ,ftplc -- FTP利差
    ,zlbl -- 认领比例
    ,zhye -- 账户余额
    ,hyye -- 行员余额
    ,hyylj -- 行员月累计
    ,hyjlj -- 行员季累计
    ,hybnlj -- 行员半年累计
    ,hynlj -- 行员年累计
    ,wjfl -- 五级分类
    ,khdkje -- 客户贷款金额
    ,ftpzycb -- FTP转移成本
    ,ftpzycbylj -- FTP转移成本月累计
    ,ftpzycbjlj -- FTP转移成本季累计
    ,ftpzycbbnlj -- FTP转移成本半年累计
    ,ftpzycbnlj -- FTP转移成本年累计
    ,ftplxsr -- FTP利息收入
    ,ftplxsrylj -- FTP利息收入月累计
    ,ftplxsrjlj -- FTP利息收入季累计
    ,ftplxsrbnlj -- FTP利息收入半年累计
    ,ftplxsrnlj -- FTP利息收入年累计
    ,ftpsy -- FTP收益
    ,ftpsyylj -- FTP收益月累计
    ,ftpsyjlj -- FTP收益季累计
    ,ftpsybnlj -- FTP收益半年累计
    ,ftpsynlj -- FTP收益年累计
    ,hxbz -- 核销标志
    ,xwdkbs -- 小微贷款标识
    ,zxzdkztdm -- 支小再贷款状态代码
    ,recal_dt -- 重算日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_nbzz_dklrmx_recal
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_nbzz_dklrmx_recal exchange partition p_${batch_date} with table ${iol_schema}.pams_nbzz_dklrmx_recal_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_nbzz_dklrmx_recal to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_nbzz_dklrmx_recal_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_nbzz_dklrmx_recal',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);