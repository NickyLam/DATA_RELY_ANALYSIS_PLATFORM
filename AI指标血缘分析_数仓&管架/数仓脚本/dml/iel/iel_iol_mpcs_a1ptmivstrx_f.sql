: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a1ptmivstrx_f
CreateDate: 20240827
FileName:   ${iel_data_path}/mpcs_a1ptmivstrx.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.transdt,chr(13),''),chr(10),'') as transdt
,replace(replace(t1.transtm,chr(13),''),chr(10),'') as transtm
,replace(replace(t1.pckno,chr(13),''),chr(10),'') as pckno
,replace(replace(t1.sndbrn,chr(13),''),chr(10),'') as sndbrn
,replace(replace(t1.sndupbrn,chr(13),''),chr(10),'') as sndupbrn
,replace(replace(t1.rcvbrn,chr(13),''),chr(10),'') as rcvbrn
,replace(replace(t1.rcvupbrn,chr(13),''),chr(10),'') as rcvupbrn
,replace(replace(t1.consigndt,chr(13),''),chr(10),'') as consigndt
,replace(replace(t1.transseq,chr(13),''),chr(10),'') as transseq
,replace(replace(t1.msgrefid,chr(13),''),chr(10),'') as msgrefid
,replace(replace(t1.iotype,chr(13),''),chr(10),'') as iotype
,replace(replace(t1.mobnb,chr(13),''),chr(10),'') as mobnb
,replace(replace(t1.entprs,chr(13),''),chr(10),'') as entprs
,replace(replace(t1.nm,chr(13),''),chr(10),'') as nm
,replace(replace(t1.nmoflglprsn,chr(13),''),chr(10),'') as nmoflglprsn
,replace(replace(t1.tranm,chr(13),''),chr(10),'') as tranm
,replace(replace(t1.idtp,chr(13),''),chr(10),'') as idtp
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.unisoccdtcd,chr(13),''),chr(10),'') as unisoccdtcd
,replace(replace(t1.bizregnb,chr(13),''),chr(10),'') as bizregnb
,replace(replace(t1.txpyridnb,chr(13),''),chr(10),'') as txpyridnb
,replace(replace(t1.agtnm,chr(13),''),chr(10),'') as agtnm
,replace(replace(t1.agtid,chr(13),''),chr(10),'') as agtid
,replace(replace(t1.opnm,chr(13),''),chr(10),'') as opnm
,replace(replace(t1.margbrn,chr(13),''),chr(10),'') as margbrn
,replace(replace(t1.tlrno,chr(13),''),chr(10),'') as tlrno
,replace(replace(t1.srcseqno,chr(13),''),chr(10),'') as srcseqno
,replace(replace(t1.sysind,chr(13),''),chr(10),'') as sysind
,replace(replace(t1.quedt,chr(13),''),chr(10),'') as quedt
,replace(replace(t1.acctsts,chr(13),''),chr(10),'') as acctsts
,replace(replace(t1.chngdt,chr(13),''),chr(10),'') as chngdt
,replace(replace(t1.orgdlvrgtransseq,chr(13),''),chr(10),'') as orgdlvrgtransseq
,replace(replace(t1.cntt,chr(13),''),chr(10),'') as cntt
,replace(replace(t1.contactnm,chr(13),''),chr(10),'') as contactnm
,replace(replace(t1.contactnb,chr(13),''),chr(10),'') as contactnb
,replace(replace(t1.rcvdt,chr(13),''),chr(10),'') as rcvdt
,replace(replace(t1.rcvtm,chr(13),''),chr(10),'') as rcvtm
,replace(replace(t1.msgid,chr(13),''),chr(10),'') as msgid
,replace(replace(t1.procsts,chr(13),''),chr(10),'') as procsts
,replace(replace(t1.proccd,chr(13),''),chr(10),'') as proccd
,replace(replace(t1.rslt,chr(13),''),chr(10),'') as rslt
,replace(replace(t1.mobcrr,chr(13),''),chr(10),'') as mobcrr
,replace(replace(t1.locmobnb,chr(13),''),chr(10),'') as locmobnb
,replace(replace(t1.cdtp,chr(13),''),chr(10),'') as cdtp
,replace(replace(t1.locnmmobnb,chr(13),''),chr(10),'') as locnmmobnb
,replace(replace(t1.sts,chr(13),''),chr(10),'') as sts
,replace(replace(t1.dataresrcdt,chr(13),''),chr(10),'') as dataresrcdt
,replace(replace(t1.cotp,chr(13),''),chr(10),'') as cotp
,replace(replace(t1.dom,chr(13),''),chr(10),'') as dom
,replace(replace(t1.regcptl,chr(13),''),chr(10),'') as regcptl
,replace(replace(t1.dtest,chr(13),''),chr(10),'') as dtest
,replace(replace(t1.opprdfrom,chr(13),''),chr(10),'') as opprdfrom
,replace(replace(t1.opprdto,chr(13),''),chr(10),'') as opprdto
,replace(replace(t1.regsts,chr(13),''),chr(10),'') as regsts
,replace(replace(t1.regauth,chr(13),''),chr(10),'') as regauth
,replace(replace(t1.bizscp,chr(13),''),chr(10),'') as bizscp
,replace(replace(t1.dtappr,chr(13),''),chr(10),'') as dtappr
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.errmsg,chr(13),''),chr(10),'') as errmsg
,replace(replace(t1.appendtable,chr(13),''),chr(10),'') as appendtable
,replace(replace(t1.lastpgind,chr(13),''),chr(10),'') as lastpgind
,replace(replace(t1.ttlpgnb,chr(13),''),chr(10),'') as ttlpgnb
,replace(replace(t1.curpgnb,chr(13),''),chr(10),'') as curpgnb
,replace(replace(t1.vrytp,chr(13),''),chr(10),'') as vrytp
,replace(replace(t1.valtp,chr(13),''),chr(10),'') as valtp
,replace(replace(t1.issdt,chr(13),''),chr(10),'') as issdt
,replace(replace(t1.exprdt,chr(13),''),chr(10),'') as exprdt
,replace(replace(t1.piclen,chr(13),''),chr(10),'') as piclen
,replace(replace(t1.picfile,chr(13),''),chr(10),'') as picfile
,replace(replace(t1.picvryrslt,chr(13),''),chr(10),'') as picvryrslt
,replace(replace(t1.picchkinf,chr(13),''),chr(10),'') as picchkinf
,replace(replace(t1.simsco,chr(13),''),chr(10),'') as simsco
,replace(replace(t1.busclass,chr(13),''),chr(10),'') as busclass
,replace(replace(t1.busclassdes,chr(13),''),chr(10),'') as busclassdes
,replace(replace(t1.subclass,chr(13),''),chr(10),'') as subclass
,replace(replace(t1.subclassdes,chr(13),''),chr(10),'') as subclassdes

from ${iol_schema}.mpcs_a1ptmivstrx t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a1ptmivstrx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
