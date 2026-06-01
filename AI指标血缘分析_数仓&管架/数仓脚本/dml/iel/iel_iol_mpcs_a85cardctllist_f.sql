: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a85cardctllist_f
CreateDate: 20180529
FileName:   ${iel_data_path}/mpcs_a85cardctllist.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.transtime,chr(13),''),chr(10),'') as transtime
,replace(replace(t.systrace,chr(13),''),chr(10),'') as systrace
,replace(replace(t.channel,chr(13),''),chr(10),'') as channel
,replace(replace(t.messageid,chr(13),''),chr(10),'') as messageid
,replace(replace(t.entitytype,chr(13),''),chr(10),'') as entitytype
,replace(replace(t.value,chr(13),''),chr(10),'') as value
,replace(replace(t.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t.userid,chr(13),''),chr(10),'') as userid
,replace(replace(t.pan,chr(13),''),chr(10),'') as pan
,replace(replace(t.tokenpan,chr(13),''),chr(10),'') as tokenpan
,replace(replace(t.operationreason,chr(13),''),chr(10),'') as operationreason
,replace(replace(t.reason,chr(13),''),chr(10),'') as reason
,replace(replace(t.state,chr(13),''),chr(10),'') as state
,replace(replace(t.orginalpan,chr(13),''),chr(10),'') as orginalpan
,replace(replace(t.newpan,chr(13),''),chr(10),'') as newpan
,replace(replace(t.validdate,chr(13),''),chr(10),'') as validdate
,replace(replace(t.remark1,chr(13),''),chr(10),'') as remark1
,replace(replace(t.remark2,chr(13),''),chr(10),'') as remark2
,replace(replace(t.remark3,chr(13),''),chr(10),'') as remark3
,replace(replace(t.remark4,chr(13),''),chr(10),'') as remark4
from ${iol_schema}.mpcs_a85cardctllist t
where t.etl_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a85cardctllist.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes