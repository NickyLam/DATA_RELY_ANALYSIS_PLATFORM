: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_acc_secu_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_acc_secu.f.${batch_date}.dat
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
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,t1.etl_timestamp as etl_timestamp
from iol.ibms_ttrd_acc_secu t1
where t1.start_dt<=TO_DATE('${batch_date}','yyyymmdd') and t1.end_dt>TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_acc_secu.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes