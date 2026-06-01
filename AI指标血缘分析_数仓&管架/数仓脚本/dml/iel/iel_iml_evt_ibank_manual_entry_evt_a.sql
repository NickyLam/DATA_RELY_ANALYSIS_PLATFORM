: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_ibank_manual_entry_evt_a
CreateDate: 20231229
FileName:   ${iel_data_path}/evt_ibank_manual_entry_evt.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.rec_id,chr(13),''),chr(10),'') as rec_id
,entry_dt
,replace(replace(t1.bus_org_id,chr(13),''),chr(10),'') as bus_org_id
,replace(replace(t1.entry_flow_num,chr(13),''),chr(10),'') as entry_flow_num
,replace(replace(t1.core_flow_num,chr(13),''),chr(10),'') as core_flow_num
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.rgst_teller_name,chr(13),''),chr(10),'') as rgst_teller_name
,replace(replace(t1.entry_teller_id,chr(13),''),chr(10),'') as entry_teller_id
,replace(replace(t1.entry_teller_name,chr(13),''),chr(10),'') as entry_teller_name
,rgst_tm
,entry_tm
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,replace(replace(t1.check_teller_name,chr(13),''),chr(10),'') as check_teller_name
,replace(replace(t1.entry_type_cd,chr(13),''),chr(10),'') as entry_type_cd
,replace(replace(t1.tran_id,chr(13),''),chr(10),'') as tran_id
,replace(replace(t1.entry_idf_cd,chr(13),''),chr(10),'') as entry_idf_cd
,replace(replace(t1.accti_bal_id,chr(13),''),chr(10),'') as accti_bal_id

from ${iml_schema}.evt_ibank_manual_entry_evt t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ibank_manual_entry_evt.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
