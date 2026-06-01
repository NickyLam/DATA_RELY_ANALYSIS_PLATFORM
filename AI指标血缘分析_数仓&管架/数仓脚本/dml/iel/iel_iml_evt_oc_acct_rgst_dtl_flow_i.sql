: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_oc_acct_rgst_dtl_flow_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_oc_acct_rgst_dtl_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,t1.oc_acct_dt as oc_acct_dt 
,replace(replace(t1.oc_acct_flow,chr(13),''),chr(10),'') as oc_acct_flow 
,replace(replace(t1.tran_flow,chr(13),''),chr(10),'') as tran_flow 
,replace(replace(t1.oc_acct_flg,chr(13),''),chr(10),'') as oc_acct_flg 
,replace(replace(t1.acct_clear_opera_flg,chr(13),''),chr(10),'') as acct_clear_opera_flg 
,replace(replace(t1.opera_org_id,chr(13),''),chr(10),'') as opera_org_id 
,replace(replace(t1.acct_org_line_id,chr(13),''),chr(10),'') as acct_org_line_id 
,replace(replace(t1.dep_acct_id,chr(13),''),chr(10),'') as dep_acct_id 
,replace(replace(t1.dep_sub_acct_id,chr(13),''),chr(10),'') as dep_sub_acct_id 
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name 
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd 
,replace(replace(t1.ec_flg,chr(13),''),chr(10),'') as ec_flg 
,replace(replace(t1.sav_type_cd,chr(13),''),chr(10),'') as sav_type_cd 
,replace(replace(t1.dep_term_cd,chr(13),''),chr(10),'') as dep_term_cd 
,replace(replace(t1.open_acct_vouch_cd,chr(13),''),chr(10),'') as open_acct_vouch_cd 
,replace(replace(t1.open_acct_vouch_no,chr(13),''),chr(10),'') as open_acct_vouch_no 
,replace(replace(t1.src_vouch_mgmt_id,chr(13),''),chr(10),'') as src_vouch_mgmt_id 
,t1.amt as amt 
,replace(replace(t1.edu_saving_proof_cd,chr(13),''),chr(10),'') as edu_saving_proof_cd 
,t1.int_amt as int_amt 
,t1.int_tax_lmt as int_tax_lmt 
,t1.in_cust_acct_int as in_cust_acct_int 
,t1.in_trdpty_int as in_trdpty_int 
from ${iml_schema}.evt_oc_acct_rgst_dtl_flow t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_oc_acct_rgst_dtl_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes