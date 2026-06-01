/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pams_khfa_fapz
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
--alter table ${itl_schema}.itl_edw_pams_khfa_fapz drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pams_khfa_fapz drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pams_khfa_fapz add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pams_khfa_fapz partition for (to_date('${batch_date}','yyyymmdd')) (
    fabh -- 方案编号
    ,famc -- 方案名称
    ,khnf -- 考核年份
    ,khdx -- 考核对象：1-机构，2-行员
    ,pzms -- 配置模式
    ,jglb -- 机构类别
    ,hylb -- 行员类别
    ,khzq -- 考核周期
    ,khqs -- 考核期数
    ,yyzlbh -- 应用种类编号
    ,yybzz -- 应用标准分
    ,yysx -- 应用上限分
    ,yyxx -- 应用下限分
    ,zt -- 状态
    ,czr -- 操作人
    ,czsj -- 操作时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(fabh), 0) as fabh -- 方案编号
    ,nvl(trim(famc), ' ') as famc -- 方案名称
    ,nvl(trim(khnf), 0) as khnf -- 考核年份
    ,nvl(trim(khdx), ' ') as khdx -- 考核对象：1-机构，2-行员
    ,nvl(trim(pzms), ' ') as pzms -- 配置模式
    ,nvl(trim(jglb), ' ') as jglb -- 机构类别
    ,nvl(trim(hylb), ' ') as hylb -- 行员类别
    ,nvl(trim(khzq), 0) as khzq -- 考核周期
    ,nvl(trim(khqs), ' ') as khqs -- 考核期数
    ,nvl(trim(yyzlbh), 0) as yyzlbh -- 应用种类编号
    ,nvl(trim(yybzz), 0) as yybzz -- 应用标准分
    ,nvl(trim(yysx), 0) as yysx -- 应用上限分
    ,nvl(trim(yyxx), 0) as yyxx -- 应用下限分
    ,nvl(trim(zt), ' ') as zt -- 状态
    ,nvl(trim(czr), ' ') as czr -- 操作人
    ,nvl(czsj, to_timestamp('00010101', 'yyyymmdd')) as czsj -- 操作时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pams_khfa_fapz
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pams_khfa_fapz to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pams_khfa_fapz',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);