: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_core_comn_entry_flow_i
CreateDate: 20250303
FileName:   ${iel_data_path}/evt_core_comn_entry_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.revs_tran_type_code,chr(13),''),chr(10),'') as revs_tran_type_code
,revs_tran_dt
,replace(replace(t1.check_entry_cd,chr(13),''),chr(10),'') as check_entry_cd
,replace(replace(t1.fee_prod_id,chr(13),''),chr(10),'') as fee_prod_id
,float_ratio
,replace(replace(t1.follow_id,chr(13),''),chr(10),'') as follow_id
,replace(replace(t1.post_flg,chr(13),''),chr(10),'') as post_flg
,replace(replace(t1.accti_status_cd,chr(13),''),chr(10),'') as accti_status_cd
,replace(replace(t1.core_flow_num,chr(13),''),chr(10),'') as core_flow_num
,replace(replace(t1.core_tran_teller_id,chr(13),''),chr(10),'') as core_tran_teller_id
,replace(replace(t1.core_tran_org_id,chr(13),''),chr(10),'') as core_tran_org_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.tran_id,chr(13),''),chr(10),'') as tran_id
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.cntpty_curr_cd,chr(13),''),chr(10),'') as cntpty_curr_cd
,replace(replace(t1.cntpty_prod_id,chr(13),''),chr(10),'') as cntpty_prod_id
,replace(replace(t1.cntpty_org_dist_cd,chr(13),''),chr(10),'') as cntpty_org_dist_cd
,replace(replace(t1.cntpty_tran_ref_no,chr(13),''),chr(10),'') as cntpty_tran_ref_no
,replace(replace(t1.cntpty_tran_flow_num,chr(13),''),chr(10),'') as cntpty_tran_flow_num
,replace(replace(t1.cntpty_type_cd,chr(13),''),chr(10),'') as cntpty_type_cd
,replace(replace(t1.cntpty_cust_acct_num,chr(13),''),chr(10),'') as cntpty_cust_acct_num
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,replace(replace(t1.cntpty_bank_name,chr(13),''),chr(10),'') as cntpty_bank_name
,replace(replace(t1.cntpty_unionpay_num,chr(13),''),chr(10),'') as cntpty_unionpay_num
,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
,replace(replace(t1.cntpty_acct_open_acct_org_id,chr(13),''),chr(10),'') as cntpty_acct_open_acct_org_id
,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,replace(replace(t1.cntpty_acct_sub_acct_num,chr(13),''),chr(10),'') as cntpty_acct_sub_acct_num
,replace(replace(t1.cntpty_cert_no,chr(13),''),chr(10),'') as cntpty_cert_no
,replace(replace(t1.cntpty_cert_type_cd,chr(13),''),chr(10),'') as cntpty_cert_type_cd
,replace(replace(t1.tran_happ_site,chr(13),''),chr(10),'') as tran_happ_site
,replace(replace(t1.tran_postsc,chr(13),''),chr(10),'') as tran_postsc
,tran_amt
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.tran_descb,chr(13),''),chr(10),'') as tran_descb
,replace(replace(t1.tran_batch_no,chr(13),''),chr(10),'') as tran_batch_no
,replace(replace(t1.tran_tm,chr(13),''),chr(10),'') as tran_tm
,replace(replace(t1.tran_revd_flg,chr(13),''),chr(10),'') as tran_revd_flg
,replace(replace(t1.tran_memo_descb,chr(13),''),chr(10),'') as tran_memo_descb
,replace(replace(t1.tran_termn_id,chr(13),''),chr(10),'') as tran_termn_id
,replace(replace(t1.med_type_cd,chr(13),''),chr(10),'') as med_type_cd
,replace(replace(t1.debit_crdt_flg,chr(13),''),chr(10),'') as debit_crdt_flg
,replace(replace(t1.amt_type_cd,chr(13),''),chr(10),'') as amt_type_cd
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.subj_entry_cust_name,chr(13),''),chr(10),'') as subj_entry_cust_name
,replace(replace(t1.subj_entry_cust_acct_num,chr(13),''),chr(10),'') as subj_entry_cust_acct_num
,replace(replace(t1.subj_entry_sub_acct_num,chr(13),''),chr(10),'') as subj_entry_sub_acct_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.src_sys_id,chr(13),''),chr(10),'') as src_sys_id
,replace(replace(t1.fe_flow_num,chr(13),''),chr(10),'') as fe_flow_num
,clear_dt
,chn_tran_dt
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,effect_dt
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t1.sys_id,chr(13),''),chr(10),'') as sys_id
,replace(replace(t1.cash_proj_cd,chr(13),''),chr(10),'') as cash_proj_cd
,replace(replace(t1.crdt_card_num,chr(13),''),chr(10),'') as crdt_card_num
,replace(replace(t1.bus_proc_status_cd,chr(13),''),chr(10),'') as bus_proc_status_cd
,replace(replace(t1.bus_tran_flow_num,chr(13),''),chr(10),'') as bus_tran_flow_num
,bus_tran_dt
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t1.bank_tran_seq_num,chr(13),''),chr(10),'') as bank_tran_seq_num
,replace(replace(t1.have_med_flg,chr(13),''),chr(10),'') as have_med_flg
,replace(replace(t1.src_module_type_cd,chr(13),''),chr(10),'') as src_module_type_cd
,replace(replace(t1.sob_cate_cd,chr(13),''),chr(10),'') as sob_cate_cd
,replace(replace(t1.real_cntpty_prod_id,chr(13),''),chr(10),'') as real_cntpty_prod_id
,replace(replace(t1.real_cntpty_org_id,chr(13),''),chr(10),'') as real_cntpty_org_id
,replace(replace(t1.real_cntpty_org_dist_cd,chr(13),''),chr(10),'') as real_cntpty_org_dist_cd
,replace(replace(t1.real_cntpty_org_name,chr(13),''),chr(10),'') as real_cntpty_org_name
,replace(replace(t1.real_cntpty_cust_acct_num,chr(13),''),chr(10),'') as real_cntpty_cust_acct_num
,replace(replace(t1.real_cntpty_name,chr(13),''),chr(10),'') as real_cntpty_name
,replace(replace(t1.real_cntpty_cert_no,chr(13),''),chr(10),'') as real_cntpty_cert_no
,replace(replace(t1.real_cntpty_cert_type_cd,chr(13),''),chr(10),'') as real_cntpty_cert_type_cd
,replace(replace(t1.real_tran_happ_site,chr(13),''),chr(10),'') as real_tran_happ_site
,replace(replace(t1.main_tran_seq_num,chr(13),''),chr(10),'') as main_tran_seq_num
,replace(replace(t1.main_evt_cls_cd,chr(13),''),chr(10),'') as main_evt_cls_cd
,replace(replace(t1.auto_revs_flg,chr(13),''),chr(10),'') as auto_revs_flg

from ${iml_schema}.evt_core_comn_entry_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_core_comn_entry_flow.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
