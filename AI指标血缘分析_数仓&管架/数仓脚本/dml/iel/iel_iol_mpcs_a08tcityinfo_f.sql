: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a08tcityinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/mpcs_a08tcityinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.citycd,chr(13),''),chr(10),'') as citycd
,replace(replace(t.citynm,chr(13),''),chr(10),'') as citynm
,replace(replace(t.citytp,chr(13),''),chr(10),'') as citytp
,replace(replace(t.cityndcd,chr(13),''),chr(10),'') as cityndcd
,replace(replace(t.chngnb,chr(13),''),chr(10),'') as chngnb
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.MPCS_A08TCITYINFO t 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a08tcityinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes