: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amss_v_all_tran_log_f
CreateDate: 20260115
FileName:   ${iel_data_path}/amss_v_all_tran_log.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tran_date
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.emp_code,chr(13),''),chr(10),'') as emp_code
,replace(replace(t1.emp_name,chr(13),''),chr(10),'') as emp_name
,replace(replace(t1.authorize_emp_code,chr(13),''),chr(10),'') as authorize_emp_code
,replace(replace(t1.authorize_emp_name,chr(13),''),chr(10),'') as authorize_emp_name
,replace(replace(t1.authorize_org_code,chr(13),''),chr(10),'') as authorize_org_code
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.tran_name,chr(13),''),chr(10),'') as tran_name
,tran_begin_time
,tran_end_time
,replace(replace(t1.txn_no,chr(13),''),chr(10),'') as txn_no
,replace(replace(t1.system_code,chr(13),''),chr(10),'') as system_code

from ${iol_schema}.amss_v_all_tran_log t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amss_v_all_tran_log.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
