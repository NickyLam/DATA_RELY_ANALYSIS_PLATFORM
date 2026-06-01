/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pams_jxbb_kpikhdfmx_jg
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
alter table ${itl_schema}.itl_edw_pams_jxbb_kpikhdfmx_jg drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pams_jxbb_kpikhdfmx_jg drop partition p_${batch_date};
truncate table ${itl_schema}.itl_edw_pams_jxbb_kpikhdfmx_jg;

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pams_jxbb_kpikhdfmx_jg add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pams_jxbb_kpikhdfmx_jg partition for (to_date('${batch_date}','yyyymmdd')) (
    tjrq -- 统计日期
    ,khdxdh -- 考核对象代号
    ,fabh -- 方案编号
    ,famc -- 方案名称
    ,zbmc -- 指标项名称
    ,bzdf -- 标准得分
    ,dfsx -- 得分上限
    ,dfxx -- 得分下限
    ,ndmbz -- 年度目标值
    ,sjjdz -- 时间进度值
    ,js -- 基数
    ,zbz -- 指标值
    ,jzz -- 净增值
    ,khdf -- 考核得分
    ,ndwcl -- 年度完成率
    ,sjjdwcl -- 时间进度完成率
    ,xh -- 展示序号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(tjrq), 0) as tjrq -- 统计日期
    ,nvl(trim(khdxdh), 0) as khdxdh -- 考核对象代号
    ,nvl(trim(fabh), ' ') as fabh -- 方案编号
    ,nvl(trim(famc), ' ') as famc -- 方案名称
    ,nvl(trim(zbmc), ' ') as zbmc -- 指标项名称
    ,nvl(trim(bzdf), 0) as bzdf -- 标准得分
    ,nvl(trim(dfsx), 0) as dfsx -- 得分上限
    ,nvl(trim(dfxx), 0) as dfxx -- 得分下限
    ,nvl(trim(ndmbz), 0) as ndmbz -- 年度目标值
    ,nvl(trim(sjjdz), 0) as sjjdz -- 时间进度值
    ,nvl(trim(js), 0) as js -- 基数
    ,nvl(trim(zbz), 0) as zbz -- 指标值
    ,nvl(trim(jzz), 0) as jzz -- 净增值
    ,nvl(trim(khdf), 0) as khdf -- 考核得分
    ,nvl(trim(ndwcl), 0) as ndwcl -- 年度完成率
    ,nvl(trim(sjjdwcl), 0) as sjjdwcl -- 时间进度完成率
    ,nvl(trim(xh), 0) as xh -- 展示序号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pams_jxbb_kpikhdfmx_jg
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pams_jxbb_kpikhdfmx_jg to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pams_jxbb_kpikhdfmx_jg',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);