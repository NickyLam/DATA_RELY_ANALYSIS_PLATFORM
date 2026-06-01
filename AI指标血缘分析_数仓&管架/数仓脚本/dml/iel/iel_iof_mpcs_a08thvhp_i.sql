: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_mpcs_a08thvhp_i
CreateDate: 20250410
FileName:   ${iel_data_path}/mpcs_a08thvhp.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.mainseq,chr(13),''),chr(10),'') as mainseq
,replace(replace(t1.transdt,chr(13),''),chr(10),'') as transdt
,replace(replace(t1.cshpbillnb,chr(13),''),chr(10),'') as cshpbillnb
,replace(replace(t1.cshpbilldate,chr(13),''),chr(10),'') as cshpbilldate
,replace(replace(t1.payacct,chr(13),''),chr(10),'') as payacct
,replace(replace(t1.payname,chr(13),''),chr(10),'') as payname
,replace(replace(t1.magebrn,chr(13),''),chr(10),'') as magebrn
,replace(replace(t1.cshpbilltype,chr(13),''),chr(10),'') as cshpbilltype
,replace(replace(t1.ccynbr,chr(13),''),chr(10),'') as ccynbr
,cshpbillamt
,replace(replace(t1.cshpbillsign,chr(13),''),chr(10),'') as cshpbillsign
,replace(replace(t1.cshpcashbkno,chr(13),''),chr(10),'') as cshpcashbkno
,replace(replace(t1.inconame,chr(13),''),chr(10),'') as inconame
,replace(replace(t1.incoacct,chr(13),''),chr(10),'') as incoacct
,replace(replace(t1.infocode,chr(13),''),chr(10),'') as infocode
,replace(replace(t1.info,chr(13),''),chr(10),'') as info
,replace(replace(t1.billst,chr(13),''),chr(10),'') as billst
,replace(replace(t1.msgsrc,chr(13),''),chr(10),'') as msgsrc
,replace(replace(t1.chngna,chr(13),''),chr(10),'') as chngna
,replace(replace(t1.cshplastopenbkno,chr(13),''),chr(10),'') as cshplastopenbkno
,replace(replace(t1.cshplastacct,chr(13),''),chr(10),'') as cshplastacct
,replace(replace(t1.cshplastname,chr(13),''),chr(10),'') as cshplastname
,replace(replace(t1.operdt,chr(13),''),chr(10),'') as operdt
,replace(replace(t1.opersq,chr(13),''),chr(10),'') as opersq
,replace(replace(t1.oprtlr,chr(13),''),chr(10),'') as oprtlr
,replace(replace(t1.chktlr,chr(13),''),chr(10),'') as chktlr
,replace(replace(t1.clenus,chr(13),''),chr(10),'') as clenus
,replace(replace(t1.auttlr,chr(13),''),chr(10),'') as auttlr
,replace(replace(t1.prttlr,chr(13),''),chr(10),'') as prttlr
,prtcnt
,replace(replace(t1.incodt,chr(13),''),chr(10),'') as incodt
,chngam
,replace(replace(t1.refdid,chr(13),''),chr(10),'') as refdid
,replace(replace(t1.consigndt,chr(13),''),chr(10),'') as consigndt
,replace(replace(t1.respcd,chr(13),''),chr(10),'') as respcd
,replace(replace(t1.lostdt,chr(13),''),chr(10),'') as lostdt
,replace(replace(t1.unlsdt,chr(13),''),chr(10),'') as unlsdt
,replace(replace(t1.lostlr,chr(13),''),chr(10),'') as lostlr
,replace(replace(t1.ulstlr,chr(13),''),chr(10),'') as ulstlr
,replace(replace(t1.idtftp1,chr(13),''),chr(10),'') as idtftp1
,replace(replace(t1.idtfno1,chr(13),''),chr(10),'') as idtfno1
,replace(replace(t1.operna1,chr(13),''),chr(10),'') as operna1
,replace(replace(t1.losttm,chr(13),''),chr(10),'') as losttm
,replace(replace(t1.lostad,chr(13),''),chr(10),'') as lostad
,replace(replace(t1.linkad1,chr(13),''),chr(10),'') as linkad1
,replace(replace(t1.linktl1,chr(13),''),chr(10),'') as linktl1
,replace(replace(t1.lostrs1,chr(13),''),chr(10),'') as lostrs1
,replace(replace(t1.idtftp2,chr(13),''),chr(10),'') as idtftp2
,replace(replace(t1.idtfno2,chr(13),''),chr(10),'') as idtfno2
,replace(replace(t1.operna2,chr(13),''),chr(10),'') as operna2
,replace(replace(t1.linkad2,chr(13),''),chr(10),'') as linkad2
,replace(replace(t1.linktl2,chr(13),''),chr(10),'') as linktl2
,replace(replace(t1.lostrs2,chr(13),''),chr(10),'') as lostrs2
,replace(replace(t1.provtp,chr(13),''),chr(10),'') as provtp
,replace(replace(t1.provno,chr(13),''),chr(10),'') as provno
,replace(replace(t1.reason,chr(13),''),chr(10),'') as reason
,replace(replace(t1.execut,chr(13),''),chr(10),'') as execut
,replace(replace(t1.execpe,chr(13),''),chr(10),'') as execpe
,replace(replace(t1.certtp,chr(13),''),chr(10),'') as certtp
,replace(replace(t1.certno,chr(13),''),chr(10),'') as certno
,replace(replace(t1.provtp2,chr(13),''),chr(10),'') as provtp2
,replace(replace(t1.provno2,chr(13),''),chr(10),'') as provno2
,replace(replace(t1.reason2,chr(13),''),chr(10),'') as reason2
,replace(replace(t1.execut2,chr(13),''),chr(10),'') as execut2
,replace(replace(t1.execpe2,chr(13),''),chr(10),'') as execpe2
,replace(replace(t1.certtp2,chr(13),''),chr(10),'') as certtp2
,replace(replace(t1.certno2,chr(13),''),chr(10),'') as certno2
,replace(replace(t1.signbilltype,chr(13),''),chr(10),'') as signbilltype
,replace(replace(t1.flag3,chr(13),''),chr(10),'') as flag3
,feeamt
,feeamt1
,feeamt2
,replace(replace(t1.bookdt,chr(13),''),chr(10),'') as bookdt
,replace(replace(t1.booknb,chr(13),''),chr(10),'') as booknb
,replace(replace(t1.payopenbrn,chr(13),''),chr(10),'') as payopenbrn
,replace(replace(t1.payopenbrnnm,chr(13),''),chr(10),'') as payopenbrnnm
,replace(replace(t1.incobrn,chr(13),''),chr(10),'') as incobrn
,replace(replace(t1.incobrnnm,chr(13),''),chr(10),'') as incobrnnm
,replace(replace(t1.idtftp3,chr(13),''),chr(10),'') as idtftp3
,replace(replace(t1.idtfno3,chr(13),''),chr(10),'') as idtfno3
,replace(replace(t1.oprtlr3,chr(13),''),chr(10),'') as oprtlr3
,replace(replace(t1.reason3,chr(13),''),chr(10),'') as reason3
,replace(replace(t1.paytype,chr(13),''),chr(10),'') as paytype
,replace(replace(t1.paybrnno,chr(13),''),chr(10),'') as paybrnno
,replace(replace(t1.paybrnname,chr(13),''),chr(10),'') as paybrnname
,replace(replace(t1.reason4,chr(13),''),chr(10),'') as reason4
,replace(replace(t1.hpstatus,chr(13),''),chr(10),'') as hpstatus
,replace(replace(t1.paytp,chr(13),''),chr(10),'') as paytp
,replace(replace(t1.bkcode,chr(13),''),chr(10),'') as bkcode

from ${iol_schema}.mpcs_a08thvhp t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a08thvhp.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
