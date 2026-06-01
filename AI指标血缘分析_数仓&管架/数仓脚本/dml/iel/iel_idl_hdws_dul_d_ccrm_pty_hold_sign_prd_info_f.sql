: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_pty_hold_sign_prd_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_pty_hold_sign_prd_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       etl_dt
      ,replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,replace(replace(presvt_fin_hold_ind,chr(10),''),chr(13),'') as presvt_fin_hold_ind
      ,replace(replace(non_presvt_fin_hold_ind,chr(10),''),chr(13),'') as non_presvt_fin_hold_ind
      ,replace(replace(fin_hold_ind,chr(10),''),chr(13),'') as fin_hold_ind
      ,replace(replace(comn_dpst_hold_flg,chr(10),''),chr(13),'') as comn_dpst_hold_flg
      ,replace(replace(stru_dpst_hold_flg,chr(10),''),chr(13),'') as stru_dpst_hold_flg
      ,replace(replace(curr_dpst_hold_flg,chr(10),''),chr(13),'') as curr_dpst_hold_flg
      ,replace(replace(time_dpst_hold_flg,chr(10),''),chr(13),'') as time_dpst_hold_flg
      ,replace(replace(loan_hold_ind,chr(10),''),chr(13),'') as loan_hold_ind
      ,replace(replace(loan_poff_flg,chr(10),''),chr(13),'') as loan_poff_flg
      ,replace(replace(loan_ovdue_flg,chr(10),''),chr(13),'') as loan_ovdue_flg
      ,replace(replace(disct_hold_flg,chr(10),''),chr(13),'') as disct_hold_flg
      ,replace(replace(acpt_draft_hold_flg,chr(10),''),chr(13),'') as acpt_draft_hold_flg
      ,replace(replace(fin_sign_flg,chr(10),''),chr(13),'') as fin_sign_flg
      ,replace(replace(nbs_pty_sign_flg,chr(10),''),chr(13),'') as nbs_pty_sign_flg
      ,replace(replace(tel_bank_pty_sign_flg,chr(10),''),chr(13),'') as tel_bank_pty_sign_flg
      ,replace(replace(acpt_draft_sign_flg,chr(10),''),chr(13),'') as acpt_draft_sign_flg
      ,replace(replace(intl_biz_sign_flg,chr(10),''),chr(13),'') as intl_biz_sign_flg
      ,replace(replace(agent_sala_sign_flg,chr(10),''),chr(13),'') as agent_sala_sign_flg
      ,replace(replace(centr_dedu_sign_flg,chr(10),''),chr(13),'') as centr_dedu_sign_flg
      ,replace(replace(disct_biz_sign_flg,chr(10),''),chr(13),'') as disct_biz_sign_flg
      ,replace(replace(lg_corp_biz_sign_flg,chr(10),''),chr(13),'') as lg_corp_biz_sign_flg
      ,replace(replace(comm_acpt_draft_flg,chr(10),''),chr(13),'') as comm_acpt_draft_flg
      ,replace(replace(bank_acpt_draft_flg,chr(10),''),chr(13),'') as bank_acpt_draft_flg
      ,replace(replace(bank_corp_lnk_sign,chr(10),''),chr(13),'') as bank_corp_lnk_sign
      ,replace(replace(corp_smart_noti_sign,chr(10),''),chr(13),'') as corp_smart_noti_sign
      ,replace(replace(fin_tax_ddct_agt_flg,chr(10),''),chr(13),'') as fin_tax_ddct_agt_flg
      ,replace(replace(agt_dpst_flg,chr(10),''),chr(13),'') as agt_dpst_flg
      ,replace(replace(short_lett_comm_agt_flg,chr(10),''),chr(13),'') as short_lett_comm_agt_flg
      ,replace(replace(spr_bd_dpst_sign_flg,chr(10),''),chr(13),'') as spr_bd_dpst_sign_flg
      ,replace(replace(txn_body_gd_agt_flg,chr(10),''),chr(13),'') as txn_body_gd_agt_flg
      ,replace(replace(ofa_agt_flg,chr(10),''),chr(13),'') as ofa_agt_flg
      ,replace(replace(dps_dir_invt_sign_flg,chr(10),''),chr(13),'') as dps_dir_invt_sign_flg
      ,replace(replace(day_dep_off_ln_fin_agt_flg,chr(10),''),chr(13),'') as day_dep_off_ln_fin_agt_flg
      ,replace(replace(syn_dps_agt_flg,chr(10),''),chr(13),'') as syn_dps_agt_flg
      ,replace(replace(cicc_bind_obank_card_flg,chr(10),''),chr(13),'') as cicc_bind_obank_card_flg
      ,replace(replace(unpay_sign_flg,chr(10),''),chr(13),'') as unpay_sign_flg
      ,replace(replace(ghb_card_sign_flg,chr(10),''),chr(13),'') as ghb_card_sign_flg
      ,replace(replace(linkg_advt_sign_flg,chr(10),''),chr(13),'') as linkg_advt_sign_flg
      ,replace(replace(tp_sign_flg,chr(10),''),chr(13),'') as tp_sign_flg
      ,replace(replace(small_bal_yuebao_hold_flg,chr(10),''),chr(13),'') as small_bal_yuebao_hold_flg
      ,replace(replace(smart_dpst_hold_flg,chr(10),''),chr(13),'') as smart_dpst_hold_flg
      ,replace(replace(agt_dpst_hold_flg,chr(10),''),chr(13),'') as agt_dpst_hold_flg
      ,replace(replace(wlth_wlthsrpl_hold_flg,chr(10),''),chr(13),'') as wlth_wlthsrpl_hold_flg
      ,replace(replace(elec_bill_sign_flg,chr(10),''),chr(13),'') as elec_bill_sign_flg 
from idl.hdws_dul_d_ccrm_pty_hold_sign_prd_info 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_pty_hold_sign_prd_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes