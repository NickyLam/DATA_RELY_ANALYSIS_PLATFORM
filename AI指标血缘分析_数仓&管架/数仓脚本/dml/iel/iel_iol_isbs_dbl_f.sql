: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_isbs_dbl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/isbs_dbl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.inr,chr(13),''),chr(10),'') as inr 
,replace(replace(t1.ver,chr(13),''),chr(10),'') as ver 
,replace(replace(t1.objtyp,chr(13),''),chr(10),'') as objtyp 
,replace(replace(t1.objinr,chr(13),''),chr(10),'') as objinr 
,replace(replace(t1.rptno,chr(13),''),chr(10),'') as rptno 
,replace(replace(t1.bassta,chr(13),''),chr(10),'') as bassta 
,replace(replace(t1.dclsta,chr(13),''),chr(10),'') as dclsta 
,replace(replace(t1.vrfsta,chr(13),''),chr(10),'') as vrfsta 
,replace(replace(t1.ownextkey,chr(13),''),chr(10),'') as ownextkey 
,replace(replace(t1.ownusr,chr(13),''),chr(10),'') as ownusr 
,replace(replace(t1.trninr,chr(13),''),chr(10),'') as trninr 
,t1.credat as credat 
,t1.reldat as reldat 
,replace(replace(t1.tmpref,chr(13),''),chr(10),'') as tmpref 
,replace(replace(t1.trdtyp,chr(13),''),chr(10),'') as trdtyp 
,replace(replace(t1.acttyp,chr(13),''),chr(10),'') as acttyp 
,replace(replace(t1.ygasta,chr(13),''),chr(10),'') as ygasta 
,replace(replace(t1.basstarcv,chr(13),''),chr(10),'') as basstarcv 
,replace(replace(t1.dclstarcv,chr(13),''),chr(10),'') as dclstarcv 
,replace(replace(t1.vrfstarcv,chr(13),''),chr(10),'') as vrfstarcv 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.isbs_dbl t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/isbs_dbl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes