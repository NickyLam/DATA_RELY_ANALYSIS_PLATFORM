: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_lc_doc_info_f
CreateDate: 20241014
FileName:   ${iel_data_path}/cmm_lc_doc_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.doc_agt_id,chr(13),''),chr(10),'') as doc_agt_id
,replace(replace(t1.doc_id,chr(13),''),chr(10),'') as doc_id
,replace(replace(t1.lc_acct_id,chr(13),''),chr(10),'') as lc_acct_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.commer_inv_no,chr(13),''),chr(10),'') as commer_inv_no
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.mx_lc_flg,chr(13),''),chr(10),'') as mx_lc_flg
,replace(replace(t1.arrive_bill_flg,chr(13),''),chr(10),'') as arrive_bill_flg
,replace(replace(t1.acpt_flg,chr(13),''),chr(10),'') as acpt_flg
,send_bill_dt
,issue_dt
,wrtoff_dt
,acpt_dt
,arrive_bill_dt
,pay_dt
,replace(replace(t1.payer_id,chr(13),''),chr(10),'') as payer_id
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'') as oper_org_id
,replace(replace(t1.pay_org_id,chr(13),''),chr(10),'') as pay_org_id
,replace(replace(t1.sign_org_id,chr(13),''),chr(10),'') as sign_org_id
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t1.payer_name,chr(13),''),chr(10),'') as payer_name
,replace(replace(t1.issue_bank_swiftcode,chr(13),''),chr(10),'') as issue_bank_swiftcode
,replace(replace(t1.issue_bank_cn_name,chr(13),''),chr(10),'') as issue_bank_cn_name
,replace(replace(t1.issue_bank_name,chr(13),''),chr(10),'') as issue_bank_name
,replace(replace(t1.doc_type_cd,chr(13),''),chr(10),'') as doc_type_cd
,replace(replace(t1.doc_status_cd,chr(13),''),chr(10),'') as doc_status_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,overs_deduct_amt
,pay_amt
,lc_bal
,cl_curr_lc_bal
,claim_amt
,doc_amt

from ${icl_schema}.cmm_lc_doc_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_lc_doc_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
