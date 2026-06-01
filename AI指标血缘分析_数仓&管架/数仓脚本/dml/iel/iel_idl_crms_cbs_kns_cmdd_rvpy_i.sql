: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_cbs_kns_cmdd_rvpy_i
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_cbs_kns_cmdd_rvpy_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
trandt
,rvpysq
,transq
,tranbr
,trantp
,acctbr
,dtitcd
,acctid
,acctno
,subsac
,bltype
,modutp
,smrycd
,amntcd
,crcycd
,tranam
,corrtg
,bkfnst
from ${idl_schema}.crms_cbs_kns_cmdd_rvpy
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_cbs_kns_cmdd_rvpy_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes