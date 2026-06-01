: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_tir_series_f
CreateDate: 20221013
FileName:   ${iel_data_path}/ibms_tir_series.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.i_code,chr(13),''),chr(10),'') as i_code
,replace(replace(t1.a_type,chr(13),''),chr(10),'') as a_type
,replace(replace(t1.m_type,chr(13),''),chr(10),'') as m_type
,t1.dp_close as dp_close
,t1.dp_high as dp_high
,t1.dp_low as dp_low
,t1.dp_ask as dp_ask
,t1.dp_bid as dp_bid
,t1.dp_mid as dp_mid
,replace(replace(t1.beg_date,chr(13),''),chr(10),'') as beg_date
,replace(replace(t1.end_date,chr(13),''),chr(10),'') as end_date
,replace(replace(t1.imp_date,chr(13),''),chr(10),'') as imp_date
,t1.pipe_id as pipe_id
,replace(replace(t1.dp_bank,chr(13),''),chr(10),'') as dp_bank
,replace(replace(t1.imp_time,chr(13),''),chr(10),'') as imp_time
,t1.dp_id as dp_id
,replace(replace(t1.source_time,chr(13),''),chr(10),'') as source_time
,replace(replace(t1.state,chr(13),''),chr(10),'') as state
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user

from ${iol_schema}.ibms_tir_series t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_tir_series.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
