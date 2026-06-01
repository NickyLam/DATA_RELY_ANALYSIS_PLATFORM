: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_eacct_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_eacct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(agt_id,chr(10),''),chr(13),'') as agt_id
      ,etl_dt
      ,replace(replace(acct_name,chr(10),''),chr(13),'') as acct_name
      ,replace(replace(acct_desc,chr(10),''),chr(13),'') as acct_desc
      ,replace(replace(card_num,chr(10),''),chr(13),'') as card_num
      ,replace(replace(blng_pty_id,chr(10),''),chr(13),'') as blng_pty_id
      ,replace(replace(open_org_id,chr(10),''),chr(13),'') as open_org_id
      ,replace(replace(mgmt_org_id,chr(10),''),chr(13),'') as mgmt_org_id
      ,replace(replace(accting_org_id,chr(10),''),chr(13),'') as accting_org_id
      ,replace(replace(pty_mgr_id,chr(10),''),chr(13),'') as pty_mgr_id
      ,eff_dt
      ,expire_dt
      ,replace(replace(frozen_flg,chr(10),''),chr(13),'') as frozen_flg
      ,frozen_dt
      ,unfrozen_dt
      ,replace(replace(ccy_cd,chr(10),''),chr(13),'') as ccy_cd
      ,acct_lmt
      ,replace(replace(auth_rank_cd,chr(10),''),chr(13),'') as auth_rank_cd
      ,replace(replace(agt_status_cd,chr(10),''),chr(13),'') as agt_status_cd
      ,replace(replace(camp_actvy_id,chr(10),''),chr(13),'') as camp_actvy_id
      ,replace(replace(refe_typ_cd,chr(10),''),chr(13),'') as refe_typ_cd
      ,replace(replace(refe_num,chr(10),''),chr(13),'') as refe_num
      ,replace(replace(reg_chn_cd,chr(10),''),chr(13),'') as reg_chn_cd
      ,replace(replace(open_tm,chr(10),''),chr(13),'') as open_tm
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg 
from idl.hdws_dul_d_rpts_agt_eacct_info 
where to_char(etl_dt,'yyyymmdd') = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_eacct_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes