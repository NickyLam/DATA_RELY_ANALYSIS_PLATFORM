: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_isbs_cbb_f
CreateDate: 20240223
FileName:   ${iel_data_path}/isbs_cbb.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.inr,chr(13),''),chr(10),'') as inr
,replace(replace(t1.objtyp,chr(13),''),chr(10),'') as objtyp
,replace(replace(t1.objinr,chr(13),''),chr(10),'') as objinr
,replace(replace(t1.cbc,chr(13),''),chr(10),'') as cbc
,replace(replace(t1.extid,chr(13),''),chr(10),'') as extid
,begdat
,enddat
,replace(replace(t1.cur,chr(13),''),chr(10),'') as cur
,amt
,replace(replace(t1.cbeinr,chr(13),''),chr(10),'') as cbeinr
,replace(replace(t1.xrfcur,chr(13),''),chr(10),'') as xrfcur
,xrfamt
,replace(replace(t1.comcur,chr(13),''),chr(10),'') as comcur
,comamt
,replace(replace(t1.xcocur,chr(13),''),chr(10),'') as xcocur
,xcoamt
,replace(replace(t1.frenum,chr(13),''),chr(10),'') as frenum

from ${iol_schema}.isbs_cbb t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/isbs_cbb.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
