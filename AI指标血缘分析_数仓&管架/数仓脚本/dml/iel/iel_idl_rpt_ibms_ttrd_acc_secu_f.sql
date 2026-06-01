: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_ibms_ttrd_acc_secu_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_ibms_ttrd_acc_secu.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.accid,chr(13),''),chr(10),'') as accid
,replace(replace(t1.accname,chr(13),''),chr(10),'') as accname
,replace(replace(t1.cash_accid,chr(13),''),chr(10),'') as cash_accid
,replace(replace(t1.owner,chr(13),''),chr(10),'') as owner
,replace(replace(t1.trdkind,chr(13),''),chr(10),'') as trdkind
,replace(replace(t1.trdgrpid,chr(13),''),chr(10),'') as trdgrpid
,replace(replace(t1.ps1,chr(13),''),chr(10),'') as ps1
,replace(replace(t1.ps2,chr(13),''),chr(10),'') as ps2
,replace(replace(t1.ps3,chr(13),''),chr(10),'') as ps3
,replace(replace(t1.ps4,chr(13),''),chr(10),'') as ps4
,t1.status as status
,replace(replace(t1.trdgrp_auto,chr(13),''),chr(10),'') as trdgrp_auto
,t1.is_lock as is_lock
,t1.lockstatus as lockstatus
,replace(replace(t1.accfiscasubject,chr(13),''),chr(10),'') as accfiscasubject
,replace(replace(t1.ps5,chr(13),''),chr(10),'') as ps5
,replace(replace(t1.ps6,chr(13),''),chr(10),'') as ps6
,replace(replace(t1.ps7,chr(13),''),chr(10),'') as ps7
,replace(replace(t1.ps8,chr(13),''),chr(10),'') as ps8
,t1.invest_type as invest_type
,replace(replace(t1.acting_type,chr(13),''),chr(10),'') as acting_type
,t1.i_id as i_id
,replace(replace(t1.unit_id,chr(13),''),chr(10),'') as unit_id
 from iol.ibms_ttrd_acc_secu T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_ibms_ttrd_acc_secu.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes