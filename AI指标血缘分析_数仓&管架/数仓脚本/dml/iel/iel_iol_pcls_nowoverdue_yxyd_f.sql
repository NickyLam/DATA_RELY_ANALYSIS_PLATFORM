: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pcls_nowoverdue_yxyd_f
CreateDate: 20250709
FileName:   ${iel_data_path}/pcls_nowoverdue_yxyd.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.datecreated,chr(13),''),chr(10),'') as datecreated
,loan_bal
,loan_cnt
,dpd3plus_cnt
,dpd3plus_amt
,dpd3plus_amt_percent
,dpd7plus_cnt
,dpd7plus_amt
,dpd7plus_amt_percent
,dpd30plus_cnt
,dpd30plus_amt
,dpd30plus_amt_percent
,dpd90plus_cnt
,dpd90plus_amt
,dpd90plus_amt_percent

from ${iol_schema}.pcls_nowoverdue_yxyd t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pcls_nowoverdue_yxyd.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
