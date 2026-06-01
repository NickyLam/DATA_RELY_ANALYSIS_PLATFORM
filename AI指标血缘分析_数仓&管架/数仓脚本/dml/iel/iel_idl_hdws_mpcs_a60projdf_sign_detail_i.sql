: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_mpcs_a60projdf_sign_detail_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_mpcs_a60projdf_sign_detail.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.summsq
,t1.trandt
,t1.transq
,t1.cntidx
,t1.acctno
,t1.acctna
,t1.pytram
,t1.accpcd
,t1.accmsg
,t1.hostsq
,t1.hostdt
,t1.respcd
,t1.rspmsg
from ${idl_schema}.hdws_mpcs_a60projdf_sign_detail t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_mpcs_a60projdf_sign_detail.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes