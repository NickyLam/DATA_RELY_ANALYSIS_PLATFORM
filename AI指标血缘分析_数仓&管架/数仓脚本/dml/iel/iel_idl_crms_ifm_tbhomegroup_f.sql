: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_ifm_tbhomegroup_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_ifm_tbhomegroup_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
home_id
,bank_acc
,client_no
,client_name
,id_type
,id_code
,mobile
,open_branch
,status
,reserve1
,reserve2
from ${idl_schema}.crms_ifm_tbhomegroup
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_ifm_tbhomegroup_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes