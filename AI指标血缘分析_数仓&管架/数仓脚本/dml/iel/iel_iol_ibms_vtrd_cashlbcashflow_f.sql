: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_vtrd_cashlbcashflow_f
CreateDate: 20221013
FileName:   ${iel_data_path}/ibms_vtrd_cashlbcashflow.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t1.paymentdate,chr(13),''),chr(10),'') as paymentdate
,t1.amount as amount
,t1.ai as ai

from ${iol_schema}.ibms_vtrd_cashlbcashflow t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_vtrd_cashlbcashflow.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
