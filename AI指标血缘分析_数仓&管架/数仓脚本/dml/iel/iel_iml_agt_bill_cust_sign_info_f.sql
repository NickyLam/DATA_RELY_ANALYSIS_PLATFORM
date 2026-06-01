: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_bill_cust_sign_info_f
CreateDate: 20230602
FileName:   ${iel_data_path}/agt_bill_cust_sign_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.src_agt_id,chr(13),''),chr(10),'') as src_agt_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.sign_acct_id,chr(13),''),chr(10),'') as sign_acct_id
,replace(replace(t1.sign_flg,chr(13),''),chr(10),'') as sign_flg
,replace(replace(t1.sign_org_id,chr(13),''),chr(10),'') as sign_org_id
,sign_dt
,revo_dt
,create_dt
,update_dt

from ${iml_schema}.agt_bill_cust_sign_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_cust_sign_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
