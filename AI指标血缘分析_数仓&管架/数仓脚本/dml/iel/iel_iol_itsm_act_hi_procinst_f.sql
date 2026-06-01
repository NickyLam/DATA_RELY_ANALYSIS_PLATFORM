: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_itsm_act_hi_procinst_f
CreateDate: 20240904
FileName:   ${iel_data_path}/itsm_act_hi_procinst.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id_,chr(13),''),chr(10),'') as id_
,rev_
,replace(replace(t1.proc_inst_id_,chr(13),''),chr(10),'') as proc_inst_id_
,replace(replace(t1.business_key_,chr(13),''),chr(10),'') as business_key_
,replace(replace(t1.proc_def_id_,chr(13),''),chr(10),'') as proc_def_id_
,start_time_
,end_time_
,duration_
,replace(replace(t1.start_user_id_,chr(13),''),chr(10),'') as start_user_id_
,replace(replace(t1.start_act_id_,chr(13),''),chr(10),'') as start_act_id_
,replace(replace(t1.end_act_id_,chr(13),''),chr(10),'') as end_act_id_
,replace(replace(t1.super_process_instance_id_,chr(13),''),chr(10),'') as super_process_instance_id_
,replace(replace(t1.delete_reason_,chr(13),''),chr(10),'') as delete_reason_
,replace(replace(t1.tenant_id_,chr(13),''),chr(10),'') as tenant_id_
,replace(replace(t1.name_,chr(13),''),chr(10),'') as name_
,replace(replace(t1.callback_id_,chr(13),''),chr(10),'') as callback_id_
,replace(replace(t1.callback_type_,chr(13),''),chr(10),'') as callback_type_

from ${iol_schema}.itsm_act_hi_procinst t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/itsm_act_hi_procinst.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
