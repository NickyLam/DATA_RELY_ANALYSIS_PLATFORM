/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_ref_rept_data
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
alter table ${idl_schema}.icrm_ref_rept_data drop partition p_${last_date};
alter table ${idl_schema}.icrm_ref_rept_data drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_ref_rept_data add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_ref_rept_data partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,rept_id  -- 报表编号
    ,row_id  -- 行编号
    ,row_name  -- 行名称
    ,cors_subj_id  -- 对应科目编号
    ,dsply_seq_no  -- 显示次序
    ,row_dimen_type  -- 行量纲类型
    ,row_attr  -- 行属性
    ,col_1_val  -- 列1值
    ,col_2_val  -- 列2值
    ,col_3_val  -- 列3值
    ,col_4_val  -- 列4值
    ,std_val  -- 标准值
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.rept_id,chr(13),''),chr(10),'')  -- 报表编号
    ,replace(replace(t1.row_id,chr(13),''),chr(10),'')  -- 行编号
    ,replace(replace(t1.row_name,chr(13),''),chr(10),'')  -- 行名称
    ,replace(replace(t1.cors_subj_id,chr(13),''),chr(10),'')  -- 对应科目编号
    ,replace(replace(t1.dsply_seq_no,chr(13),''),chr(10),'')  -- 显示次序
    ,replace(replace(t1.row_dimen_type,chr(13),''),chr(10),'')  -- 行量纲类型
    ,replace(replace(t1.row_attr,chr(13),''),chr(10),'')  -- 行属性
    ,t1.col_1_val  -- 列1值
    ,t1.col_2_val  -- 列2值
    ,t1.col_3_val  -- 列3值
    ,t1.col_4_val  -- 列4值
    ,t1.std_val  -- 标准值
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iml_schema}.ref_rept_data t1    --报表数据
where t1.create_dt<= to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_ref_rept_data',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);