: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_gzfh_agt_bl_act_base_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_gzfh_agt_bl_act_base_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(bil_id,chr(10),''),chr(13),'') as bil_id
      ,replace(replace(agt_modf,chr(10),''),chr(13),'') as agt_modf
      ,etl_dt
      ,last_update_dt
      ,replace(replace(bil_num,chr(10),''),chr(13),'') as bil_num
      ,replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,replace(replace(prd_id,chr(10),''),chr(13),'') as prd_id
      ,replace(replace(bil_typ_cd,chr(10),''),chr(13),'') as bil_typ_cd
      ,draw_dt
      ,replace(replace(bill_colt_org_id,chr(10),''),chr(13),'') as bill_colt_org_id
      ,replace(replace(draw_org_id,chr(10),''),chr(13),'') as draw_org_id
      ,replace(replace(mgmt_org_id,chr(10),''),chr(13),'') as mgmt_org_id
      ,replace(replace(accting_org_id,chr(10),''),chr(13),'') as accting_org_id
      ,replace(replace(pty_mgr_id,chr(10),''),chr(13),'') as pty_mgr_id
      ,replace(replace(bill_colt_oprt_id,chr(10),''),chr(13),'') as bill_colt_oprt_id
      ,replace(replace(draw_oprt_id,chr(10),''),chr(13),'') as draw_oprt_id
      ,replace(replace(ccy_cd,chr(10),''),chr(13),'') as ccy_cd
      ,draw_amt
      ,acpt_dt
      ,due_dt
      ,cash_dt
      ,loan_issue_dt
      ,replace(replace(bil_pay_mode,chr(10),''),chr(13),'') as bil_pay_mode
      ,replace(replace(bil_stats_cd,chr(10),''),chr(13),'') as bil_stats_cd
      ,replace(replace(bil_deal_status_cd,chr(10),''),chr(13),'') as bil_deal_status_cd
      ,replace(replace(loss_flg,chr(10),''),chr(13),'') as loss_flg
      ,replace(replace(adv_flg,chr(10),''),chr(13),'') as adv_flg
      ,replace(replace(paper_elec_bill_flg,chr(10),''),chr(13),'') as paper_elec_bill_flg
      ,replace(replace(drawe_cust_nbr,chr(10),''),chr(13),'') as drawe_cust_nbr
      ,replace(replace(drawe_name,chr(10),''),chr(13),'') as drawe_name
      ,replace(replace(drawe_acct_num,chr(10),''),chr(13),'') as drawe_acct_num
      ,replace(replace(payer_name,chr(10),''),chr(13),'') as payer_name
      ,replace(replace(payer_acct_id,chr(10),''),chr(13),'') as payer_acct_id
      ,replace(replace(payer_open_bk,chr(10),''),chr(13),'') as payer_open_bk
      ,replace(replace(payer_open_bk_name,chr(10),''),chr(13),'') as payer_open_bk_name
      ,replace(replace(payee_name,chr(10),''),chr(13),'') as payee_name
      ,replace(replace(payee_acct_id,chr(10),''),chr(13),'') as payee_acct_id
      ,replace(replace(payee_open_bk_num,chr(10),''),chr(13),'') as payee_open_bk_num
      ,replace(replace(payee_open_bk_name,chr(10),''),chr(13),'') as payee_open_bk_name
      ,replace(replace(warr_name,chr(10),''),chr(13),'') as warr_name
      ,replace(replace(acpt_name,chr(10),''),chr(13),'') as acpt_name
      ,replace(replace(acpt_acct_id,chr(10),''),chr(13),'') as acpt_acct_id
      ,replace(replace(acpt_open_bk_num,chr(10),''),chr(13),'') as acpt_open_bk_num
      ,replace(replace(acpt_open_bk_name,chr(10),''),chr(13),'') as acpt_open_bk_name
      ,replace(replace(acpt_org_id,chr(10),''),chr(13),'') as acpt_org_id
      ,replace(replace(endo_name,chr(10),''),chr(13),'') as endo_name
      ,endor_dt
      ,replace(replace(bil_txt_name,chr(10),''),chr(13),'') as bil_txt_name
      ,actl_stl_amt
      ,prest_pay_term
      ,prest_acpt_term
      ,par_rate
      ,ovdue_adv_rate
      ,ovdue_pay_rate
      ,replace(replace(loan_contr_id,chr(10),''),chr(13),'') as loan_contr_id
      ,replace(replace(guar_contr_id,chr(10),''),chr(13),'') as guar_contr_id
      ,replace(replace(adv_dbill_id,chr(10),''),chr(13),'') as adv_dbill_id
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg
      ,replace(replace(etl_task_name,chr(10),''),chr(13),'') as etl_task_name
      ,replace(replace(bil_src_cd,chr(10),''),chr(13),'') as bil_src_cd
      ,replace(replace(elec_bill_status_cd,chr(10),''),chr(13),'') as elec_bill_status_cd
      ,replace(replace(comm_invo_num,chr(10),''),chr(13),'') as comm_invo_num
      ,comm_inv_amt
      ,replace(replace(comm_inv_ccy_cd,chr(10),''),chr(13),'') as comm_inv_ccy_cd
      ,replace(replace(comm_inv_type_cd,chr(10),''),chr(13),'') as comm_inv_type_cd
      ,replace(replace(payee_typ_cd,chr(10),''),chr(13),'') as payee_typ_cd
      ,replace(replace(acpt_typ_cd,chr(10),''),chr(13),'') as acpt_typ_cd
      ,replace(replace(drawe_typ_cd,chr(10),''),chr(13),'') as drawe_typ_cd 
from idl.hdws_dul_d_gzfh_agt_bl_act_base_info 
where to_char(etl_dt,'yyyymmdd') = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_gzfh_agt_bl_act_base_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes