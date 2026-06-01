: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_pty_e_chn_user_status_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_pty_e_chn_user_status.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       etl_dt
      ,replace(replace(user_id,chr(10),''),chr(13),'') as user_id
      ,replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,replace(replace(user_login_name,chr(10),''),chr(13),'') as user_login_name
      ,replace(replace(user_status_cd,chr(10),''),chr(13),'') as user_status_cd
      ,replace(replace(pty_status_cd,chr(10),''),chr(13),'') as pty_status_cd
      ,replace(replace(sign_chn_cd,chr(10),''),chr(13),'') as sign_chn_cd
      ,open_dt
      ,colse_dt
      ,replace(replace(open_org_id,chr(10),''),chr(13),'') as open_org_id
      ,replace(replace(nbs_pause_status_cd,chr(10),''),chr(13),'') as nbs_pause_status_cd
      ,nbs_pause_stdt
      ,nbs_pause_end_dt
      ,replace(replace(mob_bank_pause_status_cd,chr(10),''),chr(13),'') as mob_bank_pause_status_cd
      ,mob_bank_pause_stdt
      ,mob_bank_pause_end_dt
      ,replace(replace(safe_ceph_num,chr(10),''),chr(13),'') as safe_ceph_num
      ,replace(replace(deft_safe_auth_mode,chr(10),''),chr(13),'') as deft_safe_auth_mode
      ,replace(replace(facct_sign_chn_cd,chr(10),''),chr(13),'') as facct_sign_chn_cd
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg 
from idl.hdws_dul_d_rpts_pty_e_chn_user_status 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_pty_e_chn_user_status.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes