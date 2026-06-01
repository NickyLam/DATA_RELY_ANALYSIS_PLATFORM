/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pams_khdx_jg
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
--alter table ${itl_schema}.itl_edw_pams_khdx_jg drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pams_khdx_jg drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pams_khdx_jg add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pams_khdx_jg partition for (to_date('${batch_date}','yyyymmdd')) (
    khdxdh -- 考核对象代号
    ,jgdh -- 机构代号
    ,jgmc -- 机构名称
    ,jyjgbz -- 经营机构标志
    ,pxbz -- 排序标志
    ,zxzt -- 注销状态
    ,zxrq -- 注销日期
    ,fhdh -- 分行代号
    ,fhbz -- 分行标志
    ,jgdj -- 机构登记
    ,jgqc -- 机构全称
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(khdxdh), 0) as khdxdh -- 考核对象代号
    ,nvl(trim(jgdh), ' ') as jgdh -- 机构代号
    ,nvl(trim(jgmc), ' ') as jgmc -- 机构名称
    ,nvl(trim(jyjgbz), ' ') as jyjgbz -- 经营机构标志
    ,nvl(trim(pxbz), 0) as pxbz -- 排序标志
    ,nvl(trim(zxzt), ' ') as zxzt -- 注销状态
    ,nvl(trim(zxrq), 0) as zxrq -- 注销日期
    ,nvl(trim(fhdh), ' ') as fhdh -- 分行代号
    ,nvl(trim(fhbz), ' ') as fhbz -- 分行标志
    ,nvl(trim(jgdj), ' ') as jgdj -- 机构登记
    ,nvl(trim(jgqc), ' ') as jgqc -- 机构全称
    ,nvl(start_dt, to_date('00010101', 'yyyymmdd')) as start_dt -- 开始时间
    ,nvl(end_dt, to_date('00010101', 'yyyymmdd')) as end_dt -- 结束时间
    ,nvl(trim(id_mark), ' ') as id_mark -- 增删标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pams_khdx_jg
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pams_khdx_jg to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pams_khdx_jg',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);