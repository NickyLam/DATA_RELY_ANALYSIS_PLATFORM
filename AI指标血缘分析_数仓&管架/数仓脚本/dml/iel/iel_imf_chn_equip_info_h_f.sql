: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_chn_equip_info_h_f
CreateDate: 20240913
FileName:   ${iel_data_path}/chn_equip_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.equip_id,chr(13),''),chr(10),'') as equip_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.equip_model,chr(13),''),chr(10),'') as equip_model
,replace(replace(t1.equip_type_cd,chr(13),''),chr(10),'') as equip_type_cd
,replace(replace(t1.equip_status_cd,chr(13),''),chr(10),'') as equip_status_cd
,replace(replace(t1.equip_use_status_cd,chr(13),''),chr(10),'') as equip_use_status_cd
,replace(replace(t1.in_bank_flg,chr(13),''),chr(10),'') as in_bank_flg
,replace(replace(t1.install_way_cd,chr(13),''),chr(10),'') as install_way_cd
,replace(replace(t1.inst_phone,chr(13),''),chr(10),'') as inst_phone
,replace(replace(t1.equip_addr,chr(13),''),chr(10),'') as equip_addr
,replace(replace(t1.equip_ip,chr(13),''),chr(10),'') as equip_ip
,matn_start_dt
,matn_end_dt
,equip_buy_dt
,equip_start_use_dt
,equip_stop_dt
,replace(replace(t1.self_h_bank_flg,chr(13),''),chr(10),'') as self_h_bank_flg
,replace(replace(t1.comm_status_flg,chr(13),''),chr(10),'') as comm_status_flg
,replace(replace(t1.move_status_cd,chr(13),''),chr(10),'') as move_status_cd
,replace(replace(t1.clean_corp_id,chr(13),''),chr(10),'') as clean_corp_id
,replace(replace(t1.clean_corp_name,chr(13),''),chr(10),'') as clean_corp_name
,replace(replace(t1.atm_clean_appl_bind_teller_id,chr(13),''),chr(10),'') as atm_clean_appl_bind_teller_id
,replace(replace(t1.outsourc_mgmt_flg,chr(13),''),chr(10),'') as outsourc_mgmt_flg
,replace(replace(t1.midgrod_inst_code,chr(13),''),chr(10),'') as midgrod_inst_code
,replace(replace(t1.midgrod_sync_flg,chr(13),''),chr(10),'') as midgrod_sync_flg
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,fir_create_dt
,replace(replace(t1.fir_create_teller_id,chr(13),''),chr(10),'') as fir_create_teller_id
,replace(replace(t1.fir_creator_belong_org_id,chr(13),''),chr(10),'') as fir_creator_belong_org_id
,replace(replace(t1.matn_ps_belong_org_cd,chr(13),''),chr(10),'') as matn_ps_belong_org_cd
,final_modif_dt
,replace(replace(t1.final_modif_teller_id,chr(13),''),chr(10),'') as final_modif_teller_id

from ${iml_schema}.chn_equip_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/chn_equip_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
