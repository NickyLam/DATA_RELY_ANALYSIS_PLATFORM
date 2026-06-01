: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_guar_cont_guar_rela_h_f
CreateDate: 20240828
FileName:   ${iel_data_path}/agt_guar_cont_guar_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.obj_type_name,chr(13),''),chr(10),'') as obj_type_name
,replace(replace(t1.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t1.guar_id,chr(13),''),chr(10),'') as guar_id
,replace(replace(t1.guar_cont_id,chr(13),''),chr(10),'') as guar_cont_id
,replace(replace(t1.rela_status_cd,chr(13),''),chr(10),'') as rela_status_cd
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,modif_dt
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,rgst_dt
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,guar_amt

from ${iml_schema}.agt_guar_cont_guar_rela_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_guar_cont_guar_rela_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
