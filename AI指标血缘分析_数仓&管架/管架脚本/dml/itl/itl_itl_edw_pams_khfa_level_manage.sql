/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pams_khfa_level_manage
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
--alter table ${itl_schema}.itl_edw_pams_khfa_level_manage drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pams_khfa_level_manage drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pams_khfa_level_manage add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pams_khfa_level_manage partition for (to_date('${batch_date}','yyyymmdd')) (
    khnf -- 考核年份
    ,fabh -- 方案编号
    ,jg -- 结构
    ,lx -- 类型
    ,khzbbh -- 考核指标编号
    ,khpl -- 考核频率
    ,dfly -- 得分来源
    ,xh -- 序号
    ,czr -- 操作人
    ,czsj -- 操作时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(khnf), 0) as khnf -- 考核年份
    ,nvl(trim(fabh), 0) as fabh -- 方案编号
    ,nvl(trim(jg), ' ') as jg -- 结构
    ,nvl(trim(lx), ' ') as lx -- 类型
    ,nvl(trim(khzbbh), 0) as khzbbh -- 考核指标编号
    ,nvl(trim(khpl), ' ') as khpl -- 考核频率
    ,nvl(trim(dfly), ' ') as dfly -- 得分来源
    ,nvl(trim(xh), 0) as xh -- 序号
    ,nvl(trim(czr), 0) as czr -- 操作人
    ,nvl(czsj, to_date('00010101', 'yyyymmdd')) as czsj -- 操作时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pams_khfa_level_manage
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pams_khfa_level_manage to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pams_khfa_level_manage',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);