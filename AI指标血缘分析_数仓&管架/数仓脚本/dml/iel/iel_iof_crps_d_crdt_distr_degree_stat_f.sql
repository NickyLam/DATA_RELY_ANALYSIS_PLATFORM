: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_crps_d_crdt_distr_degree_stat_f
CreateDate: 20251013
FileName:   ${iel_data_path}/crps_d_crdt_distr_degree_stat.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,etl_dt_ora
,replace(replace(t1.belong_brch_id,chr(13),''),chr(10),'') as belong_brch_id
,replace(replace(t1.belong_brch_name,chr(13),''),chr(10),'') as belong_brch_name
,less_or_equal_250_bilon
,full_amt
,decrs_part
,decrs_full_amt
,less_or_equal_250_bilon_pct
,replace(replace(t1.curr_id,chr(13),''),chr(10),'') as curr_id
,replace(replace(t1.curr_name,chr(13),''),chr(10),'') as curr_name
,etl_timestamp_ora

from ${iol_schema}.crps_d_crdt_distr_degree_stat t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crps_d_crdt_distr_degree_stat.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
