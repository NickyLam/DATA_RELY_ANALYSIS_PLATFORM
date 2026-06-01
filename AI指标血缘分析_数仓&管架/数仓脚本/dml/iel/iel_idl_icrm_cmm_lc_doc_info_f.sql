: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_cmm_lc_doc_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_cmm_lc_doc_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,lp_id
,doc_agt_id
,doc_id
,lc_acct_id
,commer_inv_no
,subj_id
,mx_lc_flg
,arrive_bill_flg
,acpt_flg
,send_bill_dt
,issue_dt
,wrtoff_dt
,acpt_dt
,arrive_bill_dt
,pay_dt
,payer_id
,cust_mgr_id
,oper_org_id
,pay_org_id
,sign_org_id
,acct_instit_id
,payer_name
,doc_type_cd
,doc_status_cd
,curr_cd
,overs_deduct_amt
,pay_amt
,lc_bal
,cl_curr_lc_bal from idl.icrm_cmm_lc_doc_info where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_cmm_lc_doc_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes