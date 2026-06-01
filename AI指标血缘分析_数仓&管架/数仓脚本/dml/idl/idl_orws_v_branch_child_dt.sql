/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_orws_v_branch_child_dt
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
alter table ${idl_schema}.orws_v_branch_child_dt drop partition p_${last_date};
alter table ${idl_schema}.orws_v_branch_child_dt drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.orws_v_branch_child_dt add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.orws_v_branch_child_dt partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,branch_code  -- 机构编码
    ,child_code  -- 下级机构编码
    ,branch_name  -- 机构名称
    ,up_org  -- 上级机构编码
    ,lev  -- 机构层级
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd')  -- ETL处理日期
    ,replace(replace(rtrim(branch_code),chr(13),''),chr(10),'')  -- 机构编码
    ,replace(replace(rtrim(child_code),chr(13),''),chr(10),'')  -- 下级机构编码
    ,replace(replace(rtrim(branch_name),chr(13),''),chr(10),'')  -- 机构名称
    ,replace(replace(rtrim(up_org),chr(13),''),chr(10),'')  -- 上级机构编码
    ,replace(replace(rtrim(lev),chr(13),''),chr(10),'')  -- 机构层级
    ,replace(replace(rtrim(''),chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- ETL处理时间戳
 from ${idl_schema}.t_branch_child_dt
where etl_dt=to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'orws_v_branch_child_dt',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);