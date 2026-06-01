: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rcrs_agt_dacct_base_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rcrs_agt_dacct_base_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(acct_num,chr(10),''),chr(13),'') as acct_num
      ,etl_dt
      ,replace(replace(acct_typ_cd,chr(10),''),chr(13),'') as acct_typ_cd
      ,replace(replace(acct_name,chr(10),''),chr(13),'') as acct_name
      ,replace(replace(blng_pty_id,chr(10),''),chr(13),'') as blng_pty_id
      ,replace(replace(acct_status_cd,chr(10),''),chr(13),'') as acct_status_cd
      ,replace(replace(accting_org_id,chr(10),''),chr(13),'') as accting_org_id
      ,replace(replace(open_org_id,chr(10),''),chr(13),'') as open_org_id
      ,replace(replace(colse_org_id,chr(10),''),chr(13),'') as colse_org_id
      ,replace(replace(open_teller_id,chr(10),''),chr(13),'') as open_teller_id
      ,replace(replace(colse_teller_id,chr(10),''),chr(13),'') as colse_teller_id
      ,open_dt
      ,replace(replace(open_tm,chr(10),''),chr(13),'') as open_tm
      ,colse_dt
      ,replace(replace(corp_dep_flg,chr(10),''),chr(13),'') as corp_dep_flg
      ,replace(replace(non_activ_flg,chr(10),''),chr(13),'') as non_activ_flg
      ,replace(replace(private_acct_flg,chr(10),''),chr(13),'') as private_acct_flg
      ,replace(replace(dacct_acct_frz_flg,chr(10),''),chr(13),'') as dacct_acct_frz_flg
      ,replace(replace(reg_chn_cd,chr(10),''),chr(13),'') as reg_chn_cd
      ,replace(replace(camp_actvy_id,chr(10),''),chr(13),'') as camp_actvy_id
      ,replace(replace(refe_typ_cd,chr(10),''),chr(13),'') as refe_typ_cd
      ,replace(replace(refe_num,chr(10),''),chr(13),'') as refe_num
      ,replace(replace(drw_mode_status_cd,chr(10),''),chr(13),'') as drw_mode_status_cd
      ,replace(replace(net_verfc_status_cd,chr(10),''),chr(13),'') as net_verfc_status_cd
      ,replace(replace(bind_acct_flg,chr(10),''),chr(13),'') as bind_acct_flg
      ,replace(replace(legal_acct_flg,chr(10),''),chr(13),'') as legal_acct_flg
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg
      ,last_update_dt
      ,replace(replace(etl_task_name,chr(10),''),chr(13),'') as etl_task_name
      ,replace(replace(vrf_status_cd,chr(10),''),chr(13),'') as vrf_status_cd
      ,actv_dt
      ,replace(replace(txn_chn_status_cd,chr(10),''),chr(13),'') as txn_chn_status_cd
      ,replace(replace(virt_acct_flg,chr(10),''),chr(13),'') as virt_acct_flg 
from idl.hdws_dul_d_rcrs_agt_dacct_base_info 
where to_char(etl_dt,'yyyymmdd') = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rcrs_agt_dacct_base_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes