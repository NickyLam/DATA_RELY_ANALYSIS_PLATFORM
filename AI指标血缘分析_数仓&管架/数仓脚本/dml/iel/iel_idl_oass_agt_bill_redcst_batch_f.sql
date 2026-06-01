: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_bill_redcst_batch_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_bill_redcst_batch.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.cont_id as cont_id
,t1.prod_id as prod_id
,t1.std_prod_id as std_prod_id
,t1.ctr_nt_id as ctr_nt_id
,t1.quot_bill_id as quot_bill_id
,t1.appl_form_modif_rela_id as appl_form_modif_rela_id
,t1.hq_org_id as hq_org_id
,t1.org_id as org_id
,t1.appl_dt as appl_dt
,t1.bus_type_cd as bus_type_cd
,t1.dealer_id as dealer_id
,t1.cfm_ps_id as cfm_ps_id
,t1.pbc_org_cd as pbc_org_cd
,t1.pbc_org_acquirer_id as pbc_org_acquirer_id
,t1.pbc_org_acquirer_name as pbc_org_acquirer_name
,t1.pbc_org_checker_id as pbc_org_checker_id
,t1.pbc_org_checker_name as pbc_org_checker_name
,t1.pbc_org_apver_id as pbc_org_apver_id
,t1.pbc_org_apver_name as pbc_org_apver_name
,t1.apver_apv_opinion as apver_apv_opinion
,t1.bill_type_cd as bill_type_cd
,t1.bill_med_cd as bill_med_cd
,t1.bill_cnt as bill_cnt
,t1.bill_tot as bill_tot
,t1.repo_amt as repo_amt
,t1.hold_tenor as hold_tenor
,t1.clear_speed_cd as clear_speed_cd
,t1.clear_type_cd as clear_type_cd
,t1.stl_way_cd as stl_way_cd
,t1.stl_amt as stl_amt
,t1.exp_stl_amt as exp_stl_amt
,t1.stl_dt as stl_dt
,t1.exp_stl_dt as exp_stl_dt
,t1.int_rat as int_rat
,t1.int_paybl as int_paybl
,t1.dept_id as dept_id
,t1.cust_mgr_id as cust_mgr_id
,t1.apv_rest_cd as apv_rest_cd
,t1.apv_status_cd as apv_status_cd
,t1.msg_status_cd as msg_status_cd
,t1.clear_status_cd as clear_status_cd
,t1.entry_status_cd as entry_status_cd
,t1.final_modif_tm as final_modif_tm
,t1.creator_id as creator_id
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.batch_id as batch_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_bill_redcst_batch t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_bill_redcst_batch.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
