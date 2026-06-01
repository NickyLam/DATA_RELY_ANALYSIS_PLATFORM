: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_bcdl_cust_sign_info_f
CreateDate: 20250709
FileName:   ${iel_data_path}/agt_bcdl_cust_sign_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.sign_id,chr(13),''),chr(10),'') as sign_id
,sign_dt
,replace(replace(t1.cust_open_acct_org_id,chr(13),''),chr(10),'') as cust_open_acct_org_id
,replace(replace(t1.sign_org_id,chr(13),''),chr(10),'') as sign_org_id
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,create_dt
,update_dt

from ${iml_schema}.agt_bcdl_cust_sign_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bcdl_cust_sign_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
