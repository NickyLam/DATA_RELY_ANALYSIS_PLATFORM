: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_tbnd_notional_f
CreateDate: 20221013
FileName:   ${iel_data_path}/ibms_tbnd_notional.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.d_code,chr(13),''),chr(10),'') as d_code
,replace(replace(t1.i_code,chr(13),''),chr(10),'') as i_code
,replace(replace(t1.a_type,chr(13),''),chr(10),'') as a_type
,replace(replace(t1.m_type,chr(13),''),chr(10),'') as m_type
,replace(replace(t1.b_exec_date,chr(13),''),chr(10),'') as b_exec_date
,t1.b_notional as b_notional
,t1.pipe_id as pipe_id
,replace(replace(t1.imp_date,chr(13),''),chr(10),'') as imp_date
,replace(replace(t1.imp_time,chr(13),''),chr(10),'') as imp_time

from ${iol_schema}.ibms_tbnd_notional t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_tbnd_notional.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
