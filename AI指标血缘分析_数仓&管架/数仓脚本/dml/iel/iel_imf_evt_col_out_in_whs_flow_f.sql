: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_col_out_in_whs_flow_f
CreateDate: 20250928
FileName:   ${iel_data_path}/evt_col_out_in_whs_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.rec_flow_num,chr(13),''),chr(10),'') as rec_flow_num
,replace(replace(t1.col_id,chr(13),''),chr(10),'') as col_id
,replace(replace(t1.out_in_whs_status_cd,chr(13),''),chr(10),'') as out_in_whs_status_cd
,out_in_whs_dt
,replace(replace(t1.col_type_cd,chr(13),''),chr(10),'') as col_type_cd
,hxb_cfm_val
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.create_teller_id,chr(13),''),chr(10),'') as create_teller_id
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id

from ${iml_schema}.evt_col_out_in_whs_flow t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_col_out_in_whs_flow.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
