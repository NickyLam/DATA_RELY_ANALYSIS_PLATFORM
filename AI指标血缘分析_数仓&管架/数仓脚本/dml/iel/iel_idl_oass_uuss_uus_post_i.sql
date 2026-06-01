: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_uuss_uus_post_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_uuss_uus_post.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.postname as postname
,t1.isbasepost as isbasepost
,t1.linecode as linecode
,t1.serialcode as serialcode
,t1.type as type
,t1.enablestate as enablestate
,t1.placecode as placecode
,t1.currdate as currdate
,t1.currtime as currtime
,t1.updatedate as updatedate
,t1.updatetime as updatetime
,t1.createuser as createuser
,t1.updateuser as updateuser
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.postcode as postcode
,t1.organcode as organcode

from ${idl_schema}.oass_uuss_uus_post t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_uuss_uus_post.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
