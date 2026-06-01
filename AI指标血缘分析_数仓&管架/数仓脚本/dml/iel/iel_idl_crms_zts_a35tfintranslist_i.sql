: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_zts_a35tfintranslist_i
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_zts_a35tfintranslist_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
seqno
,trntm
,chnlid
,chnlseqno
,chnltime
,cobank
,acctno
,custname
,seccd
,secname
,capitalacctno
,trntype
,trnamt
,ccy
,acctbal
,capitalacctbal
,hostseqno
,hostdt
,rspcd
,rspmsg
,dataid
,paechkflag
,paechkremark
,paechktime
,jtechkflag
,jtechkremark
,jtechktime
,turnflag
,hangflag
,addflag
from ${idl_schema}.crms_zts_a35tfintranslist
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_zts_a35tfintranslist_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes