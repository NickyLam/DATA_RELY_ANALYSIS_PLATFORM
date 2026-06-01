: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_isbs_ded_f
CreateDate: 20251013
FileName:   ${iel_data_path}/isbs_ded.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.inr,chr(13),''),chr(10),'') as inr
,replace(replace(t1.ownref,chr(13),''),chr(10),'') as ownref
,replace(replace(t1.nam,chr(13),''),chr(10),'') as nam
,opndat
,clsdat
,replace(replace(t1.ownusr,chr(13),''),chr(10),'') as ownusr
,replace(replace(t1.ver,chr(13),''),chr(10),'') as ver
,credat
,replace(replace(t1.etyextkey,chr(13),''),chr(10),'') as etyextkey
,cnfdat
,advdat
,replace(replace(t1.issnam,chr(13),''),chr(10),'') as issnam
,replace(replace(t1.issref,chr(13),''),chr(10),'') as issref
,amedat
,amenbr
,replace(replace(t1.avbby,chr(13),''),chr(10),'') as avbby
,replace(replace(t1.avbwth,chr(13),''),chr(10),'') as avbwth
,replace(replace(t1.bennam,chr(13),''),chr(10),'') as bennam
,replace(replace(t1.benref,chr(13),''),chr(10),'') as benref
,replace(replace(t1.chato,chr(13),''),chr(10),'') as chato
,replace(replace(t1.cnfflg,chr(13),''),chr(10),'') as cnfflg
,replace(replace(t1.cnfdet,chr(13),''),chr(10),'') as cnfdet
,replace(replace(t1.cnfsta,chr(13),''),chr(10),'') as cnfsta
,expdat
,replace(replace(t1.expplc,chr(13),''),chr(10),'') as expplc
,replace(replace(t1.lcrtyp,chr(13),''),chr(10),'') as lcrtyp
,replace(replace(t1.nomspc,chr(13),''),chr(10),'') as nomspc
,nomtop
,nomton
,preadvdt
,shpdat
,replace(replace(t1.shpfro,chr(13),''),chr(10),'') as shpfro
,replace(replace(t1.shppar,chr(13),''),chr(10),'') as shppar
,replace(replace(t1.shpto,chr(13),''),chr(10),'') as shpto
,replace(replace(t1.shptrs,chr(13),''),chr(10),'') as shptrs
,replace(replace(t1.stacty,chr(13),''),chr(10),'') as stacty
,replace(replace(t1.stagod,chr(13),''),chr(10),'') as stagod
,utlnbr
,replace(replace(t1.aplbnkdirsnd,chr(13),''),chr(10),'') as aplbnkdirsnd
,tenmaxday
,replace(replace(t1.cnfsnd,chr(13),''),chr(10),'') as cnfsnd
,replace(replace(t1.revflg,chr(13),''),chr(10),'') as revflg
,revnbr
,revtimes
,revdat
,replace(replace(t1.revcum,chr(13),''),chr(10),'') as revcum
,replace(replace(t1.revtyp,chr(13),''),chr(10),'') as revtyp
,replace(replace(t1.cnfins,chr(13),''),chr(10),'') as cnfins
,replace(replace(t1.redclsflg,chr(13),''),chr(10),'') as redclsflg
,advnbr
,replace(replace(t1.resflg,chr(13),''),chr(10),'') as resflg
,replace(replace(t1.inctrf,chr(13),''),chr(10),'') as inctrf
,replace(replace(t1.apprul,chr(13),''),chr(10),'') as apprul
,replace(replace(t1.apprultxt,chr(13),''),chr(10),'') as apprultxt
,replace(replace(t1.pordis,chr(13),''),chr(10),'') as pordis
,replace(replace(t1.porloa,chr(13),''),chr(10),'') as porloa
,replace(replace(t1.nonban,chr(13),''),chr(10),'') as nonban
,partcon
,replace(replace(t1.collflg,chr(13),''),chr(10),'') as collflg
,replace(replace(t1.teskeyunc,chr(13),''),chr(10),'') as teskeyunc
,replace(replace(t1.dbtflg,chr(13),''),chr(10),'') as dbtflg
,replace(replace(t1.branchinr,chr(13),''),chr(10),'') as branchinr
,replace(replace(t1.bchkeyinr,chr(13),''),chr(10),'') as bchkeyinr
,rskrat
,replace(replace(t1.tratyp,chr(13),''),chr(10),'') as tratyp
,replace(replace(t1.negflg,chr(13),''),chr(10),'') as negflg
,replace(replace(t1.cretyp,chr(13),''),chr(10),'') as cretyp
,replace(replace(t1.contractno,chr(13),''),chr(10),'') as contractno
,replace(replace(t1.shpins,chr(13),''),chr(10),'') as shpins
,replace(replace(t1.tadtyp,chr(13),''),chr(10),'') as tadtyp
,replace(replace(t1.sermod,chr(13),''),chr(10),'') as sermod
,replace(replace(t1.serfro,chr(13),''),chr(10),'') as serfro
,replace(replace(t1.comflg,chr(13),''),chr(10),'') as comflg
,replace(replace(t1.elcflg,chr(13),''),chr(10),'') as elcflg
,replace(replace(t1.concur,chr(13),''),chr(10),'') as concur
,conamt
,replace(replace(t1.rejame,chr(13),''),chr(10),'') as rejame
,rejnbr
,replace(replace(t1.cantyp,chr(13),''),chr(10),'') as cantyp
,replace(replace(t1.rejflg,chr(13),''),chr(10),'') as rejflg
,replace(replace(t1.dkflg,chr(13),''),chr(10),'') as dkflg
,nomtop1
,nomton1
,replace(replace(t1.kzref,chr(13),''),chr(10),'') as kzref

from ${iol_schema}.isbs_ded t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/isbs_ded.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
