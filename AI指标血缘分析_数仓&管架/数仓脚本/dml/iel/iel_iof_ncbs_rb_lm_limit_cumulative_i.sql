: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_rb_lm_limit_cumulative_i
CreateDate: 20231031
FileName:   ${iel_data_path}/ncbs_rb_lm_limit_cumulative.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.total_key,chr(13),''),chr(10),'') as total_key
,internal_key
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.cr_dr_ind,chr(13),''),chr(10),'') as cr_dr_ind
,limit_amt
,limit_num
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,last_change_date
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.seq_no,chr(13),''),chr(10),'') as seq_no

from ${iol_schema}.ncbs_rb_lm_limit_cumulative t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_lm_limit_cumulative.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
