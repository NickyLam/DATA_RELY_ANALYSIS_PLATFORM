/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_orws_t_emp_info
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
--alter table ${itl_schema}.itl_edw_orws_t_emp_info drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_orws_t_emp_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_orws_t_emp_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_orws_t_emp_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 
    ,id  -- 
    ,employeeinfo  -- 
    ,name  -- 
    ,sex  -- 
    ,born_date  -- 
    ,marriage  -- 
    ,office_call  -- 
    ,mobile  -- 
    ,isservice  -- 
    ,to_organ  -- 
    ,emp_no  -- 
    ,teller_no  -- 
    ,job_date  -- 
    ,become_date  -- 
    ,emptype  -- 
    ,status  -- 
    ,dimission_date  -- 
    ,position  -- 
    ,teller_level  -- 
    ,position_type  -- 
    ,service_date  -- 
    ,workroom  -- 
    ,speciality  -- 
    ,create_time  -- 
    ,update_time  -- 
    ,create_emp  -- 
    ,update_emp  -- 
    ,address  -- 
    ,etl_timestamp  -- 
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,t1.id  -- 
    ,t1.employeeinfo  -- 
    ,replace(replace(t1.name,chr(13),''),chr(10),'')  -- 
    ,t1.sex  -- 
    ,t1.born_date  -- 
    ,replace(replace(t1.marriage,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.office_call,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.mobile,chr(13),''),chr(10),'')  -- 
    ,t1.isservice  -- 
    ,t1.to_organ  -- 
    ,replace(replace(t1.emp_no,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.teller_no,chr(13),''),chr(10),'')  -- 
    ,t1.job_date  -- 
    ,t1.become_date  -- 
    ,t1.emptype  -- 
    ,t1.status  -- 
    ,t1.dimission_date  -- 
    ,t1.position  -- 
    ,t1.teller_level  -- 
    ,t1.position_type  -- 
    ,t1.service_date  -- 
    ,replace(replace(t1.workroom,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.speciality,chr(13),''),chr(10),'')  -- 
    ,t1.create_time  -- 
    ,t1.update_time  -- 
    ,t1.create_emp  -- 
    ,t1.update_emp  -- 
    ,replace(replace(t1.address,chr(13),''),chr(10),'')  -- 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from ${msl_schema}.msl_edw_orws_t_emp_info t1    --职业生涯个人信息表
where  etl_dt = to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_orws_t_emp_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);