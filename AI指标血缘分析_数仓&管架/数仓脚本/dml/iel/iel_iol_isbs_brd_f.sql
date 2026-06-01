: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_isbs_brd_f
CreateDate: 20240722
FileName:   ${iel_data_path}/isbs_brd.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.inr,chr(13),''),chr(10),'') as inr
,replace(replace(t1.ownref,chr(13),''),chr(10),'') as ownref
,replace(replace(t1.nam,chr(13),''),chr(10),'') as nam
,replace(replace(t1.ownusr,chr(13),''),chr(10),'') as ownusr
,credat
,opndat
,clsdat
,replace(replace(t1.pnttyp,chr(13),''),chr(10),'') as pnttyp
,replace(replace(t1.pntinr,chr(13),''),chr(10),'') as pntinr
,predat
,shpdat
,spddat
,totdat
,advdat
,matdat
,rcvdat
,disdat
,replace(replace(t1.docflg,chr(13),''),chr(10),'') as docflg
,replace(replace(t1.rejflg,chr(13),''),chr(10),'') as rejflg
,replace(replace(t1.approvcod,chr(13),''),chr(10),'') as approvcod
,replace(replace(t1.relgodflg,chr(13),''),chr(10),'') as relgodflg
,relgoddat
,replace(replace(t1.trpdocnum,chr(13),''),chr(10),'') as trpdocnum
,replace(replace(t1.frepayflg,chr(13),''),chr(10),'') as frepayflg
,replace(replace(t1.ver,chr(13),''),chr(10),'') as ver
,replace(replace(t1.advtyp,chr(13),''),chr(10),'') as advtyp
,replace(replace(t1.reltyp,chr(13),''),chr(10),'') as reltyp
,expdat
,replace(replace(t1.rtoaplflg,chr(13),''),chr(10),'') as rtoaplflg
,replace(replace(t1.trpdoctyp,chr(13),''),chr(10),'') as trpdoctyp
,tradat
,replace(replace(t1.tramod,chr(13),''),chr(10),'') as tramod
,replace(replace(t1.mattxtflg,chr(13),''),chr(10),'') as mattxtflg
,replace(replace(t1.dscinsflg,chr(13),''),chr(10),'') as dscinsflg
,replace(replace(t1.docprbrol,chr(13),''),chr(10),'') as docprbrol
,replace(replace(t1.docsta,chr(13),''),chr(10),'') as docsta
,replace(replace(t1.igndisflg,chr(13),''),chr(10),'') as igndisflg
,replace(replace(t1.totcur,chr(13),''),chr(10),'') as totcur
,totamt
,replace(replace(t1.payrol,chr(13),''),chr(10),'') as payrol
,replace(replace(t1.acpnowflg,chr(13),''),chr(10),'') as acpnowflg
,orddat
,replace(replace(t1.advdocflg,chr(13),''),chr(10),'') as advdocflg
,replace(replace(t1.etyextkey,chr(13),''),chr(10),'') as etyextkey
,replace(replace(t1.bchkeyinr,chr(13),''),chr(10),'') as bchkeyinr
,replace(replace(t1.branchinr,chr(13),''),chr(10),'') as branchinr
,replace(replace(t1.ngrcod,chr(13),''),chr(10),'') as ngrcod
,replace(replace(t1.sgdinr,chr(13),''),chr(10),'') as sgdinr
,replace(replace(t1.blnum,chr(13),''),chr(10),'') as blnum
,replace(replace(t1.shgref,chr(13),''),chr(10),'') as shgref
,replace(replace(t1.fincod,chr(13),''),chr(10),'') as fincod
,replace(replace(t1.fintyp,chr(13),''),chr(10),'') as fintyp
,replace(replace(t1.nraflg,chr(13),''),chr(10),'') as nraflg
,replace(replace(t1.qsqdbh,chr(13),''),chr(10),'') as qsqdbh
,replace(replace(t1.invnum,chr(13),''),chr(10),'') as invnum

from ${iol_schema}.isbs_brd t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/isbs_brd.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
