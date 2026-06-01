: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_kns_tran_bill_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_kns_tran_bill_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select TRANDT
,TRANSQ
,BILLSQ
,BILLTP
,PRCSCD
,SERVTP
,CRCYCD
,TRANAM
,TRANBR
,ACCTNO
,ACCTNA
,ACCTBR
,ACBKNA
,TOACCT
,TOACNA
,TOACBR
,TOBKNA
,DSCRTX
,DSCRTY
,DSCRTZ
,AMNTCD
,PRCSNA
,LASTUS
,PRITCT
,BILLNO from IDL.ODSS_KNS_TRAN_BILL where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_kns_tran_bill_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes