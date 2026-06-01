: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_appl_fkd_attach_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_loan_appl_fkd_attach_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.appl_id,chr(13),''),chr(10),'') as appl_id
,replace(replace(t1.appl_flow_num,chr(13),''),chr(10),'') as appl_flow_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t1.belong_brch_id,chr(13),''),chr(10),'') as belong_brch_id
,replace(replace(t1.access_chn_id,chr(13),''),chr(10),'') as access_chn_id
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.crdt_appl_flow_num,chr(13),''),chr(10),'') as crdt_appl_flow_num
,replace(replace(t1.apv_opinion,chr(13),''),chr(10),'') as apv_opinion
,replace(replace(t1.apv_concus,chr(13),''),chr(10),'') as apv_concus
,replace(replace(t1.main_debit_ps_cert_type_cd,chr(13),''),chr(10),'') as main_debit_ps_cert_type_cd
,replace(replace(t1.main_debit_ps_cert_id,chr(13),''),chr(10),'') as main_debit_ps_cert_id
,replace(replace(t1.gender_cd,chr(13),''),chr(10),'') as gender_cd
,replace(replace(t1.issue_org,chr(13),''),chr(10),'') as issue_org
,replace(replace(t1.issue_cty_cd,chr(13),''),chr(10),'') as issue_cty_cd
,t1.issue_dt as issue_dt
,t1.exp_dt as exp_dt
,replace(replace(t1.ghb_emply_flg,chr(13),''),chr(10),'') as ghb_emply_flg
,replace(replace(t1.other_housing_flg,chr(13),''),chr(10),'') as other_housing_flg
,t1.estate_qtty as estate_qtty
,replace(replace(t1.repay_src_cd,chr(13),''),chr(10),'') as repay_src_cd
,replace(replace(t1.spouse_co_ownr_flg,chr(13),''),chr(10),'') as spouse_co_ownr_flg
,replace(replace(t1.spouse_rela_ps_flg,chr(13),''),chr(10),'') as spouse_rela_ps_flg
,replace(replace(t1.mang_type_cd,chr(13),''),chr(10),'') as mang_type_cd
,replace(replace(t1.mercht_name,chr(13),''),chr(10),'') as mercht_name
,replace(replace(t1.mang_site_type_cd,chr(13),''),chr(10),'') as mang_site_type_cd
,replace(replace(t1.mang_site,chr(13),''),chr(10),'') as mang_site
,replace(replace(t1.oper_name,chr(13),''),chr(10),'') as oper_name
,replace(replace(t1.actl_ctrler_name,chr(13),''),chr(10),'') as actl_ctrler_name
,replace(replace(t1.mang_range,chr(13),''),chr(10),'') as mang_range
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name
,replace(replace(t1.unify_soci_crdt_id,chr(13),''),chr(10),'') as unify_soci_crdt_id
,replace(replace(t1.orgnz_cd,chr(13),''),chr(10),'') as orgnz_cd
,replace(replace(t1.corp_lp_name,chr(13),''),chr(10),'') as corp_lp_name
,replace(replace(t1.brwer_idti_cd,chr(13),''),chr(10),'') as brwer_idti_cd
,replace(replace(t1.rgst_addr,chr(13),''),chr(10),'') as rgst_addr
,t1.rgst_cap as rgst_cap
,t1.rgst_dt as rgst_dt
,replace(replace(t1.corp_type_cd,chr(13),''),chr(10),'') as corp_type_cd
,t1.bus_begin_dt as bus_begin_dt
,t1.bus_exp_dt as bus_exp_dt
,t1.lp_obtain_emply_years as lp_obtain_emply_years
,replace(replace(t1.lics_name,chr(13),''),chr(10),'') as lics_name
,replace(replace(t1.lics_id,chr(13),''),chr(10),'') as lics_id
,t1.mang_years as mang_years
,t1.cust_mgr_opinion_amt as cust_mgr_opinion_amt
,t1.cust_mgr_opinion_tenor as cust_mgr_opinion_tenor
,replace(replace(t1.recmd_type_cd,chr(13),''),chr(10),'') as recmd_type_cd
,replace(replace(t1.recmd_agent_name,chr(13),''),chr(10),'') as recmd_agent_name
,t1.crdt_amt as crdt_amt
,replace(replace(t1.final_jud_appl_tm,chr(13),''),chr(10),'') as final_jud_appl_tm
,replace(replace(t1.score_val,chr(13),''),chr(10),'') as score_val
,replace(replace(t1.crdtc_que_situ_cd,chr(13),''),chr(10),'') as crdtc_que_situ_cd
,replace(replace(t1.final_jud_advise_sucs_flg,chr(13),''),chr(10),'') as final_jud_advise_sucs_flg
,replace(replace(t1.distr_advise_sucs_flg,chr(13),''),chr(10),'') as distr_advise_sucs_flg
,replace(replace(t1.refuse_rs_descb,chr(13),''),chr(10),'') as refuse_rs_descb
,t1.final_jud_apv_lmt as final_jud_apv_lmt
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.dtl_addr,chr(13),''),chr(10),'') as dtl_addr
,replace(replace(t1.work_char_cd,chr(13),''),chr(10),'') as work_char_cd
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.mobile_no,chr(13),''),chr(10),'') as mobile_no
,t1.apv_end_tm as apv_end_tm
,replace(replace(t1.blip_doc_flg,chr(13),''),chr(10),'') as blip_doc_flg
,replace(replace(t1.inc_fin_brch_cust_mgr_id,chr(13),''),chr(10),'') as inc_fin_brch_cust_mgr_id
,replace(replace(t1.brwer_is_actl_ctrler_flg,chr(13),''),chr(10),'') as brwer_is_actl_ctrler_flg
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,t1.final_jud_appl_dt as final_jud_appl_dt
from ${iml_schema}.agt_loan_appl_fkd_attach_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_appl_fkd_attach_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes