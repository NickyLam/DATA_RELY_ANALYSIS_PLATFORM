: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_icss_t_chan_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_icss_t_chan_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.channelid,chr(13),''),chr(10),'') as channelid
,replace(replace(t1.contractno,chr(13),''),chr(10),'') as contractno
,replace(replace(t1.channelname,chr(13),''),chr(10),'') as channelname
,replace(replace(t1.managerid,chr(13),''),chr(10),'') as managerid
,replace(replace(t1.trusteeid,chr(13),''),chr(10),'') as trusteeid
,replace(replace(t1.controltype,chr(13),''),chr(10),'') as controltype
,replace(replace(t1.hasrate,chr(13),''),chr(10),'') as hasrate
,replace(replace(t1.ratetype,chr(13),''),chr(10),'') as ratetype
,t1.raisesum as raisesum
,replace(replace(t1.isnetvalue,chr(13),''),chr(10),'') as isnetvalue
,replace(replace(t1.ishierarchical,chr(13),''),chr(10),'') as ishierarchical
 from iol.icss_t_chan_info T1
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_icss_t_chan_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes