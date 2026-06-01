: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_uuss_uus_tellerno_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_uuss_uus_tellerno.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.attachorgan as attachorgan
,t1.tellerno as tellerno
,t1.tellerlevel as tellerlevel
,t1.organcode as organcode
,t1.status as status
,t1.userna as userna
,t1.ussatg as ussatg
,t1.lastlg as lastlg
,t1.lstrdt as lstrdt
,t1.usertp as usertp
,t1.menugp as menugp
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.employeeid as employeeid
,t1.tellermanagerid as tellermanagerid

from ${idl_schema}.oass_uuss_uus_tellerno t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_uuss_uus_tellerno.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
