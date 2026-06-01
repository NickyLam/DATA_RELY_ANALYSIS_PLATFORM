: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_tbinstinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_tbinstinfo_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
in_client_no
,inst_type
,repr_name
,repr_id_type
,repr_id_code
,actor_name
,actor_id_type
,actor_id_code
,link_name
,link_id_type
,link_id_code
,reserve1
from ${idl_schema}.odss_tbinstinfo
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_tbinstinfo_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes