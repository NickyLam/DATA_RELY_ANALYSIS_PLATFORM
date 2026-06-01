: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_isbs_pts_f
CreateDate: 20240223
FileName:   ${iel_data_path}/isbs_pts.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.inr,chr(13),''),chr(10),'') as inr
,replace(replace(t1.objtyp,chr(13),''),chr(10),'') as objtyp
,replace(replace(t1.objinr,chr(13),''),chr(10),'') as objinr
,replace(replace(t1.rol,chr(13),''),chr(10),'') as rol
,replace(replace(t1.ptainr,chr(13),''),chr(10),'') as ptainr
,replace(replace(t1.ptyinr,chr(13),''),chr(10),'') as ptyinr
,replace(replace(t1.extkey,chr(13),''),chr(10),'') as extkey
,replace(replace(t1.adrblk,chr(13),''),chr(10),'') as adrblk
,replace(replace(t1.ref,chr(13),''),chr(10),'') as ref
,replace(replace(t1.nam,chr(13),''),chr(10),'') as nam
,replace(replace(t1.ownref,chr(13),''),chr(10),'') as ownref
,replace(replace(t1.dftcur,chr(13),''),chr(10),'') as dftcur
,replace(replace(t1.dftdsp,chr(13),''),chr(10),'') as dftdsp
,replace(replace(t1.dftact,chr(13),''),chr(10),'') as dftact
,replace(replace(t1.dftfeecur,chr(13),''),chr(10),'') as dftfeecur
,replace(replace(t1.dftactptainr,chr(13),''),chr(10),'') as dftactptainr
,replace(replace(t1.glggrpflg,chr(13),''),chr(10),'') as glggrpflg
,replace(replace(t1.extact,chr(13),''),chr(10),'') as extact
,replace(replace(t1.ver,chr(13),''),chr(10),'') as ver
,replace(replace(t1.bankno,chr(13),''),chr(10),'') as bankno
,replace(replace(t1.issbaninf,chr(13),''),chr(10),'') as issbaninf
,replace(replace(t1.adrblkcn,chr(13),''),chr(10),'') as adrblkcn
,replace(replace(t1.bankno1,chr(13),''),chr(10),'') as bankno1

from ${iol_schema}.isbs_pts t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/isbs_pts.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
