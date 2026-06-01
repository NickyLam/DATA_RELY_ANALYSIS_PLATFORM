: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nibs_pl_vou_businotice_log_i
CreateDate: 20180529
FileName:   ${iel_data_path}/nibs_pl_vou_businotice_log.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.noticedate as noticedate
,replace(replace(t1.remark2,chr(13),''),chr(10),'') as remark2
,t1.channeldate as channeldate
,replace(replace(t1.channelserno,chr(13),''),chr(10),'') as channelserno
,replace(replace(t1.channelcode,chr(13),''),chr(10),'') as channelcode
,replace(replace(t1.voutype,chr(13),''),chr(10),'') as voutype
,replace(replace(t1.voukind,chr(13),''),chr(10),'') as voukind
,replace(replace(t1.scenecode,chr(13),''),chr(10),'') as scenecode
,replace(replace(t1.noticestep,chr(13),''),chr(10),'') as noticestep
,replace(replace(t1.noticestatus,chr(13),''),chr(10),'') as noticestatus
,replace(replace(t1.procnum,chr(13),''),chr(10),'') as procnum
,replace(replace(t1.noticebatchno,chr(13),''),chr(10),'') as noticebatchno
,replace(replace(t1.genidflag,chr(13),''),chr(10),'') as genidflag
,replace(replace(t1.fileupstatus,chr(13),''),chr(10),'') as fileupstatus
,replace(replace(t1.filepath,chr(13),''),chr(10),'') as filepath
,replace(replace(t1.sourcefilename,chr(13),''),chr(10),'') as sourcefilename
,replace(replace(t1.aimfilename,chr(13),''),chr(10),'') as aimfilename
,replace(replace(t1.aimcontentid,chr(13),''),chr(10),'') as aimcontentid
,replace(replace(t1.filesize,chr(13),''),chr(10),'') as filesize
,replace(replace(t1.orgid,chr(13),''),chr(10),'') as orgid
,replace(replace(t1.tellerid,chr(13),''),chr(10),'') as tellerid
,t1.oprdate as oprdate
,replace(replace(t1.printno,chr(13),''),chr(10),'') as printno
,replace(replace(t1.dealcode,chr(13),''),chr(10),'') as dealcode
,replace(replace(t1.dealmsg,chr(13),''),chr(10),'') as dealmsg
,t1.crtdatetime as crtdatetime
,t1.altdatetime as altdatetime
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.remark1,chr(13),''),chr(10),'') as remark1
,replace(replace(t1.noticeserno,chr(13),''),chr(10),'') as noticeserno
from ${iol_schema}.nibs_pl_vou_businotice_log t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nibs_pl_vou_businotice_log.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes