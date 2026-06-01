: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_a92orderconfirm_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_a92orderconfirm_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
filena
,dtlseqid
,brokeruserid
,accountid
,brokerorderno
,orderid
,paymentmethodid
,ordercreatedon
,ordertradedate
,orderconfirmdate
,fundcode
,sharetype
,busitype
,destfundcode
,destsharetype
,tradeamount
,tradeshare
,tradestat
,confirmstat
,orderdetail
,succamount
,succshare
,succinamount
,succinshare
,totfee
,taconfirmid
,pocode
,errmsg
,accountdate
,tradenav
,destnav
,status
,reserve1
,reserve2
,reserve3
,reserve4
,reserve5
from ${idl_schema}.odss_a92orderconfirm
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_a92orderconfirm_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes