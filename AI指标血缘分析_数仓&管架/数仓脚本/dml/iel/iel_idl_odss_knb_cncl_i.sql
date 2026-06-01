: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_knb_cncl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_knb_cncl_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select TRANDT
,TRANSQ
,DETLNO
,CNCLTP
,DCMTTP
,INITNO
,FINLNO
,DCMTNM
,TRBODY
,LASTST
,TRANBR
,TRANUS
,RVDCTG
,BTCHNO
,DCTPID from IDL.ODSS_KNB_CNCL where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_knb_cncl_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes