/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_orws_t_problem_info
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
alter table ${itl_schema}.itl_edw_orws_t_problem_info drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_orws_t_problem_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_orws_t_problem_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_orws_t_problem_info partition for (to_date('${batch_date}','yyyymmdd')) (
    id -- 
    ,biztype -- 
    ,node_name -- 
    ,inst_no -- 
    ,chkdept -- 
    ,organid -- 
    ,task_organ -- 
    ,bigtype_id -- 
    ,smalltype_id -- 
    ,biz_date -- 
    ,check_time -- 
    ,chktitle -- 
    ,chkperson -- 
    ,problemer -- 
    ,problemstate -- 
    ,problem_detail_action -- 
    ,problem_biz_id -- 
    ,serinum -- 
    ,rectified_serinum -- 
    ,prbinfo -- 
    ,remarks -- 
    ,is_emp_resp -- 
    ,is_debit_resp -- 
    ,is_credit_resp -- 
    ,approve_type -- 
    ,rectify_deadline -- 
    ,prb_org_first_desc -- 
    ,pro_idtf -- 
    ,org_res_date -- 
    ,confirm_desc -- 
    ,approve_status -- 
    ,risk_level -- 
    ,approve_date -- 
    ,upgrade_date -- 
    ,is_overdue -- 
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(id), 0) as id -- 
    ,nvl(trim(biztype), 0) as biztype -- 
    ,nvl(trim(node_name), ' ') as node_name -- 
    ,nvl(trim(inst_no), ' ') as inst_no -- 
    ,nvl(trim(chkdept), ' ') as chkdept -- 
    ,nvl(trim(organid), 0) as organid -- 
    ,nvl(trim(task_organ), 0) as task_organ -- 
    ,nvl(trim(bigtype_id), 0) as bigtype_id -- 
    ,nvl(trim(smalltype_id), 0) as smalltype_id -- 
    ,nvl(biz_date, to_timestamp('00010101', 'yyyymmdd')) as biz_date -- 
    ,nvl(check_time, to_timestamp('00010101', 'yyyymmdd')) as check_time -- 
    ,nvl(trim(chktitle), ' ') as chktitle -- 
    ,nvl(trim(chkperson), 0) as chkperson -- 
    ,nvl(trim(problemer), 0) as problemer -- 
    ,nvl(trim(problemstate), 0) as problemstate -- 
    ,nvl(trim(problem_detail_action), ' ') as problem_detail_action -- 
    ,nvl(trim(problem_biz_id), ' ') as problem_biz_id -- 
    ,nvl(trim(serinum), ' ') as serinum -- 
    ,nvl(trim(rectified_serinum), ' ') as rectified_serinum -- 
    ,nvl(trim(prbinfo), ' ') as prbinfo -- 
    ,nvl(trim(remarks), ' ') as remarks -- 
    ,nvl(trim(is_emp_resp), 0) as is_emp_resp -- 
    ,nvl(trim(is_debit_resp), 0) as is_debit_resp -- 
    ,nvl(trim(is_credit_resp), 0) as is_credit_resp -- 
    ,nvl(trim(approve_type), ' ') as approve_type -- 
    ,nvl(rectify_deadline, to_timestamp('00010101', 'yyyymmdd')) as rectify_deadline -- 
    ,nvl(trim(prb_org_first_desc), ' ') as prb_org_first_desc -- 
    ,nvl(trim(pro_idtf), ' ') as pro_idtf -- 
    ,nvl(org_res_date, to_timestamp('00010101', 'yyyymmdd')) as org_res_date -- 
    ,nvl(trim(confirm_desc), ' ') as confirm_desc -- 
    ,nvl(trim(approve_status), 0) as approve_status -- 
    ,nvl(trim(risk_level), 0) as risk_level -- 
    ,nvl(approve_date, to_timestamp('00010101', 'yyyymmdd')) as approve_date -- 
    ,nvl(upgrade_date, to_timestamp('00010101', 'yyyymmdd')) as upgrade_date -- 
    ,nvl(trim(is_overdue), 0) as is_overdue -- 
    ,nvl(start_dt, to_date('00010101', 'yyyymmdd')) as start_dt -- 开始时间
    ,nvl(end_dt, to_date('00010101', 'yyyymmdd')) as end_dt -- 结束时间
    ,nvl(trim(id_mark), ' ') as id_mark -- 增删标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_orws_t_problem_info
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_orws_t_problem_info to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_orws_t_problem_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);