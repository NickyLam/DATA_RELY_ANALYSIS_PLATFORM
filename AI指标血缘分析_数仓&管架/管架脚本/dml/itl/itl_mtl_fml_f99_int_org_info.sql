/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_mtl_fml_f99_int_org_info
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
-- alter table ${itl_schema}.mtl_fml_f99_int_org_info drop partition p_${retain_day}; 20200901去除删除策略，保留全部
alter table ${itl_schema}.mtl_fml_f99_int_org_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.mtl_fml_f99_int_org_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.mtl_fml_f99_int_org_info partition for (to_date('${batch_date}','yyyymmdd')) (
    org_no -- 机构编号
    ,org_name -- 机构名称
    ,org_level_cd -- 机构级别代码
    ,accts_org_ind -- 账务机构标志
    ,super_org_no -- 上级机构编号
    ,org_status_cd -- 机构状态代码
    ,org_effect_dt -- 机构生效日期
    ,org_invalid_dt -- 机构失效日期
    ,org_abbr -- 机构简称
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(org_no), ' ') as org_no -- 机构编号
    ,nvl(trim(org_name), ' ') as org_name -- 机构名称
    ,nvl(trim(org_level_cd), ' ') as org_level_cd -- 机构级别代码
    ,nvl(trim(accts_org_ind), ' ') as accts_org_ind -- 账务机构标志
    ,nvl(trim(super_org_no), ' ') as super_org_no -- 上级机构编号
    ,nvl(trim(org_status_cd), ' ') as org_status_cd -- 机构状态代码
    ,nvl(org_effect_dt, null) as org_effect_dt -- 机构生效日期
    ,nvl(org_invalid_dt, null) as org_invalid_dt -- 机构失效日期
    ,nvl(trim(org_abbr), ' ') as org_abbr -- 机构简称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_fml_f99_int_org_info
where etl_dt = to_date('${batch_date}','yyyymmdd')
 ;
commit;


-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.mtl_fml_f99_int_org_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'mtl_fml_f99_int_org_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);