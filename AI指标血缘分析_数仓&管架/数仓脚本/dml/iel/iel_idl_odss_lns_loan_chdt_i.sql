: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_lns_loan_chdt_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_lns_loan_chdt_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select TRANDT
,TRANSQ
,CHDTSQ
,CHDTTP
,TRANBR
,ACCTBR
,DTITCD
,ACCTID
,LNCFNO
,SUBSAC
,LNBLTP
,AMNTCD
,CRCYCD
,ONLNBL
,BKFNST
,DEVLTG from IDL.ODSS_LNS_LOAN_CHDT where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_lns_loan_chdt_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes