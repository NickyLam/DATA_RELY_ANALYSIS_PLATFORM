: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pcls_yxyd_loan_collect_f
CreateDate: 20250709
FileName:   ${iel_data_path}/pcls_yxyd_loan_collect.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.month_due,chr(13),''),chr(10),'') as month_due
,prin_amt
,prin_cnt
,dpd1_amt
,dpd4_amt
,dpd8_amt
,dpd1_cnt
,dpd4_cnt
,dpd8_cnt
,delinquency_rate
,delinquency_3_rate
,delinquency_7_rate

from ${iol_schema}.pcls_yxyd_loan_collect t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pcls_yxyd_loan_collect.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
