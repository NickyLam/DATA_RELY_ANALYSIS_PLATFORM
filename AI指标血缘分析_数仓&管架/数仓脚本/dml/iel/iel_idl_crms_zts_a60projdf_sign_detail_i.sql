: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_zts_a60projdf_sign_detail_i
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_zts_a60projdf_sign_detail_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
summsq
,trandt
,transq
,cntidx
,acctno
,acctna
,pytram
,accpcd
,accmsg
,hostsq
,hostdt
,respcd
,rspmsg
from ${idl_schema}.crms_zts_a60projdf_sign_detail
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_zts_a60projdf_sign_detail_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes