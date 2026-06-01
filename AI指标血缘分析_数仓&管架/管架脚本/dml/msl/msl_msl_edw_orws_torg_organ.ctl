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
infile '${data_path}/orws_torg_organ.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_orws_torg_organ
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,ORGANID char(4000) nullif ORGANID=blanks 
    ,OWNERORGANID char(4000) nullif OWNERORGANID=blanks 
    ,ORGANCODE char(4000) nullif ORGANCODE=blanks 
    ,ORGANNUM char(4000) nullif ORGANNUM=blanks 
    ,ORGANNAME char(4000) nullif ORGANNAME=blanks 
    ,INVOICENAME char(4000) nullif INVOICENAME=blanks 
    ,SHORTNAME char(4000) nullif SHORTNAME=blanks 
    ,ORGANTYPE char(4000) nullif ORGANTYPE=blanks 
    ,ISBUILDACCUNT char(4000) nullif ISBUILDACCUNT=blanks 
    ,ADDRESS char(4000) nullif ADDRESS=blanks 
    ,BUILDDATE timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif BUILDDATE=blanks 
    ,INVALIDDATE timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif INVALIDDATE=blanks 
    ,CORPORATION char(4000) nullif CORPORATION=blanks 
    ,MASTER char(4000) nullif MASTER=blanks 
    ,POSTCODE char(4000) nullif POSTCODE=blanks 
    ,LINKPHONE char(4000) nullif LINKPHONE=blanks 
    ,FAX char(4000) nullif FAX=blanks 
    ,EMAIL char(4000) nullif EMAIL=blanks 
    ,TAXNO char(4000) nullif TAXNO=blanks 
    ,PERSONNELNUM char(4000) nullif PERSONNELNUM=blanks 
    ,ISUSED char(4000) nullif ISUSED=blanks 
    ,REMARK char(4000) nullif REMARK=blanks 
    ,EXT1 char(4000) nullif EXT1=blanks 
    ,EXT2 char(4000) nullif EXT2=blanks 
    ,EXT3 char(4000) nullif EXT3=blanks 
    ,OFFICEDATE timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif OFFICEDATE=blanks 
    ,MANAGERMASTER char(4000) nullif MANAGERMASTER=blanks 
    ,MOFFICEDATE timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif MOFFICEDATE=blanks 
    ,STATUS char(4000) nullif STATUS=blanks 
    ,SOURCE_TYPE char(4000) nullif SOURCE_TYPE=blanks 
    ,START_DT date "yyyy-mm-dd hh24:mi:ss" nullif START_DT=blanks 
    ,END_DT date "yyyy-mm-dd hh24:mi:ss" nullif END_DT=blanks 
    ,ID_MARK char(4000) nullif ID_MARK=blanks 
)