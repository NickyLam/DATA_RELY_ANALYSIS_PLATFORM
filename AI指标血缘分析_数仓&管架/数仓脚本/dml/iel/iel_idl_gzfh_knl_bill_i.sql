: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_gzfh_knl_bill_i
CreateDate: 20180529
FileName:   ${iel_data_path}/gzfh_knl_bill_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select TRANDT,BILLSQ,TRANSQ,ACCTBR,ACCTID,TRANTP,AMNTCD,CRCYCD,TRANAM,TRANBL,BLNCDN,TRANBR,SMRYCD,CHEQTP,CHEQNO,CQTPID,TOACCT,TOSBAC,TOACNA,BKUSID,CKBKUS,CORRTG,DSCRTX,ACCTNO from  ${idl_schema}.gzfh_knl_bill where etl_dt=to_date('${batch_date}','yyyymmdd')" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/gzfh_knl_bill_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes