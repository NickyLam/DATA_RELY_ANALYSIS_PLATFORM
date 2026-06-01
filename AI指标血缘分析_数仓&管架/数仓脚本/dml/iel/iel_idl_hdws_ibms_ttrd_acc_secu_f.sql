: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_ibms_ttrd_acc_secu_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_ibms_ttrd_acc_secu.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select t1.accid
,t1.accname
,t1.cash_accid
,t1.owner
,t1.trdkind
,t1.trdgrpid
,t1.ps1
,t1.ps2
,t1.ps3
,t1.ps4
,t1.status
,t1.trdgrp_auto
,t1.is_lock
,t1.lockstatus
,t1.accfiscasubject
,t1.ps5
,t1.ps6
,t1.ps7
,t1.ps8
,t1.invest_type
,t1.acting_type
,t1.i_id
,t1.unit_id
,t1.start_dt
,t1.end_dt
,t1.id_mark
,t1.etl_timestamp
from ${idl_schema}.hdws_ibms_ttrd_acc_secu t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_ibms_ttrd_acc_secu.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes