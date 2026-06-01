: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_bill_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_bill_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.bill_id as bill_id
,t.vouch_id as vouch_id
,t.lp_id as lp_id
,t.bill_num as bill_num
,t.bill_lev_ctrl_flg as bill_lev_ctrl_flg
,t.role_src_cd as role_src_cd
,t.discnt_batch_id as discnt_batch_id
,t.pbc_tranbl_flg as pbc_tranbl_flg
,t.hxb_acpt_flg as hxb_acpt_flg
,t.bill_med_cd as bill_med_cd
,t.bill_type_cd as bill_type_cd
,t.draw_dt as draw_dt
,t.fac_val_exp_dt as fac_val_exp_dt
,t.cust_id as cust_id
,t.drawer_cate_cd as drawer_cate_cd
,t.drawer_orgnz_cd as drawer_orgnz_cd
,t.drawer_name as drawer_name
,t.drawer_acct_num as drawer_acct_num
,t.drawer_open_bank_num as drawer_open_bank_num
,t.accptor_open_bank_name as accptor_open_bank_name
,t.drawer_open_bank_name as drawer_open_bank_name
,t.accptor_name as accptor_name
,t.accptor_open_bank_num as accptor_open_bank_num
,t.accptor_acct_num as accptor_acct_num
,t.recver_name as recver_name
,t.recver_acct_num as recver_acct_num
,t.recver_open_bank_num as recver_open_bank_num
,t.recver_open_bank_name as recver_open_bank_name
,t.bill_amt as bill_amt
,t.sys_in_acpt_flg as sys_in_acpt_flg
,t.bill_belong_org_id as bill_belong_org_id
,t.bill_invtry_status_cd as bill_invtry_status_cd
,t.bill_status_cd as bill_status_cd
,t.proc_mdl_status_cd as proc_mdl_status_cd
,t.inpwn_status_cd as inpwn_status_cd
,t.inpwn_rgst_b_id as inpwn_rgst_b_id
,t.loss_status_cd as loss_status_cd
,t.loss_rgst_b_id as loss_rgst_b_id
,t.final_modif_operr_id as final_modif_operr_id
,t.final_modif_tm as final_modif_tm
,t.drawer_crdt_level_cd as drawer_crdt_level_cd
,t.drawer_rating_org_id as drawer_rating_org_id
,t.drawer_rating_exp_dt as drawer_rating_exp_dt
,t.recv_bank_name as recv_bank_name
,t.cpes_acpt_rgst_status_flg as cpes_acpt_rgst_status_flg
,t.cpes_discnt_rgst_status_flg as cpes_discnt_rgst_status_flg
,t.drawer_unify_soci_crdt_cd as drawer_unify_soci_crdt_cd
,t.payoff_flg as payoff_flg
,t.receipt_flg as receipt_flg
,t.redcst_flg as redcst_flg
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.agt_bill_info t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes