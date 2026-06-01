/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_ref_dist_cd
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.icrm_ref_dist_cd drop partition p_${last_date};
alter table ${idl_schema}.icrm_ref_dist_cd drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_ref_dist_cd add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_ref_dist_cd partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,rg_cd  -- 地区代码
    ,rg_name  -- 地区名称
    ,city_cd  -- 市代码
    ,city_name  -- 城市名称
    ,prov_cd  -- 省代码
    ,prov_name  -- 省名称
    ,base_std_flg  -- 基础标准标志
    ,std_id  -- 标准编号
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.rg_cd,chr(13),''),chr(10),'')  -- 地区代码
    ,replace(replace(t1.rg_name,chr(13),''),chr(10),'')  -- 地区名称
    ,replace(replace(t1.city_cd,chr(13),''),chr(10),'')  -- 市代码
    ,replace(replace(t1.city_name,chr(13),''),chr(10),'')  -- 城市名称
    ,replace(replace(t1.prov_cd,chr(13),''),chr(10),'')  -- 省代码
    ,replace(replace(t1.prov_name,chr(13),''),chr(10),'')  -- 省名称
    ,replace(replace(t1.base_std_flg,chr(13),''),chr(10),'')  -- 基础标准标志
    ,replace(replace(t1.std_id,chr(13),''),chr(10),'')  -- 标准编号
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iml_schema}.ref_dist_cd t1    --行政区划代码表
where 1=1 ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_ref_dist_cd',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);