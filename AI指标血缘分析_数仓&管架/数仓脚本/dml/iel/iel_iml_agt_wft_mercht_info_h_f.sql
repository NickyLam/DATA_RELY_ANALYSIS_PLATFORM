: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_wft_mercht_info_h_f
CreateDate: 20231226
FileName:   ${iel_data_path}/agt_wft_mercht_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.mercht_id,chr(13),''),chr(10),'') as mercht_id
,replace(replace(t1.mercht_name,chr(13),''),chr(10),'') as mercht_name
,replace(replace(t1.mercht_type_descb,chr(13),''),chr(10),'') as mercht_type_descb
,replace(replace(t1.wft_org_id,chr(13),''),chr(10),'') as wft_org_id
,replace(replace(t1.corp_cert_type_cd,chr(13),''),chr(10),'') as corp_cert_type_cd
,replace(replace(t1.corp_cert_type_descb,chr(13),''),chr(10),'') as corp_cert_type_descb
,replace(replace(t1.corp_cert_no,chr(13),''),chr(10),'') as corp_cert_no
,corp_cert_effect_dt
,corp_cert_invalid_dt
,replace(replace(t1.mang_range,chr(13),''),chr(10),'') as mang_range
,replace(replace(t1.rgst_addr,chr(13),''),chr(10),'') as rgst_addr
,replace(replace(t1.legal_rep_name,chr(13),''),chr(10),'') as legal_rep_name
,replace(replace(t1.legal_rep_gender_cd,chr(13),''),chr(10),'') as legal_rep_gender_cd
,replace(replace(t1.legal_rep_gender_descb,chr(13),''),chr(10),'') as legal_rep_gender_descb
,replace(replace(t1.legal_rep_cert_type_cd,chr(13),''),chr(10),'') as legal_rep_cert_type_cd
,replace(replace(t1.legal_rep_cert_type,chr(13),''),chr(10),'') as legal_rep_cert_type
,replace(replace(t1.legal_rep_cert_no,chr(13),''),chr(10),'') as legal_rep_cert_no
,legal_rep_cert_effect_dt
,legal_rep_cert_invalid_dt
,replace(replace(t1.legal_rep_mobile_no,chr(13),''),chr(10),'') as legal_rep_mobile_no
,replace(replace(t1.bnft_owner_name,chr(13),''),chr(10),'') as bnft_owner_name
,replace(replace(t1.bnft_owner_cert_type_cd,chr(13),''),chr(10),'') as bnft_owner_cert_type_cd
,replace(replace(t1.bnft_owner_cert_type_descb,chr(13),''),chr(10),'') as bnft_owner_cert_type_descb
,replace(replace(t1.bnft_owner_cert_no,chr(13),''),chr(10),'') as bnft_owner_cert_no
,bnft_owner_cert_effect_dt
,bnft_owner_cert_invalid_dt
,replace(replace(t1.bnft_owner_dtl_addr,chr(13),''),chr(10),'') as bnft_owner_dtl_addr
,replace(replace(t1.hold_shard_name,chr(13),''),chr(10),'') as hold_shard_name
,replace(replace(t1.hold_shard_cert_type_cd,chr(13),''),chr(10),'') as hold_shard_cert_type_cd
,replace(replace(t1.hold_shard_cert_type_descb,chr(13),''),chr(10),'') as hold_shard_cert_type_descb
,replace(replace(t1.hold_shard_cert_no,chr(13),''),chr(10),'') as hold_shard_cert_no
,hold_shard_cert_effect_dt
,hold_shard_cert_invalid_dt
,replace(replace(t1.auth_trast_ps_name,chr(13),''),chr(10),'') as auth_trast_ps_name
,replace(replace(t1.auth_trast_ps_cert_type_cd,chr(13),''),chr(10),'') as auth_trast_ps_cert_type_cd
,replace(replace(t1.auth_trast_ps_cert_type_descb,chr(13),''),chr(10),'') as auth_trast_ps_cert_type_descb
,replace(replace(t1.auth_trast_ps_cert_no,chr(13),''),chr(10),'') as auth_trast_ps_cert_no
,auth_trast_ps_cert_effect_dt
,auth_trast_ps_cert_invalid_dt
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.mercht_check_status_descb,chr(13),''),chr(10),'') as mercht_check_status_descb
,replace(replace(t1.mercht_actv_status_descb,chr(13),''),chr(10),'') as mercht_actv_status_descb

from ${iml_schema}.agt_wft_mercht_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_wft_mercht_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
