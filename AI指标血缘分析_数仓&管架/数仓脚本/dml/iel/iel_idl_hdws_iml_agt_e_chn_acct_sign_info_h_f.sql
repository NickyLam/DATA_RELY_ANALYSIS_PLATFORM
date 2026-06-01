: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_e_chn_acct_sign_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_e_chn_acct_sign_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.open_all_chn_typ_cd,chr(13),''),chr(10),'') as open_all_chn_typ_cd
,t1.etl_dt as st_dt
,to_date('30001231','yyyymmdd') as end_dt
,replace(replace(t1.sign_chn_typ_cd,chr(13),''),chr(10),'') as sign_chn_typ_cd
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t1.vchr_typ_cd,chr(13),''),chr(10),'') as vchr_typ_cd
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,replace(replace(t1.acct_alias,chr(13),''),chr(10),'') as acct_alias
,replace(replace(t1.acct_add_in_dt,chr(13),''),chr(10),'') as acct_add_in_dt
,replace(replace(t1.acct_add_in_org,chr(13),''),chr(10),'') as acct_add_in_org
,replace(replace(t1.tfr_perm_open_all_flg,chr(13),''),chr(10),'') as tfr_perm_open_all_flg
,replace(replace(t1.appo_tfr_open_all_flg,chr(13),''),chr(10),'') as appo_tfr_open_all_flg
,replace(replace(t1.card_typ_cd,chr(13),''),chr(10),'') as card_typ_cd
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'AGT_E_CHN_ACCT_SIGN_INFO_H'||'_'||t1.data_src_cd,'AGT_E_CHN_ACCT_SIGN_INFO_H') as etl_task_name
from ${idl_schema}.hdws_iml_agt_e_chn_acct_sign_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd') and del_flg <> '1' ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_e_chn_acct_sign_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes