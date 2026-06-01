/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol orws_t_problem_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.orws_t_problem_info
whenever sqlerror continue none;
drop table ${iol_schema}.orws_t_problem_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orws_t_problem_info(
    id number(18,0) -- 
    ,biztype number(18,0) -- 
    ,node_name varchar2(300) -- 
    ,inst_no varchar2(135) -- 
    ,chkdept varchar2(150) -- 
    ,organid number(18,0) -- 
    ,task_organ number(18,0) -- 
    ,bigtype_id number(18,0) -- 
    ,smalltype_id number(18,0) -- 
    ,biz_date timestamp -- 
    ,check_time timestamp -- 
    ,chktitle varchar2(315) -- 
    ,chkperson number(18,0) -- 
    ,problemer number(18,0) -- 
    ,problemstate number(1,0) -- 
    ,problem_detail_action varchar2(300) -- 
    ,problem_biz_id varchar2(300) -- 
    ,serinum varchar2(383) -- 
    ,rectified_serinum varchar2(383) -- 
    ,prbinfo varchar2(4000) -- 
    ,remarks varchar2(4000) -- 
    ,is_emp_resp number(1,0) -- 
    ,is_debit_resp number(1,0) -- 
    ,is_credit_resp number(1,0) -- 
    ,approve_type varchar2(27) -- 
    ,rectify_deadline timestamp -- 
    ,prb_org_first_desc varchar2(4000) -- 
    ,pro_idtf varchar2(4000) -- 
    ,org_res_date timestamp -- 
    ,confirm_desc varchar2(4000) -- 
    ,approve_status number(1,0) -- 
    ,risk_level number(1,0) -- 
    ,approve_date timestamp -- 
    ,upgrade_date timestamp -- 
    ,is_overdue number(1,0) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.orws_t_problem_info to ${iml_schema};
grant select on ${iol_schema}.orws_t_problem_info to ${icl_schema};
grant select on ${iol_schema}.orws_t_problem_info to ${idl_schema};
grant select on ${iol_schema}.orws_t_problem_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.orws_t_problem_info is '问题主信息表';
comment on column ${iol_schema}.orws_t_problem_info.id is '';
comment on column ${iol_schema}.orws_t_problem_info.biztype is '';
comment on column ${iol_schema}.orws_t_problem_info.node_name is '';
comment on column ${iol_schema}.orws_t_problem_info.inst_no is '';
comment on column ${iol_schema}.orws_t_problem_info.chkdept is '';
comment on column ${iol_schema}.orws_t_problem_info.organid is '';
comment on column ${iol_schema}.orws_t_problem_info.task_organ is '';
comment on column ${iol_schema}.orws_t_problem_info.bigtype_id is '';
comment on column ${iol_schema}.orws_t_problem_info.smalltype_id is '';
comment on column ${iol_schema}.orws_t_problem_info.biz_date is '';
comment on column ${iol_schema}.orws_t_problem_info.check_time is '';
comment on column ${iol_schema}.orws_t_problem_info.chktitle is '';
comment on column ${iol_schema}.orws_t_problem_info.chkperson is '';
comment on column ${iol_schema}.orws_t_problem_info.problemer is '';
comment on column ${iol_schema}.orws_t_problem_info.problemstate is '';
comment on column ${iol_schema}.orws_t_problem_info.problem_detail_action is '';
comment on column ${iol_schema}.orws_t_problem_info.problem_biz_id is '';
comment on column ${iol_schema}.orws_t_problem_info.serinum is '';
comment on column ${iol_schema}.orws_t_problem_info.rectified_serinum is '';
comment on column ${iol_schema}.orws_t_problem_info.prbinfo is '';
comment on column ${iol_schema}.orws_t_problem_info.remarks is '';
comment on column ${iol_schema}.orws_t_problem_info.is_emp_resp is '';
comment on column ${iol_schema}.orws_t_problem_info.is_debit_resp is '';
comment on column ${iol_schema}.orws_t_problem_info.is_credit_resp is '';
comment on column ${iol_schema}.orws_t_problem_info.approve_type is '';
comment on column ${iol_schema}.orws_t_problem_info.rectify_deadline is '';
comment on column ${iol_schema}.orws_t_problem_info.prb_org_first_desc is '';
comment on column ${iol_schema}.orws_t_problem_info.pro_idtf is '';
comment on column ${iol_schema}.orws_t_problem_info.org_res_date is '';
comment on column ${iol_schema}.orws_t_problem_info.confirm_desc is '';
comment on column ${iol_schema}.orws_t_problem_info.approve_status is '';
comment on column ${iol_schema}.orws_t_problem_info.risk_level is '';
comment on column ${iol_schema}.orws_t_problem_info.approve_date is '';
comment on column ${iol_schema}.orws_t_problem_info.upgrade_date is '';
comment on column ${iol_schema}.orws_t_problem_info.is_overdue is '';
comment on column ${iol_schema}.orws_t_problem_info.start_dt is '开始时间';
comment on column ${iol_schema}.orws_t_problem_info.end_dt is '结束时间';
comment on column ${iol_schema}.orws_t_problem_info.id_mark is '增删标志';
comment on column ${iol_schema}.orws_t_problem_info.etl_timestamp is 'ETL处理时间戳';
