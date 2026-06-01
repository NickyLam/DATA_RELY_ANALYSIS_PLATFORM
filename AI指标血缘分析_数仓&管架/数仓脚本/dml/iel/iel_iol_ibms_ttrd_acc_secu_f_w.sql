: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_acc_secu_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_acc_secu_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(accid,chr(10),''),chr(13),'') as accid
,replace(replace(accname,chr(10),''),chr(13),'') as accname
,replace(replace(cash_accid,chr(10),''),chr(13),'') as cash_accid
,replace(replace(owner,chr(10),''),chr(13),'') as owner
,replace(replace(trdkind,chr(10),''),chr(13),'') as trdkind
,replace(replace(trdgrpid,chr(10),''),chr(13),'') as trdgrpid
,replace(replace(ps1,chr(10),''),chr(13),'') as ps1
,replace(replace(ps2,chr(10),''),chr(13),'') as ps2
,replace(replace(ps3,chr(10),''),chr(13),'') as ps3
,replace(replace(ps4,chr(10),''),chr(13),'') as ps4
,replace(replace(status,chr(10),''),chr(13),'') as status
,replace(replace(trdgrp_auto,chr(10),''),chr(13),'') as trdgrp_auto
,replace(replace(is_lock,chr(10),''),chr(13),'') as is_lock
,replace(replace(lockstatus,chr(10),''),chr(13),'') as lockstatus
,replace(replace(accfiscasubject,chr(10),''),chr(13),'') as accfiscasubject
,replace(replace(ps5,chr(10),''),chr(13),'') as ps5
,replace(replace(ps6,chr(10),''),chr(13),'') as ps6
,replace(replace(ps7,chr(10),''),chr(13),'') as ps7
,replace(replace(ps8,chr(10),''),chr(13),'') as ps8
,replace(replace(invest_type,chr(10),''),chr(13),'') as invest_type
,replace(replace(acting_type,chr(10),''),chr(13),'') as acting_type
,replace(replace(i_id,chr(10),''),chr(13),'') as i_id
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ibms_ttrd_acc_secu
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_acc_secu_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes