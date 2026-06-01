: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_isbs_gl059660_a
CreateDate: 20250609
FileName:   ${iel_data_path}/isbs_gl059660.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.inr,chr(13),''),chr(10),'') as inr
,replace(replace(t1.trninr,chr(13),''),chr(10),'') as trninr
,credattim
,replace(replace(t1.seq,chr(13),''),chr(10),'') as seq
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.acct_seq_no,chr(13),''),chr(10),'') as acct_seq_no
,replace(replace(t1.branch,chr(13),''),chr(10),'') as branch
,replace(replace(t1.tran_type,chr(13),''),chr(10),'') as tran_type
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,tran_amt
,replace(replace(t1.tran_branch,chr(13),''),chr(10),'') as tran_branch
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.system_id,chr(13),''),chr(10),'') as system_id
,replace(replace(t1.event_type,chr(13),''),chr(10),'') as event_type
,replace(replace(t1.amt_type,chr(13),''),chr(10),'') as amt_type
,replace(replace(t1.tran_date,chr(13),''),chr(10),'') as tran_date
,replace(replace(t1.write_off_seq_no,chr(13),''),chr(10),'') as write_off_seq_no
,replace(replace(t1.narrative,chr(13),''),chr(10),'') as narrative
,replace(replace(t1.is_northbound_sign,chr(13),''),chr(10),'') as is_northbound_sign

from ${iol_schema}.isbs_gl059660 t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/isbs_gl059660.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
