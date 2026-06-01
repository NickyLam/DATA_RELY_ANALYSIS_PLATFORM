: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icps_afa_jzck_documents_a
CreateDate: 20240812
FileName:   ${iel_data_path}/icps_afa_jzck_documents.i.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.productcode,chr(13),''),chr(10),'') as productcode
,replace(replace(t1.workdate,chr(13),''),chr(10),'') as workdate
,replace(replace(t1.agentserialno,chr(13),''),chr(10),'') as agentserialno
,replace(replace(t1.worktime,chr(13),''),chr(10),'') as worktime
,replace(replace(t1.fileflag,chr(13),''),chr(10),'') as fileflag
,replace(replace(t1.fileid,chr(13),''),chr(10),'') as fileid
,replace(replace(t1.transserialnumber,chr(13),''),chr(10),'') as transserialnumber
,replace(replace(t1.applicationid,chr(13),''),chr(10),'') as applicationid
,replace(replace(t1.casenumber,chr(13),''),chr(10),'') as casenumber
,replace(replace(t1.documentnumber,chr(13),''),chr(10),'') as documentnumber
,replace(replace(t1.filename,chr(13),''),chr(10),'') as filename
,replace(replace(t1.filetype,chr(13),''),chr(10),'') as filetype
,replace(replace(t1.filetypename,chr(13),''),chr(10),'') as filetypename
,replace(replace(t1.documenttype,chr(13),''),chr(10),'') as documenttype
,replace(replace(t1.documenttypename,chr(13),''),chr(10),'') as documenttypename
,replace(replace(t1.documentmd5,chr(13),''),chr(10),'') as documentmd5
,replace(replace(t1.filepath,chr(13),''),chr(10),'') as filepath
,replace(replace(t1.content,chr(13),''),chr(10),'') as content
,replace(replace(t1.remark1,chr(13),''),chr(10),'') as remark1
,replace(replace(t1.remark2,chr(13),''),chr(10),'') as remark2
,replace(replace(t1.remark3,chr(13),''),chr(10),'') as remark3
,replace(replace(t1.remark4,chr(13),''),chr(10),'') as remark4
,replace(replace(t1.tradesystem,chr(13),''),chr(10),'') as tradesystem
,replace(replace(t1.tradetype,chr(13),''),chr(10),'') as tradetype
,replace(replace(t1.zjmc,chr(13),''),chr(10),'') as zjmc
,replace(replace(t1.djr,chr(13),''),chr(10),'') as djr
,replace(replace(t1.djrq,chr(13),''),chr(10),'') as djrq

from ${iol_schema}.icps_afa_jzck_documents t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icps_afa_jzck_documents.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
