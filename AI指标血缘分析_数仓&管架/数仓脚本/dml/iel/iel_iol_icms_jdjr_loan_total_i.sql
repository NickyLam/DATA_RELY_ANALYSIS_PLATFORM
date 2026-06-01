: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_jdjr_loan_total_i
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_jdjr_loan_total.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.jzno,chr(13),''),chr(10),'') as jzno
,replace(replace(t1.jzamt,chr(13),''),chr(10),'') as jzamt
from ${iol_schema}.icms_jdjr_loan_total t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_jdjr_loan_total.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes