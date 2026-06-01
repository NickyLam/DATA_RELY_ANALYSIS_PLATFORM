: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_ap_rela_info_h_f
CreateDate: 20240904
FileName:   ${iel_data_path}/agt_ap_rela_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.disp_prop_id,chr(13),''),chr(10),'') as disp_prop_id
,replace(replace(t1.obj_rela_id,chr(13),''),chr(10),'') as obj_rela_id
,replace(replace(t1.obj_type_cd,chr(13),''),chr(10),'') as obj_type_cd
,replace(replace(t1.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t1.obj_name,chr(13),''),chr(10),'') as obj_name
,rela_dt
,replace(replace(t1.exec_status_cd,chr(13),''),chr(10),'') as exec_status_cd

from ${iml_schema}.agt_ap_rela_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_ap_rela_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
