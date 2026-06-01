/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_orws_a_d_cm_branch_dt
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
alter table ${idl_schema}.orws_a_d_cm_branch_dt drop partition p_${last_date};
alter table ${idl_schema}.orws_a_d_cm_branch_dt drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.orws_a_d_cm_branch_dt add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.orws_a_d_cm_branch_dt partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,date_id  -- 会计日期
    ,branch_code  -- 机构编码
    ,branch_name  -- 机构名称
    ,short_name  -- 机构简称
    ,branch_tp  -- 机构类型
    ,branch_level  -- 机构级别
    ,parent_id  -- 父级机构编码
    ,start_date  -- 启用日期
    ,end_date  -- 禁用日期
    ,city_code  -- 分行行号
    ,brch_level  -- 部门级别
    ,bak_1  -- 备用字段1
    ,bak_2  -- 备用字段2
    ,bak_3  -- 备用字段3
    ,oth_brch_tg  -- 他行标志
    ,corp_code  -- 法人行号
    ,brch_acct_tg  -- 是否账务部门
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd')  -- ETL处理日期
    ,replace(replace(date_id,chr(13),''),chr(10),'')  -- 会计日期
    ,replace(replace(branch_code,chr(13),''),chr(10),'')  -- 机构编码
    ,replace(replace(rtrim(branch_name),chr(13),''),chr(10),'')  -- 机构名称
    ,replace(replace(rtrim(short_name),chr(13),''),chr(10),'')  -- 机构简称
    ,replace(replace(rtrim(branch_tp),chr(13),''),chr(10),'')  -- 机构类型
    ,branch_level  -- 机构级别
    ,replace(replace(rtrim(parent_id),chr(13),''),chr(10),'')  -- 父级机构编码
    ,replace(replace(rtrim(start_date),chr(13),''),chr(10),'')  -- 启用日期
    ,replace(replace(rtrim(end_date),chr(13),''),chr(10),'')  -- 禁用日期
    ,replace(replace(rtrim(city_code),chr(13),''),chr(10),'')  -- 分行行号
    ,replace(replace(rtrim(brch_level),chr(13),''),chr(10),'')  -- 部门级别
    ,replace(replace(rtrim(bak_1),chr(13),''),chr(10),'')  -- 备用字段1
    ,replace(replace(rtrim(bak_2),chr(13),''),chr(10),'')  -- 备用字段2
    ,replace(replace(rtrim(bak_3),chr(13),''),chr(10),'')  -- 备用字段3
    ,replace(replace(rtrim(oth_brch_tg),chr(13),''),chr(10),'')  -- 他行标志
    ,replace(replace(rtrim(corp_code),chr(13),''),chr(10),'')  -- 法人行号
    ,replace(replace(rtrim(brch_acct_tg),chr(13),''),chr(10),'')  -- 是否账务部门
    ,replace(replace(rtrim(''),chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- ETL处理时间戳
 from ${idl_schema}.a_d_cm_branch_dt
where etl_dt=to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'orws_a_d_cm_branch_dt',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);