/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_orws_t_emp_edu_resume
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
alter table ${itl_schema}.itl_edw_orws_t_emp_edu_resume drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_orws_t_emp_edu_resume drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_orws_t_emp_edu_resume add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_orws_t_emp_edu_resume partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 
    ,id  -- 
    ,emp_info  -- 
    ,begin_date  -- 
    ,end_date  -- 
    ,university  -- 
    ,profession  -- 
    ,academic  -- 
    ,degree  -- 
    ,is_fulltime  -- 
    ,creator  -- 
    ,editor  -- 
    ,create_time  -- 
    ,edit_time  -- 
    ,is_economics  -- 
    ,etl_timestamp  -- 
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,t1.id  -- 
    ,t1.emp_info  -- 
    ,t1.begin_date  -- 
    ,t1.end_date  -- 
    ,replace(replace(t1.university,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.profession,chr(13),''),chr(10),'')  -- 
    ,t1.academic  -- 
    ,t1.degree  -- 
    ,t1.is_fulltime  -- 
    ,t1.creator  -- 
    ,t1.editor  -- 
    ,t1.create_time  -- 
    ,t1.edit_time  -- 
    ,t1.is_economics  -- 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from ${msl_schema}.msl_edw_orws_t_emp_edu_resume t1    --员工教育简历表
where  1=1 ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_orws_t_emp_edu_resume',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);