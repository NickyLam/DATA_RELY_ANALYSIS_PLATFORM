: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_kdb_mkcd_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_kdb_mkcd_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select DCMTTP
,DCMTNO
,DCTPID
,CARDNO
,MKCDDT
,USEDTG
,MGNTCD
,CARDNM
,MKCDSQ
,CHIPTG
,COOPCD from IDL.ODSS_KDB_MKCD where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_kdb_mkcd_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes