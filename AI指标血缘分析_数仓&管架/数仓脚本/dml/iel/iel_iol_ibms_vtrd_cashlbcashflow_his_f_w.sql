: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_vtrd_cashlbcashflow_his_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_vtrd_cashlbcashflow_his_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t.paymentdate,chr(13),''),chr(10),'') as paymentdate
,t.amount as amount
,t.ai as ai
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.ibms_vtrd_cashlbcashflow_his t
where start_dt <= to_date('${batch_date}', 'yyyymmdd')
and end_Dt>to_date('${batch_date}', 'yyyymmdd')
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_vtrd_cashlbcashflow_his_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes