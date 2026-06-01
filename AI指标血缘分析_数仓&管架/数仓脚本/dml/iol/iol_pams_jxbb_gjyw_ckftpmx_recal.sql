/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_gjyw_ckftpmx_recal
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
drop table ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal_ex purge;
alter table ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal where 0=1;

insert /*+ append */ into ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal_ex(
    tjrq -- 统计日期
    ,zhid -- 账户ID
    ,khh -- 客户号
    ,zhm -- 账户名
    ,zhh -- 账户号
    ,zzh -- 子户号
    ,fhjgdh -- 分行机构号
    ,fhjgmc -- 分行机构名称
    ,khjgdh -- 开户机构号
    ,khjgmc -- 开户机构名称
    ,ssjgdh -- 所属机构号
    ,ssjgmc -- 所属机构名称
    ,hydh -- 客户经理工号
    ,hymc -- 客户经理名称
    ,fpbl -- 分配比例
    ,fptx -- 所属条线
    ,txfpbl -- 条线分配比例
    ,qx -- 存期
    ,qxmc -- 存期名称
    ,cph -- 产品编号
    ,cpmc -- 产品中文名称
    ,qxrq -- 起息日
    ,dqrq -- 到期日
    ,xhrq -- 销户日
    ,sfzy -- 是否质押
    ,bzmc -- 币种
    ,ckje_yb -- 存款金额(原币）
    ,ckje -- 存款金额（折合人民币）
    ,ye_yb -- 余额（原币）
    ,ye -- 余额（折合人民币）
    ,yrj -- 月日均
    ,jrj -- 季日均
    ,nrj -- 年日均
    ,zhzxll -- 账户执行利率
    ,ftpjg -- 存款FTP价格
    ,ftpsy -- 当日FTP净收益
    ,ftpsyylj -- 当月FTP净收益
    ,ftpsyjlj -- 当季FTP净收益
    ,ftpsynlj -- 当年FTP净收益
    ,ftpsyqlj -- 历史累计FTP净收益
    ,cksrlx -- 存款收入类型
    ,glckywcp -- 关联敞口业务产品
    ,whzhxzdm -- 外汇账户性质代码
    ,whzhxzms -- 外汇账户性质描述
    ,recal_dt -- 重算日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,zhid -- 账户ID
    ,khh -- 客户号
    ,zhm -- 账户名
    ,zhh -- 账户号
    ,zzh -- 子户号
    ,fhjgdh -- 分行机构号
    ,fhjgmc -- 分行机构名称
    ,khjgdh -- 开户机构号
    ,khjgmc -- 开户机构名称
    ,ssjgdh -- 所属机构号
    ,ssjgmc -- 所属机构名称
    ,hydh -- 客户经理工号
    ,hymc -- 客户经理名称
    ,fpbl -- 分配比例
    ,fptx -- 所属条线
    ,txfpbl -- 条线分配比例
    ,qx -- 存期
    ,qxmc -- 存期名称
    ,cph -- 产品编号
    ,cpmc -- 产品中文名称
    ,qxrq -- 起息日
    ,dqrq -- 到期日
    ,xhrq -- 销户日
    ,sfzy -- 是否质押
    ,bzmc -- 币种
    ,ckje_yb -- 存款金额(原币）
    ,ckje -- 存款金额（折合人民币）
    ,ye_yb -- 余额（原币）
    ,ye -- 余额（折合人民币）
    ,yrj -- 月日均
    ,jrj -- 季日均
    ,nrj -- 年日均
    ,zhzxll -- 账户执行利率
    ,ftpjg -- 存款FTP价格
    ,ftpsy -- 当日FTP净收益
    ,ftpsyylj -- 当月FTP净收益
    ,ftpsyjlj -- 当季FTP净收益
    ,ftpsynlj -- 当年FTP净收益
    ,ftpsyqlj -- 历史累计FTP净收益
    ,cksrlx -- 存款收入类型
    ,glckywcp -- 关联敞口业务产品
    ,whzhxzdm -- 外汇账户性质代码
    ,whzhxzms -- 外汇账户性质描述
    ,recal_dt -- 重算日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_jxbb_gjyw_ckftpmx_recal
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal exchange partition p_${batch_date} with table ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_jxbb_gjyw_ckftpmx_recal_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_gjyw_ckftpmx_recal',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);