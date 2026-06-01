: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_bl_act_base_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_bl_act_base_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.bil_id,chr(13),''),chr(10),'') as bil_id
,replace(replace(t1.agt_modf,chr(13),''),chr(10),'') as agt_modf
,t1.etl_dt as etl_dt
,t1.last_update_dt as last_update_dt
,replace(replace(t1.bil_num,chr(13),''),chr(10),'') as bil_num
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,replace(replace(t1.prd_id,chr(13),''),chr(10),'') as prd_id
,replace(replace(t1.bil_typ_cd,chr(13),''),chr(10),'') as bil_typ_cd
,t1.draw_dt as draw_dt
,replace(replace(t1.bill_colt_org_id,chr(13),''),chr(10),'') as bill_colt_org_id
,replace(replace(t1.draw_org_id,chr(13),''),chr(10),'') as draw_org_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.accting_org_id,chr(13),''),chr(10),'') as accting_org_id
,replace(replace(t1.pty_mgr_id,chr(13),''),chr(10),'') as pty_mgr_id
,replace(replace(t1.bill_colt_oprt_id,chr(13),''),chr(10),'') as bill_colt_oprt_id
,replace(replace(t1.draw_oprt_id,chr(13),''),chr(10),'') as draw_oprt_id
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.draw_amt as draw_amt
,t1.acpt_dt as acpt_dt
,t1.due_dt as due_dt
,t1.cash_dt as cash_dt
,t1.loan_issue_dt as loan_issue_dt
,replace(replace(t1.bil_pay_mode,chr(13),''),chr(10),'') as bil_pay_mode
,replace(replace(t1.bil_stats_cd,chr(13),''),chr(10),'') as bil_stats_cd
,replace(replace(t1.bil_deal_status_cd,chr(13),''),chr(10),'') as bil_deal_status_cd
,replace(replace(t1.loss_flg,chr(13),''),chr(10),'') as loss_flg
,replace(replace(t1.adv_flg,chr(13),''),chr(10),'') as adv_flg
,replace(replace(t1.paper_elec_bill_flg,chr(13),''),chr(10),'') as paper_elec_bill_flg
,replace(replace(t1.drawe_cust_nbr,chr(13),''),chr(10),'') as drawe_cust_nbr
,replace(replace(t1.drawe_name,chr(13),''),chr(10),'') as drawe_name
,replace(replace(t1.drawe_acct_num,chr(13),''),chr(10),'') as drawe_acct_num
,replace(replace(t1.payer_name,chr(13),''),chr(10),'') as payer_name
,replace(replace(t1.payer_acct_id,chr(13),''),chr(10),'') as payer_acct_id
,replace(replace(t1.payer_open_bk,chr(13),''),chr(10),'') as payer_open_bk
,replace(replace(t1.payer_open_bk_name,chr(13),''),chr(10),'') as payer_open_bk_name
,replace(replace(t1.payee_name,chr(13),''),chr(10),'') as payee_name
,replace(replace(t1.payee_acct_id,chr(13),''),chr(10),'') as payee_acct_id
,replace(replace(t1.payee_open_bk_num,chr(13),''),chr(10),'') as payee_open_bk_num
,replace(replace(t1.payee_open_bk_name,chr(13),''),chr(10),'') as payee_open_bk_name
,replace(replace(t1.warr_name,chr(13),''),chr(10),'') as warr_name
,replace(replace(t1.acpt_name,chr(13),''),chr(10),'') as acpt_name
,replace(replace(t1.acpt_acct_id,chr(13),''),chr(10),'') as acpt_acct_id
,replace(replace(t1.acpt_open_bk_num,chr(13),''),chr(10),'') as acpt_open_bk_num
,replace(replace(t1.acpt_open_bk_name,chr(13),''),chr(10),'') as acpt_open_bk_name
,replace(replace(t1.acpt_org_id,chr(13),''),chr(10),'') as acpt_org_id
,replace(replace(t1.endo_name,chr(13),''),chr(10),'') as endo_name
,t1.endor_dt as endor_dt
,replace(replace(t1.bil_txt_name,chr(13),''),chr(10),'') as bil_txt_name
,t1.actl_stl_amt as actl_stl_amt
,t1.prest_pay_term as prest_pay_term
,t1.prest_acpt_term as prest_acpt_term
,t1.par_rate as par_rate
,t1.ovdue_adv_rate as ovdue_adv_rate
,t1.ovdue_pay_rate as ovdue_pay_rate
,replace(replace(t1.loan_contr_id,chr(13),''),chr(10),'') as loan_contr_id
,replace(replace(t1.guar_contr_id,chr(13),''),chr(10),'') as guar_contr_id
,replace(replace(t1.adv_dbill_id,chr(13),''),chr(10),'') as adv_dbill_id
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,NVL2(t1.data_src_cd,'AGT_BL_ACT_BASE_INFO'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_BL_ACT_BASE_INFO') as etl_task_name
,replace(replace(t1.bil_src_cd,chr(13),''),chr(10),'') as bil_src_cd
,replace(replace(t1.elec_bill_status_cd,chr(13),''),chr(10),'') as elec_bill_status_cd
,replace(replace(t1.comm_invo_num,chr(13),''),chr(10),'') as comm_invo_num
,t1.comm_inv_amt as comm_inv_amt
,replace(replace(t1.comm_inv_ccy_cd,chr(13),''),chr(10),'') as comm_inv_ccy_cd
,replace(replace(t1.comm_inv_type_cd,chr(13),''),chr(10),'') as comm_inv_type_cd
,replace(replace(t1.payee_typ_cd,chr(13),''),chr(10),'') as payee_typ_cd
,replace(replace(t1.acpt_typ_cd,chr(13),''),chr(10),'') as acpt_typ_cd
,replace(replace(t1.drawe_typ_cd,chr(13),''),chr(10),'') as drawe_typ_cd
from ${idl_schema}.hdws_iml_agt_bl_act_base_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_bl_act_base_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes