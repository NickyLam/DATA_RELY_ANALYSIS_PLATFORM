: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_rb_gain_sin_card_info_f
CreateDate: 20250808
FileName:   ${iel_data_path}/ncbs_rb_gain_sin_card_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.gain_type,chr(13),''),chr(10),'') as gain_type
,replace(replace(t1.make_card_type,chr(13),''),chr(10),'') as make_card_type
,replace(replace(t1.seq_no,chr(13),''),chr(10),'') as seq_no
,tran_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.tran_branch,chr(13),''),chr(10),'') as tran_branch
,replace(replace(t1.gain_status,chr(13),''),chr(10),'') as gain_status
,replace(replace(t1.med_ins_card_no,chr(13),''),chr(10),'') as med_ins_card_no
,replace(replace(t1.sin_card_no,chr(13),''),chr(10),'') as sin_card_no
,in_date

from ${iol_schema}.ncbs_rb_gain_sin_card_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_gain_sin_card_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
