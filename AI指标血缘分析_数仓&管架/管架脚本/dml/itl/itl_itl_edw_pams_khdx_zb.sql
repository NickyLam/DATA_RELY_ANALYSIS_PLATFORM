/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pams_khdx_zb
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
--alter table ${itl_schema}.itl_edw_pams_khdx_zb drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pams_khdx_zb drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pams_khdx_zb add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pams_khdx_zb partition for (to_date('${batch_date}','yyyymmdd')) (
    zbdh -- 指标代号
    ,zbmc -- 指标名称
    ,zbdw -- 指标单位
    ,zbjb -- 指标级别
    ,whfs -- 维护方式
    ,sfxs -- 是否显示
    ,ddsx -- 调度顺序
    ,zbpx -- 指标排序
    ,zbcc -- 指标层次
    ,ddlb -- 调度类别
    ,jspl -- 计算频率
    ,sjzb -- 上级指标
    ,zbzt -- 指标状态
    ,dlbz -- 定量标准
    ,xszbdh -- 显示指标代号
    ,kzlx -- 扩展类型
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(zbdh), 0) as zbdh -- 指标代号
    ,nvl(trim(zbmc), ' ') as zbmc -- 指标名称
    ,nvl(trim(zbdw), ' ') as zbdw -- 指标单位
    ,nvl(trim(zbjb), ' ') as zbjb -- 指标级别
    ,nvl(trim(whfs), ' ') as whfs -- 维护方式
    ,nvl(trim(sfxs), ' ') as sfxs -- 是否显示
    ,nvl(trim(ddsx), 0) as ddsx -- 调度顺序
    ,nvl(trim(zbpx), 0) as zbpx -- 指标排序
    ,nvl(trim(zbcc), ' ') as zbcc -- 指标层次
    ,nvl(trim(ddlb), ' ') as ddlb -- 调度类别
    ,nvl(trim(jspl), ' ') as jspl -- 计算频率
    ,nvl(trim(sjzb), 0) as sjzb -- 上级指标
    ,nvl(trim(zbzt), ' ') as zbzt -- 指标状态
    ,nvl(trim(dlbz), ' ') as dlbz -- 定量标准
    ,nvl(trim(xszbdh), 0) as xszbdh -- 显示指标代号
    ,nvl(trim(kzlx), ' ') as kzlx -- 扩展类型
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pams_khdx_zb
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pams_khdx_zb to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pams_khdx_zb',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);