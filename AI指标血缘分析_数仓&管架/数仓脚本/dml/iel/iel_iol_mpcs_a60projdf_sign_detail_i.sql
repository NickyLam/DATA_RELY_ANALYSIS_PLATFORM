: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a60projdf_sign_detail_i
CreateDate: 20180529
FileName:   ${iel_data_path}/mpcs_a60projdf_sign_detail.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.summsq,chr(13),''),chr(10),'') as summsq
,replace(replace(t.trandt,chr(13),''),chr(10),'') as trandt
,replace(replace(t.transq,chr(13),''),chr(10),'') as transq
,t.cntidx as cntidx
,replace(replace(t.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t.acctna,chr(13),''),chr(10),'') as acctna
,t.pytram as pytram
,replace(replace(t.accpcd,chr(13),''),chr(10),'') as accpcd
,replace(replace(t.accmsg,chr(13),''),chr(10),'') as accmsg
,replace(replace(t.hostsq,chr(13),''),chr(10),'') as hostsq
,replace(replace(t.hostdt,chr(13),''),chr(10),'') as hostdt
,replace(replace(t.respcd,chr(13),''),chr(10),'') as respcd
,replace(replace(t.rspmsg,chr(13),''),chr(10),'') as rspmsg
from ${iol_schema}.mpcs_a60projdf_sign_detail t 
where TRANDT='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a60projdf_sign_detail.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes