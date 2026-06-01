: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pcls_yxyd_dz_info_f
CreateDate: 20250709
FileName:   ${iel_data_path}/pcls_yxyd_dz_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,draw_dt
,draw_cnt
,draw_pass_cnt
,draw_pass_percent
,draw_amt
,draw_amt_avg
,bal

from ${iol_schema}.pcls_yxyd_dz_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pcls_yxyd_dz_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
