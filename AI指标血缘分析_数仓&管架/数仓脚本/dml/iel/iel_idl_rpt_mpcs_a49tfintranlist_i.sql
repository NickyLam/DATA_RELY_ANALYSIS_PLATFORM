: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_mpcs_a49tfintranlist_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_mpcs_a49tfintranlist.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.mainseq,chr(13),''),chr(10),'') as mainseq
,replace(replace(t1.transdt,chr(13),''),chr(10),'') as transdt
,replace(replace(t1.sysid,chr(13),''),chr(10),'') as sysid
,replace(replace(t1.transtime,chr(13),''),chr(10),'') as transtime
,replace(replace(t1.unotnbr,chr(13),''),chr(10),'') as unotnbr
,replace(replace(t1.unotdate,chr(13),''),chr(10),'') as unotdate
,replace(replace(t1.hosttrcd,chr(13),''),chr(10),'') as hosttrcd
,replace(replace(t1.fronttrcd,chr(13),''),chr(10),'') as fronttrcd
,replace(replace(t1.magbrn,chr(13),''),chr(10),'') as magbrn
,replace(replace(t1.userid,chr(13),''),chr(10),'') as userid
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.hostdate,chr(13),''),chr(10),'') as hostdate
,replace(replace(t1.hostnbr,chr(13),''),chr(10),'') as hostnbr
,replace(replace(t1.payacct,chr(13),''),chr(10),'') as payacct
,replace(replace(t1.payname,chr(13),''),chr(10),'') as payname
,replace(replace(t1.incoacct,chr(13),''),chr(10),'') as incoacct
,replace(replace(t1.inconame,chr(13),''),chr(10),'') as inconame
,replace(replace(t1.dataid,chr(13),''),chr(10),'') as dataid
,replace(replace(t1.errcode,chr(13),''),chr(10),'') as errcode
,replace(replace(t1.errms,chr(13),''),chr(10),'') as errms
,replace(replace(t1.colsts,chr(13),''),chr(10),'') as colsts
,replace(replace(t1.transamt,chr(13),''),chr(10),'') as transamt
,replace(replace(t1.abscde,chr(13),''),chr(10),'') as abscde
,replace(replace(t1.colldate,chr(13),''),chr(10),'') as colldate
,replace(replace(t1.eaccflg,chr(13),''),chr(10),'') as eaccflg
,replace(replace(t1.transeqno,chr(13),''),chr(10),'') as transeqno
,replace(replace(t1.globalseqno,chr(13),''),chr(10),'') as globalseqno
 from iol.mpcs_a49tfintranlist T1
where unotdate='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_mpcs_a49tfintranlist.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes