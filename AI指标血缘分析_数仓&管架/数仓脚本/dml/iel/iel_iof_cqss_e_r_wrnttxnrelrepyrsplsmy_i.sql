: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_cqss_e_r_wrnttxnrelrepyrsplsmy_i
CreateDate: 20250703
FileName:   ${iel_data_path}/cqss_e_r_wrnttxnrelrepyrsplsmy.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t1.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,replace(replace(t1.rel_repy_rspl_tp,chr(13),''),chr(10),'') as rel_repy_rspl_tp
,repy_rspl_qot
,acc_num
,bal
,fcs_cgy_bal
,bad_cgy_bal
,crt_dt_tm

from ${iol_schema}.cqss_e_r_wrnttxnrelrepyrsplsmy t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_wrnttxnrelrepyrsplsmy.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
