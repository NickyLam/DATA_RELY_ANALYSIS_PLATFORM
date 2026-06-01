/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_orws_tmm_result
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
alter table ${itl_schema}.itl_edw_orws_tmm_result drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_orws_tmm_result drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_orws_tmm_result add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_orws_tmm_result partition for (to_date('${batch_date}','yyyymmdd')) (
    id -- 
    ,commissioning_id -- 
    ,biz_date -- 
    ,biz_organ_id -- 
    ,biz_emp_no -- 
    ,img_info -- 
    ,found_date -- 
    ,handle_date -- 
    ,handle_user_id -- 
    ,handle_position_id -- 
    ,handle_organ_id -- 
    ,handle_result -- 
    ,biz_info -- 
    ,cancel_reason -- 
    ,problem_id -- 
    ,problem_state -- 
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(id), 0) as id -- 
    ,nvl(trim(commissioning_id), 0) as commissioning_id -- 
    ,nvl(biz_date, to_timestamp('00010101', 'yyyymmdd')) as biz_date -- 
    ,nvl(trim(biz_organ_id), 0) as biz_organ_id -- 
    ,nvl(trim(biz_emp_no), ' ') as biz_emp_no -- 
    ,nvl(trim(img_info), ' ') as img_info -- 
    ,nvl(found_date, to_timestamp('00010101', 'yyyymmdd')) as found_date -- 
    ,nvl(handle_date, to_timestamp('00010101', 'yyyymmdd')) as handle_date -- 
    ,nvl(trim(handle_user_id), 0) as handle_user_id -- 
    ,nvl(trim(handle_position_id), 0) as handle_position_id -- 
    ,nvl(trim(handle_organ_id), 0) as handle_organ_id -- 
    ,nvl(trim(handle_result), 0) as handle_result -- 
    ,nvl(trim(biz_info), ' ') as biz_info -- 
    ,nvl(trim(cancel_reason), ' ') as cancel_reason -- 
    ,nvl(trim(problem_id), 0) as problem_id -- 
    ,nvl(trim(problem_state), 0) as problem_state -- 
    ,nvl(start_dt, to_date('00010101', 'yyyymmdd')) as start_dt -- 开始时间
    ,nvl(end_dt, to_date('00010101', 'yyyymmdd')) as end_dt -- 结束时间
    ,nvl(trim(id_mark), ' ') as id_mark -- 增删标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_orws_tmm_result
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_orws_tmm_result to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_orws_tmm_result',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);