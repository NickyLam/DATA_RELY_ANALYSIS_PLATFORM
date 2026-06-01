: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a1ptabnmlbizinfo_f
CreateDate: 20240826
FileName:   ${iel_data_path}/mpcs_a1ptabnmlbizinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.transdt,chr(13),''),chr(10),'') as transdt
,replace(replace(t1.transeqno,chr(13),''),chr(10),'') as transeqno
,replace(replace(t1.no,chr(13),''),chr(10),'') as no
,replace(replace(t1.abnmlcause,chr(13),''),chr(10),'') as abnmlcause
,replace(replace(t1.abnmldate,chr(13),''),chr(10),'') as abnmldate
,replace(replace(t1.abnmldcsnauth,chr(13),''),chr(10),'') as abnmldcsnauth
,replace(replace(t1.rmvcause,chr(13),''),chr(10),'') as rmvcause
,replace(replace(t1.rmvdate,chr(13),''),chr(10),'') as rmvdate
,replace(replace(t1.rmvdcsnauth,chr(13),''),chr(10),'') as rmvdcsnauth

from ${iol_schema}.mpcs_a1ptabnmlbizinfo t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a1ptabnmlbizinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
