: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_e_chn_acct_sign_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_e_chn_acct_sign.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       etl_dt
      ,replace(replace(acct_id,chr(10),''),chr(13),'') as acct_id
      ,replace(replace(open_all_chn_typ_cd,chr(10),''),chr(13),'') as open_all_chn_typ_cd
      ,replace(replace(sign_chn_typ_cd,chr(10),''),chr(13),'') as sign_chn_typ_cd
      ,replace(replace(acct_status_cd,chr(10),''),chr(13),'') as acct_status_cd
      ,replace(replace(vchr_typ_cd,chr(10),''),chr(13),'') as vchr_typ_cd
      ,replace(replace(user_id,chr(10),''),chr(13),'') as user_id
      ,replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,replace(replace(acct_alias,chr(10),''),chr(13),'') as acct_alias
      ,replace(replace(acct_add_in_dt,chr(10),''),chr(13),'') as acct_add_in_dt
      ,replace(replace(acct_add_in_org,chr(10),''),chr(13),'') as acct_add_in_org
      ,replace(replace(tfr_perm_open_all_flg,chr(10),''),chr(13),'') as tfr_perm_open_all_flg
      ,replace(replace(appo_tfr_open_all_flg,chr(10),''),chr(13),'') as appo_tfr_open_all_flg
      ,replace(replace(card_typ_cd,chr(10),''),chr(13),'') as card_typ_cd
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg 
from idl.hdws_dul_d_rpts_agt_e_chn_acct_sign 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_e_chn_acct_sign.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes