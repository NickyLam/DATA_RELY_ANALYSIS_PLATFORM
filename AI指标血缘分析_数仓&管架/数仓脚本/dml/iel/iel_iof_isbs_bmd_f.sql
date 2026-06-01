: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_isbs_bmd_f
CreateDate: 20251013
FileName:   ${iel_data_path}/isbs_bmd.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.inr,chr(13),''),chr(10),'') as inr
,replace(replace(t1.ownref,chr(13),''),chr(10),'') as ownref
,replace(replace(t1.nam,chr(13),''),chr(10),'') as nam
,replace(replace(t1.pnttyp,chr(13),''),chr(10),'') as pnttyp
,replace(replace(t1.pntinr,chr(13),''),chr(10),'') as pntinr
,predat
,rcvdat
,shpdat
,advdat
,matdat
,replace(replace(t1.doctypcod,chr(13),''),chr(10),'') as doctypcod
,opndat
,clsdat
,credat
,replace(replace(t1.ownusr,chr(13),''),chr(10),'') as ownusr
,replace(replace(t1.ver,chr(13),''),chr(10),'') as ver
,replace(replace(t1.approvcod,chr(13),''),chr(10),'') as approvcod
,replace(replace(t1.frepayflg,chr(13),''),chr(10),'') as frepayflg
,replace(replace(t1.docprbrol,chr(13),''),chr(10),'') as docprbrol
,replace(replace(t1.payrol,chr(13),''),chr(10),'') as payrol
,orddat
,replace(replace(t1.mattxtflg,chr(13),''),chr(10),'') as mattxtflg
,replace(replace(t1.dscinsflg,chr(13),''),chr(10),'') as dscinsflg
,replace(replace(t1.acpnowflg,chr(13),''),chr(10),'') as acpnowflg
,replace(replace(t1.advtyp,chr(13),''),chr(10),'') as advtyp
,disdat
,replace(replace(t1.totcur,chr(13),''),chr(10),'') as totcur
,totamt
,totdat
,replace(replace(t1.docsta,chr(13),''),chr(10),'') as docsta
,replace(replace(t1.docrol,chr(13),''),chr(10),'') as docrol
,replace(replace(t1.docrolflg,chr(13),''),chr(10),'') as docrolflg
,dta770snd
,replace(replace(t1.advdocflg,chr(13),''),chr(10),'') as advdocflg
,replace(replace(t1.etyextkey,chr(13),''),chr(10),'') as etyextkey
,replace(replace(t1.rmbrol,chr(13),''),chr(10),'') as rmbrol
,lescom
,replace(replace(t1.bchkeyinr,chr(13),''),chr(10),'') as bchkeyinr
,replace(replace(t1.branchinr,chr(13),''),chr(10),'') as branchinr
,replace(replace(t1.nraflg,chr(13),''),chr(10),'') as nraflg
,replace(replace(t1.clmcur,chr(13),''),chr(10),'') as clmcur
,clmamt
,replace(replace(t1.expmno,chr(13),''),chr(10),'') as expmno
,replace(replace(t1.rcssta,chr(13),''),chr(10),'') as rcssta
,replace(replace(t1.paytyp,chr(13),''),chr(10),'') as paytyp
,replace(replace(t1.clrmtd,chr(13),''),chr(10),'') as clrmtd
,replace(replace(t1.bilpro,chr(13),''),chr(10),'') as bilpro
,replace(replace(t1.dckref,chr(13),''),chr(10),'') as dckref
,replace(replace(t1.isnegflg,chr(13),''),chr(10),'') as isnegflg

from ${iol_schema}.isbs_bmd t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/isbs_bmd.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
