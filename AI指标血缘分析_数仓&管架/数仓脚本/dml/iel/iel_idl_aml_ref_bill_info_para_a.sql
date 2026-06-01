: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_ref_bill_info_para_a
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_ref_bill_info_para.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,bill_id
,lp_id
,bill_num
,bill_lev_ctrl_flg
,role_src_cd
,discnt_batch_id
,pbc_tranbl_flg
,hxb_acpt_flg
,bill_med_cd
,bill_type_cd
,draw_dt
,fac_val_exp_dt
,cust_id
,drawer_cate_cd
,drawer_orgnz_cd
,drawer_name
,drawer_acct_num
,drawer_open_bank_num
,accptor_open_bank_name
,drawer_open_bank_name
,accptor_name
,accptor_open_bank_num
,accptor_acct_num
,recver_name
,recver_acct_num
,recver_open_bank_num
,recver_open_bank_name
,bill_amt
,sys_in_acpt_flg
,bill_belong_org_id
,bill_invtry_status_cd
,bill_status_cd
,proc_mdl_status_cd
,inpwn_status_cd
,inpwn_rgst_b_id
,loss_status_cd
,loss_rgst_b_id
,final_modif_operr_id
,final_modif_tm
,drawer_crdt_level_cd
,drawer_rating_org_id
,drawer_rating_exp_dt
,recv_bank_name
,cpes_acpt_rgst_status_flg
,cpes_discnt_rgst_status_flg
,drawer_unify_soci_crdt_cd
,payoff_flg from idl.aml_ref_bill_info_para where etl_dt =to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_ref_bill_info_para.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes