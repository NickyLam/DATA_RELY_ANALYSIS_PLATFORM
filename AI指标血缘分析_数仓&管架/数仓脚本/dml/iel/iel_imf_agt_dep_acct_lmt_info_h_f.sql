: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_dep_acct_lmt_info_h_f
CreateDate: 20230914
FileName:   ${iel_data_path}/agt_dep_acct_lmt_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.tran_lmt_type_cd,chr(13),''),chr(10),'') as tran_lmt_type_cd
,replace(replace(t1.lmt_id,chr(13),''),chr(10),'') as lmt_id
,tran_dt
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,effect_dt
,dep_tenor
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
,invalid_dt
,acct_check_dt
,can_deduct_amt
,acct_lmt_amt
,replace(replace(t1.wait_to_froz_seq_num,chr(13),''),chr(10),'') as wait_to_froz_seq_num
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.vouch_type_cd,chr(13),''),chr(10),'') as vouch_type_cd
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.stl_flow_id,chr(13),''),chr(10),'') as stl_flow_id
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd
,stop_amt
,aldy_paid_amt
,begin_amt
,pay_amt
,tran_amt
,replace(replace(t1.acct_aldy_check_flg,chr(13),''),chr(10),'') as acct_aldy_check_flg
,replace(replace(t1.interp_flg,chr(13),''),chr(10),'') as interp_flg
,replace(replace(t1.enforc_ps_1_cert_a_type_cd,chr(13),''),chr(10),'') as enforc_ps_1_cert_a_type_cd
,replace(replace(t1.enforc_ps_1_cert_b_type_cd,chr(13),''),chr(10),'') as enforc_ps_1_cert_b_type_cd
,replace(replace(t1.enforc_ps_2_cert_a_type_cd,chr(13),''),chr(10),'') as enforc_ps_2_cert_a_type_cd
,replace(replace(t1.enforc_ps_2_cert_b_type_cd,chr(13),''),chr(10),'') as enforc_ps_2_cert_b_type_cd
,replace(replace(t1.matn_way_cd,chr(13),''),chr(10),'') as matn_way_cd
,replace(replace(t1.cntpty_acct_prod_id,chr(13),''),chr(10),'') as cntpty_acct_prod_id
,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,replace(replace(t1.cntpty_cust_acct_num,chr(13),''),chr(10),'') as cntpty_cust_acct_num
,replace(replace(t1.cntpty_curr_cd,chr(13),''),chr(10),'') as cntpty_curr_cd
,replace(replace(t1.cntpty_open_acct_org_id,chr(13),''),chr(10),'') as cntpty_open_acct_org_id
,replace(replace(t1.mtg_acct_id,chr(13),''),chr(10),'') as mtg_acct_id
,replace(replace(t1.mtg_cust_acct_num,chr(13),''),chr(10),'') as mtg_cust_acct_num
,replace(replace(t1.mtg_acct_curr_cd,chr(13),''),chr(10),'') as mtg_acct_curr_cd
,replace(replace(t1.mtg_acct_type_cd,chr(13),''),chr(10),'') as mtg_acct_type_cd
,replace(replace(t1.auth_org_name,chr(13),''),chr(10),'') as auth_org_name
,replace(replace(t1.deduct_law_doc_num,chr(13),''),chr(10),'') as deduct_law_doc_num
,replace(replace(t1.termnt_check_id,chr(13),''),chr(10),'') as termnt_check_id
,replace(replace(t1.full_amt_froz_flg,chr(13),''),chr(10),'') as full_amt_froz_flg
,replace(replace(t1.asit_exec_item,chr(13),''),chr(10),'') as asit_exec_item
,replace(replace(t1.ct_froz_flg,chr(13),''),chr(10),'') as ct_froz_flg
,replace(replace(t1.enforc_ps_1_cert_a_no,chr(13),''),chr(10),'') as enforc_ps_1_cert_a_no
,replace(replace(t1.enforc_ps_1_cert_b_no,chr(13),''),chr(10),'') as enforc_ps_1_cert_b_no
,replace(replace(t1.enforc_ps_2_cert_a_no,chr(13),''),chr(10),'') as enforc_ps_2_cert_a_no
,replace(replace(t1.enforc_ps_2_cert_b_no,chr(13),''),chr(10),'') as enforc_ps_2_cert_b_no
,replace(replace(t1.tran_memo_descb,chr(13),''),chr(10),'') as tran_memo_descb
,tot_pay_cnt
,aldy_pay_cnt
,replace(replace(t1.unfrz_org_name,chr(13),''),chr(10),'') as unfrz_org_name
,replace(replace(t1.unfrz_org_law_doc_num,chr(13),''),chr(10),'') as unfrz_org_law_doc_num
,replace(replace(t1.froz_org_name,chr(13),''),chr(10),'') as froz_org_name
,replace(replace(t1.froz_org_law_doc_num,chr(13),''),chr(10),'') as froz_org_law_doc_num
,replace(replace(t1.lmt_acct_range_cd,chr(13),''),chr(10),'') as lmt_acct_range_cd
,replace(replace(t1.froz_lev,chr(13),''),chr(10),'') as froz_lev
,replace(replace(t1.acct_lmt_status_cd,chr(13),''),chr(10),'') as acct_lmt_status_cd
,replace(replace(t1.src_module_type_cd,chr(13),''),chr(10),'') as src_module_type_cd
,replace(replace(t1.begin_check_id,chr(13),''),chr(10),'') as begin_check_id
,replace(replace(t1.sub_lmt_cate_cd,chr(13),''),chr(10),'') as sub_lmt_cate_cd
,replace(replace(t1.pm_flg,chr(13),''),chr(10),'') as pm_flg
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.enforc_ps_1_name,chr(13),''),chr(10),'') as enforc_ps_1_name
,replace(replace(t1.enforc_ps_2_name,chr(13),''),chr(10),'') as enforc_ps_2_name
,replace(replace(t1.operr_1_cert_a_no,chr(13),''),chr(10),'') as operr_1_cert_a_no
,replace(replace(t1.operr_1_cert_b_no,chr(13),''),chr(10),'') as operr_1_cert_b_no
,replace(replace(t1.operr_1_name,chr(13),''),chr(10),'') as operr_1_name
,replace(replace(t1.operr_2_cert_a_no,chr(13),''),chr(10),'') as operr_2_cert_a_no
,replace(replace(t1.operr_2_cert_b_no,chr(13),''),chr(10),'') as operr_2_cert_b_no
,replace(replace(t1.operr_2_cert_a_type_cd,chr(13),''),chr(10),'') as operr_2_cert_a_type_cd
,replace(replace(t1.operr_2_cert_b_type_cd,chr(13),''),chr(10),'') as operr_2_cert_b_type_cd
,replace(replace(t1.operr_2_name,chr(13),''),chr(10),'') as operr_2_name
,replace(replace(t1.operr_1_cert_a_type_cd,chr(13),''),chr(10),'') as operr_1_cert_a_type_cd
,replace(replace(t1.operr_1_cert_b_type_cd,chr(13),''),chr(10),'') as operr_1_cert_b_type_cd
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,unloss_tm
,replace(replace(t1.unloss_teller_id,chr(13),''),chr(10),'') as unloss_teller_id

from ${iml_schema}.agt_dep_acct_lmt_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_dep_acct_lmt_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
