: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_alss_am_acc_handle_tb_f
CreateDate: 20241009
FileName:   ${iel_data_path}/alss_am_acc_handle_tb.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t1.spectp,chr(13),''),chr(10),'') as spectp
,replace(replace(t1.invost,chr(13),''),chr(10),'') as invost
,replace(replace(t1.channelstatus,chr(13),''),chr(10),'') as channelstatus
,replace(replace(t1.operateremarks,chr(13),''),chr(10),'') as operateremarks
,replace(replace(t1.statusupdateorg,chr(13),''),chr(10),'') as statusupdateorg
,trandt
,replace(replace(t1.transq,chr(13),''),chr(10),'') as transq
,frozdt
,replace(replace(t1.frozsq,chr(13),''),chr(10),'') as frozsq
,unfrdt
,replace(replace(t1.unfrsq,chr(13),''),chr(10),'') as unfrsq
,replace(replace(t1.frtransq,chr(13),''),chr(10),'') as frtransq
,replace(replace(t1.operatetype,chr(13),''),chr(10),'') as operatetype
,replace(replace(t1.freezetransno,chr(13),''),chr(10),'') as freezetransno
,replace(replace(t1.freezeno,chr(13),''),chr(10),'') as freezeno
,freezedate
,replace(replace(t1.freezestatus,chr(13),''),chr(10),'') as freezestatus
,replace(replace(t1.statusid,chr(13),''),chr(10),'') as statusid
,replace(replace(t1.reason,chr(13),''),chr(10),'') as reason
,replace(replace(t1.isdealsource,chr(13),''),chr(10),'') as isdealsource
,replace(replace(t1.warn_id,chr(13),''),chr(10),'') as warn_id
,replace(replace(t1.form_id,chr(13),''),chr(10),'') as form_id
,replace(replace(t1.teller_id,chr(13),''),chr(10),'') as teller_id
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.trantime,chr(13),''),chr(10),'') as trantime

from ${iol_schema}.alss_am_acc_handle_tb t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/alss_am_acc_handle_tb.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
