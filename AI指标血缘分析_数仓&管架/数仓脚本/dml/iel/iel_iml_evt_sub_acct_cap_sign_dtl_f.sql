: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_sub_acct_cap_sign_dtl_f
CreateDate: 20250114
FileName:   ${iel_data_path}/evt_sub_acct_cap_sign_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,plat_dt
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.main_acct_id,chr(13),''),chr(10),'') as main_acct_id
,replace(replace(t1.main_acct_name,chr(13),''),chr(10),'') as main_acct_name
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.open_acct_org_name,chr(13),''),chr(10),'') as open_acct_org_name
,replace(replace(t1.sign_status_cd,chr(13),''),chr(10),'') as sign_status_cd
,replace(replace(t1.sign_org_id,chr(13),''),chr(10),'') as sign_org_id
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,replace(replace(t1.oper_teller_name,chr(13),''),chr(10),'') as oper_teller_name
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark

from ${iml_schema}.evt_sub_acct_cap_sign_dtl t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_sub_acct_cap_sign_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
