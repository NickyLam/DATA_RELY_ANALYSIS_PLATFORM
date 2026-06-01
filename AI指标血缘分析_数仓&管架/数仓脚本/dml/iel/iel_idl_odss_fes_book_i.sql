: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_fes_book_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_fes_book_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select FEESDT
,FEESSQ
,BRCHNO
,USERID
,CRCYCD
,TRANTP
,CUSTNO
,ACCTNO
,RECDTP
,TRANNM
,TRANDT
,TRANSQ
,REMARK
,STAUTS
,STRKTG from IDL.ODSS_FES_BOOK where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_fes_book_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes