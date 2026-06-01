: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_kms_tran_last_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_kms_tran_last_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select PCKGSQ
,SYSTDT
,TSBGTI
,TSEDTI
,USEDTM
,PRCSCD
,USERID
,ERSTCK
,ERORCD
,ERORTX
,ERORSC
,DATAIN
,DATAOT
,SERVTP
,EXCNTS from IDL.ODSS_KMS_TRAN_LAST where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_kms_tran_last_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes