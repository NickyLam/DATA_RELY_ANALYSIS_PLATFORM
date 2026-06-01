: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_o_zts_a10tibpsdetaillog_i
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_o_zts_a10tibpsdetaillog_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select function
,function1
,function2
,businesstrace
,businessno
,hostretcode
,processcode
,rscode
,functype
,businesskind
,businesstype
,batch
,amount
,kind
,settlestat
,trace
,hosttrace
,ticket
,node
,operater
,governor1
,governor2
,terminal
,printstat
,printstat1
,printtime
,subj
,vouchkind
,vouch
,billrecdate
,date0
,date1
,date2
,dealdate
,trantime
,sendtime
,level0
,flag1
,flag2
,flag3
,flag4
,acceptbank
,acceptbankname
,acceptacct
,acceptname
,acceptaccttype
,sendbank
,sendbankname
,sendacct
,sendname
,sendaccttype
,msgoutbank
,msginbank
,status
,counter
,fill
,rejectbank
,outsdficode
,insdficode
,sendopenbank
,acceptopenbank
,sendcitycode
,acceptcitycode
,chargefee
,postfee
,thirdchargefee
,settleamount
,endtoendid
,authtype
,authinfo
,authid
,merchantcode
,merchantname
,onlinetrantrace
,onlinetrantime
,onlinetrandesc
,opennode
,chmoment
,coldate
,url
,dealcolflag
,dataid from idl.pirs_o_zts_a10tibpsdetaillog where etl_dt =to_date('${batch_date}','yyyymmdd') 
and date2>=to_char(to_date('${batch_date}','yyyymmdd')-15,'yyyymmdd') and date2<='${batch_date}';" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_o_zts_a10tibpsdetaillog_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes