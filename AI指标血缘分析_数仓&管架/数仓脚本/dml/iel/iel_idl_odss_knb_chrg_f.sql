: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_knb_chrg_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_knb_chrg_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select CACHDT
,CACHSQ
,ORTRDT
,ORTRSQ
,ORTRAM
,CHRGTP
,SUBTYP
,CHAMTP
,BGINDC
,FINADC
,RVCHTP
,ACCTNO
,CRCYCD
,CACHAM
,RLTRAM
,TRANDT
,TRANSQ
,CHRGST
,SMRYCD from IDL.ODSS_KNB_CHRG where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_knb_chrg_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes