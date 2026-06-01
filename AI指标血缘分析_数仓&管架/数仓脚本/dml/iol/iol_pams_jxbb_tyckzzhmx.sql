/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_tyckzzhmx
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
drop table ${iol_schema}.pams_jxbb_tyckzzhmx_ex purge;
alter table ${iol_schema}.pams_jxbb_tyckzzhmx add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.pams_jxbb_tyckzzhmx truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_jxbb_tyckzzhmx_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_tyckzzhmx where 0=1;

insert /*+ append */ into ${iol_schema}.pams_jxbb_tyckzzhmx_ex(
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,khdxdh -- 考核对象代号
    ,jgdh -- 机构代号
    ,jgmc -- 机构名称
    ,hydh -- 行员代号
    ,hymc -- 行员名称
    ,khh -- 客户号
    ,khmc -- 客户名称
    ,jrjglb -- 金融机构类型
    ,zhdh -- 账户代号
    ,zhid -- 账户id
    ,zzh -- 子账号
    ,khjgdh -- 开户机构代号
    ,khjgmc -- 开户机构名称
    ,bz -- 币种
    ,cz -- 储种
    ,khrq -- 开户日期
    ,nll -- 年利率
    ,qxrq -- 起息日期
    ,dqrq -- 到期日期
    ,fxpl -- 付息频率
    ,zhye -- 账户余额
    ,yrj -- 月日均
    ,nrj -- 年日均
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,ftpll -- 准备金ftp利率
    ,byftpjsr -- 当月ftp净收入
    ,bnftpjsr -- 半年ftp净支出
    ,ljftpjsr -- 累计ftp季收入
    ,fpjs -- 分配角色
    ,fpbl -- 分配比例
    ,lxzcylj -- 利息支出月累计
    ,lxzcnlj -- 利息支出年累计
    ,lxsrylj -- 利息收入月累计
    ,lxsrnlj -- 利息收入年累计
    ,lxzcrlj -- 利息支出日累计
    ,lxsrrlj -- 利息收入日累计
    ,brftpjsr -- 当日FTP净收入
    ,fptx -- 所属条线
    ,txfpbl -- 条线分配比例
    ,qylx -- 签约类型
    ,cph -- 产品编号
    ,cpejfl -- 产品小类（二级分类）
    ,cpsjfl -- 产品组（三级分类）
    ,cpsijfl -- 基础产品（四级分类）
    ,cpzwmc -- 可售产品（产品名称）
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,khdxdh -- 考核对象代号
    ,jgdh -- 机构代号
    ,jgmc -- 机构名称
    ,hydh -- 行员代号
    ,hymc -- 行员名称
    ,khh -- 客户号
    ,khmc -- 客户名称
    ,jrjglb -- 金融机构类型
    ,zhdh -- 账户代号
    ,zhid -- 账户id
    ,zzh -- 子账号
    ,khjgdh -- 开户机构代号
    ,khjgmc -- 开户机构名称
    ,bz -- 币种
    ,cz -- 储种
    ,khrq -- 开户日期
    ,nll -- 年利率
    ,qxrq -- 起息日期
    ,dqrq -- 到期日期
    ,fxpl -- 付息频率
    ,zhye -- 账户余额
    ,yrj -- 月日均
    ,nrj -- 年日均
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,ftpll -- 准备金ftp利率
    ,byftpjsr -- 当月ftp净收入
    ,bnftpjsr -- 半年ftp净支出
    ,ljftpjsr -- 累计ftp季收入
    ,fpjs -- 分配角色
    ,fpbl -- 分配比例
    ,lxzcylj -- 利息支出月累计
    ,lxzcnlj -- 利息支出年累计
    ,lxsrylj -- 利息收入月累计
    ,lxsrnlj -- 利息收入年累计
    ,lxzcrlj -- 利息支出日累计
    ,lxsrrlj -- 利息收入日累计
    ,brftpjsr -- 当日FTP净收入
    ,fptx -- 所属条线
    ,txfpbl -- 条线分配比例
    ,qylx -- 签约类型
    ,cph -- 产品编号
    ,cpejfl -- 产品小类（二级分类）
    ,cpsjfl -- 产品组（三级分类）
    ,cpsijfl -- 基础产品（四级分类）
    ,cpzwmc -- 可售产品（产品名称）
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_jxbb_tyckzzhmx
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_jxbb_tyckzzhmx exchange partition p_${batch_date} with table ${iol_schema}.pams_jxbb_tyckzzhmx_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxbb_tyckzzhmx to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_jxbb_tyckzzhmx_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_tyckzzhmx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);