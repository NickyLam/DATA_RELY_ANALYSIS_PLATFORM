/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pams_v_yjzb_jg
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
--alter table ${itl_schema}.itl_edw_pams_v_yjzb_jg drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pams_v_yjzb_jg drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pams_v_yjzb_jg add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pams_v_yjzb_jg partition for (to_date('${batch_date}','yyyymmdd')) (
    tjrq -- 统计日期
    ,zbdh -- 指标代号
    ,sdbs -- 时段标识
    ,tjkj -- 统计口径
    ,bz -- 币种
    ,khdxdh -- 考核对象代号
    ,zbz -- 指标值
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(tjrq), 0) as tjrq -- 统计日期
    ,nvl(trim(zbdh), 0) as zbdh -- 指标代号
    ,nvl(trim(sdbs), ' ') as sdbs -- 时段标识
    ,nvl(trim(tjkj), ' ') as tjkj -- 统计口径
    ,nvl(trim(bz), ' ') as bz -- 币种
    ,nvl(trim(khdxdh), 0) as khdxdh -- 考核对象代号
    ,nvl(trim(zbz), 0) as zbz -- 指标值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pams_v_yjzb_jg
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pams_v_yjzb_jg to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pams_v_yjzb_jg',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);