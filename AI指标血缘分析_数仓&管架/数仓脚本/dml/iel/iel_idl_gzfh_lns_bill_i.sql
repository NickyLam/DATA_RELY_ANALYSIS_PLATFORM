: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_gzfh_lns_bill_i
CreateDate: 20180529
FileName:   ${iel_data_path}/gzfh_lns_bill_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select TRANDT,BILLSQ,TRANSQ,ACCTID,LNBLTP,BILLTP,LNBLSQ,TRANCD,CRCYCD,AMNTCD,TRANAM,ONLNBL,USERID,STRKTG,ACCTNO,BLSQBL,TERMNO from  ${idl_schema}.gzfh_lns_bill where etl_dt=to_date('${batch_date}','yyyymmdd')" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/gzfh_lns_bill_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes