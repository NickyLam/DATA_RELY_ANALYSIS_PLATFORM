: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_ic_card_elec_cash_acct_h_f
CreateDate: 20221229
FileName:   ${iel_data_path}/agt_ic_card_elec_cash_acct_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.card_ser_num,chr(13),''),chr(10),'') as card_ser_num
,replace(replace(t1.app_idf,chr(13),''),chr(10),'') as app_idf
,replace(replace(t1.elec_cash_acct_status_cd,chr(13),''),chr(10),'') as elec_cash_acct_status_cd
,replace(replace(t1.elec_cash_acct_curr_cd,chr(13),''),chr(10),'') as elec_cash_acct_curr_cd
,elec_cash_acct_bal
,elec_cash_bal_uplmi
,elec_cash_sig_tran_lmt
,acm_load_amt
,app_effect_dt
,app_invalid_dt
,elec_cash_acct_open_acct_dt
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id

from ${iml_schema}.agt_ic_card_elec_cash_acct_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_ic_card_elec_cash_acct_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
