: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_temp_wyd_loan_relative_rep_three_f
CreateDate: 20251112
FileName:   ${iel_data_path}/icms_temp_wyd_loan_relative_rep_three.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.loanno,chr(13),''),chr(10),'') as loanno
,replace(replace(t1.relativeloanno,chr(13),''),chr(10),'') as relativeloanno
,replace(replace(t1.businesstype,chr(13),''),chr(10),'') as businesstype

from ${iol_schema}.icms_temp_wyd_loan_relative_rep_three t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_temp_wyd_loan_relative_rep_three.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
