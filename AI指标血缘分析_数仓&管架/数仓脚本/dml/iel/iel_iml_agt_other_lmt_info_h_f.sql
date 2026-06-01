: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_other_lmt_info_h_f
CreateDate: 20250425
FileName:   ${iel_data_path}/agt_other_lmt_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t1.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t1.obj_type_name,chr(13),''),chr(10),'') as obj_type_name
,replace(replace(t1.o_use_lmt_cont_id,chr(13),''),chr(10),'') as o_use_lmt_cont_id
,replace(replace(t1.o_use_lmt_cust_id,chr(13),''),chr(10),'') as o_use_lmt_cust_id
,replace(replace(t1.o_use_lmt_cust_name,chr(13),''),chr(10),'') as o_use_lmt_cust_name
,replace(replace(t1.circl_flg,chr(13),''),chr(10),'') as circl_flg
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,rgst_dt
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,final_update_dt
,replace(replace(t1.move_flg,chr(13),''),chr(10),'') as move_flg

from ${iml_schema}.agt_other_lmt_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_other_lmt_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
