: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_ponl_bk_sign_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_ponl_bk_sign_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.user_id,chr(13),''),chr(10),'') as user_id
    ,replace(replace(t.onl_bank_cust_status_cd,chr(13),''),chr(10),'') as onl_bank_cust_status_cd
    ,t.open_acct_tm as open_acct_tm
    ,t.clos_acct_tm as clos_acct_tm
    ,replace(replace(t.ghb_emply_flg,chr(13),''),chr(10),'') as ghb_emply_flg
    ,replace(replace(t.cust_cn_name,chr(13),''),chr(10),'') as cust_cn_name
    ,replace(replace(t.cust_en_name,chr(13),''),chr(10),'') as cust_en_name
    ,replace(replace(t.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
    ,replace(replace(t.cert_no,chr(13),''),chr(10),'') as cert_no
    ,replace(replace(t.cont_addr,chr(13),''),chr(10),'') as cont_addr
    ,replace(replace(t.phone,chr(13),''),chr(10),'') as phone
    ,replace(replace(t.zip_cd,chr(13),''),chr(10),'') as zip_cd
    ,replace(replace(t.mobile_no,chr(13),''),chr(10),'') as mobile_no
    ,replace(replace(t.gender_cd,chr(13),''),chr(10),'') as gender_cd
    ,replace(replace(t.work_unit_tel,chr(13),''),chr(10),'') as work_unit_tel
    ,replace(replace(t.open_bank_id,chr(13),''),chr(10),'') as open_bank_id
    ,replace(replace(t.open_bank_name,chr(13),''),chr(10),'') as open_bank_name
    ,replace(replace(t.open_acct_brch_id,chr(13),''),chr(10),'') as open_acct_brch_id
    ,replace(replace(t.open_acct_brch_name,chr(13),''),chr(10),'') as open_acct_brch_name
    ,replace(replace(t.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
    ,replace(replace(t.open_acct_org_name,chr(13),''),chr(10),'') as open_acct_org_name
    ,replace(replace(t.cty,chr(13),''),chr(10),'') as cty
from icl.cmm_ponl_bk_sign_info t
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_ponl_bk_sign_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes