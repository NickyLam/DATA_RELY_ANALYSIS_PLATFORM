: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_elec_chn_acct_sign_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_elec_chn_acct_sign_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.open_chn_type_cd,chr(13),''),chr(10),'') as open_chn_type_cd
,replace(replace(t1.sign_chn_cd,chr(13),''),chr(10),'') as sign_chn_cd
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t1.vouch_type_cd,chr(13),''),chr(10),'') as vouch_type_cd
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.acct_alias,chr(13),''),chr(10),'') as acct_alias
,t1.acct_add_dt as acct_add_dt
,replace(replace(t1.acct_add_org,chr(13),''),chr(10),'') as acct_add_org
,replace(replace(t1.tran_prvlg_open_flg,chr(13),''),chr(10),'') as tran_prvlg_open_flg
,replace(replace(t1.apot_tran_open_flg,chr(13),''),chr(10),'') as apot_tran_open_flg
,replace(replace(t1.card_type_cd,chr(13),''),chr(10),'') as card_type_cd
from ${icl_schema}.cmm_elec_chn_acct_sign_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_elec_chn_acct_sign_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes