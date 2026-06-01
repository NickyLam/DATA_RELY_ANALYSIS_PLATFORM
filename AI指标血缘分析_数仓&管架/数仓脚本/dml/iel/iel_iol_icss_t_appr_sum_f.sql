: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icss_t_appr_sum_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icss_t_appr_sum.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t.customername,chr(13),''),chr(10),'') as customername
,t.lmttotalamt as lmttotalamt
,t.lmtusedamt as lmtusedamt
,t.lmttotalck as lmttotalck
,t.lmtusedck as lmtusedck
from ${iol_schema}.icss_t_appr_sum t
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icss_t_appr_sum.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes