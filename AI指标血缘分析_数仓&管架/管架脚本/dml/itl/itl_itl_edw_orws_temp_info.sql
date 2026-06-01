/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_orws_temp_info
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${itl_schema}.itl_edw_orws_temp_info drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_orws_temp_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_orws_temp_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_orws_temp_info partition for (to_date('${batch_date}','yyyymmdd')) (
    id -- 
    ,name -- 
    ,employee_no -- 
    ,sex -- 
    ,folk -- 
    ,native_place -- 
    ,born_date -- 
    ,address -- 
    ,edu_degree -- 
    ,is_fulltime -- 
    ,employeement_type -- 
    ,clerk_level -- 
    ,status -- 
    ,mobile -- 
    ,organ_id -- 
    ,organ_name -- 
    ,organ_number -- 
    ,to_organ -- 
    ,to_group -- 
    ,employee_id -- 
    ,become_date -- 
    ,create_time -- 
    ,update_time -- 
    ,create_user_id -- 
    ,update_user_id -- 
    ,email -- 
    ,office_call -- 
    ,emp_no -- 
    ,ismain -- 
    ,belong_emp_no -- 
    ,external_status -- 
    ,domainid -- 
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(id), 0) as id -- 
    ,nvl(trim(name), ' ') as name -- 
    ,nvl(trim(employee_no), ' ') as employee_no -- 
    ,nvl(trim(sex), 0) as sex -- 
    ,nvl(trim(folk), 0) as folk -- 
    ,nvl(trim(native_place), ' ') as native_place -- 
    ,nvl(born_date, to_timestamp('00010101', 'yyyymmdd')) as born_date -- 
    ,nvl(trim(address), ' ') as address -- 
    ,nvl(trim(edu_degree), 0) as edu_degree -- 
    ,nvl(trim(is_fulltime), 0) as is_fulltime -- 
    ,nvl(trim(employeement_type), 0) as employeement_type -- 
    ,nvl(trim(clerk_level), ' ') as clerk_level -- 
    ,nvl(trim(status), 0) as status -- 
    ,nvl(trim(mobile), ' ') as mobile -- 
    ,nvl(trim(organ_id), 0) as organ_id -- 
    ,nvl(trim(organ_name), ' ') as organ_name -- 
    ,nvl(trim(organ_number), ' ') as organ_number -- 
    ,nvl(trim(to_organ), 0) as to_organ -- 
    ,nvl(trim(to_group), 0) as to_group -- 
    ,nvl(trim(employee_id), 0) as employee_id -- 
    ,nvl(become_date, to_timestamp('00010101', 'yyyymmdd')) as become_date -- 
    ,nvl(create_time, to_timestamp('00010101', 'yyyymmdd')) as create_time -- 
    ,nvl(update_time, to_timestamp('00010101', 'yyyymmdd')) as update_time -- 
    ,nvl(trim(create_user_id), 0) as create_user_id -- 
    ,nvl(trim(update_user_id), 0) as update_user_id -- 
    ,nvl(trim(email), ' ') as email -- 
    ,nvl(trim(office_call), ' ') as office_call -- 
    ,nvl(trim(emp_no), ' ') as emp_no -- 
    ,nvl(trim(ismain), 0) as ismain -- 
    ,nvl(trim(belong_emp_no), ' ') as belong_emp_no -- 
    ,nvl(trim(external_status), 0) as external_status -- 
    ,nvl(trim(domainid), ' ') as domainid -- 
    ,nvl(start_dt, to_date('00010101', 'yyyymmdd')) as start_dt -- 开始时间
    ,nvl(end_dt, to_date('00010101', 'yyyymmdd')) as end_dt -- 结束时间
    ,nvl(trim(id_mark), ' ') as id_mark -- 增删标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_orws_temp_info
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_orws_temp_info to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_orws_temp_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);