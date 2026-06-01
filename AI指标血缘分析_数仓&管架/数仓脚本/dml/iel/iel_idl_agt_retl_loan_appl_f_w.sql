: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_retl_loan_appl_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_retl_loan_appl_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.appl_id as appl_id
,t.lp_id as lp_id
,t.appl_flow_num as appl_flow_num
,t.prod_id as prod_id
,t.prod_name as prod_name
,t.cust_id as cust_id
,t.cust_name as cust_name
,t.loan_form_cd as loan_form_cd
,t.curr_cd as curr_cd
,t.appl_amt as appl_amt
,t.tenor_type_cd as tenor_type_cd
,t.appl_tenor as appl_tenor
,t.int_sub_flg as int_sub_flg
,t.repay_way_cd as repay_way_cd
,t.main_guar_way_cd as main_guar_way_cd
,t.guar_way_cd_2 as guar_way_cd_2
,t.guar_way_cd_3 as guar_way_cd_3
,t.loan_dir_cd as loan_dir_cd
,t.loan_dir_name as loan_dir_name
,t.loan_usage_type_cd as loan_usage_type_cd
,t.loan_usage_descb as loan_usage_descb
,t.invstg_opinion_descb as invstg_opinion_descb
,t.crdt_lmt_use_flg as crdt_lmt_use_flg
,t.apv_status_cd as apv_status_cd
,t.invstg_emply_id as invstg_emply_id
,t.cust_mgr_id as cust_mgr_id
,t.appl_dt as appl_dt
,t.invstg_org_id as invstg_org_id
,t.acct_instit_id as acct_instit_id
,t.rgst_org_id as rgst_org_id
,t.rgst_dt as rgst_dt
,t.init_dubil_id as init_dubil_id
,t.int_rat_modif_effect_way_cd as int_rat_modif_effect_way_cd
,t.cont_type_cd as cont_type_cd
,t.crdt_agt_id as crdt_agt_id
,t.risk_flg as risk_flg
,t.distr_way_cd as distr_way_cd
,t.bar_flg as bar_flg
,t.cap_mode_pay_cd as cap_mode_pay_cd
,t.espec_lon_flg as espec_lon_flg
,t.class_low_risk_flg as class_low_risk_flg
,t.open_amt as open_amt
,t.housing_cnt_cd as housing_cnt_cd
,t.open_supv_acct_flg as open_supv_acct_flg
,t.base_rat_type_cd as base_rat_type_cd
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark
,t.job_cd 
from ${idl_schema}.agt_retl_loan_appl t 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_retl_loan_appl_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes