/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_ref_ibank_asset_cls
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
alter table ${idl_schema}.icrm_ref_ibank_asset_cls drop partition p_${last_date};
alter table ${idl_schema}.icrm_ref_ibank_asset_cls drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_ref_ibank_asset_cls add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_ref_ibank_asset_cls partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,prod_cls_id  -- 产品分类编号
    ,lp_id  -- 法人编号
    ,asset_type_id  -- 资产类型编号
    ,prod_cls_name  -- 产品分类名称
    ,prod_type_id  -- 产品类型编号
    ,prod_type_name  -- 产品类型名称
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.prod_cls_id,chr(13),''),chr(10),'')  -- 产品分类编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.asset_type_id,chr(13),''),chr(10),'')  -- 资产类型编号
    ,replace(replace(t1.prod_cls_name,chr(13),''),chr(10),'')  -- 产品分类名称
    ,replace(replace(t1.prod_type_id,chr(13),''),chr(10),'')  -- 产品类型编号
    ,replace(replace(t1.prod_type_name,chr(13),''),chr(10),'')  -- 产品类型名称
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iml_schema}.ref_ibank_asset_cls t1    --同业资产分类
where t1.create_dt<= to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_ref_ibank_asset_cls',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);