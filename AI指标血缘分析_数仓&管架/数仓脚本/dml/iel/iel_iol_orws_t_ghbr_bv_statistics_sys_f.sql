: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_orws_t_ghbr_bv_statistics_sys_f
CreateDate: 20240101
FileName:   ${iel_data_path}/orws_t_ghbr_bv_statistics_sys.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,statistics_id
,replace(replace(t1.sys_name,chr(13),''),chr(10),'') as sys_name
,id
,sys_weight_txnvol
,sys_txnvol

from ${iol_schema}.orws_t_ghbr_bv_statistics_sys t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/orws_t_ghbr_bv_statistics_sys.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
