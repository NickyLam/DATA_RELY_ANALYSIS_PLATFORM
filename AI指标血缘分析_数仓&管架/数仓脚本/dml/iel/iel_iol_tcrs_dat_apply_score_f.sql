: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tcrs_dat_apply_score_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tcrs_dat_apply_score.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.seq_id,chr(13),''),chr(10),'') as seq_id
,replace(replace(t.src_seq,chr(13),''),chr(10),'') as src_seq
,replace(replace(t.score,chr(13),''),chr(10),'') as score
,replace(replace(t.cust_code,chr(13),''),chr(10),'') as cust_code
,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t.event_code,chr(13),''),chr(10),'') as event_code
,replace(replace(t.amount,chr(13),''),chr(10),'') as amount
,replace(replace(t.loan_type,chr(13),''),chr(10),'') as loan_type
,replace(replace(t.identity_no,chr(13),''),chr(10),'') as identity_no
,replace(replace(t.src_time,chr(13),''),chr(10),'') as src_time
,replace(replace(t.channel_code,chr(13),''),chr(10),'') as channel_code
,t.ctime as ctime
,t.mtime as mtime
,t.version as version
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.tcrs_dat_apply_score t
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tcrs_dat_apply_score.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes