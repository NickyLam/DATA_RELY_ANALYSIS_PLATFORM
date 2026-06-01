: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_isbs_gid_f
CreateDate: 20240228
FileName:   ${iel_data_path}/isbs_gid.f.${batch_date}.dat
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
,replace(replace(t1.oldref,chr(13),''),chr(10),'') as oldref
,amedat
,orddat
,amenbr
,pndclm
,replace(replace(t1.chato,chr(13),''),chr(10),'') as chato
,expdat
,liadat
,replace(replace(t1.stacty,chr(13),''),chr(10),'') as stacty
,replace(replace(t1.ver,chr(13),''),chr(10),'') as ver
,replace(replace(t1.hndtyp,chr(13),''),chr(10),'') as hndtyp
,replace(replace(t1.gidtxtmodflg,chr(13),''),chr(10),'') as gidtxtmodflg
,replace(replace(t1.gtxinr,chr(13),''),chr(10),'') as gtxinr
,replace(replace(t1.giduil,chr(13),''),chr(10),'') as giduil
,replace(replace(t1.expflg,chr(13),''),chr(10),'') as expflg
,replace(replace(t1.liaflg,chr(13),''),chr(10),'') as liaflg
,orcdat
,replace(replace(t1.orcref,chr(13),''),chr(10),'') as orcref
,replace(replace(t1.orccur,chr(13),''),chr(10),'') as orccur
,orcamt
,orcrat
,replace(replace(t1.sndto,chr(13),''),chr(10),'') as sndto
,replace(replace(t1.purcan,chr(13),''),chr(10),'') as purcan
,replace(replace(t1.tenref,chr(13),''),chr(10),'') as tenref
,tendat
,avidat
,tenclsdat
,replace(replace(t1.decrea,chr(13),''),chr(10),'') as decrea
,replace(replace(t1.jurplc,chr(13),''),chr(10),'') as jurplc
,replace(replace(t1.jurlaw,chr(13),''),chr(10),'') as jurlaw
,replace(replace(t1.acc,chr(13),''),chr(10),'') as acc
,replace(replace(t1.resflg,chr(13),''),chr(10),'') as resflg
,replace(replace(t1.stagod,chr(13),''),chr(10),'') as stagod
,redamt
,replace(replace(t1.redcur,chr(13),''),chr(10),'') as redcur
,reddat
,replace(replace(t1.outcur,chr(13),''),chr(10),'') as outcur
,outamt
,replace(replace(t1.cnfsta,chr(13),''),chr(10),'') as cnfsta
,partcon
,cnfdat
,replace(replace(t1.cnfflg,chr(13),''),chr(10),'') as cnfflg
,replace(replace(t1.revflg,chr(13),''),chr(10),'') as revflg
,replace(replace(t1.etyextkey,chr(13),''),chr(10),'') as etyextkey
,replace(replace(t1.gartyp,chr(13),''),chr(10),'') as gartyp
,trmdat
,replace(replace(t1.legfrm,chr(13),''),chr(10),'') as legfrm
,inudat
,feecoldat
,replace(replace(t1.bchkeyinr,chr(13),''),chr(10),'') as bchkeyinr
,replace(replace(t1.branchinr,chr(13),''),chr(10),'') as branchinr
,replace(replace(t1.teskeyunc,chr(13),''),chr(10),'') as teskeyunc
,replace(replace(t1.juscod,chr(13),''),chr(10),'') as juscod
,replace(replace(t1.cunqii,chr(13),''),chr(10),'') as cunqii
,bilvvv
,replace(replace(t1.decflg,chr(13),''),chr(10),'') as decflg
,rskrat
,cshpct
,replace(replace(t1.guaflg,chr(13),''),chr(10),'') as guaflg
,replace(replace(t1.fincod,chr(13),''),chr(10),'') as fincod
,replace(replace(t1.fintyp,chr(13),''),chr(10),'') as fintyp
,relcshpct
,replace(replace(t1.garfin,chr(13),''),chr(10),'') as garfin
,replace(replace(t1.purpos,chr(13),''),chr(10),'') as purpos
,replace(replace(t1.plsiss,chr(13),''),chr(10),'') as plsiss

from ${iol_schema}.isbs_gid t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/isbs_gid.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
