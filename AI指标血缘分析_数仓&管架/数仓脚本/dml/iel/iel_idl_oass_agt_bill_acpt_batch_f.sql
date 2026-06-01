: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_bill_acpt_batch_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_bill_acpt_batch.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.batch_id as batch_id
,t1.lp_id as lp_id
,t1.org_id as org_id
,t1.acpt_agt_id as acpt_agt_id
,t1.task_type_cd as task_type_cd
,t1.bill_med_cd as bill_med_cd
,t1.bill_type_cd as bill_type_cd
,t1.drawer_cust_id as drawer_cust_id
,t1.appl_acpt_amt as appl_acpt_amt
,t1.appl_draw_dt as appl_draw_dt
,t1.exp_dt as exp_dt
,t1.margin_ratio as margin_ratio
,t1.comm_fee_ratio as comm_fee_ratio
,t1.tran_amt as tran_amt
,t1.pay_bank_bank_no as pay_bank_bank_no
,t1.cust_mgr_id as cust_mgr_id
,t1.dept_id as dept_id
,t1.operr_id as operr_id
,t1.tran_dt as tran_dt
,t1.bus_logic_check_status_cd as bus_logic_check_status_cd
,t1.apv_status_cd as apv_status_cd
,t1.check_status_cd as check_status_cd
,t1.crdt_check_status_cd as crdt_check_status_cd
,t1.final_modif_tm as final_modif_tm
,t1.drawer_acct_num as drawer_acct_num
,t1.drawer_bank_name as drawer_bank_name
,t1.actl_dir_indus_name as actl_dir_indus_name
,t1.enter_acct_org_id as enter_acct_org_id
,t1.acpt_fee as acpt_fee
,t1.mgmt_fee as mgmt_fee
,t1.agt_exp_dt as agt_exp_dt
,t1.acct_amt as acct_amt
,t1.apprved_use_crdt_open_amt as apprved_use_crdt_open_amt
,t1.distr_post_acm_use_open_amt as distr_post_acm_use_open_amt
,t1.cert_no as cert_no
,t1.onl_bank_batch_id as onl_bank_batch_id
,t1.fst_repay_acct_id as fst_repay_acct_id
,t1.margin_tenor_type_cd as margin_tenor_type_cd
,t1.margin_acct_id as margin_acct_id
,t1.margin_type_cd as margin_type_cd
,t1.int_rat_type_cd as int_rat_type_cd
,t1.margin_int_rat_float_type_cd as margin_int_rat_float_type_cd
,t1.margin_int_rat_float_way_cd as margin_int_rat_float_way_cd
,t1.margin_flo_val as margin_flo_val
,t1.rela_party_que_rest_cd as rela_party_que_rest_cd
,t1.tgls_entry_status_cd as tgls_entry_status_cd
,t1.ncbs_entry_status_cd as ncbs_entry_status_cd
,t1.h_data_flg as h_data_flg
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark

from ${idl_schema}.oass_agt_bill_acpt_batch t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_bill_acpt_batch.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
