/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_ref_postn_para
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
alter table ${idl_schema}.aml_ref_postn_para drop partition p_${last_date};
alter table ${idl_schema}.aml_ref_postn_para drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_ref_postn_para add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_ref_postn_para partition for (to_date('${batch_date}','yyyymmdd')) (
    post_id  -- 岗位编号
    ,org_id  -- 机构编号
    ,post_name  -- 岗位名称
    ,base_post_flg  -- 基准岗位标志
    ,strip_line_id  -- 条线编号
    ,order_id  -- 序列编号
    ,type_cd  -- 类型代码
    ,status_cd  -- 状态代码
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,etl_dt  -- 数据日期
    ,id_mark  -- 删除标识
    ,src_table_name  -- 源表名称
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    replace(replace(t1.post_id,chr(13),''),chr(10),'')  -- 岗位编号
    ,replace(replace(t1.org_id,chr(13),''),chr(10),'')  -- 机构编号
    ,replace(replace(t1.post_name,chr(13),''),chr(10),'')  -- 岗位名称
    ,replace(replace(t1.base_post_flg,chr(13),''),chr(10),'')  -- 基准岗位标志
    ,replace(replace(t1.strip_line_id,chr(13),''),chr(10),'')  -- 条线编号
    ,replace(replace(t1.order_id,chr(13),''),chr(10),'')  -- 序列编号
    ,replace(replace(t1.type_cd,chr(13),''),chr(10),'')  -- 类型代码
    ,replace(replace(t1.status_cd,chr(13),''),chr(10),'')  -- 状态代码
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.src_table_name,chr(13),''),chr(10),'')  -- 源表名称
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,t1.etl_timestamp  -- 数据处理时间
from ${iml_schema}.ref_postn_para t1    --职位参数
where t1.create_dt <=to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_ref_postn_para',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);