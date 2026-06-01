: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_payoff_sign_info_h_f
CreateDate: 20240805
FileName:   ${iel_data_path}/agt_payoff_sign_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sign_id,chr(13),''),chr(10),'') as sign_id
,replace(replace(t1.sign_type_cd,chr(13),''),chr(10),'') as sign_type_cd
,replace(replace(t1.entr_acct_id,chr(13),''),chr(10),'') as entr_acct_id
,replace(replace(t1.entr_acct_name,chr(13),''),chr(10),'') as entr_acct_name
,replace(replace(t1.tel_num,chr(13),''),chr(10),'') as tel_num
,replace(replace(t1.corp_addr,chr(13),''),chr(10),'') as corp_addr
,replace(replace(t1.intnal_acct_id,chr(13),''),chr(10),'') as intnal_acct_id
,replace(replace(t1.intnal_acct_name,chr(13),''),chr(10),'') as intnal_acct_name
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,sign_dt
,replace(replace(t1.sign_org_id,chr(13),''),chr(10),'') as sign_org_id
,replace(replace(t1.sign_teller_id,chr(13),''),chr(10),'') as sign_teller_id
,replace(replace(t1.agt_status_cd,chr(13),''),chr(10),'') as agt_status_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.obank_flg,chr(13),''),chr(10),'') as obank_flg
,replace(replace(t1.obank_acct_id,chr(13),''),chr(10),'') as obank_acct_id
,replace(replace(t1.obank_acct_name,chr(13),''),chr(10),'') as obank_acct_name
,replace(replace(t1.obank_bank_no,chr(13),''),chr(10),'') as obank_bank_no
,replace(replace(t1.obank_bank_name,chr(13),''),chr(10),'') as obank_bank_name
,replace(replace(t1.tran_inside_acct_id,chr(13),''),chr(10),'') as tran_inside_acct_id
,replace(replace(t1.tran_inside_acct_name,chr(13),''),chr(10),'') as tran_inside_acct_name
,replace(replace(t1.rfued_flg,chr(13),''),chr(10),'') as rfued_flg
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.agt_payoff_sign_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_payoff_sign_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
