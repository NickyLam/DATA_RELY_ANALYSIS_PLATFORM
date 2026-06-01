/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pams_jxbb_tycdmx
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${itl_schema}.itl_edw_pams_jxbb_tycdmx drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pams_jxbb_tycdmx drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pams_jxbb_tycdmx add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pams_jxbb_tycdmx partition for (to_date('${batch_date}','yyyymmdd')) (
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
    ,drftpjsr -- 当日ftp净收入
    ,dnftpjsr -- 当年ftp净收入
    ,ftplxsr -- ftp利息收入
    ,xsjgmczh -- 销售机构名称组合
    ,xsjgmczb -- 销售机构占比说明
    ,gsjgmczh -- 归属机构名称组合
    ,gsjgmczb -- 归属机构占比说明
    ,cpdm -- 产品代码
    ,fptx -- 所属条线
    ,txfpbl -- 条线分配比例
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(tjrq), 0) as tjrq -- 统计日期
    ,nvl(trim(jxdxdh), 0) as jxdxdh -- 绩效对象代号
    ,nvl(trim(khdxdh), 0) as khdxdh -- 考核对象代号
    ,nvl(trim(jgkhdxdh), 0) as jgkhdxdh -- 机构考核对象代号
    ,nvl(trim(jgdh), ' ') as jgdh -- 机构代号
    ,nvl(trim(jgmc), ' ') as jgmc -- 机构名称
    ,nvl(trim(hydh), ' ') as hydh -- 行员代号
    ,nvl(trim(hymc), ' ') as hymc -- 行员名称
    ,nvl(trim(ywbh), ' ') as ywbh -- 业务编号
    ,nvl(trim(cddm), ' ') as cddm -- 存单代码
    ,nvl(trim(cdjc), ' ') as cdjc -- 存单简称
    ,nvl(trim(ssjgkhdxdh), 0) as ssjgkhdxdh -- 所属机构考核对象代号
    ,nvl(trim(ssjgdh), ' ') as ssjgdh -- 所属机构代号
    ,nvl(trim(ssjgmc), ' ') as ssjgmc -- 所属机构名称
    ,nvl(trim(fxrq), 0) as fxrq -- 发行日期
    ,nvl(trim(qxrq), 0) as qxrq -- 起息日期
    ,nvl(trim(dqrq), 0) as dqrq -- 到期日期
    ,nvl(trim(dfrq), 0) as dfrq -- 兑付日
    ,nvl(trim(qx), ' ') as qx -- 期限
    ,nvl(trim(jxts), 0) as jxts -- 计息天数
    ,nvl(trim(fxjg), 0) as fxjg -- 发行机构
    ,nvl(trim(nll), 0) as nll -- 年利率
    ,nvl(trim(fxl), 0) as fxl -- 发行量(元)
    ,nvl(trim(fxje), 0) as fxje -- 发行金额(元)
    ,nvl(trim(bqye), 0) as bqye -- 本期余额(元)
    ,nvl(trim(sjtzrkhh), ' ') as sjtzrkhh -- 实际投资人客户号
    ,nvl(trim(sjtzrqc), ' ') as sjtzrqc -- 实际投资人全称
    ,nvl(trim(fxjgmc), ' ') as fxjgmc -- 发行机构
    ,nvl(trim(xsjgmc), ' ') as xsjgmc -- 销售机构
    ,nvl(trim(nrj), 0) as nrj -- 年日均
    ,nvl(trim(yrj), 0) as yrj -- 月日均
    ,nvl(trim(nzc), 0) as nzc -- 年支出
    ,nvl(trim(yzc), 0) as yzc -- 月支出
    ,nvl(trim(ftpll), 0) as ftpll -- 准备金ftp利率
    ,nvl(trim(dyftpjsr), 0) as dyftpjsr -- 当月ftp季收入
    ,nvl(trim(ljftpjsr), 0) as ljftpjsr -- 累计ftp季收入
    ,nvl(trim(fpbl), 0) as fpbl -- 分配比例
    ,nvl(trim(fpjs), ' ') as fpjs -- 分配角色
    ,nvl(trim(ftplxsrylj), 0) as ftplxsrylj -- ftp利息收入月累计
    ,nvl(trim(ftplxsrnlj), 0) as ftplxsrnlj -- ftp利息收入年累计
    ,nvl(trim(rzc), 0) as rzc -- 日支出
    ,nvl(trim(drftpjsr), 0) as drftpjsr -- 当日ftp净收入
    ,nvl(trim(dnftpjsr), 0) as dnftpjsr -- 当年ftp净收入
    ,nvl(trim(ftplxsr), 0) as ftplxsr -- ftp利息收入
    ,nvl(trim(xsjgmczh), ' ') as xsjgmczh -- 销售机构名称组合
    ,nvl(trim(xsjgmczb), ' ') as xsjgmczb -- 销售机构占比说明
    ,nvl(trim(gsjgmczh), ' ') as gsjgmczh -- 归属机构名称组合
    ,nvl(trim(gsjgmczb), ' ') as gsjgmczb -- 归属机构占比说明
    ,nvl(trim(cpdm), ' ') as cpdm -- 产品代码
    ,nvl(trim(fptx), ' ') as fptx -- 所属条线
    ,nvl(trim(txfpbl), 0) as txfpbl -- 条线分配比例
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pams_jxbb_tycdmx
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pams_jxbb_tycdmx to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pams_jxbb_tycdmx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);