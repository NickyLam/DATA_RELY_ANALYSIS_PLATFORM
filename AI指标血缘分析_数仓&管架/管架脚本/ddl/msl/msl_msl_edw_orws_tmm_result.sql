/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_orws_tmm_result
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_orws_tmm_result
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_orws_tmm_result purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_orws_tmm_result(
    ETL_DT DATE
    ,ID NUMBER(18,0)
    ,COMMISSIONING_ID NUMBER(18,0)
    ,BIZ_DATE TIMESTAMP(6)
    ,BIZ_ORGAN_ID NUMBER(18,0)
    ,BIZ_EMP_NO VARCHAR2(50)
    ,IMG_INFO VARCHAR2(300)
    ,FOUND_DATE TIMESTAMP(6)
    ,HANDLE_DATE TIMESTAMP(6)
    ,HANDLE_USER_ID NUMBER(18,0)
    ,HANDLE_POSITION_ID NUMBER(18,0)
    ,HANDLE_ORGAN_ID NUMBER(18,0)
    ,HANDLE_RESULT NUMBER(2,0)
    ,BIZ_INFO VARCHAR2(4000)
    ,CANCEL_REASON VARCHAR2(300)
    ,PROBLEM_ID NUMBER(18,0)
    ,PROBLEM_STATE NUMBER(1,0)
    ,START_DT DATE
    ,END_DT DATE
    ,ID_MARK VARCHAR2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_orws_tmm_result to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_orws_tmm_result is '模型结果对象';
comment on column ${msl_schema}.msl_edw_orws_tmm_result.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_orws_tmm_result.ID is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_result.COMMISSIONING_ID is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_result.BIZ_DATE is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_result.BIZ_ORGAN_ID is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_result.BIZ_EMP_NO is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_result.IMG_INFO is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_result.FOUND_DATE is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_result.HANDLE_DATE is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_result.HANDLE_USER_ID is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_result.HANDLE_POSITION_ID is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_result.HANDLE_ORGAN_ID is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_result.HANDLE_RESULT is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_result.BIZ_INFO is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_result.CANCEL_REASON is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_result.PROBLEM_ID is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_result.PROBLEM_STATE is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_result.START_DT is '开始时间';
comment on column ${msl_schema}.msl_edw_orws_tmm_result.END_DT is '结束时间';
comment on column ${msl_schema}.msl_edw_orws_tmm_result.ID_MARK is '增删标志';
