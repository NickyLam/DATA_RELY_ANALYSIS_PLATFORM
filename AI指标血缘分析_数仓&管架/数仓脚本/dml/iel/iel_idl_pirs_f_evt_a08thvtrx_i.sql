: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_f_evt_a08thvtrx_i
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_f_evt_a08thvtrx_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select mainseq
,transseq
,businesstrace
,cmtno
,hosttrcd
,fronttrcd
,transdt
,consigndt
,hostdate
,hostnbr
,ccynbr
,transamt
,spbrn
,sndct
,sndupbrn
,sndbrn
,paybrn
,payopenbrn
,payopenbanknm
,payacct
,payname
,payaddr
,rcvct
,rcvupbrn
,rcvbrn
,incobrn
,recvopenbanknm
,incoacct
,inconame
,incoaddr
,servtype
,bustype
,billdt
,billcode
,orasndbrn
,oracmtno
,cmpsamt
,inrate
,refuseamt
,status
,processcode
,varseal
,ckrvnbr
,sndrvnbr
,cleardt
,errcode
,errms
,levels
,oprtlr
,chktlr
,sndtlr
,auttlr
,stoptlr
,oprbrn
,sndtlrbrn
,autbrn
,seccode
,chkstatus
,info
,note
,note2
,prtcnt
,rcvdt
,transmitdt
,billseccode
,paydt
,wlflag
,flag2
,flag3
,flag4
,billrqcode
,sacacct
,sacname
,crdt
,crtlr
,crbrn
,cracct
,crseq
,prodnbr
,tracenbr
,sndtracenbr
,bookcode
,bookdate
,bookseqno
,idtype
,idno
,maxtransamt
,transnbr
,sndtransnbr
,changtime
,reserv40
,rcdver
,rcdstatus
,paymod
,openwintype
,changdate
,servnbr
,magebrn
,feeamt
,feeamt1
,feeamt2
,feeamt3
,linkid
,endtlr
,edhostnbr
,edhostdt
,prodcd
,isinout
,inacct
,inname
,ourcnapsver
,othercnapsver
,landdealsts
,checkdealsts
,appenddatatable
,hangupreason
,modifytlr
,info2
,cmtno2
,bustype2
,servtype2 from idl.pirs_f_evt_a08thvtrx where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_f_evt_a08thvtrx_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes