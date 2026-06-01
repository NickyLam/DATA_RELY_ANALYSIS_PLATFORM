/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_ref_emply_post_para
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
alter table ${idl_schema}.aml_ref_emply_post_para drop partition p_${last_date};
alter table ${idl_schema}.aml_ref_emply_post_para drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_ref_emply_post_para add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_ref_emply_post_para partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,post_id  -- 职务编号
    ,lp_id  -- 法人编号
    ,post_name  -- 职务名称
    ,post_cate_id  -- 职务类别编号
    ,start_use_status_flg  -- 启用状态标志
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.post_id,chr(13),''),chr(10),'')  -- 职务编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.post_name,chr(13),''),chr(10),'')  -- 职务名称
    ,replace(replace(t1.post_cate_id,chr(13),''),chr(10),'')  -- 职务类别编号
    ,replace(replace(t1.start_use_status_flg,chr(13),''),chr(10),'')  -- 启用状态标志
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iml_schema}.ref_emply_post_para t1    --员工职务参数
where t1.create_dt <=to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_ref_emply_post_para',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);