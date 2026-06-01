/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_ref_rept_model_catlg
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
alter table ${idl_schema}.icrm_ref_rept_model_catlg drop partition p_${last_date};
alter table ${idl_schema}.icrm_ref_rept_model_catlg drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_ref_rept_model_catlg add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_ref_rept_model_catlg partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,model_id  -- 模型编号
    ,model_name  -- 模型名称
    ,model_type  -- 模型类型
    ,model_descb  -- 模型描述
    ,model_abb  -- 模型缩写
    ,model_cls  -- 模型分类
    ,model_attr_1  -- 模型属性1
    ,model_attr_2  -- 模型属性2
    ,dsply_method  -- 显示方法
    ,tab_head_descb  -- 表头描述
    ,del_flg  -- 删除标志
    ,remark  -- 备注
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.model_id,chr(13),''),chr(10),'')  -- 模型编号
    ,replace(replace(t1.model_name,chr(13),''),chr(10),'')  -- 模型名称
    ,replace(replace(t1.model_type,chr(13),''),chr(10),'')  -- 模型类型
    ,replace(replace(t1.model_descb,chr(13),''),chr(10),'')  -- 模型描述
    ,replace(replace(t1.model_abb,chr(13),''),chr(10),'')  -- 模型缩写
    ,replace(replace(t1.model_cls,chr(13),''),chr(10),'')  -- 模型分类
    ,replace(replace(t1.model_attr_1,chr(13),''),chr(10),'')  -- 模型属性1
    ,replace(replace(t1.model_attr_2,chr(13),''),chr(10),'')  -- 模型属性2
    ,replace(replace(t1.dsply_method,chr(13),''),chr(10),'')  -- 显示方法
    ,replace(replace(t1.tab_head_descb,chr(13),''),chr(10),'')  -- 表头描述
    ,replace(replace(t1.del_flg,chr(13),''),chr(10),'')  -- 删除标志
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 备注
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iml_schema}.ref_rept_model_catlg t1    --报表模型目录
where t1.create_dt<= to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_ref_rept_model_catlg',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);