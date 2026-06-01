: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_epc_payfan_mercht_info_h_f
CreateDate: 20250910
FileName:   ${iel_data_path}/agt_epc_payfan_mercht_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.ser_num,chr(13),''),chr(10),'') as ser_num
,replace(replace(t1.sign_acct_id,chr(13),''),chr(10),'') as sign_acct_id
,replace(replace(t1.sign_acct_name,chr(13),''),chr(10),'') as sign_acct_name
,replace(replace(t1.sign_acct_type_cd,chr(13),''),chr(10),'') as sign_acct_type_cd
,replace(replace(t1.sign_status_cd,chr(13),''),chr(10),'') as sign_status_cd
,sign_dt
,replace(replace(t1.coll_acct_id,chr(13),''),chr(10),'') as coll_acct_id
,replace(replace(t1.coll_acct_name,chr(13),''),chr(10),'') as coll_acct_name
,payfan_lmt
,replace(replace(t1.mercht_status_cd,chr(13),''),chr(10),'') as mercht_status_cd
,replace(replace(t1.cotas_name,chr(13),''),chr(10),'') as cotas_name
,replace(replace(t1.cotas_tel_num,chr(13),''),chr(10),'') as cotas_tel_num
,replace(replace(t1.mgmt_chn_cd,chr(13),''),chr(10),'') as mgmt_chn_cd
,replace(replace(t1.belong_brch_org_id,chr(13),''),chr(10),'') as belong_brch_org_id
,replace(replace(t1.valid_flg,chr(13),''),chr(10),'') as valid_flg
,init_create_dt
,replace(replace(t1.create_teller_id,chr(13),''),chr(10),'') as create_teller_id
,replace(replace(t1.create_teller_name,chr(13),''),chr(10),'') as create_teller_name
,latest_update_dt
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_teller_name,chr(13),''),chr(10),'') as update_teller_name

from ${iml_schema}.agt_epc_payfan_mercht_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_epc_payfan_mercht_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
