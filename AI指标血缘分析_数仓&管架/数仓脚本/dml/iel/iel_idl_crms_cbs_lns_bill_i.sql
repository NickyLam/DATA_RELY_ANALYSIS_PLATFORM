: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_cbs_lns_bill_i
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_cbs_lns_bill_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
trandt
,billsq
,transq
,acctid
,lnbltp
,billtp
,lnblsq
,trancd
,crcycd
,amntcd
,tranam
,onlnbl
,userid
,strktg
,acctno
,blsqbl
,termno
from ${idl_schema}.crms_cbs_lns_bill
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_cbs_lns_bill_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes