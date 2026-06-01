: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_rate_index_value_a
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_rate_index_value.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select rate_index,rate_date,rate,status_flag,modify_user from ${iol_schema}.ctms_tbs_rate_index_value where etl_dt < to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_rate_index_value.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes