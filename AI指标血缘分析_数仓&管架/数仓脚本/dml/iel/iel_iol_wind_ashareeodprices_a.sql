: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_ashareeodprices_a
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_ashareeodprices.i.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.object_id,chr(13),''),chr(10),'') as object_id
    ,replace(replace(t.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
    ,replace(replace(t.trade_dt,chr(13),''),chr(10),'') as trade_dt
    ,replace(replace(t.crncy_code,chr(13),''),chr(10),'') as crncy_code
    ,t.s_dq_preclose as s_dq_preclose
    ,t.s_dq_open as s_dq_open
    ,t.s_dq_high as s_dq_high
    ,t.s_dq_low as s_dq_low
    ,t.s_dq_close as s_dq_close
    ,t.s_dq_change as s_dq_change
    ,t.s_dq_pctchange as s_dq_pctchange
    ,t.s_dq_volume as s_dq_volume
    ,t.s_dq_amount as s_dq_amount
    ,t.s_dq_adjpreclose as s_dq_adjpreclose
    ,t.s_dq_adjopen as s_dq_adjopen
    ,t.s_dq_adjhigh as s_dq_adjhigh
    ,t.s_dq_adjlow as s_dq_adjlow
    ,t.s_dq_adjclose as s_dq_adjclose
    ,t.s_dq_adjfactor as s_dq_adjfactor
    ,t.s_dq_avgprice as s_dq_avgprice
    ,replace(replace(t.s_dq_tradestatus,chr(13),''),chr(10),'') as s_dq_tradestatus
from iol.wind_ashareeodprices t
  where t.trade_dt >= '20200701' and t.trade_dt <= '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_ashareeodprices.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes