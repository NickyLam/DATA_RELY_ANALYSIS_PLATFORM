: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_crps_cmm_unite_wl_appl_info_f
CreateDate: 20221109
FileName:   ${iel_data_path}/crps_cmm_unite_wl_appl_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.lp_id as lp_id
,t1.loan_appl_flow_num as loan_appl_flow_num
,t1.partner_appl_flow_num as partner_appl_flow_num
,t1.prod_id as prod_id
,t1.prod_name as prod_name
,t1.belong_org_id as belong_org_id
,t1.cust_id as cust_id
,t1.cust_name as cust_name
,t1.cert_type_cd as cert_type_cd
,t1.cert_id as cert_id
,t1.cont_num as cont_num
,t1.hxb_blklist_flg as hxb_blklist_flg
,t1.crdtc_que_flg as crdtc_que_flg
,t1.score_val as score_val
,t1.anti_fraud_check_flg as anti_fraud_check_flg
,t1.solv_rating_flg as solv_rating_flg
,t1.partner_apv_rest_flg as partner_apv_rest_flg
,t1.other_acp_lmt_flg as other_acp_lmt_flg
,t1.appl_dt as appl_dt
,t1.appl_amt as appl_amt
,t1.apv_start_tm as apv_start_tm
,t1.apv_status_cd as apv_status_cd
,t1.apv_amt as apv_amt
,t1.apv_end_tm as apv_end_tm
,t1.final_jud_end_tm as final_jud_end_tm
,t1.advise_sucs_flg as advise_sucs_flg
,t1.refuse_rs as refuse_rs
,t1.rela_appl_flow_num as rela_appl_flow_num
,t1.custs_mang_lab_pbc_cali as custs_mang_lab_pbc_cali
,t1.custs_mang_lab_bank_supv_cali as custs_mang_lab_bank_supv_cali

from ${idl_schema}.crps_cmm_unite_wl_appl_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crps_cmm_unite_wl_appl_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
