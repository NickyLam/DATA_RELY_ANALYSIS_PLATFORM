: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_osbs_pbs_logon_flow_i
CreateDate: 20240328
FileName:   ${iel_data_path}/osbs_pbs_logon_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.plf_flowno,chr(13),''),chr(10),'') as plf_flowno
,replace(replace(t1.plf_ecifno,chr(13),''),chr(10),'') as plf_ecifno
,replace(replace(t1.plf_operationtype,chr(13),''),chr(10),'') as plf_operationtype
,replace(replace(t1.plf_result,chr(13),''),chr(10),'') as plf_result
,replace(replace(t1.plf_resultmsg,chr(13),''),chr(10),'') as plf_resultmsg
,replace(replace(t1.plf_loginid,chr(13),''),chr(10),'') as plf_loginid
,replace(replace(t1.plf_logondate,chr(13),''),chr(10),'') as plf_logondate
,replace(replace(t1.plf_channel,chr(13),''),chr(10),'') as plf_channel
,replace(replace(t1.plf_deviceno,chr(13),''),chr(10),'') as plf_deviceno
,replace(replace(t1.plf_customerip,chr(13),''),chr(10),'') as plf_customerip
,replace(replace(t1.plf_hostname,chr(13),''),chr(10),'') as plf_hostname
,replace(replace(t1.plf_src_serverip,chr(13),''),chr(10),'') as plf_src_serverip
,replace(replace(t1.plf_userno,chr(13),''),chr(10),'') as plf_userno
,replace(replace(t1.plf_userid,chr(13),''),chr(10),'') as plf_userid
,replace(replace(t1.plf_logintype,chr(13),''),chr(10),'') as plf_logintype

from ${iol_schema}.osbs_pbs_logon_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/osbs_pbs_logon_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
