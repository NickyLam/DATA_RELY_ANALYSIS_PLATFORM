: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_unite_wl_appl_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_unite_wl_appl_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.loan_appl_flow_num,chr(13),''),chr(10),'') as loan_appl_flow_num
,replace(replace(t1.partner_appl_flow_num,chr(13),''),chr(10),'') as partner_appl_flow_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_id,chr(13),''),chr(10),'') as cert_id
,replace(replace(t1.cont_num,chr(13),''),chr(10),'') as cont_num
,replace(replace(t1.hxb_blklist_flg,chr(13),''),chr(10),'') as hxb_blklist_flg
,replace(replace(t1.crdtc_que_flg,chr(13),''),chr(10),'') as crdtc_que_flg
,t1.score_val as score_val
,replace(replace(t1.anti_fraud_check_flg,chr(13),''),chr(10),'') as anti_fraud_check_flg
,replace(replace(t1.solv_rating_flg,chr(13),''),chr(10),'') as solv_rating_flg
,replace(replace(t1.partner_apv_rest_flg,chr(13),''),chr(10),'') as partner_apv_rest_flg
,replace(replace(t1.other_acp_lmt_flg,chr(13),''),chr(10),'') as other_acp_lmt_flg
,t1.appl_dt as appl_dt
,t1.appl_amt as appl_amt
,t1.apv_start_tm as apv_start_tm
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd
,t1.apv_amt as apv_amt
,t1.apv_end_tm as apv_end_tm
,t1.final_jud_end_tm as final_jud_end_tm
,replace(replace(t1.advise_sucs_flg,chr(13),''),chr(10),'') as advise_sucs_flg
,replace(replace(t1.refuse_rs,chr(13),''),chr(10),'') as refuse_rs
,replace(replace(t1.rela_appl_flow_num,chr(13),''),chr(10),'') as rela_appl_flow_num
,replace(replace(t1.custs_mang_lab_pbc_cali,chr(13),''),chr(10),'') as custs_mang_lab_pbc_cali
,replace(replace(t1.custs_mang_lab_bank_supv_cali,chr(13),''),chr(10),'') as custs_mang_lab_bank_supv_cali
from ${icl_schema}.cmm_unite_wl_appl_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')-1;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_unite_wl_appl_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes