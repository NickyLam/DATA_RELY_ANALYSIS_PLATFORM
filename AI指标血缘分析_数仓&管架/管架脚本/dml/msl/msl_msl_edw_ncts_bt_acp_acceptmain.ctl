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
infile '${data_path}/ncts_bt_acp_acceptmain.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,TRADESERNO char(4000) nullif TRADESERNO=blanks 
    ,OLDTRADESERNO char(4000) nullif OLDTRADESERNO=blanks 
    ,BIZTYPE char(4000) nullif BIZTYPE=blanks 
    ,STATUS char(4000) nullif STATUS=blanks 
    ,BUSISERNO char(4000) nullif BUSISERNO=blanks 
    ,CHANNELCODE char(4000) nullif CHANNELCODE=blanks 
    ,ACCTNO char(4000) nullif ACCTNO=blanks 
    ,ACCTNAME char(4000) nullif ACCTNAME=blanks 
    ,CUSTNO char(4000) nullif CUSTNO=blanks 
    ,IDTYPE char(4000) nullif IDTYPE=blanks 
    ,IDNO char(4000) nullif IDNO=blanks 
    ,IDNAME char(4000) nullif IDNAME=blanks 
    ,AGENTIDTYPE char(4000) nullif AGENTIDTYPE=blanks 
    ,AGENTIDNO char(4000) nullif AGENTIDNO=blanks 
    ,AGENTIDNAME char(4000) nullif AGENTIDNAME=blanks 
    ,REMARK char(4000) nullif REMARK=blanks 
    ,CREATEDATE date "yyyy-mm-dd hh24:mi:ss" nullif CREATEDATE=blanks 
    ,CREATETIME char(4000) nullif CREATETIME=blanks 
    ,CREATEBY char(4000) nullif CREATEBY=blanks 
    ,UPDATEDATE date "yyyy-mm-dd hh24:mi:ss" nullif UPDATEDATE=blanks 
    ,UPDATETIME char(4000) nullif UPDATETIME=blanks 
    ,UPDATEBY char(4000) nullif UPDATEBY=blanks 
    ,REFTRADESERNO char(4000) nullif REFTRADESERNO=blanks 
    ,APPLYDATE char(4000) nullif APPLYDATE=blanks 
    ,APPLYBRNO char(4000) nullif APPLYBRNO=blanks 
    ,PHONE char(4000) nullif PHONE=blanks 
    ,RESERV_ID char(4000) nullif RESERV_ID=blanks 
    ,TELLERPHONE char(4000) nullif TELLERPHONE=blanks 
    ,START_DT date "yyyy-mm-dd hh24:mi:ss" nullif START_DT=blanks 
    ,END_DT date "yyyy-mm-dd hh24:mi:ss" nullif END_DT=blanks 
    ,ID_MARK char(4000) nullif ID_MARK=blanks 
)