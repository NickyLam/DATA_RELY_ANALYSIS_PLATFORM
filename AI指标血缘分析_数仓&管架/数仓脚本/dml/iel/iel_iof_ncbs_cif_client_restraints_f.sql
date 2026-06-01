: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_cif_client_restraints_f
CreateDate: 20230804
FileName:   ${iel_data_path}/ncbs_cif_client_restraints.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.res_seq_no,chr(13),''),chr(10),'') as res_seq_no
,replace(replace(t1.restraint_type,chr(13),''),chr(10),'') as restraint_type
,replace(replace(t1.source_type,chr(13),''),chr(10),'') as source_type
,tran_date
,replace(replace(t1.tran_branch,chr(13),''),chr(10),'') as tran_branch
,replace(replace(t1.maintain_type,chr(13),''),chr(10),'') as maintain_type
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,start_date
,replace(replace(t1.term,chr(13),''),chr(10),'') as term
,replace(replace(t1.term_type,chr(13),''),chr(10),'') as term_type
,end_date
,replace(replace(t1.restraints_status,chr(13),''),chr(10),'') as restraints_status
,replace(replace(t1.narrative,chr(13),''),chr(10),'') as narrative
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.auth_user_id,chr(13),''),chr(10),'') as auth_user_id
,last_change_date
,replace(replace(t1.last_change_user_id,chr(13),''),chr(10),'') as last_change_user_id
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.sign_user_id,chr(13),''),chr(10),'') as sign_user_id
,replace(replace(t1.out_sign_user_id,chr(13),''),chr(10),'') as out_sign_user_id
,replace(replace(t1.sign_channel,chr(13),''),chr(10),'') as sign_channel
,replace(replace(t1.unlost_time,chr(13),''),chr(10),'') as unlost_time

from ${iol_schema}.ncbs_cif_client_restraints t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_cif_client_restraints.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
