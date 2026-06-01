: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_point_mall_pay_mec_info_f
CreateDate: 20251016
FileName:   ${iel_data_path}/evt_point_mall_pay_mec_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.merchd_sub_indent_flow_num,chr(13),''),chr(10),'') as merchd_sub_indent_flow_num
,replace(replace(t1.indent_flow_num,chr(13),''),chr(10),'') as indent_flow_num
,replace(replace(t1.mode_pay_cd,chr(13),''),chr(10),'') as mode_pay_cd
,replace(replace(t1.provi_name,chr(13),''),chr(10),'') as provi_name
,replace(replace(t1.merchd_id,chr(13),''),chr(10),'') as merchd_id
,replace(replace(t1.merchd_name,chr(13),''),chr(10),'') as merchd_name
,merchd_tot_qtty
,replace(replace(t1.merchd_descb,chr(13),''),chr(10),'') as merchd_descb
,single_merchd_comm_fee
,replace(replace(t1.valid_flg,chr(13),''),chr(10),'') as valid_flg
,final_update_dt
,replace(replace(t1.create_teller_id,chr(13),''),chr(10),'') as create_teller_id
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id

from ${iml_schema}.evt_point_mall_pay_mec_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_point_mall_pay_mec_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
