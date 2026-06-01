: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icss_t_chan_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icss_t_chan_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.channelid,chr(13),''),chr(10),'') as channelid
,replace(replace(t.contractno,chr(13),''),chr(10),'') as contractno
,replace(replace(t.channelname,chr(13),''),chr(10),'') as channelname
,replace(replace(t.managerid,chr(13),''),chr(10),'') as managerid
,replace(replace(t.trusteeid,chr(13),''),chr(10),'') as trusteeid
,replace(replace(t.controltype,chr(13),''),chr(10),'') as controltype
,t.hasrate as hasrate
,replace(replace(t.ratetype,chr(13),''),chr(10),'') as ratetype
,replace(replace(t.raisesum,chr(13),''),chr(10),'') as raisesum
,replace(replace(t.isnetvalue,chr(13),''),chr(10),'') as isnetvalue
,replace(replace(t.ishierarchical,chr(13),''),chr(10),'') as ishierarchical
from ${iol_schema}.icss_t_chan_info t
where etl_dt = to_date('${batch_date}','yyyymmdd');
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icss_t_chan_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes