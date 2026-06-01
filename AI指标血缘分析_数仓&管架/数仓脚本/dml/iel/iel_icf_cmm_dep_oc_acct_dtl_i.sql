: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_dep_oc_acct_dtl_i
CreateDate: 20240902
FileName:   ${iel_data_path}/cmm_dep_oc_acct_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.oc_acct_flow_num,chr(13),''),chr(10),'') as oc_acct_flow_num
,replace(replace(t1.ova_chn_flow_num,chr(13),''),chr(10),'') as ova_chn_flow_num
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,tran_dt
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.open_vouch_id,chr(13),''),chr(10),'') as open_vouch_id
,replace(replace(t1.dep_prod_acct_id,chr(13),''),chr(10),'') as dep_prod_acct_id
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.sav_type_cd,chr(13),''),chr(10),'') as sav_type_cd
,replace(replace(t1.dep_term_cd,chr(13),''),chr(10),'') as dep_term_cd
,replace(replace(t1.open_vouch_type_cd,chr(13),''),chr(10),'') as open_vouch_type_cd
,replace(replace(t1.proc_status_cd,chr(13),''),chr(10),'') as proc_status_cd
,replace(replace(t1.chn_cd,chr(13),''),chr(10),'') as chn_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.operr_cert_type_cd,chr(13),''),chr(10),'') as operr_cert_type_cd
,replace(replace(t1.operr_cert_no,chr(13),''),chr(10),'') as operr_cert_no
,replace(replace(t1.operr_mobile_no,chr(13),''),chr(10),'') as operr_mobile_no
,operr_info_invalid_dt
,replace(replace(t1.ec_flg,chr(13),''),chr(10),'') as ec_flg
,replace(replace(t1.oc_acct_flg,chr(13),''),chr(10),'') as oc_acct_flg
,replace(replace(t1.strk_bal_flg,chr(13),''),chr(10),'') as strk_bal_flg
,tran_amt
,replace(replace(t1.sub_acct_id,chr(13),''),chr(10),'') as sub_acct_id
,replace(replace(t1.agent_idf_cd,chr(13),''),chr(10),'') as agent_idf_cd
,replace(replace(t1.agent_name,chr(13),''),chr(10),'') as agent_name
,replace(replace(t1.agent_cert_type_cd,chr(13),''),chr(10),'') as agent_cert_type_cd
,replace(replace(t1.agent_cert_no,chr(13),''),chr(10),'') as agent_cert_no
,agent_cert_start_dt
,agent_cert_exp_dt
,replace(replace(t1.old_sub_acct_id,chr(13),''),chr(10),'') as old_sub_acct_id
,replace(replace(t1.old_dep_prod_acct_id,chr(13),''),chr(10),'') as old_dep_prod_acct_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.dep_term_tenor_type_cd,chr(13),''),chr(10),'') as dep_term_tenor_type_cd
,replace(replace(t1.agent_phone,chr(13),''),chr(10),'') as agent_phone
,replace(replace(t1.agent_licen_issue_autho_site,chr(13),''),chr(10),'') as agent_licen_issue_autho_site
,tran_timestamp

from ${icl_schema}.cmm_dep_oc_acct_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_dep_oc_acct_dtl.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
