: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_cust_risk_warn_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/pty_cust_risk_warn_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t1.obj_type_name,chr(13),''),chr(10),'') as obj_type_name
,replace(replace(t1.warn_id,chr(13),''),chr(10),'') as warn_id
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t1.warn_descb,chr(13),''),chr(10),'') as warn_descb
,replace(replace(t1.warn_hibchy,chr(13),''),chr(10),'') as warn_hibchy
,replace(replace(t1.warn_type_cd,chr(13),''),chr(10),'') as warn_type_cd
,replace(replace(t1.warn_status_cd,chr(13),''),chr(10),'') as warn_status_cd
,replace(replace(t1.warn_sgn_idtfy_comnt,chr(13),''),chr(10),'') as warn_sgn_idtfy_comnt
,replace(replace(t1.risk_ctrl_measure_descb,chr(13),''),chr(10),'') as risk_ctrl_measure_descb
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,rgst_dt
,modif_dt
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id

from ${iml_schema}.pty_cust_risk_warn_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_cust_risk_warn_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
