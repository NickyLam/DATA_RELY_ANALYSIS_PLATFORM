: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_isbs_trn_f
CreateDate: 20240223
FileName:   ${iel_data_path}/isbs_trn.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.inr,chr(13),''),chr(10),'') as inr
,inidattim
,replace(replace(t1.inifrm,chr(13),''),chr(10),'') as inifrm
,replace(replace(t1.iniusr,chr(13),''),chr(10),'') as iniusr
,replace(replace(t1.ininam,chr(13),''),chr(10),'') as ininam
,replace(replace(t1.ownref,chr(13),''),chr(10),'') as ownref
,replace(replace(t1.objtyp,chr(13),''),chr(10),'') as objtyp
,replace(replace(t1.objinr,chr(13),''),chr(10),'') as objinr
,replace(replace(t1.objnam,chr(13),''),chr(10),'') as objnam
,replace(replace(t1.ssninr,chr(13),''),chr(10),'') as ssninr
,smhnxt
,replace(replace(t1.usg,chr(13),''),chr(10),'') as usg
,replace(replace(t1.usr,chr(13),''),chr(10),'') as usr
,cpldattim
,replace(replace(t1.infdsp,chr(13),''),chr(10),'') as infdsp
,replace(replace(t1.inftxt,chr(13),''),chr(10),'') as inftxt
,replace(replace(t1.relflg,chr(13),''),chr(10),'') as relflg
,replace(replace(t1.comflg,chr(13),''),chr(10),'') as comflg
,comdat
,replace(replace(t1.cortrninr,chr(13),''),chr(10),'') as cortrninr
,replace(replace(t1.xreflg,chr(13),''),chr(10),'') as xreflg
,replace(replace(t1.xrecurblk,chr(13),''),chr(10),'') as xrecurblk
,replace(replace(t1.relcur,chr(13),''),chr(10),'') as relcur
,relamt
,replace(replace(t1.reloricur,chr(13),''),chr(10),'') as reloricur
,reloriamt
,replace(replace(t1.relreq,chr(13),''),chr(10),'') as relreq
,replace(replace(t1.relres,chr(13),''),chr(10),'') as relres
,replace(replace(t1.cnfflg,chr(13),''),chr(10),'') as cnfflg
,replace(replace(t1.evttxt,chr(13),''),chr(10),'') as evttxt
,replace(replace(t1.rprusr,chr(13),''),chr(10),'') as rprusr
,replace(replace(t1.ordinr,chr(13),''),chr(10),'') as ordinr
,exedat
,replace(replace(t1.etyextkey,chr(13),''),chr(10),'') as etyextkey
,replace(replace(t1.bchkeyinr,chr(13),''),chr(10),'') as bchkeyinr
,replace(replace(t1.accbchinr,chr(13),''),chr(10),'') as accbchinr
,replace(replace(t1.relreq0,chr(13),''),chr(10),'') as relreq0
,replace(replace(t1.relreq1,chr(13),''),chr(10),'') as relreq1
,replace(replace(t1.relreq2,chr(13),''),chr(10),'') as relreq2
,replace(replace(t1.relres0,chr(13),''),chr(10),'') as relres0
,replace(replace(t1.relres1,chr(13),''),chr(10),'') as relres1
,replace(replace(t1.relres2,chr(13),''),chr(10),'') as relres2
,replace(replace(t1.relusr1,chr(13),''),chr(10),'') as relusr1
,replace(replace(t1.relusr2,chr(13),''),chr(10),'') as relusr2
,replace(replace(t1.relusr3,chr(13),''),chr(10),'') as relusr3
,replace(replace(t1.imginr,chr(13),''),chr(10),'') as imginr
,replace(replace(t1.branchinr,chr(13),''),chr(10),'') as branchinr
,replace(replace(t1.orgflg,chr(13),''),chr(10),'') as orgflg
,replace(replace(t1.addtxt,chr(13),''),chr(10),'') as addtxt
,replace(replace(t1.gylsh,chr(13),''),chr(10),'') as gylsh
,replace(replace(t1.gylsh1,chr(13),''),chr(10),'') as gylsh1
,replace(replace(t1.yewgzh,chr(13),''),chr(10),'') as yewgzh
,replace(replace(t1.cmtflg,chr(13),''),chr(10),'') as cmtflg
,replace(replace(t1.ctrbnknum,chr(13),''),chr(10),'') as ctrbnknum
,replace(replace(t1.ctrbnknam,chr(13),''),chr(10),'') as ctrbnknam
,replace(replace(t1.atrdon,chr(13),''),chr(10),'') as atrdon
,replace(replace(t1.atrque,chr(13),''),chr(10),'') as atrque
,replace(replace(t1.qjls,chr(13),''),chr(10),'') as qjls
,replace(replace(t1.qjlscz,chr(13),''),chr(10),'') as qjlscz
,replace(replace(t1.czreason,chr(13),''),chr(10),'') as czreason
,replace(replace(t1.ywls,chr(13),''),chr(10),'') as ywls

from ${iol_schema}.isbs_trn t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/isbs_trn.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
