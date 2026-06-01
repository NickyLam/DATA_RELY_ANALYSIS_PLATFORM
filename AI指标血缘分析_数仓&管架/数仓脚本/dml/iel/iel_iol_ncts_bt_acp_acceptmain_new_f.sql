: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncts_bt_acp_acceptmain_new_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ncts_bt_acp_acceptmain_new.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.tradeserno,chr(13),''),chr(10),'') as tradeserno 
,replace(replace(t1.oldtradeserno,chr(13),''),chr(10),'') as oldtradeserno 
,replace(replace(t1.biztype,chr(13),''),chr(10),'') as biztype 
,replace(replace(t1.status,chr(13),''),chr(10),'') as status 
,replace(replace(t1.busiserno,chr(13),''),chr(10),'') as busiserno 
,replace(replace(t1.channelcode,chr(13),''),chr(10),'') as channelcode 
,replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno 
,replace(replace(t1.acctname,chr(13),''),chr(10),'') as acctname 
,replace(replace(t1.custno,chr(13),''),chr(10),'') as custno 
,replace(replace(t1.custname,chr(13),''),chr(10),'') as custname 
,replace(replace(t1.idtype,chr(13),''),chr(10),'') as idtype 
,replace(replace(t1.idno,chr(13),''),chr(10),'') as idno 
,replace(replace(t1.idname,chr(13),''),chr(10),'') as idname 
,replace(replace(t1.is_porxy,chr(13),''),chr(10),'') as is_porxy 
,replace(replace(t1.agentidtype,chr(13),''),chr(10),'') as agentidtype 
,replace(replace(t1.agentidno,chr(13),''),chr(10),'') as agentidno 
,replace(replace(t1.agentidname,chr(13),''),chr(10),'') as agentidname 
,replace(replace(t1.agentphone,chr(13),''),chr(10),'') as agentphone 
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark 
,t1.createdate as createdate 
,replace(replace(t1.createtime,chr(13),''),chr(10),'') as createtime 
,replace(replace(t1.createby,chr(13),''),chr(10),'') as createby 
,t1.updatedate as updatedate 
,replace(replace(t1.updatetime,chr(13),''),chr(10),'') as updatetime 
,replace(replace(t1.updateby,chr(13),''),chr(10),'') as updateby 
,replace(replace(t1.reftradeserno,chr(13),''),chr(10),'') as reftradeserno 
,replace(replace(t1.applydate,chr(13),''),chr(10),'') as applydate 
,replace(replace(t1.applybrno,chr(13),''),chr(10),'') as applybrno 
,replace(replace(t1.phone,chr(13),''),chr(10),'') as phone 
,replace(replace(t1.reserv_id,chr(13),''),chr(10),'') as reserv_id 
,replace(replace(t1.apply_remark,chr(13),''),chr(10),'') as apply_remark 
,replace(replace(t1.other_remark,chr(13),''),chr(10),'') as other_remark 
,replace(replace(t1.vouchers,chr(13),''),chr(10),'') as vouchers 
,replace(replace(t1.vouchers_amt,chr(13),''),chr(10),'') as vouchers_amt 
,replace(replace(t1.apply_ccy,chr(13),''),chr(10),'') as apply_ccy 
,replace(replace(t1.apply_amt,chr(13),''),chr(10),'') as apply_amt 
,replace(replace(t1.apply_type,chr(13),''),chr(10),'') as apply_type 
from ${iol_schema}.ncts_bt_acp_acceptmain_new t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncts_bt_acp_acceptmain_new.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes