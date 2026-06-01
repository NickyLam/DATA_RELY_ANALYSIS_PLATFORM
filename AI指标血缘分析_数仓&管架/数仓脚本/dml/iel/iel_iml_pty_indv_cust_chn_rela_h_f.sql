: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_indv_cust_chn_rela_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_indv_cust_chn_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.belong_plat_cd,chr(13),''),chr(10),'') as belong_plat_cd
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sign_chn_cd,chr(13),''),chr(10),'') as sign_chn_cd
,replace(replace(t1.user_seq_num,chr(13),''),chr(10),'') as user_seq_num
,replace(replace(t1.logon_acct_id,chr(13),''),chr(10),'') as logon_acct_id
,replace(replace(t1.user_acct_status_cd,chr(13),''),chr(10),'') as user_acct_status_cd
,t1.open_tm as open_tm
,t1.clos_acct_tm as clos_acct_tm
,replace(replace(t1.onl_bank_pause_status_cd,chr(13),''),chr(10),'') as onl_bank_pause_status_cd
,t1.onl_bank_pause_end_tm as onl_bank_pause_end_tm
,t1.onl_bank_pause_start_tm as onl_bank_pause_start_tm
,replace(replace(t1.mbank_pause_status_cd,chr(13),''),chr(10),'') as mbank_pause_status_cd
,t1.mbank_pause_start_tm as mbank_pause_start_tm
,t1.mbank_pause_end_tm as mbank_pause_end_tm
,replace(replace(t1.e_acct_sign_plat_cd,chr(13),''),chr(10),'') as e_acct_sign_plat_cd
,replace(replace(t1.save_cert_way_cd,chr(13),''),chr(10),'') as save_cert_way_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.pty_indv_cust_chn_rela_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_indv_cust_chn_rela_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes