: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_a50ubcardjour_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_a50ubcardjour_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
acqinstid
,fwdinstid
,systrace
,transtime
,transcode
,transdate
,tlrnbr
,brnnbr
,trantype
,channels
,msgtype
,priacct
,procecode
,workcode
,transamt
,onlnbl
,avalbl
,cravbl
,trxfee
,localtime
,localdate
,exprdate
,settlmtdate
,mchnttype
,posentrymode
,servicecode
,trackdata2
,trackdata3
,retrivarefnum
,authridresp
,respcode
,acptermnlid
,accptrid
,accttrnameloc
,addtnlrespcd
,privatedate
,currcycode
,pindata
,reserve
,rcvinstid
,cupsreserve
,oldacqinstid
,oldfwdinstid
,oldsystrace
,oldtranstime
,inputdata
,outputdata
,outacctnbr
,inacctnbr
,atmctrace
,linkid
,headinfo
,status
,errcode
,errmsg
,tertype
,promty
,acqinstctrycd
,cardholdamt
,cardholdrate
,settlmtamt
,newfwdinstid
,channeltp
,cardseq
,inpbocelem
,outpbocelem
,atmcrust
,trncd
from ${idl_schema}.odss_a50ubcardjour
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_a50ubcardjour_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes