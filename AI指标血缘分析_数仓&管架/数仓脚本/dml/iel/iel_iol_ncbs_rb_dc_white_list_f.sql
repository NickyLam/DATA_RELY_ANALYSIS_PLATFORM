: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_rb_dc_white_list_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ncbs_rb_dc_white_list.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.document_id,chr(13),''),chr(10),'') as document_id
,replace(replace(t1.document_type,chr(13),''),chr(10),'') as document_type
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.batch_no,chr(13),''),chr(10),'') as batch_no
,replace(replace(t1.batch_status,chr(13),''),chr(10),'') as batch_status
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.error_code,chr(13),''),chr(10),'') as error_code
,replace(replace(t1.error_desc,chr(13),''),chr(10),'') as error_desc
,replace(replace(t1.job_run_id,chr(13),''),chr(10),'') as job_run_id
,replace(replace(t1.ret_msg,chr(13),''),chr(10),'') as ret_msg
,replace(replace(t1.seq_no,chr(13),''),chr(10),'') as seq_no
,replace(replace(t1.stage_code,chr(13),''),chr(10),'') as stage_code
,replace(replace(t1.tran_file_result,chr(13),''),chr(10),'') as tran_file_result
,t1.tran_date as tran_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.ch_client_name,chr(13),''),chr(10),'') as ch_client_name
from ${iol_schema}.ncbs_rb_dc_white_list t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_dc_white_list.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes