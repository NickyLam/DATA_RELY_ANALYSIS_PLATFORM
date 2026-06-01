: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nibs_v_ibs_busicq_i
CreateDate: 20251112
FileName:   ${iel_data_path}/nibs_v_ibs_busicq.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,channeldate
,replace(replace(t1.tx_teller_num,chr(13),''),chr(10),'') as tx_teller_num
,replace(replace(t1.tx_teller_name,chr(13),''),chr(10),'') as tx_teller_name
,replace(replace(t1.tx_org_num,chr(13),''),chr(10),'') as tx_org_num
,replace(replace(t1.tx_org_name,chr(13),''),chr(10),'') as tx_org_name
,replace(replace(t1.auth_tel_num,chr(13),''),chr(10),'') as auth_tel_num
,replace(replace(t1.auth_tel_name,chr(13),''),chr(10),'') as auth_tel_name
,replace(replace(t1.authbranchnum,chr(13),''),chr(10),'') as authbranchnum
,replace(replace(t1.authbranchname,chr(13),''),chr(10),'') as authbranchname
,replace(replace(t1.cust_num,chr(13),''),chr(10),'') as cust_num
,queuegettime
,queuecalltime
,transtarttime
,tranendtime
,replace(replace(t1.channeltrancode,chr(13),''),chr(10),'') as channeltrancode
,replace(replace(t1.menuname,chr(13),''),chr(10),'') as menuname
,replace(replace(t1.authstarttime,chr(13),''),chr(10),'') as authstarttime
,replace(replace(t1.authendtime,chr(13),''),chr(10),'') as authendtime
,replace(replace(t1.auth_mould,chr(13),''),chr(10),'') as auth_mould
,replace(replace(t1.tx_seq_num,chr(13),''),chr(10),'') as tx_seq_num

from ${iol_schema}.nibs_v_ibs_busicq t1
where etl_dt = to_date('${batch_date}','yyyymmdd') and channeldate = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nibs_v_ibs_busicq.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
