: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_knb_slcq_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_knb_slcq_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select TRANDT
,TRANSQ
,DETLNO
,DCMTTP
,BTCHNO
,INITNO
,FINLNO
,DCTPID
,DCMTNM
,ACCTNO
,TRANBR
,TRANUS
,CSBXNO
,STATUS from IDL.ODSS_KNB_SLCQ where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_knb_slcq_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes