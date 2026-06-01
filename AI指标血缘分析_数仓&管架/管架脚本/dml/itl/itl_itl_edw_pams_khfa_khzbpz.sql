/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pams_khfa_khzbpz
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
--alter table ${itl_schema}.itl_edw_pams_khfa_khzbpz drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pams_khfa_khzbpz drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pams_khfa_khzbpz add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pams_khfa_khzbpz partition for (to_date('${batch_date}','yyyymmdd')) (
    fabh -- 方案编号
    ,khzbdh -- 考核指标代号
    ,wdmc -- 维度名称
    ,wdqz -- 维度权重
    ,zbqz -- 指标权重
    ,jldw -- 计量单位
    ,bdz -- 
    ,fdz -- 
    ,mbbh -- 模板编号
    ,qjlx -- 
    ,jsfs -- 
    ,xh -- 序号
    ,tlbl -- 提留比例
    ,tjcx -- 统计程序
    ,xmmc -- 项目名称
    ,zswdqz -- 
    ,zszbqz -- 折算指标权重
    ,pjbh -- 评价编号
    ,khnr -- 考核内容
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(fabh), 0) as fabh -- 方案编号
    ,nvl(trim(khzbdh), 0) as khzbdh -- 考核指标代号
    ,nvl(trim(wdmc), ' ') as wdmc -- 维度名称
    ,nvl(trim(wdqz), 0) as wdqz -- 维度权重
    ,nvl(trim(zbqz), 0) as zbqz -- 指标权重
    ,nvl(trim(jldw), ' ') as jldw -- 计量单位
    ,nvl(trim(bdz), 0) as bdz -- 
    ,nvl(trim(fdz), 0) as fdz -- 
    ,nvl(trim(mbbh), 0) as mbbh -- 模板编号
    ,nvl(trim(qjlx), ' ') as qjlx -- 
    ,nvl(trim(jsfs), ' ') as jsfs -- 
    ,nvl(trim(xh), 0) as xh -- 序号
    ,nvl(trim(tlbl), 0) as tlbl -- 提留比例
    ,nvl(trim(tjcx), ' ') as tjcx -- 统计程序
    ,nvl(trim(xmmc), ' ') as xmmc -- 项目名称
    ,nvl(trim(zswdqz), ' ') as zswdqz -- 
    ,nvl(trim(zszbqz), ' ') as zszbqz -- 折算指标权重
    ,nvl(trim(pjbh), 0) as pjbh -- 评价编号
    ,nvl(trim(khnr), ' ') as khnr -- 考核内容
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pams_khfa_khzbpz
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pams_khfa_khzbpz to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pams_khfa_khzbpz',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);