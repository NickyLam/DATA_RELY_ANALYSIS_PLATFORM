: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_epcc_sign_info_h_f
CreateDate: 20240930
FileName:   ${iel_data_path}/agt_epcc_sign_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sign_agt_id,chr(13),''),chr(10),'') as sign_agt_id
,create_tm
,replace(replace(t1.start_use_status_cd,chr(13),''),chr(10),'') as start_use_status_cd
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.mobile_no,chr(13),''),chr(10),'') as mobile_no
,replace(replace(t1.intior_belong_org_id,chr(13),''),chr(10),'') as intior_belong_org_id
,sign_dt
,sign_tm
,replace(replace(t1.sign_status_cd,chr(13),''),chr(10),'') as sign_status_cd
,replace(replace(t1.sign_acct_belong_org_id,chr(13),''),chr(10),'') as sign_acct_belong_org_id
,replace(replace(t1.sign_acct_type_cd,chr(13),''),chr(10),'') as sign_acct_type_cd
,replace(replace(t1.sign_acct_id,chr(13),''),chr(10),'') as sign_acct_id
,replace(replace(t1.sign_acct_name,chr(13),''),chr(10),'') as sign_acct_name
,replace(replace(t1.sign_acct_level_cd,chr(13),''),chr(10),'') as sign_acct_level_cd
,replace(replace(t1.pay_acct_belong_org_id,chr(13),''),chr(10),'') as pay_acct_belong_org_id
,replace(replace(t1.sign_pay_acct_id,chr(13),''),chr(10),'') as sign_pay_acct_id
,agt_invalid_dt
,final_update_tm
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark

from ${iml_schema}.agt_epcc_sign_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_epcc_sign_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
