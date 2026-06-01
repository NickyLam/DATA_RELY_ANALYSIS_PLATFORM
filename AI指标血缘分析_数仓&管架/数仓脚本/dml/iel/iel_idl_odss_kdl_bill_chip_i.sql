: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_kdl_bill_chip_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_kdl_bill_chip_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select TRANDT
,CHIPSQ
,TRANSQ
,ACCTBR
,ACCTNO
,TRANTP
,AMNTCD
,TRANBR
,CRCYCD
,TRANAM
,TRANBL
,SMRYCD
,DSCRTX
,CORRTG
,BKUSID
,TIMSTP from IDL.ODSS_KDL_BILL_CHIP where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_kdl_bill_chip_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes