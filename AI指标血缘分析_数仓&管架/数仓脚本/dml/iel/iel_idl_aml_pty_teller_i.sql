: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_pty_teller_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_pty_teller.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select emply_id 
,party_id 
,lp_id 
,belong_org_id 
,teller_id 
,belong_dept_id 
,teller_status_cd 
,create_dt 
,update_dt 
,etl_dt 
,id_mark 
,src_table_name 
,job_cd 
,etl_timestamp from idl.aml_pty_teller where create_dt<=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_pty_teller.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes