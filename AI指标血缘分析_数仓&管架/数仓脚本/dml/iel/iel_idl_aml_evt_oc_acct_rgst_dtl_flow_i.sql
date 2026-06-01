: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_evt_oc_acct_rgst_dtl_flow_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_evt_oc_acct_rgst_dtl_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,evt_id
,lp_id
,oc_acct_dt
,oc_acct_flow
,tran_flow
,oc_acct_flg
,acct_clear_opera_flg
,opera_org_id
,acct_org_line_id
,dep_acct_id
,dep_sub_acct_id
,acct_name
,curr_cd
,ec_flg
,sav_type_cd
,dep_term_cd
,open_acct_vouch_cd
,open_acct_vouch_no
,src_vouch_mgmt_id
,amt
,edu_saving_proof_cd
,int_amt
,int_tax_lmt
,in_cust_acct_int
,in_trdpty_int
from idl.aml_evt_oc_acct_rgst_dtl_flow
where oc_acct_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_evt_oc_acct_rgst_dtl_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes