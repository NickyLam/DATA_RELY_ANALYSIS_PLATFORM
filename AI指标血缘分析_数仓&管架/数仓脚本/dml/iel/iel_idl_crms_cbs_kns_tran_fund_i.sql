: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_cbs_kns_tran_fund_i
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_cbs_kns_tran_fund_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
trandt
,transq
,crcycd
,tranam
,acctno
,subsac
,acctna
,acctbr
,dcmttp
,dcmtno
,dctpid
,cheqtp
,cheqno
,cqtpid
,invodt
,toacct
,tosbac
,toacna
,toacbr
from ${idl_schema}.crms_cbs_kns_tran_fund
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_cbs_kns_tran_fund_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes