: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a1ptilldscrtinfo_f
CreateDate: 20240826
FileName:   ${iel_data_path}/mpcs_a1ptilldscrtinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.transdt,chr(13),''),chr(10),'') as transdt
,replace(replace(t1.transeqno,chr(13),''),chr(10),'') as transeqno
,replace(replace(t1.no,chr(13),''),chr(10),'') as no
,replace(replace(t1.illdscrtcause,chr(13),''),chr(10),'') as illdscrtcause
,replace(replace(t1.illabnmldate,chr(13),''),chr(10),'') as illabnmldate
,replace(replace(t1.illabnmldcsnauth,chr(13),''),chr(10),'') as illabnmldcsnauth
,replace(replace(t1.illrmvcause,chr(13),''),chr(10),'') as illrmvcause
,replace(replace(t1.illrmvdate,chr(13),''),chr(10),'') as illrmvdate
,replace(replace(t1.illrmvdcsnauth,chr(13),''),chr(10),'') as illrmvdcsnauth

from ${iol_schema}.mpcs_a1ptilldscrtinfo t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a1ptilldscrtinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
