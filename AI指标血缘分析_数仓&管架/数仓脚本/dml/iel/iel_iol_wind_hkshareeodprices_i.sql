: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_hkshareeodprices_i
CreateDate: 20230202
FileName:   ${iel_data_path}/wind_hkshareeodprices.i.${batch_date}.dat
IF_mark:    i
Logs:
       sundexin
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.object_id,chr(13),''),chr(10),'') as object_id
    ,replace(replace(t.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
    ,replace(replace(t.trade_dt,chr(13),''),chr(10),'') as trade_dt
    ,replace(replace(t.crncy_code,chr(13),''),chr(10),'') as crncy_code
    ,t.s_dq_open as s_dq_open
    ,t.s_dq_high as s_dq_high
    ,t.s_dq_low as s_dq_low
    ,t.s_dq_close as s_dq_close
    ,t.s_dq_volume as s_dq_volume
    ,t.s_dq_amount as s_dq_amount
    ,t.s_dq_preclose as s_dq_preclose
    ,t.s_dq_adjpreclose as s_dq_adjpreclose
    ,t.s_dq_adjopen as s_dq_adjopen
    ,t.s_dq_adjhigh as s_dq_adjhigh
    ,t.s_dq_adjlow as s_dq_adjlow
    ,t.s_dq_adjclose as s_dq_adjclose
    ,t.s_dq_adjfactor as s_dq_adjfactor
    ,t.s_dq_avgprice as s_dq_avgprice
    ,t.dividend_yield as dividend_yield
    ,t.s_dq_adjclose_backward as s_dq_adjclose_backward
    ,t.opdate as opdate
    ,replace(replace(t.opmode,chr(13),''),chr(10),'') as opmode
from iol.wind_hkshareeodprices t
where etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_hkshareeodprices.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes