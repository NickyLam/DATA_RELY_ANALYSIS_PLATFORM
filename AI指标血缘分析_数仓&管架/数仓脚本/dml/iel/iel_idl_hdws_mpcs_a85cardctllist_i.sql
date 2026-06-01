: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_mpcs_a85cardctllist_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_mpcs_a85cardctllist.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.transtime
,t1.systrace
,t1.channel
,t1.messageid
,t1.entitytype
,t1.value
,t1.custno
,t1.userid
,t1.pan
,t1.tokenpan
,t1.operationreason
,t1.reason
,t1.state
,t1.orginalpan
,t1.newpan
,t1.validdate
,t1.remark1
,t1.remark2
,t1.remark3
,t1.remark4
from ${idl_schema}.hdws_mpcs_a85cardctllist t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_mpcs_a85cardctllist.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes