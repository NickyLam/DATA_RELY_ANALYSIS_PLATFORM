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
infile '${data_path}/pbss_flw_t_main_flow.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pbss_flw_t_main_flow
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,ID char(4000) nullif ID=blanks 
    ,PROCESS_INST_ID char(4000) nullif PROCESS_INST_ID=blanks 
    ,ARC_ID char(4000) nullif ARC_ID=blanks 
    ,SCAN_SEQ_NO char(4000) nullif SCAN_SEQ_NO=blanks 
    ,TR_CODE char(4000) nullif TR_CODE=blanks 
    ,TR_DATE date "yyyy-mm-dd hh24:mi:ss" nullif TR_DATE=blanks 
    ,BIZ_CODE char(4000) nullif BIZ_CODE=blanks 
    ,BACK_OPER_CENTER_ID char(4000) nullif BACK_OPER_CENTER_ID=blanks 
    ,BR_TRACE_NO char(4000) nullif BR_TRACE_NO=blanks 
    ,BIZ_PRIORITY char(4000) nullif BIZ_PRIORITY=blanks 
    ,MAIN_NOTE_PAGES char(4000) nullif MAIN_NOTE_PAGES=blanks 
    ,ATTACH_PAGES char(4000) nullif ATTACH_PAGES=blanks 
    ,MAG_PRINT_FLAG char(4000) nullif MAG_PRINT_FLAG=blanks 
    ,ACCPT_TIME timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif ACCPT_TIME=blanks 
    ,END_TIME timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif END_TIME=blanks 
    ,SCAN_OPR_NO char(4000) nullif SCAN_OPR_NO=blanks 
    ,FR_TLR_OPR_NO char(4000) nullif FR_TLR_OPR_NO=blanks 
    ,FR_CHRG_OPR_NO char(4000) nullif FR_CHRG_OPR_NO=blanks 
    ,AUTH_FLAG char(4000) nullif AUTH_FLAG=blanks 
    ,TX_STATUS char(4000) nullif TX_STATUS=blanks 
    ,RET_REASON char(4000) nullif RET_REASON=blanks 
    ,PRE_FLAG char(4000) nullif PRE_FLAG=blanks 
    ,RESERVE1 char(4000) nullif RESERVE1=blanks 
    ,RESERVE2 char(4000) nullif RESERVE2=blanks 
    ,BIZ_PRE_TIME char(4000) nullif BIZ_PRE_TIME=blanks 
    ,AUTH_REASON char(4000) nullif AUTH_REASON=blanks 
    ,TACHE_CODE char(4000) nullif TACHE_CODE=blanks 
    ,PROCESSOR char(4000) nullif PROCESSOR=blanks 
    ,RECEIVE_NO char(4000) nullif RECEIVE_NO=blanks 
    ,BACK_CHECK_FLAG char(4000) nullif BACK_CHECK_FLAG=blanks 
    ,BACK_AUTH_FLAG char(4000) nullif BACK_AUTH_FLAG=blanks 
    ,BACK_CHECK_DATE date "yyyy-mm-dd hh24:mi:ss" nullif BACK_CHECK_DATE=blanks 
    ,OLDSCANNO char(4000) nullif OLDSCANNO=blanks 
    ,IS_SYS_OP char(4000) nullif IS_SYS_OP=blanks 
    ,MAIN_SCAN_SEQ_NO char(4000) nullif MAIN_SCAN_SEQ_NO=blanks 
    ,FIRST_ACCPT_TIME date "yyyy-mm-dd hh24:mi:ss" nullif FIRST_ACCPT_TIME=blanks 
    ,DELTA_PRIORITY char(4000) nullif DELTA_PRIORITY=blanks 
    ,BUSI_CHECK_FLAG char(4000) nullif BUSI_CHECK_FLAG=blanks 
    ,BUSI_CHECK_TIME date "yyyy-mm-dd hh24:mi:ss" nullif BUSI_CHECK_TIME=blanks 
    ,BUSI_CHECK_USER char(4000) nullif BUSI_CHECK_USER=blanks 
    ,ROOT_SCAN_SEQ_NO char(4000) nullif ROOT_SCAN_SEQ_NO=blanks 
    ,MODIFY_TIME date "yyyy-mm-dd hh24:mi:ss" nullif MODIFY_TIME=blanks 
    ,BUSI_START_TIME date "yyyy-mm-dd hh24:mi:ss" nullif BUSI_START_TIME=blanks 
    ,BUSI_END_TIME date "yyyy-mm-dd hh24:mi:ss" nullif BUSI_END_TIME=blanks 
    ,STATIS_TACHE_FLAG char(4000) nullif STATIS_TACHE_FLAG=blanks 
    ,SYS_ID char(4000) nullif SYS_ID=blanks 
    ,NETSTATE char(4000) nullif NETSTATE=blanks 
    ,LOGONPWNEW char(4000) nullif LOGONPWNEW=blanks 
    ,NETRESET char(4000) nullif NETRESET=blanks 
    ,FIRST_CHECK_USER char(4000) nullif FIRST_CHECK_USER=blanks 
    ,SECOND_CHECK_USER char(4000) nullif SECOND_CHECK_USER=blanks 
    ,FR_END_STATUS char(4000) nullif FR_END_STATUS=blanks 
    ,FR_END_REASON char(4000) nullif FR_END_REASON=blanks 
    ,MTWO_SEAL_REASON char(4000) nullif MTWO_SEAL_REASON=blanks 
)