: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_fm_branch_status_detail_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ncbs_fm_branch_status_detail.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.branch,chr(13),''),chr(10),'') as branch
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.branch_reg_type,chr(13),''),chr(10),'') as branch_reg_type
,replace(replace(t1.reg_value,chr(13),''),chr(10),'') as reg_value
,replace(replace(t1.seq_no,chr(13),''),chr(10),'') as seq_no
,t1.tran_date as tran_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.ncbs_fm_branch_status_detail t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_fm_branch_status_detail.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes