: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_tir_series_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_tir_series_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(i_code,chr(10),''),chr(13),'') as i_code
,replace(replace(a_type,chr(10),''),chr(13),'') as a_type
,replace(replace(m_type,chr(10),''),chr(13),'') as m_type
,replace(replace(dp_close,chr(10),''),chr(13),'') as dp_close
,replace(replace(dp_high,chr(10),''),chr(13),'') as dp_high
,replace(replace(dp_low,chr(10),''),chr(13),'') as dp_low
,replace(replace(dp_ask,chr(10),''),chr(13),'') as dp_ask
,replace(replace(dp_bid,chr(10),''),chr(13),'') as dp_bid
,replace(replace(dp_mid,chr(10),''),chr(13),'') as dp_mid
,replace(replace(beg_date,chr(10),''),chr(13),'') as beg_date
,replace(replace(end_date,chr(10),''),chr(13),'') as end_date
,replace(replace(imp_date,chr(10),''),chr(13),'') as imp_date
,replace(replace(pipe_id,chr(10),''),chr(13),'') as pipe_id
,replace(replace(dp_bank,chr(10),''),chr(13),'') as dp_bank
,replace(replace(imp_time,chr(10),''),chr(13),'') as imp_time
,replace(replace(dp_id,chr(10),''),chr(13),'') as dp_id
,replace(replace(source_time,chr(10),''),chr(13),'') as source_time
,replace(replace(state,chr(10),''),chr(13),'') as state
,replace(replace(update_user,chr(10),''),chr(13),'') as update_user
,etl_dt
,etl_timestamp
from iol.ibms_tir_series 
where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_tir_series_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes