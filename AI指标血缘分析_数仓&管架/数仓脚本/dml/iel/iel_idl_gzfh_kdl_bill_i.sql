: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_gzfh_kdl_bill_i
CreateDate: 20180529
FileName:   ${iel_data_path}/gzfh_kdl_bill_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select TRANDT,BILLSQ,TRANSQ,ACCTBR,ACCTID,ACCTNO,SUBSAC,TRANTP,AMNTCD,CRCYCD,TRANAM,TRANBL,TRANBR,SMRYCD,TOACCT,TOSBAC,TOACNA,CHEQTP,CHEQNO,CQTPID,BKUSID,CKBKUS,CORRTG,DSCRTX,TIMSTP,TMPFLG,SERVTP,TOACBR,TOBKNA from  ${idl_schema}.gzfh_kdl_bill where etl_dt=to_date('${batch_date}','yyyymmdd')" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/gzfh_kdl_bill_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes