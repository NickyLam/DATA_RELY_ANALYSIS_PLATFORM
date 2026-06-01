: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pty_teller_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_teller_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt 
,t1.emply_id as emply_id 
,t1.party_id as party_id 
,t1.lp_id as lp_id 
,t1.belong_org_id as belong_org_id 
,t1.teller_id as teller_id 
,t1.belong_dept_id as belong_dept_id 
,t1.teller_status_cd as teller_status_cd 
,t1.create_dt as create_dt 
,t1.update_dt as update_dt 
,t1.id_mark as id_mark 
,t1.job_cd
from ${idl_schema}.pty_teller t1 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_teller_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes