: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pcls_byte_zd_sx_info_f
CreateDate: 20250709
FileName:   ${iel_data_path}/pcls_byte_zd_sx_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,appl_dt
,appl_cnt
,appl_pass_cnt
,appl_pass_percent
,credit_amount
,credit_amount_avg
,rate

from ${iol_schema}.pcls_byte_zd_sx_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pcls_byte_zd_sx_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
