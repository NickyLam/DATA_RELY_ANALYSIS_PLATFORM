/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_ref_indus_type_cd
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
alter table ${idl_schema}.icrm_ref_indus_type_cd drop partition p_${last_date};
alter table ${idl_schema}.icrm_ref_indus_type_cd drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_ref_indus_type_cd add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_ref_indus_type_cd partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,indus_type_cd  -- 行业类型代码
    ,indus_type_name  -- 行业类型名称
    ,indus_cate_cd  -- 行业类别代码
    ,indus_cate_name  -- 行业类别名称
    ,indus_gen_cd  -- 行业大类代码
    ,indus_gen_name  -- 行业大类名称
    ,indus_categy_cd  -- 行业门类代码
    ,indus_categy_name  -- 行业门类名称
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.indus_type_cd,chr(13),''),chr(10),'')  -- 行业类型代码
    ,replace(replace(t1.indus_type_name,chr(13),''),chr(10),'')  -- 行业类型名称
    ,replace(replace(t1.indus_cate_cd,chr(13),''),chr(10),'')  -- 行业类别代码
    ,replace(replace(t1.indus_cate_name,chr(13),''),chr(10),'')  -- 行业类别名称
    ,replace(replace(t1.indus_gen_cd,chr(13),''),chr(10),'')  -- 行业大类代码
    ,replace(replace(t1.indus_gen_name,chr(13),''),chr(10),'')  -- 行业大类名称
    ,replace(replace(t1.indus_categy_cd,chr(13),''),chr(10),'')  -- 行业门类代码
    ,replace(replace(t1.indus_categy_name,chr(13),''),chr(10),'')  -- 行业门类名称
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iml_schema}.ref_indus_type_cd t1    --行业类型代码表
where 1=1 ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_ref_indus_type_cd',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);