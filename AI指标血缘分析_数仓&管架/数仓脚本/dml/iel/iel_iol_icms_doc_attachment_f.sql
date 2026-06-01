: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_doc_attachment_f
CreateDate: 20240328
FileName:   ${iel_data_path}/icms_doc_attachment.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.attachmentno,chr(13),''),chr(10),'') as attachmentno
,replace(replace(t1.filename,chr(13),''),chr(10),'') as filename
,replace(replace(t1.contenttype,chr(13),''),chr(10),'') as contenttype
,replace(replace(t1.contentlength,chr(13),''),chr(10),'') as contentlength
,replace(replace(t1.contentstatus,chr(13),''),chr(10),'') as contentstatus
,replace(replace(t1.doccontent,chr(13),''),chr(10),'') as doccontent
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.filepath,chr(13),''),chr(10),'') as filepath
,replace(replace(t1.fullpath,chr(13),''),chr(10),'') as fullpath
,replace(replace(t1.filesavemode,chr(13),''),chr(10),'') as filesavemode
,replace(replace(t1.objecttype,chr(13),''),chr(10),'') as objecttype
,replace(replace(t1.objectno,chr(13),''),chr(10),'') as objectno
,begintime
,endtime
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,inputdate
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,updatedate
,replace(replace(t1.corporgid,chr(13),''),chr(10),'') as corporgid
,replace(replace(t1.filebusicode,chr(13),''),chr(10),'') as filebusicode
,replace(replace(t1.oldattachmentno,chr(13),''),chr(10),'') as oldattachmentno
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag

from ${iol_schema}.icms_doc_attachment t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_doc_attachment.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
