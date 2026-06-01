/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_orws_a_d_cm_acccode_dt
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
alter table ${idl_schema}.orws_a_d_cm_acccode_dt drop partition p_${last_date};
alter table ${idl_schema}.orws_a_d_cm_acccode_dt drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.orws_a_d_cm_acccode_dt add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.orws_a_d_cm_acccode_dt partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,date_id  -- 会计日期
    ,acc_code  -- 科目编码
    ,acc_name  -- 科目名称
    ,acc_level  -- 科目层级
    ,parent_id  -- 父级科目编码
    ,in_out_flag  -- 表内表外标志
    ,acc_blncdn  -- 科目方向
    ,detail_flag  -- 明细科目标志
    ,profit_flag  -- 损益项目标志
    ,acc_sour  -- 科目来源分类
    ,acc_tg  -- 科目性质
    ,overdraw_flag  -- 允许透支标志
    ,bal_tg  -- 余额性质
    ,bak_1  -- 备用字段1
    ,bak_2  -- 备用字段2
    ,bak_3  -- 备用字段3
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd')  -- ETL处理日期
    ,replace(replace(date_id,chr(13),''),chr(10),'')  -- 会计日期
    ,replace(replace(acc_code,chr(13),''),chr(10),'')  -- 科目编码
    ,replace(replace(acc_name,chr(13),''),chr(10),'')  -- 科目名称
    ,acc_level  -- 科目层级
    ,replace(replace(rtrim(parent_id),chr(13),''),chr(10),'')  -- 父级科目编码
    ,replace(replace(in_out_flag,chr(13),''),chr(10),'')  -- 表内表外标志
    ,replace(replace(rtrim(acc_blncdn),chr(13),''),chr(10),'')  -- 科目方向
    ,replace(replace(detail_flag,chr(13),''),chr(10),'')  -- 明细科目标志
    ,replace(replace(rtrim(profit_flag),chr(13),''),chr(10),'')  -- 损益项目标志
    ,replace(replace(rtrim(acc_sour),chr(13),''),chr(10),'')  -- 科目来源分类
    ,replace(replace(rtrim(acc_tg),chr(13),''),chr(10),'')  -- 科目性质
    ,replace(replace(overdraw_flag,chr(13),''),chr(10),'')  -- 允许透支标志
    ,replace(replace(bal_tg,chr(13),''),chr(10),'')  -- 余额性质
    ,replace(replace(rtrim(bak_1),chr(13),''),chr(10),'')  -- 备用字段1
    ,replace(replace(rtrim(bak_2),chr(13),''),chr(10),'')  -- 备用字段2
    ,replace(replace(rtrim(bak_3),chr(13),''),chr(10),'')  -- 备用字段3
    ,replace(replace(rtrim(''),chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- ETL处理时间戳
 from ${idl_schema}.a_d_cm_acccode_dt
where etl_dt=to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'orws_a_d_cm_acccode_dt',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);