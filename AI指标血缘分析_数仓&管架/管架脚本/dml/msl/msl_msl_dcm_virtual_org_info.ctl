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
infile '${data_path}/mcs_dcm_virtual_org_info.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_dcm_virtual_org_info
fields terminated by x'1b' 
trailing nullcols
(
     ORG_NO char(4000) nullif ORG_NO=blanks 
    ,ORG_NAME char(4000) nullif ORG_NAME=blanks 
    ,SUPER_ORG_NO char(4000) nullif SUPER_ORG_NO=blanks 
)