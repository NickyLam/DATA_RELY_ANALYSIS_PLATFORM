: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_ps_cust_lmt_info_h_f
CreateDate: 20230804
FileName:   ${iel_data_path}/agt_ps_cust_lmt_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.lmt_agt_id,chr(13),''),chr(10),'') as lmt_agt_id
,replace(replace(t1.agt_status_cd,chr(13),''),chr(10),'') as agt_status_cd
,replace(replace(t1.sign_way_cd,chr(13),''),chr(10),'') as sign_way_cd
,replace(replace(t1.lmt_obj_id,chr(13),''),chr(10),'') as lmt_obj_id
,replace(replace(t1.lmt_obj_type_cd,chr(13),''),chr(10),'') as lmt_obj_type_cd
,replace(replace(t1.lmt_type_descb,chr(13),''),chr(10),'') as lmt_type_descb
,lmt_effect_dt
,lmt_invalid_dt
,replace(replace(t1.chn_sys_cd,chr(13),''),chr(10),'') as chn_sys_cd
,replace(replace(t1.trdpty_agt_id,chr(13),''),chr(10),'') as trdpty_agt_id
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark

from ${iml_schema}.agt_ps_cust_lmt_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_ps_cust_lmt_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
