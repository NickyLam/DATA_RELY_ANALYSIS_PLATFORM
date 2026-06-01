: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_isbs_pte_f
CreateDate: 20240223
FileName:   ${iel_data_path}/isbs_pte.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.inr,chr(13),''),chr(10),'') as inr
,replace(replace(t1.objtyp,chr(13),''),chr(10),'') as objtyp
,replace(replace(t1.objinr,chr(13),''),chr(10),'') as objinr
,replace(replace(t1.subid,chr(13),''),chr(10),'') as subid
,replace(replace(t1.cbtpfx,chr(13),''),chr(10),'') as cbtpfx
,replace(replace(t1.grpkey,chr(13),''),chr(10),'') as grpkey
,replace(replace(t1.extid,chr(13),''),chr(10),'') as extid
,replace(replace(t1.liaptyinr,chr(13),''),chr(10),'') as liaptyinr
,replace(replace(t1.liaptainr,chr(13),''),chr(10),'') as liaptainr
,replace(replace(t1.cdtptsinr,chr(13),''),chr(10),'') as cdtptsinr
,replace(replace(t1.ownref,chr(13),''),chr(10),'') as ownref
,replace(replace(t1.nam,chr(13),''),chr(10),'') as nam
,replace(replace(t1.feeinr,chr(13),''),chr(10),'') as feeinr
,begdat
,clsdat
,setdat
,nxtcomdat
,replace(replace(t1.rolpay,chr(13),''),chr(10),'') as rolpay
,matdat
,replace(replace(t1.covtyp,chr(13),''),chr(10),'') as covtyp
,prc
,replace(replace(t1.amtflg,chr(13),''),chr(10),'') as amtflg
,replace(replace(t1.ver,chr(13),''),chr(10),'') as ver
,replace(replace(t1.asgtxt,chr(13),''),chr(10),'') as asgtxt
,replace(replace(t1.asbtxt,chr(13),''),chr(10),'') as asbtxt
,tenday

from ${iol_schema}.isbs_pte t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/isbs_pte.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
