: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_cbss_knl_bill_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_cbss_knl_bill.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select trandt
,billsq
,transq
,acctbr
,acctid
,trantp
,amntcd
,crcycd
,tranam
,tranbl
,blncdn
,tranbr
,smrycd
,cheqtp
,cheqno
,cqtpid
,toacct
,tosbac
,toacna
,bkusid
,ckbkus
,corrtg
,dscrtx
,acctno
,etl_dt
,etl_timestamp from idl.aml_cbss_knl_bill where etl_dt= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_cbss_knl_bill.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes