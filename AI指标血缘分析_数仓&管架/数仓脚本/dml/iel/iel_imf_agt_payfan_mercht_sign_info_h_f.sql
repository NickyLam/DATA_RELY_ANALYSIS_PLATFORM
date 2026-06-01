: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_payfan_mercht_sign_info_h_f
CreateDate: 20230927
FileName:   ${iel_data_path}/agt_payfan_mercht_sign_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.mercht_id,chr(13),''),chr(10),'') as mercht_id
,replace(replace(t1.mercht_name,chr(13),''),chr(10),'') as mercht_name
,replace(replace(t1.mercht_abbr,chr(13),''),chr(10),'') as mercht_abbr
,replace(replace(t1.white_list_ctrl_flg,chr(13),''),chr(10),'') as white_list_ctrl_flg
,replace(replace(t1.mercht_status_cd,chr(13),''),chr(10),'') as mercht_status_cd
,replace(replace(t1.supv_acct_id,chr(13),''),chr(10),'') as supv_acct_id
,replace(replace(t1.supv_acct_name,chr(13),''),chr(10),'') as supv_acct_name
,replace(replace(t1.supv_acct_open_bank_num,chr(13),''),chr(10),'') as supv_acct_open_bank_num
,replace(replace(t1.supv_acct_open_bank_name,chr(13),''),chr(10),'') as supv_acct_open_bank_name
,replace(replace(t1.supv_acct_type_cd,chr(13),''),chr(10),'') as supv_acct_type_cd
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.adv_acct_id,chr(13),''),chr(10),'') as adv_acct_id
,replace(replace(t1.adv_acct_name,chr(13),''),chr(10),'') as adv_acct_name
,replace(replace(t1.adv_acct_open_bank_num,chr(13),''),chr(10),'') as adv_acct_open_bank_num
,replace(replace(t1.adv_acct_type_cd,chr(13),''),chr(10),'') as adv_acct_type_cd
,replace(replace(t1.flow_status_cd,chr(13),''),chr(10),'') as flow_status_cd
,replace(replace(t1.free_apv_tranbl_acct_flg,chr(13),''),chr(10),'') as free_apv_tranbl_acct_flg
,create_tm
,modif_tm
,replace(replace(t1.matn_teller_id,chr(13),''),chr(10),'') as matn_teller_id
,replace(replace(t1.apv_teller_id,chr(13),''),chr(10),'') as apv_teller_id

from ${iml_schema}.agt_payfan_mercht_sign_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_payfan_mercht_sign_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
