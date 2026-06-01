: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_isbs_fud_f
CreateDate: 20240228
FileName:   ${iel_data_path}/isbs_fud.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.inr,chr(13),''),chr(10),'') as inr
,replace(replace(t1.ownref,chr(13),''),chr(10),'') as ownref
,replace(replace(t1.nam,chr(13),''),chr(10),'') as nam
,opndat
,replace(replace(t1.proref,chr(13),''),chr(10),'') as proref
,replace(replace(t1.ovaref,chr(13),''),chr(10),'') as ovaref
,replace(replace(t1.trnway,chr(13),''),chr(10),'') as trnway
,replace(replace(t1.lmttyp,chr(13),''),chr(10),'') as lmttyp
,expdat
,replace(replace(t1.frgact,chr(13),''),chr(10),'') as frgact
,replace(replace(t1.frgcur,chr(13),''),chr(10),'') as frgcur
,frgamt
,rat
,replace(replace(t1.cnyact,chr(13),''),chr(10),'') as cnyact
,replace(replace(t1.cnycur,chr(13),''),chr(10),'') as cnycur
,cnyamt
,clsdat
,replace(replace(t1.mrgact,chr(13),''),chr(10),'') as mrgact
,replace(replace(t1.mrgcur,chr(13),''),chr(10),'') as mrgcur
,cshpct
,cshpctori
,replace(replace(t1.aplptyinr,chr(13),''),chr(10),'') as aplptyinr
,replace(replace(t1.aplptainr,chr(13),''),chr(10),'') as aplptainr
,replace(replace(t1.aplnam,chr(13),''),chr(10),'') as aplnam
,replace(replace(t1.apltyp,chr(13),''),chr(10),'') as apltyp
,replace(replace(t1.aplref,chr(13),''),chr(10),'') as aplref
,replace(replace(t1.inqref,chr(13),''),chr(10),'') as inqref
,replace(replace(t1.fixlmt,chr(13),''),chr(10),'') as fixlmt
,begdat
,enddat
,replace(replace(t1.stdlmt,chr(13),''),chr(10),'') as stdlmt
,replace(replace(t1.extlmt,chr(13),''),chr(10),'') as extlmt
,replace(replace(t1.extflg,chr(13),''),chr(10),'') as extflg
,replace(replace(t1.hdltyp,chr(13),''),chr(10),'') as hdltyp
,sysrat
,sptrat
,appdat
,replace(replace(t1.infdsp,chr(13),''),chr(10),'') as infdsp
,replace(replace(t1.spread,chr(13),''),chr(10),'') as spread
,replace(replace(t1.ver,chr(13),''),chr(10),'') as ver
,credat
,replace(replace(t1.pnttyp,chr(13),''),chr(10),'') as pnttyp
,replace(replace(t1.pntinr,chr(13),''),chr(10),'') as pntinr
,replace(replace(t1.branchinr,chr(13),''),chr(10),'') as branchinr
,replace(replace(t1.bchkeyinr,chr(13),''),chr(10),'') as bchkeyinr
,lstamt
,replace(replace(t1.syflg,chr(13),''),chr(10),'') as syflg
,losamt
,replace(replace(t1.loscur,chr(13),''),chr(10),'') as loscur
,replace(replace(t1.lstcur,chr(13),''),chr(10),'') as lstcur
,replace(replace(t1.etyextkey,chr(13),''),chr(10),'') as etyextkey
,replace(replace(t1.trnman,chr(13),''),chr(10),'') as trnman
,replace(replace(t1.trdint,chr(13),''),chr(10),'') as trdint
,replace(replace(t1.trdout,chr(13),''),chr(10),'') as trdout
,replace(replace(t1.regref,chr(13),''),chr(10),'') as regref
,setdat
,replace(replace(t1.setref,chr(13),''),chr(10),'') as setref
,cetrat
,ceurat
,cesamt
,replace(replace(t1.cesact,chr(13),''),chr(10),'') as cesact
,betrat
,beurat
,besamt
,eusinc
,replace(replace(t1.eudtyp,chr(13),''),chr(10),'') as eudtyp
,cdrrat
,cdramt
,replace(replace(t1.cdract,chr(13),''),chr(10),'') as cdract
,bdrrat
,bdramt
,dcrinc
,replace(replace(t1.mrgcurbnk,chr(13),''),chr(10),'') as mrgcurbnk
,cshpctbnk
,cnyamtbnk
,replace(replace(t1.cnycurbnk,chr(13),''),chr(10),'') as cnycurbnk
,replace(replace(t1.cvaref,chr(13),''),chr(10),'') as cvaref
,inffrgamt
,infexpdat
,replace(replace(t1.inffvaref,chr(13),''),chr(10),'') as inffvaref
,replace(replace(t1.infadvflg,chr(13),''),chr(10),'') as infadvflg
,replace(replace(t1.clsflg,chr(13),''),chr(10),'') as clsflg
,replace(replace(t1.cdtref,chr(13),''),chr(10),'') as cdtref
,lmtpct
,replace(replace(t1.ccvint,chr(13),''),chr(10),'') as ccvint
,ccvrat
,lmdamt
,mrgamt
,lmtamt
,mrgamtbnk
,replace(replace(t1.ownusr,chr(13),''),chr(10),'') as ownusr
,replace(replace(t1.oldownref,chr(13),''),chr(10),'') as oldownref
,mrgamtprt
,replace(replace(t1.padflg,chr(13),''),chr(10),'') as padflg
,replace(replace(t1.selflg,chr(13),''),chr(10),'') as selflg
,replace(replace(t1.zjly,chr(13),''),chr(10),'') as zjly
,replace(replace(t1.rptcod,chr(13),''),chr(10),'') as rptcod
,replace(replace(t1.dbway,chr(13),''),chr(10),'') as dbway
,replace(replace(t1.setlmttyp,chr(13),''),chr(10),'') as setlmttyp
,rcvbnkamt
,replace(replace(t1.rcvtyp,chr(13),''),chr(10),'') as rcvtyp
,replace(replace(t1.ownact,chr(13),''),chr(10),'') as ownact
,replace(replace(t1.seqno,chr(13),''),chr(10),'') as seqno
,replace(replace(t1.hkchn,chr(13),''),chr(10),'') as hkchn

from ${iol_schema}.isbs_fud t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/isbs_fud.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
