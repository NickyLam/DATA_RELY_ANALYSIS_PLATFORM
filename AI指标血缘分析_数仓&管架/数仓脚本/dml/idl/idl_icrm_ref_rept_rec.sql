/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_ref_rept_rec
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
alter table ${idl_schema}.icrm_ref_rept_rec drop partition p_${last_date};
alter table ${idl_schema}.icrm_ref_rept_rec drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_ref_rept_rec add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_ref_rept_rec partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,rept_id  -- 报表编号
    ,rela_obj_type  -- 关联对象类型
    ,rela_obj_id  -- 关联对象编号
    ,rept_cali  -- 报表口径
    ,model_id  -- 模型编号
    ,rept_name  -- 报表名称
    ,rept_dt  -- 报表日期
    ,create_tm  -- 创建时间
    ,create_org_id  -- 创建机构编号
    ,creator_id  -- 创建人编号
    ,update_tm  -- 更新时间
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.rept_id,chr(13),''),chr(10),'')  -- 报表编号
    ,replace(replace(t1.rela_obj_type,chr(13),''),chr(10),'')  -- 关联对象类型
    ,replace(replace(t1.rela_obj_id,chr(13),''),chr(10),'')  -- 关联对象编号
    ,replace(replace(t1.rept_cali,chr(13),''),chr(10),'')  -- 报表口径
    ,replace(replace(t1.model_id,chr(13),''),chr(10),'')  -- 模型编号
    ,replace(replace(t1.rept_name,chr(13),''),chr(10),'')  -- 报表名称
    ,replace(replace(t1.rept_dt,chr(13),''),chr(10),'')  -- 报表日期
    ,replace(replace(t1.create_tm,chr(13),''),chr(10),'')  -- 创建时间
    ,replace(replace(t1.create_org_id,chr(13),''),chr(10),'')  -- 创建机构编号
    ,replace(replace(t1.creator_id,chr(13),''),chr(10),'')  -- 创建人编号
    ,replace(replace(t1.update_tm,chr(13),''),chr(10),'')  -- 更新时间
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iml_schema}.ref_rept_rec t1    --报表记录表
where t1.create_dt<= to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_ref_rept_rec',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);