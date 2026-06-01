: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_batch_dig_factor_a
CreateDate: 20241107
FileName:   ${iel_data_path}/cqss_i_r_batch_dig_factor.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,tsk_seq_no
,inf_rcrd_idr_no
,aft_rmrk
,crt_dt_tm

from ${iol_schema}.cqss_i_r_batch_dig_factor t1
where to_char(crt_dt_tm,'yyyymmdd') <= '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_batch_dig_factor.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
