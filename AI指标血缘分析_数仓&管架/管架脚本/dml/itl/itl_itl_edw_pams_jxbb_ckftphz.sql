/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pams_jxbb_ckftphz
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
--alter table ${itl_schema}.itl_edw_pams_jxbb_ckftphz drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pams_jxbb_ckftphz drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pams_jxbb_ckftphz add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pams_jxbb_ckftphz partition for (to_date('${batch_date}','yyyymmdd')) (
    tjrq -- 统计日期
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,cpmc -- 产品名称
    ,zhye -- 账户余额
    ,zhyrjye -- 账户月日均余额
    ,zhnrjye -- 账户年日均余额
    ,jqll -- 加权利率
    ,ftplxzcylj -- ftp利息支出月累计
    ,ftplxzcnlj -- ftp利息支出年累计
    ,jqftpjg -- 加权ftp价格
    ,ftpsrylj -- ftp收入月累计
    ,ftpsrnlj -- ftp收入年累计
    ,ftpsyylj -- ftp收益月累计
    ,ftpsynlj -- ftp收益年累计
    ,lxkm -- 利息科目
    ,lxkmmc -- 利息科目名称
    ,khjgh -- 开户机构号
    ,khjgmc -- 开户机构名称
    ,ssjgh -- 所属机构号
    ,ssjgmc -- 所属机构名称
    ,bz -- 币种
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(tjrq), 0) as tjrq -- 统计日期
    ,nvl(trim(kmh), ' ') as kmh -- 科目号
    ,nvl(trim(kmmc), ' ') as kmmc -- 科目名称
    ,nvl(trim(cpmc), ' ') as cpmc -- 产品名称
    ,nvl(trim(zhye), 0) as zhye -- 账户余额
    ,nvl(trim(zhyrjye), 0) as zhyrjye -- 账户月日均余额
    ,nvl(trim(zhnrjye), 0) as zhnrjye -- 账户年日均余额
    ,nvl(trim(jqll), 0) as jqll -- 加权利率
    ,nvl(trim(ftplxzcylj), 0) as ftplxzcylj -- ftp利息支出月累计
    ,nvl(trim(ftplxzcnlj), 0) as ftplxzcnlj -- ftp利息支出年累计
    ,nvl(trim(jqftpjg), 0) as jqftpjg -- 加权ftp价格
    ,nvl(trim(ftpsrylj), 0) as ftpsrylj -- ftp收入月累计
    ,nvl(trim(ftpsrnlj), 0) as ftpsrnlj -- ftp收入年累计
    ,nvl(trim(ftpsyylj), 0) as ftpsyylj -- ftp收益月累计
    ,nvl(trim(ftpsynlj), 0) as ftpsynlj -- ftp收益年累计
    ,nvl(trim(lxkm), ' ') as lxkm -- 利息科目
    ,nvl(trim(lxkmmc), ' ') as lxkmmc -- 利息科目名称
    ,nvl(trim(khjgh), ' ') as khjgh -- 开户机构号
    ,nvl(trim(khjgmc), ' ') as khjgmc -- 开户机构名称
    ,nvl(trim(ssjgh), ' ') as ssjgh -- 所属机构号
    ,nvl(trim(ssjgmc), ' ') as ssjgmc -- 所属机构名称
    ,nvl(trim(bz), ' ') as bz -- 币种
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pams_jxbb_ckftphz
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pams_jxbb_ckftphz to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pams_jxbb_ckftphz',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);