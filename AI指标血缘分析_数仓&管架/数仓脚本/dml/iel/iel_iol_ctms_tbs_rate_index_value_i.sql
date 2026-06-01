: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_rate_index_value_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_rate_index_value.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.rate_index,chr(13),''),chr(10),'') as rate_index
,replace(replace(t1.rate_date,chr(13),''),chr(10),'') as rate_date
,t1.rate as rate
,replace(replace(t1.status_flag,chr(13),''),chr(10),'') as status_flag
,t1.modify_user as modify_user
from ${iol_schema}.ctms_tbs_rate_index_value t1
where replace(trim(t1.rate_date),'-') = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_rate_index_value.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes