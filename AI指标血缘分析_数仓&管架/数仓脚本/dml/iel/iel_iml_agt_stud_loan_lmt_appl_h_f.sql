: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_stud_loan_lmt_appl_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_stud_loan_lmt_appl_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.appl_id,chr(13),''),chr(10),'') as appl_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,t.appl_dt as appl_dt
    ,replace(replace(t.appl_flow_num,chr(13),''),chr(10),'') as appl_flow_num
    ,replace(replace(t.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
    ,replace(replace(t.indv_cust_flg,chr(13),''),chr(10),'') as indv_cust_flg
    ,replace(replace(t.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
    ,replace(replace(t.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
    ,replace(replace(t.cert_no,chr(13),''),chr(10),'') as cert_no
    ,replace(replace(t.white_list_cust_flg,chr(13),''),chr(10),'') as white_list_cust_flg
    ,replace(replace(t.back_to_catch_flg,chr(13),''),chr(10),'') as back_to_catch_flg
    ,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
    ,replace(replace(t.prod_name,chr(13),''),chr(10),'') as prod_name
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
    ,t.appl_amt as appl_amt
    ,replace(replace(t.circl_flg,chr(13),''),chr(10),'') as circl_flg
    ,replace(replace(t.adj_lmt_flg,chr(13),''),chr(10),'') as adj_lmt_flg
    ,replace(replace(t.redc_flg,chr(13),''),chr(10),'') as redc_flg
    ,replace(replace(t.not_mt_thr_mon_new_car_flg,chr(13),''),chr(10),'') as not_mt_thr_mon_new_car_flg
    ,replace(replace(t.attach_or_rent_flg,chr(13),''),chr(10),'') as attach_or_rent_flg
    ,t.mon_in as mon_in
    ,t.mon_expns as mon_expns
    ,replace(replace(t.appl_rs_descb,chr(13),''),chr(10),'') as appl_rs_descb
    ,replace(replace(t.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
    ,t.tenor as tenor
    ,replace(replace(t.main_guar_way_cd,chr(13),''),chr(10),'') as main_guar_way_cd
    ,replace(replace(t.loan_usage_cd,chr(13),''),chr(10),'') as loan_usage_cd
    ,t.int_score_val as int_score_val
    ,t.apv_dt as apv_dt
    ,replace(replace(t.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd
    ,t.apv_lmt as apv_lmt
    ,t.final_apv_lmt as final_apv_lmt
    ,replace(replace(t.refuse_rs_descb,chr(13),''),chr(10),'') as refuse_rs_descb
    ,replace(replace(t.src_chn_cd,chr(13),''),chr(10),'') as src_chn_cd
    ,replace(replace(t.fin_org_id,chr(13),''),chr(10),'') as fin_org_id
    ,replace(replace(t.rgst_emply_id,chr(13),''),chr(10),'') as rgst_emply_id
    ,replace(replace(t.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
    ,replace(replace(t.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
    ,replace(replace(t.director_org_id,chr(13),''),chr(10),'') as director_org_id
    ,replace(replace(t.stud_loan_corp_id,chr(13),''),chr(10),'') as stud_loan_corp_id
    ,replace(replace(t.stud_loan_corp_name,chr(13),''),chr(10),'') as stud_loan_corp_name
    ,replace(replace(t.corp_name,chr(13),''),chr(10),'') as corp_name
    ,replace(replace(t.corp_cert_type_cd,chr(13),''),chr(10),'') as corp_cert_type_cd
    ,replace(replace(t.corp_cert_no,chr(13),''),chr(10),'') as corp_cert_no
    ,t.attach_or_rent_agt_sign_dt as attach_or_rent_agt_sign_dt
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_stud_loan_lmt_appl_h t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_stud_loan_lmt_appl_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes