/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_orws_temp_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_orws_temp_info
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_orws_temp_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_orws_temp_info(
    ETL_DT DATE
    ,ID NUMBER(18,0)
    ,NAME VARCHAR2(150)
    ,EMPLOYEE_NO VARCHAR2(50)
    ,SEX NUMBER(18,0)
    ,FOLK NUMBER(18,0)
    ,NATIVE_PLACE VARCHAR2(200)
    ,BORN_DATE TIMESTAMP(6)
    ,ADDRESS VARCHAR2(1000)
    ,EDU_DEGREE NUMBER(18,0)
    ,IS_FULLTIME NUMBER(18,0)
    ,EMPLOYEEMENT_TYPE NUMBER(18,0)
    ,CLERK_LEVEL VARCHAR2(20)
    ,STATUS NUMBER(18,0)
    ,MOBILE VARCHAR2(20)
    ,ORGAN_ID NUMBER(18,0)
    ,ORGAN_NAME VARCHAR2(80)
    ,ORGAN_NUMBER VARCHAR2(80)
    ,TO_ORGAN NUMBER(18,0)
    ,TO_GROUP NUMBER(18,0)
    ,EMPLOYEE_ID NUMBER(18,0)
    ,BECOME_DATE TIMESTAMP(6)
    ,CREATE_TIME TIMESTAMP(6)
    ,UPDATE_TIME TIMESTAMP(6)
    ,CREATE_USER_ID NUMBER(18,0)
    ,UPDATE_USER_ID NUMBER(18,0)
    ,EMAIL VARCHAR2(50)
    ,OFFICE_CALL VARCHAR2(50)
    ,EMP_NO VARCHAR2(50)
    ,ISMAIN NUMBER(18,0)
    ,BELONG_EMP_NO VARCHAR2(50)
    ,EXTERNAL_STATUS NUMBER(18,0)
    ,DOMAINID VARCHAR2(20)
    ,START_DT DATE
    ,END_DT DATE
    ,ID_MARK VARCHAR2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_orws_temp_info to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_orws_temp_info is '员工信息表';
comment on column ${msl_schema}.msl_edw_orws_temp_info.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_orws_temp_info.ID is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.NAME is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.EMPLOYEE_NO is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.SEX is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.FOLK is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.NATIVE_PLACE is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.BORN_DATE is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.ADDRESS is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.EDU_DEGREE is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.IS_FULLTIME is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.EMPLOYEEMENT_TYPE is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.CLERK_LEVEL is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.STATUS is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.MOBILE is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.ORGAN_ID is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.ORGAN_NAME is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.ORGAN_NUMBER is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.TO_ORGAN is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.TO_GROUP is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.EMPLOYEE_ID is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.BECOME_DATE is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.CREATE_TIME is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.UPDATE_TIME is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.CREATE_USER_ID is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.UPDATE_USER_ID is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.EMAIL is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.OFFICE_CALL is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.EMP_NO is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.ISMAIN is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.BELONG_EMP_NO is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.EXTERNAL_STATUS is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.DOMAINID is '';
comment on column ${msl_schema}.msl_edw_orws_temp_info.START_DT is '开始时间';
comment on column ${msl_schema}.msl_edw_orws_temp_info.END_DT is '结束时间';
comment on column ${msl_schema}.msl_edw_orws_temp_info.ID_MARK is '增删标志';
