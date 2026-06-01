: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_ref_moy_box_card_info_h_f
CreateDate: 20250102
FileName:   ${iel_data_path}/ref_moy_box_card_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.card_vouch_status,chr(13),''),chr(10),'') as card_vouch_status
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.nomi_card_flg,chr(13),''),chr(10),'') as nomi_card_flg
,replace(replace(t1.supp_card_flg,chr(13),''),chr(10),'') as supp_card_flg
,replace(replace(t1.main_card_card_no,chr(13),''),chr(10),'') as main_card_card_no
,replace(replace(t1.appl_id,chr(13),''),chr(10),'') as appl_id
,replace(replace(t1.make_card_doc_batch_no,chr(13),''),chr(10),'') as make_card_doc_batch_no
,replace(replace(t1.card_cnv,chr(13),''),chr(10),'') as card_cnv
,replace(replace(t1.card_med_type_cd,chr(13),''),chr(10),'') as card_med_type_cd
,replace(replace(t1.card_psbook_merge_one_flg,chr(13),''),chr(10),'') as card_psbook_merge_one_flg
,replace(replace(t1.card_status_cd,chr(13),''),chr(10),'') as card_status_cd
,change_card_cnt
,issue_dt
,tran_tm
,effect_dt
,invalid_dt
,replace(replace(t1.appl_teller_id,chr(13),''),chr(10),'') as appl_teller_id
,replace(replace(t1.card_iss_teller_id,chr(13),''),chr(10),'') as card_iss_teller_id
,replace(replace(t1.core_tran_org_id,chr(13),''),chr(10),'') as core_tran_org_id

from ${iml_schema}.ref_moy_box_card_info_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_moy_box_card_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
