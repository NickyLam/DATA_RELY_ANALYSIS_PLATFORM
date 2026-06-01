: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pty_cust_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_cust_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt 
,t1.party_id as party_id 
,t1.lp_id as lp_id 
,t1.sorc_sys_cd as sorc_sys_cd 
,t1.cust_id as cust_id 
,t1.cust_cate_cd as cust_cate_cd 
,t1.cust_type_cd as cust_type_cd 
,t1.cert_no as cert_no 
,t1.cert_name as cert_name 
,t1.cert_type_cd as cert_type_cd 
,t1.open_acct_user_id as open_acct_user_id 
,t1.open_acct_org_id as open_acct_org_id 
,t1.open_acct_dt as open_acct_dt 
,t1.create_dt as create_dt 
,t1.update_dt as update_dt 
,t1.id_mark as id_mark 
,t1.job_cd
from ${idl_schema}.pty_cust t1 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_cust_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes