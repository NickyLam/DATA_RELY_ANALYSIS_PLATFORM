: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_cbondpricesrepo_f
CreateDate: 20240724
FileName:   ${iel_data_path}/wind_cbondpricesrepo.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
,replace(replace(t1.trade_dt,chr(13),''),chr(10),'') as trade_dt
,s_dq_open
,s_dq_high
,s_dq_low
,s_dq_close
,s_dq_avgprice
,s_dq_volume
,s_dq_amount
,opdate
,replace(replace(t1.opmode,chr(13),''),chr(10),'') as opmode

from ${iol_schema}.wind_cbondpricesrepo t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_cbondpricesrepo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
