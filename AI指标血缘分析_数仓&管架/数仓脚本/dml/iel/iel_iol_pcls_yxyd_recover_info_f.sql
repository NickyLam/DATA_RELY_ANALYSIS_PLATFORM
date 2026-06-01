: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pcls_yxyd_recover_info_f
CreateDate: 20250709
FileName:   ${iel_data_path}/pcls_yxyd_recover_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.month_loan,chr(13),''),chr(10),'') as month_loan
,loan_amt
,m1_amt
,m2_amt
,m3_amt
,m3plus_amt
,m1_recover_amt
,m2_recover_amt
,m3_recover_amt
,m3plus_recover_amt
,m1_recover_percent
,m2_recover_percent
,m3_recover_percent
,m3plus_recover_percent

from ${iol_schema}.pcls_yxyd_recover_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pcls_yxyd_recover_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
