: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_pty_cust_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_pty_cust.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
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
,t1.party_id as party_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_pty_cust t1
where etl_dt = to_date('${batch_date}','yyyymmdd'); " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_pty_cust.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
