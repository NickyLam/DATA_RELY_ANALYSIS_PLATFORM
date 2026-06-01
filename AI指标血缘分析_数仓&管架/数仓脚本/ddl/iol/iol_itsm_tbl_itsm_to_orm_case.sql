/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol itsm_tbl_itsm_to_orm_case
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.itsm_tbl_itsm_to_orm_case
whenever sqlerror continue none;
drop table ${iol_schema}.itsm_tbl_itsm_to_orm_case purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.itsm_tbl_itsm_to_orm_case(
    business_key varchar2(96) -- 工单ID
    ,case_real_happen date -- 故障实际发生时间
    ,topicname varchar2(766) -- 工单标题
    ,detail varchar2(4000) -- 详细描述
    ,reason_ana varchar2(4000) -- 原因分析
    ,scope_influence varchar2(4000) -- 影响范围
    ,emergency_solution varchar2(4000) -- 解决方案
    ,the_end_rank varchar2(48) -- 最终事件等级
    ,fault_time date -- 故障发生时间
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.itsm_tbl_itsm_to_orm_case to ${iml_schema};
grant select on ${iol_schema}.itsm_tbl_itsm_to_orm_case to ${icl_schema};
grant select on ${iol_schema}.itsm_tbl_itsm_to_orm_case to ${idl_schema};
grant select on ${iol_schema}.itsm_tbl_itsm_to_orm_case to ${iel_schema};

-- comment
comment on table ${iol_schema}.itsm_tbl_itsm_to_orm_case is 'ITSM供数给操作风险管理系统的事件表';
comment on column ${iol_schema}.itsm_tbl_itsm_to_orm_case.business_key is '工单ID';
comment on column ${iol_schema}.itsm_tbl_itsm_to_orm_case.case_real_happen is '故障实际发生时间';
comment on column ${iol_schema}.itsm_tbl_itsm_to_orm_case.topicname is '工单标题';
comment on column ${iol_schema}.itsm_tbl_itsm_to_orm_case.detail is '详细描述';
comment on column ${iol_schema}.itsm_tbl_itsm_to_orm_case.reason_ana is '原因分析';
comment on column ${iol_schema}.itsm_tbl_itsm_to_orm_case.scope_influence is '影响范围';
comment on column ${iol_schema}.itsm_tbl_itsm_to_orm_case.emergency_solution is '解决方案';
comment on column ${iol_schema}.itsm_tbl_itsm_to_orm_case.the_end_rank is '最终事件等级';
comment on column ${iol_schema}.itsm_tbl_itsm_to_orm_case.fault_time is '故障发生时间';
comment on column ${iol_schema}.itsm_tbl_itsm_to_orm_case.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.itsm_tbl_itsm_to_orm_case.etl_timestamp is 'ETL处理时间戳';
