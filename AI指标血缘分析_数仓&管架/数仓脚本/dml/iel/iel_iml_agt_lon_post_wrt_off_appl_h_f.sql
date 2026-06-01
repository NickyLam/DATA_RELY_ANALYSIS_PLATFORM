: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_lon_post_wrt_off_appl_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_lon_post_wrt_off_appl_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.appl_id,chr(13),''),chr(10),'') as appl_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.wrt_off_flow_num,chr(13),''),chr(10),'') as wrt_off_flow_num
,replace(replace(t1.wrt_off_cate_cd,chr(13),''),chr(10),'') as wrt_off_cate_cd
,replace(replace(t1.wrt_off_batch_no,chr(13),''),chr(10),'') as wrt_off_batch_no
,loan_bal
,pric_amt
,wrt_off_amt
,wrt_off_pric
,wrt_off_in_bs_int
,wrt_off_off_bs_int
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,apv_wrt_off_dt
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd
,wrt_off_dt
,replace(replace(t1.guar_recs_situ_and_rest_descb,chr(13),''),chr(10),'') as guar_recs_situ_and_rest_descb
,replace(replace(t1.brwer_recs_situ_and_rest_descb,chr(13),''),chr(10),'') as brwer_recs_situ_and_rest_descb
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.court_final_rule_num,chr(13),''),chr(10),'') as court_final_rule_num
,court_final_rule_tm
,replace(replace(t1.court_final_rule_doc_name,chr(13),''),chr(10),'') as court_final_rule_doc_name
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,rgst_dt
,replace(replace(t1.bad_debt_form_rs_descb,chr(13),''),chr(10),'') as bad_debt_form_rs_descb
,replace(replace(t1.duty_idtfy_and_rest_descb,chr(13),''),chr(10),'') as duty_idtfy_and_rest_descb
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t1.dubil_id_comb,chr(13),''),chr(10),'') as dubil_id_comb
,replace(replace(t1.mang_corp_name,chr(13),''),chr(10),'') as mang_corp_name
,replace(replace(t1.resv_debtor_recs_flg,chr(13),''),chr(10),'') as resv_debtor_recs_flg

from ${iml_schema}.agt_lon_post_wrt_off_appl_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_lon_post_wrt_off_appl_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
