: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nibs_pl_img_uploadrcd_f
CreateDate: 20180529
FileName:   ${iel_data_path}/nibs_pl_img_uploadrcd.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.channelcode,chr(13),''),chr(10),'') as channelcode
,replace(replace(t1.modelcode,chr(13),''),chr(10),'') as modelcode
,replace(replace(t1.busi_date,chr(13),''),chr(10),'') as busi_date
,replace(replace(t1.busi_time,chr(13),''),chr(10),'') as busi_time
,replace(replace(t1.busi_serial_no,chr(13),''),chr(10),'') as busi_serial_no
,replace(replace(t1.uploadfile,chr(13),''),chr(10),'') as uploadfile
,replace(replace(t1.content_id,chr(13),''),chr(10),'') as content_id
,replace(replace(t1.securitycode,chr(13),''),chr(10),'') as securitycode
,replace(replace(t1.eipaddr,chr(13),''),chr(10),'') as eipaddr
,replace(replace(t1.uploaddate,chr(13),''),chr(10),'') as uploaddate
,replace(replace(t1.uploadtime,chr(13),''),chr(10),'') as uploadtime
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.nibs_pl_img_uploadrcd t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nibs_pl_img_uploadrcd.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes