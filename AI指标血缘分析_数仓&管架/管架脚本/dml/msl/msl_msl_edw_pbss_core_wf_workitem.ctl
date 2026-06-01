-- SQL* Unloader: Fast Oracle TetUnloader (Gzip),Release 3.0.1
-- (@) Copyright Lou Fangxin (AnySQL.net) 2004 -2010, all rigths reserved.
-- Purpose:    Sqlldr Control File
-- Author:     Sunline
-- CreateDate: 20190705
-- FileType:   Control-File
-- Logs:
--     luzd 2019-07-05 create template

options(bindsize=2097152,readsize=2097152,errors=0,rows=5000)
load data
infile '${data_path}/pbss_core_wf_workitem.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pbss_core_wf_workitem
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,ID char(4000) nullif ID=blanks 
    ,ENGINE_ADDRESS char(4000) nullif ENGINE_ADDRESS=blanks 
    ,ROOT_ACT_ID char(4000) nullif ROOT_ACT_ID=blanks 
    ,PARENT_ACT_ID char(4000) nullif PARENT_ACT_ID=blanks 
    ,ACTIVITYPATH char(4000) nullif ACTIVITYPATH=blanks 
    ,DESCRIPTION char(4000) nullif DESCRIPTION=blanks 
    ,STYLESHEET char(4000) nullif STYLESHEET=blanks 
    ,EXCLUDE_PARTICIPANT char(4000) nullif EXCLUDE_PARTICIPANT=blanks 
    ,WORKQUEUE char(4000) nullif WORKQUEUE=blanks 
    ,CREATED_TIME char(4000) nullif CREATED_TIME=blanks 
    ,RECLAIM_DEADLINE_TIME char(4000) nullif RECLAIM_DEADLINE_TIME=blanks 
    ,OBTAIN_DEADLINE_TIME char(4000) nullif OBTAIN_DEADLINE_TIME=blanks 
    ,OBTAINED_TIME char(4000) nullif OBTAINED_TIME=blanks 
    ,SUBMITED_TIME char(4000) nullif SUBMITED_TIME=blanks 
    ,PAUSEED_TIME char(4000) nullif PAUSEED_TIME=blanks 
    ,EXCEPTION_PAUSEED_TIME char(4000) nullif EXCEPTION_PAUSEED_TIME=blanks 
    ,RESUMED_TIME char(4000) nullif RESUMED_TIME=blanks 
    ,FINISHED_TIME char(4000) nullif FINISHED_TIME=blanks 
    ,PARTICIPANT char(4000) nullif PARTICIPANT=blanks 
    ,ISROLEMANAGER char(4000) nullif ISROLEMANAGER=blanks 
    ,ORG_BUSINESS char(4000) nullif ORG_BUSINESS=blanks 
    ,ORGANIZATIONALUNIT char(4000) nullif ORGANIZATIONALUNIT=blanks 
    ,ORGANIZATIONALUNITTYPE char(4000) nullif ORGANIZATIONALUNITTYPE=blanks 
    ,ORGANIZATIONCLASSNAME char(4000) nullif ORGANIZATIONCLASSNAME=blanks 
    ,OPERATOR char(4000) nullif OPERATOR=blanks 
    ,STATE char(4000) nullif STATE=blanks 
    ,PRIORITY char(4000) nullif PRIORITY=blanks 
    ,PROCESSTYPE char(4000) nullif PROCESSTYPE=blanks 
    ,OBTAINID char(4000) nullif OBTAINID=blanks 
    ,INSTANCEPATH char(4000) nullif INSTANCEPATH=blanks 
    ,ACT_ID char(4000) nullif ACT_ID=blanks 
    ,ACT_DEF_V_ID char(4000) nullif ACT_DEF_V_ID=blanks 
    ,REF_ENTITY_ID char(4000) nullif REF_ENTITY_ID=blanks 
    ,CONDITION_DATA1 char(4000) nullif CONDITION_DATA1=blanks 
    ,CONDITION_DATA2 char(4000) nullif CONDITION_DATA2=blanks 
    ,CONDITION_DATA3 char(4000) nullif CONDITION_DATA3=blanks 
    ,CONDITION_DATA4 char(4000) nullif CONDITION_DATA4=blanks 
    ,SHARE_DATA1 char(4000) nullif SHARE_DATA1=blanks 
    ,SHARE_DATA2 char(4000) nullif SHARE_DATA2=blanks 
    ,SHARE_DATA3 char(4000) nullif SHARE_DATA3=blanks 
    ,SHARE_DATA4 date "yyyy-mm-dd hh24:mi:ss" nullif SHARE_DATA4=blanks 
    ,UPDATE_ASS char(4000) nullif UPDATE_ASS=blanks 
    ,ROOT_START_DATETIME char(4000) nullif ROOT_START_DATETIME=blanks 
    ,START_DT date "yyyy-mm-dd hh24:mi:ss" nullif START_DT=blanks 
    ,END_DT date "yyyy-mm-dd hh24:mi:ss" nullif END_DT=blanks 
    ,ID_MARK char(4000) nullif ID_MARK=blanks 
)