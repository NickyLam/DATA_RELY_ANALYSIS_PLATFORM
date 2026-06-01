: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_o_zts_a68tszfstrx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_o_zts_a68tszfstrx_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select mainseq
,transdt
,businesstrace
,pckno
,txtpcd
,txcd
,txid
,cnsdt
,instgpty
,pkgbusinesstrace
,pksqno
,hosttrcd
,fronttrcd
,hostdate
,hostnbr
,crcycd
,transamt
,dbtrid
,sndbrnname
,cdtrid
,rcvbrnname
,payopenbank
,payopenbanknm
,payacct
,payname
,payaddr
,rcvopenbank
,rcvopenbanknm
,rcvacct
,rcvname
,rcvaddr
,orgnltxtpcd
,orgnlcnsdt
,orgnltxid
,orgnlinstgpty
,orgnlpkgbustrace
,netgrnd
,netgdt
,transt
,iotype
,flag4
,magebrn
,oprtlr
,chktlr
,sndtlr
,auttlr
,oprbrn
,sendbranch
,autbrn
,caclrs
,processcode
,rspncd
,rspninf
,rtncd
,rtninf
,rtrltd
,diskno
,clerdt
,bperno
,bpermg
,levels
,recdes
,chksta
,remark
,prtcnt
,transmitdt
,feeflag
,inoutflag
,sacact
,sacana
,clendt
,clenus
,clrbrn
,edhtno
,edhtdt
,endtlr
,prdnbr
,bookcd
,cobkdt
,booknbr
,idtype
,idno
,transq
,sdtrsq
,paymod
,opnwin
,feamt1
,feamt2
,feamt3
,calfee
,chngti
,rcdsta
,prodcd
,isinout
,inacct
,inname
,landdealsts
,checkdealsts
,appenddatatable
,appenddatadtltab
,hangupreason
,modifytlr
,feetype
,areacd
,acctchckflg
,servmode
,realtmcdtflg
,chflag
,protocolnb
,resndflg
,bllind
,blltp
,billnb
,channeldt
,tranflowno
,orgnlpksqno
,corprtnid
,pmtitmcd
,pmtitmnm
,billamount
,feeamount
,info2 from idl.pirs_o_zts_a68tszfstrx where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_o_zts_a68tszfstrx_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes