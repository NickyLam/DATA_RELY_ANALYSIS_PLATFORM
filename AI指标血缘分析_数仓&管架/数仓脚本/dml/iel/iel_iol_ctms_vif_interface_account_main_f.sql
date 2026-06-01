: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_vif_interface_account_main_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_vif_interface_account_main.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.src_cd,chr(13),''),chr(10),'') as src_cd
,t1.settledate as settledate
,replace(replace(t1.settletime,chr(13),''),chr(10),'') as settletime
,replace(replace(t1.bus_depart_id,chr(13),''),chr(10),'') as bus_depart_id
,replace(replace(t1.ope_depart_id,chr(13),''),chr(10),'') as ope_depart_id
,replace(replace(t1.handle_teller_id,chr(13),''),chr(10),'') as handle_teller_id
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,replace(replace(t1.txn_num,chr(13),''),chr(10),'') as txn_num
,replace(replace(t1.txn_desc,chr(13),''),chr(10),'') as txn_desc
,replace(replace(t1.alterbalance_id,chr(13),''),chr(10),'') as alterbalance_id
,replace(replace(t1.core_seq,chr(13),''),chr(10),'') as core_seq
,t1.amount as amount
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.ctms_vif_interface_account_main t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_vif_interface_account_main.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes