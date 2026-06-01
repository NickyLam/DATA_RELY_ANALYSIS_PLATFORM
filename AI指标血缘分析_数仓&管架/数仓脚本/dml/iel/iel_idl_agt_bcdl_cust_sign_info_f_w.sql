: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_bcdl_cust_sign_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_bcdl_cust_sign_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.agt_id as agt_id
,t.lp_id as lp_id
,t.cust_id as cust_id
,t.cust_name as cust_name
,t.sign_id as sign_id
,t.sign_dt as sign_dt
,t.cust_open_acct_org_id as cust_open_acct_org_id
,t.sign_org_id as sign_org_id
,t.cert_type_cd as cert_type_cd
,t.cert_no as cert_no
,t.status_cd as status_cd
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark
,t.job_cd 
from ${idl_schema}.agt_bcdl_cust_sign_info t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bcdl_cust_sign_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes