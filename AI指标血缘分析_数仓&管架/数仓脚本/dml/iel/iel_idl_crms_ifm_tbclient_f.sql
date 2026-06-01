: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_ifm_tbclient_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_ifm_tbclient_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
in_client_no
,client_type
,client_group
,id_type
,id_code
,short_name
,client_name
,address
,post_code
,tel
,fax
,mobile
,email
,sex
,send_freq
,send_mode
,risk_level
,risk_date
,birthday
,id_code_date
,education
,income
,vocation
,nationality
,channels
,prd_types
,client_manager
,open_branch
,status
,modi_date
,modi_time
,modify_info
,reserve1
,reserve2
,reserve3
,reserve4
from ${idl_schema}.crms_ifm_tbclient
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_ifm_tbclient_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes