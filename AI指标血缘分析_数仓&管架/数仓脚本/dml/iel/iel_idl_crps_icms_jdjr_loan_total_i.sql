: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crps_icms_jdjr_loan_total_i
CreateDate: 20230608
FileName:   ${iel_data_path}/crps_icms_jdjr_loan_total.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.jzno as jzno
,t1.jzamt as jzamt

from ${idl_schema}.crps_icms_jdjr_loan_total t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crps_icms_jdjr_loan_total.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
