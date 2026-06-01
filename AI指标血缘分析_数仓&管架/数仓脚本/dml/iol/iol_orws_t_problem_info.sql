/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_orws_t_problem_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.orws_t_problem_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.orws_t_problem_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orws_t_problem_info_op purge;
drop table ${iol_schema}.orws_t_problem_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orws_t_problem_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orws_t_problem_info where 0=1;

create table ${iol_schema}.orws_t_problem_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orws_t_problem_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orws_t_problem_info_cl(
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
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orws_t_problem_info_op(
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
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.biztype, o.biztype) as biztype -- 
    ,nvl(n.node_name, o.node_name) as node_name -- 
    ,nvl(n.inst_no, o.inst_no) as inst_no -- 
    ,nvl(n.chkdept, o.chkdept) as chkdept -- 
    ,nvl(n.organid, o.organid) as organid -- 
    ,nvl(n.task_organ, o.task_organ) as task_organ -- 
    ,nvl(n.bigtype_id, o.bigtype_id) as bigtype_id -- 
    ,nvl(n.smalltype_id, o.smalltype_id) as smalltype_id -- 
    ,nvl(n.biz_date, o.biz_date) as biz_date -- 
    ,nvl(n.check_time, o.check_time) as check_time -- 
    ,nvl(n.chktitle, o.chktitle) as chktitle -- 
    ,nvl(n.chkperson, o.chkperson) as chkperson -- 
    ,nvl(n.problemer, o.problemer) as problemer -- 
    ,nvl(n.problemstate, o.problemstate) as problemstate -- 
    ,nvl(n.problem_detail_action, o.problem_detail_action) as problem_detail_action -- 
    ,nvl(n.problem_biz_id, o.problem_biz_id) as problem_biz_id -- 
    ,nvl(n.serinum, o.serinum) as serinum -- 
    ,nvl(n.rectified_serinum, o.rectified_serinum) as rectified_serinum -- 
    ,nvl(n.prbinfo, o.prbinfo) as prbinfo -- 
    ,nvl(n.remarks, o.remarks) as remarks -- 
    ,nvl(n.is_emp_resp, o.is_emp_resp) as is_emp_resp -- 
    ,nvl(n.is_debit_resp, o.is_debit_resp) as is_debit_resp -- 
    ,nvl(n.is_credit_resp, o.is_credit_resp) as is_credit_resp -- 
    ,nvl(n.approve_type, o.approve_type) as approve_type -- 
    ,nvl(n.rectify_deadline, o.rectify_deadline) as rectify_deadline -- 
    ,nvl(n.prb_org_first_desc, o.prb_org_first_desc) as prb_org_first_desc -- 
    ,nvl(n.pro_idtf, o.pro_idtf) as pro_idtf -- 
    ,nvl(n.org_res_date, o.org_res_date) as org_res_date -- 
    ,nvl(n.confirm_desc, o.confirm_desc) as confirm_desc -- 
    ,nvl(n.approve_status, o.approve_status) as approve_status -- 
    ,nvl(n.risk_level, o.risk_level) as risk_level -- 
    ,nvl(n.approve_date, o.approve_date) as approve_date -- 
    ,nvl(n.upgrade_date, o.upgrade_date) as upgrade_date -- 
    ,nvl(n.is_overdue, o.is_overdue) as is_overdue -- 
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.orws_t_problem_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.orws_t_problem_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.biztype <> n.biztype
        or o.node_name <> n.node_name
        or o.inst_no <> n.inst_no
        or o.chkdept <> n.chkdept
        or o.organid <> n.organid
        or o.task_organ <> n.task_organ
        or o.bigtype_id <> n.bigtype_id
        or o.smalltype_id <> n.smalltype_id
        or o.biz_date <> n.biz_date
        or o.check_time <> n.check_time
        or o.chktitle <> n.chktitle
        or o.chkperson <> n.chkperson
        or o.problemer <> n.problemer
        or o.problemstate <> n.problemstate
        or o.problem_detail_action <> n.problem_detail_action
        or o.problem_biz_id <> n.problem_biz_id
        or o.serinum <> n.serinum
        or o.rectified_serinum <> n.rectified_serinum
        or o.prbinfo <> n.prbinfo
        or o.remarks <> n.remarks
        or o.is_emp_resp <> n.is_emp_resp
        or o.is_debit_resp <> n.is_debit_resp
        or o.is_credit_resp <> n.is_credit_resp
        or o.approve_type <> n.approve_type
        or o.rectify_deadline <> n.rectify_deadline
        or o.prb_org_first_desc <> n.prb_org_first_desc
        or o.pro_idtf <> n.pro_idtf
        or o.org_res_date <> n.org_res_date
        or o.confirm_desc <> n.confirm_desc
        or o.approve_status <> n.approve_status
        or o.risk_level <> n.risk_level
        or o.approve_date <> n.approve_date
        or o.upgrade_date <> n.upgrade_date
        or o.is_overdue <> n.is_overdue
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orws_t_problem_info_cl(
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
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orws_t_problem_info_op(
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
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.biztype -- 
    ,o.node_name -- 
    ,o.inst_no -- 
    ,o.chkdept -- 
    ,o.organid -- 
    ,o.task_organ -- 
    ,o.bigtype_id -- 
    ,o.smalltype_id -- 
    ,o.biz_date -- 
    ,o.check_time -- 
    ,o.chktitle -- 
    ,o.chkperson -- 
    ,o.problemer -- 
    ,o.problemstate -- 
    ,o.problem_detail_action -- 
    ,o.problem_biz_id -- 
    ,o.serinum -- 
    ,o.rectified_serinum -- 
    ,o.prbinfo -- 
    ,o.remarks -- 
    ,o.is_emp_resp -- 
    ,o.is_debit_resp -- 
    ,o.is_credit_resp -- 
    ,o.approve_type -- 
    ,o.rectify_deadline -- 
    ,o.prb_org_first_desc -- 
    ,o.pro_idtf -- 
    ,o.org_res_date -- 
    ,o.confirm_desc -- 
    ,o.approve_status -- 
    ,o.risk_level -- 
    ,o.approve_date -- 
    ,o.upgrade_date -- 
    ,o.is_overdue -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.orws_t_problem_info_bk o
    left join ${iol_schema}.orws_t_problem_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.orws_t_problem_info_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.orws_t_problem_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('orws_t_problem_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.orws_t_problem_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.orws_t_problem_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.orws_t_problem_info exchange partition p_${batch_date} with table ${iol_schema}.orws_t_problem_info_cl;
alter table ${iol_schema}.orws_t_problem_info exchange partition p_20991231 with table ${iol_schema}.orws_t_problem_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.orws_t_problem_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orws_t_problem_info_op purge;
drop table ${iol_schema}.orws_t_problem_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.orws_t_problem_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'orws_t_problem_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
