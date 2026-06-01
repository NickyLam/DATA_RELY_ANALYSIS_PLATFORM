: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_batch_dig_factor_i
CreateDate: 20241230
FileName:   ${iel_data_path}/cqss_i_r_batch_dig_factor.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tsk_seq_no
,inf_rcrd_idr_no
,replace(replace(t1.aft_rmrk,chr(13),''),chr(10),'') as aft_rmrk
,crt_dt_tm

from ${iol_schema}.cqss_i_r_batch_dig_factor t1
where to_char(crt_dt_tm,'yyyymmdd') = '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_batch_dig_factor.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
