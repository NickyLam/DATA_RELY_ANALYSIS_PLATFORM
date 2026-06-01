: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_isbs_cpd_f
CreateDate: 20250208
FileName:   ${iel_data_path}/isbs_cpd.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.inr,chr(13),''),chr(10),'') as inr
,replace(replace(t1.ownref,chr(13),''),chr(10),'') as ownref
,replace(replace(t1.nam,chr(13),''),chr(10),'') as nam
,replace(replace(t1.pyeptyinr,chr(13),''),chr(10),'') as pyeptyinr
,replace(replace(t1.pyeptainr,chr(13),''),chr(10),'') as pyeptainr
,replace(replace(t1.pyenam,chr(13),''),chr(10),'') as pyenam
,replace(replace(t1.pyeref,chr(13),''),chr(10),'') as pyeref
,replace(replace(t1.pybptyinr,chr(13),''),chr(10),'') as pybptyinr
,replace(replace(t1.pybptainr,chr(13),''),chr(10),'') as pybptainr
,replace(replace(t1.pybnam,chr(13),''),chr(10),'') as pybnam
,replace(replace(t1.pybref,chr(13),''),chr(10),'') as pybref
,replace(replace(t1.orcptyinr,chr(13),''),chr(10),'') as orcptyinr
,replace(replace(t1.orcptainr,chr(13),''),chr(10),'') as orcptainr
,replace(replace(t1.orcnam,chr(13),''),chr(10),'') as orcnam
,replace(replace(t1.orcref,chr(13),''),chr(10),'') as orcref
,replace(replace(t1.oriptyinr,chr(13),''),chr(10),'') as oriptyinr
,replace(replace(t1.oriptainr,chr(13),''),chr(10),'') as oriptainr
,replace(replace(t1.orinam,chr(13),''),chr(10),'') as orinam
,replace(replace(t1.oriref,chr(13),''),chr(10),'') as oriref
,valdat
,opndat
,clsdat
,replace(replace(t1.chato,chr(13),''),chr(10),'') as chato
,credat
,replace(replace(t1.ownusr,chr(13),''),chr(10),'') as ownusr
,replace(replace(t1.ver,chr(13),''),chr(10),'') as ver
,replace(replace(t1.detchgcod,chr(13),''),chr(10),'') as detchgcod
,replace(replace(t1.paytyp,chr(13),''),chr(10),'') as paytyp
,replace(replace(t1.stagod,chr(13),''),chr(10),'') as stagod
,replace(replace(t1.stacty,chr(13),''),chr(10),'') as stacty
,replace(replace(t1.etyextkey,chr(13),''),chr(10),'') as etyextkey
,replace(replace(t1.sysno,chr(13),''),chr(10),'') as sysno
,replace(replace(t1.othbch,chr(13),''),chr(10),'') as othbch
,replace(replace(t1.gors,chr(13),''),chr(10),'') as gors
,replace(replace(t1.feecur,chr(13),''),chr(10),'') as feecur
,feeamt
,replace(replace(t1.trntyp,chr(13),''),chr(10),'') as trntyp
,replace(replace(t1.paytype,chr(13),''),chr(10),'') as paytype
,paydat
,replace(replace(t1.clityp,chr(13),''),chr(10),'') as clityp
,replace(replace(t1.trdint,chr(13),''),chr(10),'') as trdint
,replace(replace(t1.curf33b,chr(13),''),chr(10),'') as curf33b
,replace(replace(t1.cur71f,chr(13),''),chr(10),'') as cur71f
,amt71f
,amtf33b
,f36
,replace(replace(t1.f23e,chr(13),''),chr(10),'') as f23e
,replace(replace(t1.f23b,chr(13),''),chr(10),'') as f23b
,replace(replace(t1.trdout,chr(13),''),chr(10),'') as trdout
,replace(replace(t1.swftyp,chr(13),''),chr(10),'') as swftyp
,replace(replace(t1.trdinr,chr(13),''),chr(10),'') as trdinr
,replace(replace(t1.rel21,chr(13),''),chr(10),'') as rel21
,replace(replace(t1.branchinr,chr(13),''),chr(10),'') as branchinr
,replace(replace(t1.bchkeyinr,chr(13),''),chr(10),'') as bchkeyinr
,replace(replace(t1.accmod,chr(13),''),chr(10),'') as accmod
,replace(replace(t1.sztyp,chr(13),''),chr(10),'') as sztyp
,replace(replace(t1.sndbanref,chr(13),''),chr(10),'') as sndbanref
,replace(replace(t1.orcact,chr(13),''),chr(10),'') as orcact
,replace(replace(t1.pyeact,chr(13),''),chr(10),'') as pyeact
,replace(replace(t1.canflg,chr(13),''),chr(10),'') as canflg
,replace(replace(t1.nraflg,chr(13),''),chr(10),'') as nraflg
,replace(replace(t1.qsqdbh,chr(13),''),chr(10),'') as qsqdbh
,replace(replace(t1.zjcflg,chr(13),''),chr(10),'') as zjcflg
,replace(replace(t1.edtyp,chr(13),''),chr(10),'') as edtyp
,basamt
,intamt
,replace(replace(t1.stzfref,chr(13),''),chr(10),'') as stzfref
,replace(replace(t1.duebillno,chr(13),''),chr(10),'') as duebillno
,replace(replace(t1.gpiflg,chr(13),''),chr(10),'') as gpiflg
,replace(replace(t1.acstyp,chr(13),''),chr(10),'') as acstyp
,replace(replace(t1.qufflg,chr(13),''),chr(10),'') as qufflg
,replace(replace(t1.feeacc,chr(13),''),chr(10),'') as feeacc
,replace(replace(t1.resno,chr(13),''),chr(10),'') as resno
,replace(replace(t1.iskds,chr(13),''),chr(10),'') as iskds
,replace(replace(t1.sbflg,chr(13),''),chr(10),'') as sbflg

from ${iol_schema}.isbs_cpd t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/isbs_cpd.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
