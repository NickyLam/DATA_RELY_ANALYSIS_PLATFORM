: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_cbondcurvecnbd_i
CreateDate: 20240903
FileName:   ${iel_data_path}/wind_cbondcurvecnbd.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.trade_dt,chr(13),''),chr(10),'') as trade_dt
,b_anal_curvenumber
,replace(replace(t1.b_anal_curvename,chr(13),''),chr(10),'') as b_anal_curvename
,replace(replace(t1.b_anal_curvetype,chr(13),''),chr(10),'') as b_anal_curvetype
,b_anal_curveterm
,b_anal_yield
,b_anal_base_yield
,b_anal_yield_total

from ${iol_schema}.wind_cbondcurvecnbd t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_cbondcurvecnbd.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
