: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_f_evt_a08thvhp_i
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_f_evt_a08thvhp_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select mainseq
,transdt
,cshpbillnb
,cshpbilldate
,payacct
,payname
,magebrn
,cshpbilltype
,ccynbr
,cshpbillamt
,cshpbillsign
,cshpcashbkno
,inconame
,incoacct
,infocode
,info
,billst
,msgsrc
,chngna
,cshplastopenbkno
,cshplastacct
,cshplastname
,operdt
,opersq
,oprtlr
,chktlr
,clenus
,auttlr
,prttlr
,prtcnt
,incodt
,chngam
,refdid
,consigndt
,respcd
,lostdt
,unlsdt
,lostlr
,ulstlr
,idtftp1
,idtfno1
,operna1
,losttm
,lostad
,linkad1
,linktl1
,lostrs1
,idtftp2
,idtfno2
,operna2
,linkad2
,linktl2
,lostrs2
,provtp
,provno
,reason
,execut
,execpe
,certtp
,certno
,provtp2
,provno2
,reason2
,execut2
,execpe2
,certtp2
,certno2
,signbilltype
,flag3
,feeamt
,feeamt1
,feeamt2
,bookdt
,booknb
,payopenbrn
,payopenbrnnm
,incobrn
,incobrnnm
,idtftp3
,idtfno3
,oprtlr3
,reason3
,type3
,paybrnno
,paybrnname
,reason4
,hpstatus from idl.pirs_f_evt_a08thvhp where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_f_evt_a08thvhp_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes