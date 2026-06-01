: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_unionpay_sign_info_h_f
CreateDate: 20240930
FileName:   ${iel_data_path}/agt_unionpay_sign_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sign_agt_id,chr(13),''),chr(10),'') as sign_agt_id
,replace(replace(t1.intior_belong_org_id,chr(13),''),chr(10),'') as intior_belong_org_id
,sign_dt
,replace(replace(t1.sign_status_cd,chr(13),''),chr(10),'') as sign_status_cd
,replace(replace(t1.sign_acct_unionpay_org_id,chr(13),''),chr(10),'') as sign_acct_unionpay_org_id
,replace(replace(t1.sign_acct_type_cd,chr(13),''),chr(10),'') as sign_acct_type_cd
,replace(replace(t1.sign_acct_id,chr(13),''),chr(10),'') as sign_acct_id
,replace(replace(t1.sign_acct_name,chr(13),''),chr(10),'') as sign_acct_name
,replace(replace(t1.sign_acct_level_cd,chr(13),''),chr(10),'') as sign_acct_level_cd
,replace(replace(t1.sign_type_cd,chr(13),''),chr(10),'') as sign_type_cd
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.mobile_no,chr(13),''),chr(10),'') as mobile_no
,agt_invalid_dt
,replace(replace(t1.init_bus_kind_id,chr(13),''),chr(10),'') as init_bus_kind_id
,replace(replace(t1.init_acct_id,chr(13),''),chr(10),'') as init_acct_id
,replace(replace(t1.init_acct_unionpay_org_id,chr(13),''),chr(10),'') as init_acct_unionpay_org_id
,replace(replace(t1.intior_unionpay_org_id,chr(13),''),chr(10),'') as intior_unionpay_org_id
,replace(replace(t1.init_org_name,chr(13),''),chr(10),'') as init_org_name
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.vtual_teller_id,chr(13),''),chr(10),'') as vtual_teller_id
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,create_date
,final_update_dt

from ${iml_schema}.agt_unionpay_sign_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_unionpay_sign_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
