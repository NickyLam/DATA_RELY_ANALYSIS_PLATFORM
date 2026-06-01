: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_bill_acpt_batch_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_bill_acpt_batch_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.batch_id as batch_id
,t.lp_id as lp_id
,t.org_id as org_id
,t.acpt_agt_id as acpt_agt_id
,t.task_type_cd as task_type_cd
,t.bill_med_cd as bill_med_cd
,t.bill_type_cd as bill_type_cd
,t.drawer_cust_id as drawer_cust_id
,t.appl_acpt_amt as appl_acpt_amt
,t.appl_draw_dt as appl_draw_dt
,t.exp_dt as exp_dt
,t.fst_repay_num as fst_repay_num
,t.secd_repay_num as secd_repay_num
,t.margin_ratio as margin_ratio
,t.comm_fee_ratio as comm_fee_ratio
,t.tran_amt as tran_amt
,t.pay_bank_bank_no as pay_bank_bank_no
,t.cust_mgr_id as cust_mgr_id
,t.dept_id as dept_id
,t.operr_id as operr_id
,t.tran_dt as tran_dt
,t.apv_status_cd as apv_status_cd
,t.bus_logic_check_status_cd as bus_logic_check_status_cd
,t.check_status_cd as check_status_cd
,t.crdt_check_status_cd as crdt_check_status_cd
,t.data_src_type_cd as data_src_type_cd
,t.appl_id as appl_id
,t.final_modif_tm as final_modif_tm
,t.drawer_acct_num as drawer_acct_num
,t.drawer_bank_name as drawer_bank_name
,t.actl_dir_indus_name as actl_dir_indus_name
,t.major_guar_way_cd as major_guar_way_cd
,t.enter_acct_org_id as enter_acct_org_id
,t.acpt_fee as acpt_fee
,t.mgmt_fee as mgmt_fee
,t.agt_exp_dt as agt_exp_dt
,t.acct_amt as acct_amt
,t.group_name as group_name
,t.group_open_flg as group_open_flg
,t.group_open_drawer_name as group_open_drawer_name
,t.acpt_type_cd as acpt_type_cd
,t.apprved_use_crdt_open_amt as apprved_use_crdt_open_amt
,t.distr_post_acm_use_open_amt as distr_post_acm_use_open_amt
,t.cert_no as cert_no
,t.onl_bank_batch_id as onl_bank_batch_id
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.agt_bill_acpt_batch t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_acpt_batch_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes