: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_lg_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_lg_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(bill_no,chr(10),''),chr(13),'') as bill_no
      ,replace(replace(lg_contr_id,chr(10),''),chr(13),'') as lg_contr_id
      ,etl_dt
      ,replace(replace(leave_acct_acct_num,chr(10),''),chr(13),'') as leave_acct_acct_num
      ,replace(replace(sign_org_id,chr(10),''),chr(13),'') as sign_org_id
      ,replace(replace(acct_org_id,chr(10),''),chr(13),'') as acct_org_id
      ,replace(replace(mgmt_org_id,chr(10),''),chr(13),'') as mgmt_org_id
      ,replace(replace(guar_org_id,chr(10),''),chr(13),'') as guar_org_id
      ,replace(replace(pty_mgr_id,chr(10),''),chr(13),'') as pty_mgr_id
      ,replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,issue_dt
      ,start_dt
      ,due_dt
      ,log_off_dt
      ,replace(replace(applnt_stl_acct_num,chr(10),''),chr(13),'') as applnt_stl_acct_num
      ,replace(replace(issue_evt_id,chr(10),''),chr(13),'') as issue_evt_id
      ,replace(replace(log_off_evt_id,chr(10),''),chr(13),'') as log_off_evt_id
      ,replace(replace(lg_typ_cd,chr(10),''),chr(13),'') as lg_typ_cd
      ,replace(replace(lg_status,chr(10),''),chr(13),'') as lg_status
      ,replace(replace(guar_flg,chr(10),''),chr(13),'') as guar_flg
      ,replace(replace(guar_mode_cd,chr(10),''),chr(13),'') as guar_mode_cd
      ,replace(replace(int_mode_cd,chr(10),''),chr(13),'') as int_mode_cd
      ,replace(replace(log_off_mode_cd,chr(10),''),chr(13),'') as log_off_mode_cd
      ,replace(replace(ccy_cd,chr(10),''),chr(13),'') as ccy_cd
      ,lg_amt
      ,lg_bal
      ,bal_occur_dt
      ,fee_rate
      ,fee_amt
      ,ovdue_rate
      ,replace(replace(acct_id,chr(10),''),chr(13),'') as acct_id
      ,replace(replace(crdt_agt_id,chr(10),''),chr(13),'') as crdt_agt_id
      ,replace(replace(cms_ctr_id,chr(10),''),chr(13),'') as cms_ctr_id
      ,replace(replace(benef_name,chr(10),''),chr(13),'') as benef_name
      ,replace(replace(benef_acct_num,chr(10),''),chr(13),'') as benef_acct_num
      ,replace(replace(benef_openbk_name,chr(10),''),chr(13),'') as benef_openbk_name
      ,replace(replace(margin_acct_num,chr(10),''),chr(13),'') as margin_acct_num
      ,replace(replace(marg_ccy,chr(10),''),chr(13),'') as marg_ccy
      ,margin_amt
      ,marg_ratio
      ,replace(replace(adv_flg,chr(10),''),chr(13),'') as adv_flg
      ,adv_rate
      ,replace(replace(adv_dbill_id,chr(10),''),chr(13),'') as adv_dbill_id
      ,adv_amt
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg 
from idl.hdws_dul_d_rpts_agt_lg_info 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_lg_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes