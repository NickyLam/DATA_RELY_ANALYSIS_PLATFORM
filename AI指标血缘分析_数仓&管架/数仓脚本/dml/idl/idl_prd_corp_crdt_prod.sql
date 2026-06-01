/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_prd_corp_crdt_prod
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
--alter table ${idl_schema}.prd_corp_crdt_prod drop partition p_${last_date};
alter table ${idl_schema}.prd_corp_crdt_prod drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.prd_corp_crdt_prod add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.prd_corp_crdt_prod (
    etl_dt  -- 数据日期
    ,prod_id  -- 产品编号
    ,lp_id  -- 法人编号
    ,src_prod_id  -- 源产品编号
    ,prod_name  -- 产品名称
    ,input_org_id  -- 录入机构编号
    ,input_tm  -- 录入时间
    ,prod_update_tm  -- 产品更新时间
    ,sellbl_prod_flg  -- 可售产品标志
    ,loan_size_ctrl_flg  -- 贷款规模控制标志
    ,prod_catlg_id  -- 产品目录编号
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,job_cd -- 任务编码
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.prod_id,chr(13),''),chr(10),'')  -- 产品编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.src_prod_id,chr(13),''),chr(10),'')  -- 源产品编号
    ,replace(replace(t1.prod_name,chr(13),''),chr(10),'')  -- 产品名称
    ,replace(replace(t1.input_org_id,chr(13),''),chr(10),'')  -- 录入机构编号
    ,t1.input_tm  -- 录入时间
    ,t1.prod_update_tm  -- 产品更新时间
    ,replace(replace(t1.sellbl_prod_flg,chr(13),''),chr(10),'')  -- 可售产品标志
    ,replace(replace(t1.loan_size_ctrl_flg,chr(13),''),chr(10),'')  -- 贷款规模控制标志
    ,replace(replace(t1.prod_catlg_id,chr(13),''),chr(10),'')  -- 产品目录编号
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务编码
from ${iml_schema}.prd_corp_crdt_prod t1    --对公信贷产品
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'prd_corp_crdt_prod',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);