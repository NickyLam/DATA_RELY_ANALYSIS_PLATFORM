: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icms_tk_management_info_f
CreateDate: 20241126
FileName:   ${iel_data_path}/icms_tk_management_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.serialno as serialno
,t1.batchdate as batchdate
,t1.userid as userid
,t1.userdomainid as userdomainid
,t1.customerid as customerid
,t1.customername as customername
,t1.inputdate as inputdate

from ${idl_schema}.icms_tk_management_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_tk_management_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
