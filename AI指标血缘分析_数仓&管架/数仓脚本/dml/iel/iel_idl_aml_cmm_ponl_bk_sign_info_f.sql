: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_cmm_ponl_bk_sign_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_cmm_ponl_bk_sign_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,lp_id
,cust_id
,user_id
,onl_bank_cust_status_cd
,open_acct_tm
,clos_acct_tm
,ghb_emply_flg
,cust_cn_name
,cust_en_name
,cert_type_cd
,cert_no
,cont_addr
,phone
,zip_cd
,mobile_no
,gender_cd
,work_unit_tel
,open_bank_id
,open_bank_name
,open_acct_brch_id
,open_acct_brch_name
,open_acct_org_id
,open_acct_org_name
,cty
from idl.aml_cmm_ponl_bk_sign_info
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_cmm_ponl_bk_sign_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes