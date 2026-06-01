/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_prd_product
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
--alter table ${idl_schema}.prd_product drop partition p_${last_date};
alter table ${idl_schema}.prd_product drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.prd_product add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.prd_product (
    etl_dt  -- 数据日期
    ,prod_id  -- 产品编号
    ,lp_id  -- 法人编号
    ,prod_name  -- 产品名称
    ,prod_descb  -- 产品描述
    ,prod_type_cd  -- 产品类型代码
    ,self_own_prod_flg  -- 自有产品标志
    ,sellbl_prod_flg  -- 可售产品标志
    ,prod_effect_dt  -- 产品生效日期
    ,prod_invalid_dt  -- 产品失效日期
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,job_cd -- 任务编码
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.prod_id,chr(13),''),chr(10),'')  -- 产品编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.prod_name,chr(13),''),chr(10),'')  -- 产品名称
    ,replace(replace(t1.prod_descb,chr(13),''),chr(10),'')  -- 产品描述
    ,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'')  -- 产品类型代码
    ,replace(replace(t1.self_own_prod_flg,chr(13),''),chr(10),'')  -- 自有产品标志
    ,replace(replace(t1.sellbl_prod_flg,chr(13),''),chr(10),'')  -- 可售产品标志
    ,t1.prod_effect_dt  -- 产品生效日期
    ,t1.prod_invalid_dt  -- 产品失效日期
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务编码
from ${iml_schema}.prd_product t1    --产品
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'prd_product',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);