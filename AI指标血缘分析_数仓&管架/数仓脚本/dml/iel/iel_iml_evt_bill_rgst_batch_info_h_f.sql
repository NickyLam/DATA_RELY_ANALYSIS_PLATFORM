: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_bill_rgst_batch_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/evt_bill_rgst_batch_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.rgst_id,chr(13),''),chr(10),'') as rgst_id
,replace(replace(t1.rgst_batch_id,chr(13),''),chr(10),'') as rgst_batch_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.hq_org_id,chr(13),''),chr(10),'') as hq_org_id
,rgst_dt
,replace(replace(t1.bus_rgst_type_cd,chr(13),''),chr(10),'') as bus_rgst_type_cd
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd
,replace(replace(t1.msg_status_cd,chr(13),''),chr(10),'') as msg_status_cd
,replace(replace(t1.final_modif_operr_id,chr(13),''),chr(10),'') as final_modif_operr_id
,final_modif_tm

from ${iml_schema}.evt_bill_rgst_batch_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_bill_rgst_batch_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
