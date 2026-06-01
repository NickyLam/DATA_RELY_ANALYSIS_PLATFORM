: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icss_t_neg_list_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icss_t_neg_list.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t.negativetype,chr(13),''),chr(10),'') as negativetype
,replace(replace(t.inputtime,chr(13),''),chr(10),'') as inputtime
,replace(replace(t.outlisttime,chr(13),''),chr(10),'') as outlisttime
from ${iol_schema}.icss_t_neg_list t 
where t.etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icss_t_neg_list.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes