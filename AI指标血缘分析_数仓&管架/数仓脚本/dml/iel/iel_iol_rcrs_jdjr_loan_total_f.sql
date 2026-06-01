: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_jdjr_loan_total_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_jdjr_loan_total.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.jz_no,chr(13),''),chr(10),'') as jz_no 
,replace(replace(t1.jz_amt,chr(13),''),chr(10),'') as jz_amt 
from ${iol_schema}.rcrs_jdjr_loan_total t1 
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_jdjr_loan_total.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes