/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_orws_t_problem_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_orws_t_problem_info
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_orws_t_problem_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_orws_t_problem_info(
    ETL_DT DATE
    ,ID NUMBER(18,0)
    ,BIZTYPE NUMBER(18,0)
    ,NODE_NAME VARCHAR2(200)
    ,INST_NO VARCHAR2(90)
    ,CHKDEPT VARCHAR2(100)
    ,ORGANID NUMBER(18,0)
    ,TASK_ORGAN NUMBER(18,0)
    ,BIGTYPE_ID NUMBER(18,0)
    ,SMALLTYPE_ID NUMBER(18,0)
    ,BIZ_DATE TIMESTAMP(6)
    ,CHECK_TIME TIMESTAMP(6)
    ,CHKTITLE VARCHAR2(210)
    ,CHKPERSON NUMBER(18,0)
    ,PROBLEMER NUMBER(18,0)
    ,PROBLEMSTATE NUMBER(1,0)
    ,PROBLEM_DETAIL_ACTION VARCHAR2(200)
    ,PROBLEM_BIZ_ID VARCHAR2(200)
    ,SERINUM VARCHAR2(255)
    ,RECTIFIED_SERINUM VARCHAR2(255)
    ,PRBINFO VARCHAR2(4000)
    ,REMARKS VARCHAR2(4000)
    ,IS_EMP_RESP NUMBER(1,0)
    ,IS_DEBIT_RESP NUMBER(1,0)
    ,IS_CREDIT_RESP NUMBER(1,0)
    ,APPROVE_TYPE VARCHAR2(18)
    ,RECTIFY_DEADLINE TIMESTAMP(6)
    ,PRB_ORG_FIRST_DESC VARCHAR2(4000)
    ,PRO_IDTF VARCHAR2(4000)
    ,ORG_RES_DATE TIMESTAMP(6)
    ,CONFIRM_DESC VARCHAR2(4000)
    ,APPROVE_STATUS NUMBER(1,0)
    ,RISK_LEVEL NUMBER(1,0)
    ,APPROVE_DATE TIMESTAMP(6)
    ,UPGRADE_DATE TIMESTAMP(6)
    ,IS_OVERDUE NUMBER(1,0)
    ,START_DT DATE
    ,END_DT DATE
    ,ID_MARK VARCHAR2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_orws_t_problem_info to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_orws_t_problem_info is '问题主信息表';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.ID is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.BIZTYPE is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.NODE_NAME is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.INST_NO is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.CHKDEPT is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.ORGANID is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.TASK_ORGAN is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.BIGTYPE_ID is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.SMALLTYPE_ID is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.BIZ_DATE is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.CHECK_TIME is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.CHKTITLE is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.CHKPERSON is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.PROBLEMER is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.PROBLEMSTATE is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.PROBLEM_DETAIL_ACTION is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.PROBLEM_BIZ_ID is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.SERINUM is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.RECTIFIED_SERINUM is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.PRBINFO is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.REMARKS is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.IS_EMP_RESP is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.IS_DEBIT_RESP is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.IS_CREDIT_RESP is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.APPROVE_TYPE is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.RECTIFY_DEADLINE is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.PRB_ORG_FIRST_DESC is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.PRO_IDTF is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.ORG_RES_DATE is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.CONFIRM_DESC is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.APPROVE_STATUS is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.RISK_LEVEL is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.APPROVE_DATE is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.UPGRADE_DATE is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.IS_OVERDUE is '';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.START_DT is '开始时间';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.END_DT is '结束时间';
comment on column ${msl_schema}.msl_edw_orws_t_problem_info.ID_MARK is '增删标志';
