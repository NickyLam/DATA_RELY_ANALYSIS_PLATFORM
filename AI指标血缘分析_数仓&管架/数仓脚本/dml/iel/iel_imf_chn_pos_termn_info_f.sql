: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_chn_pos_termn_info_f
CreateDate: 20230525
FileName:   ${iel_data_path}/chn_pos_termn_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.mercht_id,chr(13),''),chr(10),'') as mercht_id
,replace(replace(t1.termn_id,chr(13),''),chr(10),'') as termn_id
,replace(replace(t1.uniq_mark_id,chr(13),''),chr(10),'') as uniq_mark_id
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t1.sign_status_cd,chr(13),''),chr(10),'') as sign_status_cd
,replace(replace(t1.check_status_cd,chr(13),''),chr(10),'') as check_status_cd
,replace(replace(t1.stl_curr_cd,chr(13),''),chr(10),'') as stl_curr_cd
,replace(replace(t1.termn_mcc_code,chr(13),''),chr(10),'') as termn_mcc_code
,replace(replace(t1.manuf_name,chr(13),''),chr(10),'') as manuf_name
,replace(replace(t1.termn_model,chr(13),''),chr(10),'') as termn_model
,replace(replace(t1.termn_type_cd,chr(13),''),chr(10),'') as termn_type_cd
,replace(replace(t1.termn_para_dload_flg,chr(13),''),chr(10),'') as termn_para_dload_flg
,replace(replace(t1.ic_card_para_dload_flg,chr(13),''),chr(10),'') as ic_card_para_dload_flg
,replace(replace(t1.capk_dload_flg,chr(13),''),chr(10),'') as capk_dload_flg
,replace(replace(t1.prop_belong_cd,chr(13),''),chr(10),'') as prop_belong_cd
,replace(replace(t1.prop_belong_org_name,chr(13),''),chr(10),'') as prop_belong_org_name
,replace(replace(t1.supt_forgn_card_flg,chr(13),''),chr(10),'') as supt_forgn_card_flg
,replace(replace(t1.forgn_card_org_brand_name,chr(13),''),chr(10),'') as forgn_card_org_brand_name
,replace(replace(t1.supt_ic_card_flg,chr(13),''),chr(10),'') as supt_ic_card_flg
,replace(replace(t1.access_way_cd,chr(13),''),chr(10),'') as access_way_cd
,replace(replace(t1.termn_belong_org_id,chr(13),''),chr(10),'') as termn_belong_org_id
,replace(replace(t1.termn_belong_bank_num,chr(13),''),chr(10),'') as termn_belong_bank_num
,replace(replace(t1.termn_batch_id,chr(13),''),chr(10),'') as termn_batch_id
,replace(replace(t1.termn_end_dt,chr(13),''),chr(10),'') as termn_end_dt
,replace(replace(t1.termn_para,chr(13),''),chr(10),'') as termn_para
,replace(replace(t1.bind_tel_num,chr(13),''),chr(10),'') as bind_tel_num
,replace(replace(t1.dist_cd,chr(13),''),chr(10),'') as dist_cd
,replace(replace(t1.termn_install_addr,chr(13),''),chr(10),'') as termn_install_addr
,replace(replace(t1.phone,chr(13),''),chr(10),'') as phone
,replace(replace(t1.open_acct_teller,chr(13),''),chr(10),'') as open_acct_teller
,rec_dt
,create_dt
,update_dt

from ${iml_schema}.chn_pos_termn_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/chn_pos_termn_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
