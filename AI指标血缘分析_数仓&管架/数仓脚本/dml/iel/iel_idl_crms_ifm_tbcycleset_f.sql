: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_ifm_tbcycleset_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_ifm_tbcycleset_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
prd_code
,cycle_date
,deal_status
,deal_date
,all_income
,froze_income
,all_fee
,manage_fee
,reserve1
,reserve2
,reserve3
from ${idl_schema}.crms_ifm_tbcycleset
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_ifm_tbcycleset_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes