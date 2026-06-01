: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pty_cust_mgr_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_cust_mgr_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt 
,t1.party_id as party_id 
,t1.lp_id as lp_id 
,t1.party_type_cd as party_type_cd 
,t1.cust_mgr_id as cust_mgr_id 
,t1.cust_mgr_name as cust_mgr_name 
,t1.create_dt as create_dt 
,t1.update_dt as update_dt 
,t1.id_mark as id_mark 
,t1.job_cd
from ${idl_schema}.pty_cust_mgr t1 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_cust_mgr_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes