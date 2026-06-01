: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_bill_redcst_batch_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_bill_redcst_batch_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.batch_id as batch_id
,t.lp_id as lp_id
,t.cont_id as cont_id
,t.prod_id as prod_id
,t.std_prod_id as std_prod_id
,t.ctr_nt_id as ctr_nt_id
,t.quot_bill_id as quot_bill_id
,t.appl_form_modif_rela_id as appl_form_modif_rela_id
,t.hq_org_id as hq_org_id
,t.org_id as org_id
,t.appl_dt as appl_dt
,t.bus_type_cd as bus_type_cd
,t.dealer_id as dealer_id
,t.cfm_ps_id as cfm_ps_id
,t.pbc_org_cd as pbc_org_cd
,t.pbc_org_acquirer_id as pbc_org_acquirer_id
,t.pbc_org_acquirer_name as pbc_org_acquirer_name
,t.pbc_org_checker_id as pbc_org_checker_id
,t.pbc_org_checker_name as pbc_org_checker_name
,t.pbc_org_apver_id as pbc_org_apver_id
,t.pbc_org_apver_name as pbc_org_apver_name
,t.apver_apv_opinion as apver_apv_opinion
,t.bill_type_cd as bill_type_cd
,t.bill_med_cd as bill_med_cd
,t.bill_cnt as bill_cnt
,t.bill_tot as bill_tot
,t.repo_amt as repo_amt
,t.hold_tenor as hold_tenor
,t.clear_speed_cd as clear_speed_cd
,t.clear_type_cd as clear_type_cd
,t.stl_way_cd as stl_way_cd
,t.stl_amt as stl_amt
,t.exp_stl_amt as exp_stl_amt
,t.stl_dt as stl_dt
,t.exp_stl_dt as exp_stl_dt
,t.int_rat as int_rat
,t.int_paybl as int_paybl
,t.dept_id as dept_id
,t.cust_mgr_id as cust_mgr_id
,t.apv_rest_cd as apv_rest_cd
,t.apv_status_cd as apv_status_cd
,t.msg_status_cd as msg_status_cd
,t.clear_status_cd as clear_status_cd
,t.entry_status_cd as entry_status_cd
,t.final_modif_tm as final_modif_tm
,t.creator_id as creator_id
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.agt_bill_redcst_batch t 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_redcst_batch_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes