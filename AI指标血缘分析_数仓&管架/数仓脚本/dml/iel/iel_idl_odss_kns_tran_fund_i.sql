: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_kns_tran_fund_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_kns_tran_fund_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select TRANDT
,TRANSQ
,CRCYCD
,TRANAM
,ACCTNO
,SUBSAC
,ACCTNA
,ACCTBR
,DCMTTP
,DCMTNO
,DCTPID
,CHEQTP
,CHEQNO
,CQTPID
,INVODT
,TOACCT
,TOSBAC
,TOACNA
,TOACBR from IDL.ODSS_KNS_TRAN_FUND where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_kns_tran_fund_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes