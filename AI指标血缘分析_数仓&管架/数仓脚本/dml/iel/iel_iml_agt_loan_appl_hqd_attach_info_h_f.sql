: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_appl_hqd_attach_info_h_f
CreateDate: 20251106
FileName:   ${iel_data_path}/agt_loan_appl_hqd_attach_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.appl_id,chr(13),''),chr(10),'') as appl_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.appl_flow_num,chr(13),''),chr(10),'') as appl_flow_num
,replace(replace(t1.crdt_appl_flow_num,chr(13),''),chr(10),'') as crdt_appl_flow_num
,replace(replace(t1.lmt_appl_flow_num,chr(13),''),chr(10),'') as lmt_appl_flow_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.prod_abbr,chr(13),''),chr(10),'') as prod_abbr
,appl_amt
,loan_tenor
,replace(replace(t1.main_guar_way_cd,chr(13),''),chr(10),'') as main_guar_way_cd
,replace(replace(t1.lmt_circl_flg,chr(13),''),chr(10),'') as lmt_circl_flg
,apv_appl_dt
,apv_end_dt
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd
,apv_lmt
,replace(replace(t1.advise_flg,chr(13),''),chr(10),'') as advise_flg
,replace(replace(t1.warn_info,chr(13),''),chr(10),'') as warn_info
,replace(replace(t1.refuse_rs_descb,chr(13),''),chr(10),'') as refuse_rs_descb
,replace(replace(t1.cust_mgr_opinion,chr(13),''),chr(10),'') as cust_mgr_opinion
,th_year_degree_workr_num
,actl_ctrler_work_years
,flow_calcu_year_sell_inco
,crdtc_not_embody_liab_bal
,crdtc_not_mon_second_marke
,corp_mon_second_marke
,replace(replace(t1.corp_acct_recvbl_inpwn_flg,chr(13),''),chr(10),'') as corp_acct_recvbl_inpwn_flg
,acct_recvbl_inpwn_loan_amt
,intel_prop_inpwn_loan_amt
,replace(replace(t1.share_right_inpwn_flg,chr(13),''),chr(10),'') as share_right_inpwn_flg
,share_right_inpwn_loan_amt
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.cust_mgr_belong_org_id,chr(13),''),chr(10),'') as cust_mgr_belong_org_id
,replace(replace(t1.cust_mgr_belong_brch_org_id,chr(13),''),chr(10),'') as cust_mgr_belong_brch_org_id
,replace(replace(t1.update_cust_mgr_id,chr(13),''),chr(10),'') as update_cust_mgr_id
,replace(replace(t1.new_cust_mgr_belong_org_id,chr(13),''),chr(10),'') as new_cust_mgr_belong_org_id
,up_date

from ${iml_schema}.agt_loan_appl_hqd_attach_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_appl_hqd_attach_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
