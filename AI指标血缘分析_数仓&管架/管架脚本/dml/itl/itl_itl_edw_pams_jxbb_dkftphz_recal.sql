/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pams_jxbb_dkftphz_recal
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
--alter table ${itl_schema}.itl_edw_pams_jxbb_dkftphz_recal drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pams_jxbb_dkftphz_recal drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pams_jxbb_dkftphz_recal add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pams_jxbb_dkftphz_recal partition for (to_date('${batch_date}','yyyymmdd')) (
    recal_dt -- 重算窗口日期
    ,tjrq -- 统计日期
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,cpbh -- 产品编号
    ,cpzwmc -- 产品中文名称
    ,ye -- 余额
    ,yrj -- 月日均
    ,nrj -- 年日均
    ,jqll -- 加权利率
    ,ylx -- 月利息
    ,nlx -- 年利息
    ,jqftpjg -- 加权FTP价格
    ,dyftpzycb -- 当月FTP转移成本
    ,ljftpzycb -- 累计FTP转移成本
    ,dyftpjsy -- 当月FTP净收益
    ,ljftpjsy -- 累计FTP净收益
    ,lxkm -- 利息科目
    ,lxkmmc -- 利息科目名称
    ,khjgh -- 开户机构号
    ,khjgmc -- 开户机构名称
    ,ssjgh -- 所属机构号
    ,ssjgmc -- 所属机构名称
    ,yqxyss -- 预计信用损失
    ,fxjqzcje -- 风险加权资产金额
    ,bz -- 币种
    ,frje -- 分润金额
    ,hyfrje -- 行员分润金额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(recal_dt), 0) as recal_dt -- 重算窗口日期
    ,nvl(trim(tjrq), 0) as tjrq -- 统计日期
    ,nvl(trim(kmh), ' ') as kmh -- 科目号
    ,nvl(trim(kmmc), ' ') as kmmc -- 科目名称
    ,nvl(trim(cpbh), ' ') as cpbh -- 产品编号
    ,nvl(trim(cpzwmc), ' ') as cpzwmc -- 产品中文名称
    ,nvl(trim(ye), 0) as ye -- 余额
    ,nvl(trim(yrj), 0) as yrj -- 月日均
    ,nvl(trim(nrj), 0) as nrj -- 年日均
    ,nvl(trim(jqll), 0) as jqll -- 加权利率
    ,nvl(trim(ylx), 0) as ylx -- 月利息
    ,nvl(trim(nlx), 0) as nlx -- 年利息
    ,nvl(trim(jqftpjg), 0) as jqftpjg -- 加权FTP价格
    ,nvl(trim(dyftpzycb), 0) as dyftpzycb -- 当月FTP转移成本
    ,nvl(trim(ljftpzycb), 0) as ljftpzycb -- 累计FTP转移成本
    ,nvl(trim(dyftpjsy), 0) as dyftpjsy -- 当月FTP净收益
    ,nvl(trim(ljftpjsy), 0) as ljftpjsy -- 累计FTP净收益
    ,nvl(trim(lxkm), ' ') as lxkm -- 利息科目
    ,nvl(trim(lxkmmc), ' ') as lxkmmc -- 利息科目名称
    ,nvl(trim(khjgh), ' ') as khjgh -- 开户机构号
    ,nvl(trim(khjgmc), ' ') as khjgmc -- 开户机构名称
    ,nvl(trim(ssjgh), ' ') as ssjgh -- 所属机构号
    ,nvl(trim(ssjgmc), ' ') as ssjgmc -- 所属机构名称
    ,nvl(trim(yqxyss), 0) as yqxyss -- 预计信用损失
    ,nvl(trim(fxjqzcje), 0) as fxjqzcje -- 风险加权资产金额
    ,nvl(trim(bz), ' ') as bz -- 币种
    ,nvl(trim(frje), 0) as frje -- 分润金额
    ,nvl(trim(hyfrje), 0) as hyfrje -- 行员分润金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pams_jxbb_dkftphz_recal
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pams_jxbb_dkftphz_recal to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pams_jxbb_dkftphz_recal',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);