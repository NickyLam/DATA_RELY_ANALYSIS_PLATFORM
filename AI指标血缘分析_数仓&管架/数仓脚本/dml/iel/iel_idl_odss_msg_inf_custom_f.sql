: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_msg_inf_custom_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_msg_inf_custom_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
custid
,idtype
,idno
,custname
,custtype
,sex
,birthday
,email
,beginamount
,msgcount
,status
,arrears
,freelargess
,largessflag
,largessmonths
,validlmonths
,discount
,dcmonth
,dctotalmonths
,paydate
,nextpaydate
,exfeetype
,feetype
,fee
,paymode
,payaccttype
,payacct
,payacctbr
,payacctor
,addedamount
,canceldate
,upddate
,opendate
,origin
,organ
,operator
,remark
,fixedamountfee
,fixedamounttotalfee
,activefee
,activediscount
,activediscountmonths
from ${idl_schema}.odss_msg_inf_custom
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_msg_inf_custom_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes