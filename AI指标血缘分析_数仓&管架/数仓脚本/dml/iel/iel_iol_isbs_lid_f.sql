: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_isbs_lid_f
CreateDate: 20240722
FileName:   ${iel_data_path}/isbs_lid.f.${batch_date}.dat
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
,replace(replace(t1.advnam,chr(13),''),chr(10),'') as advnam
,replace(replace(t1.advref,chr(13),''),chr(10),'') as advref
,amedat
,amenbr
,replace(replace(t1.aplnam,chr(13),''),chr(10),'') as aplnam
,replace(replace(t1.aplref,chr(13),''),chr(10),'') as aplref
,replace(replace(t1.avbby,chr(13),''),chr(10),'') as avbby
,replace(replace(t1.avbwth,chr(13),''),chr(10),'') as avbwth
,replace(replace(t1.bennam,chr(13),''),chr(10),'') as bennam
,replace(replace(t1.benref,chr(13),''),chr(10),'') as benref
,replace(replace(t1.chato,chr(13),''),chr(10),'') as chato
,replace(replace(t1.cnfdet,chr(13),''),chr(10),'') as cnfdet
,expdat
,replace(replace(t1.expplc,chr(13),''),chr(10),'') as expplc
,replace(replace(t1.lcrtyp,chr(13),''),chr(10),'') as lcrtyp
,replace(replace(t1.nomspc,chr(13),''),chr(10),'') as nomspc
,nomtop
,nomton
,preadvdt
,replace(replace(t1.rmbact,chr(13),''),chr(10),'') as rmbact
,replace(replace(t1.rmbcha,chr(13),''),chr(10),'') as rmbcha
,replace(replace(t1.rmbflg,chr(13),''),chr(10),'') as rmbflg
,shpdat
,replace(replace(t1.shpfro,chr(13),''),chr(10),'') as shpfro
,replace(replace(t1.porloa,chr(13),''),chr(10),'') as porloa
,replace(replace(t1.pordis,chr(13),''),chr(10),'') as pordis
,replace(replace(t1.shppar,chr(13),''),chr(10),'') as shppar
,replace(replace(t1.shpto,chr(13),''),chr(10),'') as shpto
,replace(replace(t1.shptrs,chr(13),''),chr(10),'') as shptrs
,replace(replace(t1.stacty,chr(13),''),chr(10),'') as stacty
,replace(replace(t1.stagod,chr(13),''),chr(10),'') as stagod
,utlnbr
,advnbr
,replace(replace(t1.redclsflg,chr(13),''),chr(10),'') as redclsflg
,replace(replace(t1.ver,chr(13),''),chr(10),'') as ver
,replace(replace(t1.lcityp,chr(13),''),chr(10),'') as lcityp
,replace(replace(t1.b2binr,chr(13),''),chr(10),'') as b2binr
,replace(replace(t1.b2bref,chr(13),''),chr(10),'') as b2bref
,revnbr
,revtimes
,replace(replace(t1.revflg,chr(13),''),chr(10),'') as revflg
,replace(replace(t1.revawapl,chr(13),''),chr(10),'') as revawapl
,revdat
,replace(replace(t1.revcum,chr(13),''),chr(10),'') as revcum
,replace(replace(t1.revtyp,chr(13),''),chr(10),'') as revtyp
,replace(replace(t1.initpty,chr(13),''),chr(10),'') as initpty
,replace(replace(t1.resflg,chr(13),''),chr(10),'') as resflg
,replace(replace(t1.apprul,chr(13),''),chr(10),'') as apprul
,replace(replace(t1.apprulrmb,chr(13),''),chr(10),'') as apprulrmb
,replace(replace(t1.apprultxt,chr(13),''),chr(10),'') as apprultxt
,autdat
,replace(replace(t1.etyextkey,chr(13),''),chr(10),'') as etyextkey
,tenmaxday
,replace(replace(t1.branchinr,chr(13),''),chr(10),'') as branchinr
,replace(replace(t1.bchkeyinr,chr(13),''),chr(10),'') as bchkeyinr
,replace(replace(t1.decflg,chr(13),''),chr(10),'') as decflg
,cshpct
,replace(replace(t1.isstyp,chr(13),''),chr(10),'') as isstyp
,replace(replace(t1.fincod,chr(13),''),chr(10),'') as fincod
,replace(replace(t1.fintyp,chr(13),''),chr(10),'') as fintyp
,relcshpct
,replace(replace(t1.jjh,chr(13),''),chr(10),'') as jjh
,replace(replace(t1.dflg,chr(13),''),chr(10),'') as dflg
,replace(replace(t1.guaflg,chr(13),''),chr(10),'') as guaflg
,replace(replace(t1.tratyp,chr(13),''),chr(10),'') as tratyp
,opnamo
,replace(replace(t1.ameflg,chr(13),''),chr(10),'') as ameflg
,replace(replace(t1.cretyp,chr(13),''),chr(10),'') as cretyp
,replace(replace(t1.tadtyp,chr(13),''),chr(10),'') as tadtyp
,replace(replace(t1.shpins,chr(13),''),chr(10),'') as shpins
,replace(replace(t1.sermod,chr(13),''),chr(10),'') as sermod
,replace(replace(t1.serfro,chr(13),''),chr(10),'') as serfro
,replace(replace(t1.negflg,chr(13),''),chr(10),'') as negflg
,replace(replace(t1.comflg,chr(13),''),chr(10),'') as comflg
,replace(replace(t1.insdat,chr(13),''),chr(10),'') as insdat
,replace(replace(t1.shppars18,chr(13),''),chr(10),'') as shppars18
,replace(replace(t1.shptrss18,chr(13),''),chr(10),'') as shptrss18
,replace(replace(t1.spcbenflg,chr(13),''),chr(10),'') as spcbenflg
,replace(replace(t1.spcrcbflg,chr(13),''),chr(10),'') as spcrcbflg
,replace(replace(t1.prepertxts18,chr(13),''),chr(10),'') as prepertxts18
,prepers18
,replace(replace(t1.zytyp,chr(13),''),chr(10),'') as zytyp

from ${iol_schema}.isbs_lid t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/isbs_lid.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
