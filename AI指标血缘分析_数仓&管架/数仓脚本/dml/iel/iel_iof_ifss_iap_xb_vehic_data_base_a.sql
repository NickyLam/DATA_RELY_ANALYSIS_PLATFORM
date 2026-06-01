: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ifss_iap_xb_vehic_data_base_a
CreateDate: 20250514
FileName:   ${iel_data_path}/ifss_iap_xb_vehic_data_base.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.ivb_create_time,chr(13),''),chr(10),'') as ivb_create_time
,replace(replace(t1.ivb_cust_no,chr(13),''),chr(10),'') as ivb_cust_no
,replace(replace(t1.ivb_cust_name,chr(13),''),chr(10),'') as ivb_cust_name
,replace(replace(t1.ivb_order_no,chr(13),''),chr(10),'') as ivb_order_no
,replace(replace(t1.ivb_stru_data_id_1,chr(13),''),chr(10),'') as ivb_stru_data_id_1
,replace(replace(t1.ivb_frame_no_1,chr(13),''),chr(10),'') as ivb_frame_no_1
,replace(replace(t1.ivb_plate_no_1,chr(13),''),chr(10),'') as ivb_plate_no_1
,replace(replace(t1.ivb_owner,chr(13),''),chr(10),'') as ivb_owner
,replace(replace(t1.ivb_poli_start_dt,chr(13),''),chr(10),'') as ivb_poli_start_dt
,replace(replace(t1.ivb_poli_end_dt,chr(13),''),chr(10),'') as ivb_poli_end_dt
,replace(replace(t1.ivb_insu_comp_name_1,chr(13),''),chr(10),'') as ivb_insu_comp_name_1
,replace(replace(t1.ivb_blip_data_id_1,chr(13),''),chr(10),'') as ivb_blip_data_id_1
,replace(replace(t1.ivb_blip_flag_1,chr(13),''),chr(10),'') as ivb_blip_flag_1
,replace(replace(t1.ivb_sys_check_flg_1,chr(13),''),chr(10),'') as ivb_sys_check_flg_1
,replace(replace(t1.ivb_manu_check_flg_1,chr(13),''),chr(10),'') as ivb_manu_check_flg_1
,replace(replace(t1.ivb_insure_form_flg,chr(13),''),chr(10),'') as ivb_insure_form_flg
,replace(replace(t1.ivb_pay_advi_flg,chr(13),''),chr(10),'') as ivb_pay_advi_flg
,replace(replace(t1.ivb_dubil_no,chr(13),''),chr(10),'') as ivb_dubil_no
,replace(replace(t1.ivb_distr_dt,chr(13),''),chr(10),'') as ivb_distr_dt
,replace(replace(t1.ivb_exp_dt,chr(13),''),chr(10),'') as ivb_exp_dt
,ivb_dubil_amt
,ivb_dubil_bal
,replace(replace(t1.ivb_blip_data_id_2,chr(13),''),chr(10),'') as ivb_blip_data_id_2
,replace(replace(t1.ivb_blip_flag_2,chr(13),''),chr(10),'') as ivb_blip_flag_2
,replace(replace(t1.ivb_sys_check_flg_2,chr(13),''),chr(10),'') as ivb_sys_check_flg_2
,replace(replace(t1.ivb_manu_check_flg_2,chr(13),''),chr(10),'') as ivb_manu_check_flg_2
,replace(replace(t1.ivb_poli_send_flg,chr(13),''),chr(10),'') as ivb_poli_send_flg
,replace(replace(t1.ivb_surder_flg,chr(13),''),chr(10),'') as ivb_surder_flg
,replace(replace(t1.ivb_surder_dt,chr(13),''),chr(10),'') as ivb_surder_dt
,replace(replace(t1.ivb_stru_data_id_2,chr(13),''),chr(10),'') as ivb_stru_data_id_2
,replace(replace(t1.ivb_poli_name,chr(13),''),chr(10),'') as ivb_poli_name
,replace(replace(t1.ivb_insu_comp_name_2,chr(13),''),chr(10),'') as ivb_insu_comp_name_2
,replace(replace(t1.ivb_poli_num,chr(13),''),chr(10),'') as ivb_poli_num
,replace(replace(t1.ivb_insrt,chr(13),''),chr(10),'') as ivb_insrt
,replace(replace(t1.ivb_plate_no_2,chr(13),''),chr(10),'') as ivb_plate_no_2
,replace(replace(t1.ivb_frame_no_2,chr(13),''),chr(10),'') as ivb_frame_no_2
,replace(replace(t1.ivb_engine_no,chr(13),''),chr(10),'') as ivb_engine_no
,replace(replace(t1.ivb_insure_pre_tot,chr(13),''),chr(10),'') as ivb_insure_pre_tot
,replace(replace(t1.ivb_insure_duran,chr(13),''),chr(10),'') as ivb_insure_duran
,replace(replace(t1.ivb_use_char,chr(13),''),chr(10),'') as ivb_use_char
,replace(replace(t1.ivb_vehic_kind,chr(13),''),chr(10),'') as ivb_vehic_kind
,replace(replace(t1.ivb_vehic_loss_insure,chr(13),''),chr(10),'') as ivb_vehic_loss_insure
,replace(replace(t1.ivb_vehic_trd_duty_insure,chr(13),''),chr(10),'') as ivb_vehic_trd_duty_insure
,replace(replace(t1.ivb_insrt_sign,chr(13),''),chr(10),'') as ivb_insrt_sign
,replace(replace(t1.ivb_insrt_comp_name,chr(13),''),chr(10),'') as ivb_insrt_comp_name
,replace(replace(t1.ivb_insrt_cert_no,chr(13),''),chr(10),'') as ivb_insrt_cert_no
,replace(replace(t1.ivb_lab_model,chr(13),''),chr(10),'') as ivb_lab_model
,replace(replace(t1.ivb_cons_verifi_flg,chr(13),''),chr(10),'') as ivb_cons_verifi_flg
,replace(replace(t1.ivb_base_verifi_flg,chr(13),''),chr(10),'') as ivb_base_verifi_flg
,replace(replace(t1.ivb_occu_flg,chr(13),''),chr(10),'') as ivb_occu_flg
,replace(replace(t1.ivb_etl_dt,chr(13),''),chr(10),'') as ivb_etl_dt
,replace(replace(t1.ivb_covered_flg,chr(13),''),chr(10),'') as ivb_covered_flg
,replace(replace(t1.ivb_notcover_msg,chr(13),''),chr(10),'') as ivb_notcover_msg
,replace(replace(t1.ivb_order_fk,chr(13),''),chr(10),'') as ivb_order_fk

from ${iol_schema}.ifss_iap_xb_vehic_data_base t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifss_iap_xb_vehic_data_base.a.${batch_date}.dat" \
        charset=utf8
        safe=yes
