: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ref_bill_info_para_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_bill_info_para_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt
,t.bill_id
,t.lp_id
,t.bill_num
,t.bill_lev_ctrl_flg
,t.role_src_cd
,t.discnt_batch_id
,t.pbc_tranbl_flg
,t.hxb_acpt_flg
,t.bill_med_cd
,t.bill_type_cd
,t.draw_dt
,t.fac_val_exp_dt
,t.cust_id
,t.drawer_cate_cd
,t.drawer_orgnz_cd
,t.drawer_name
,t.drawer_acct_num
,t.drawer_open_bank_num
,t.accptor_open_bank_name
,t.drawer_open_bank_name
,t.accptor_name
,t.accptor_open_bank_num
,t.accptor_acct_num
,t.recver_name
,t.recver_acct_num
,t.recver_open_bank_num
,t.recver_open_bank_name
,t.bill_amt
,t.sys_in_acpt_flg
,t.bill_belong_org_id
,t.bill_invtry_status_cd
,t.bill_status_cd
,t.proc_mdl_status_cd
,t.inpwn_status_cd
,t.inpwn_rgst_b_id
,t.loss_status_cd
,t.loss_rgst_b_id
,t.final_modif_operr_id
,t.final_modif_tm
,t.drawer_crdt_level_cd
,t.drawer_rating_org_id
,t.drawer_rating_exp_dt
,t.recv_bank_name
,t.cpes_acpt_rgst_status_flg
,t.cpes_discnt_rgst_status_flg
,t.drawer_unify_soci_crdt_cd
,t.payoff_flg
,t.receipt_flg
,t.create_dt
,t.update_dt
,t.id_mark
from ${idl_schema}.ref_bill_info_para t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_bill_info_para_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes