: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_bcdl_acct_sign_info_f
CreateDate: 20240906
FileName:   ${iel_data_path}/agt_bcdl_acct_sign_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sign_id,chr(13),''),chr(10),'') as sign_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.acct_prvlg_cd,chr(13),''),chr(10),'') as acct_prvlg_cd
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.acct_sign_status_cd,chr(13),''),chr(10),'') as acct_sign_status_cd
,create_dt
,update_dt
,sign_dt

from ${iml_schema}.agt_bcdl_acct_sign_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bcdl_acct_sign_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
