: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_sumbit_order_employee_f
CreateDate: 20240627
FileName:   ${iel_data_path}/ibms_sumbit_order_employee.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.assetno,chr(13),''),chr(10),'') as assetno
,replace(replace(t1.createdate,chr(13),''),chr(10),'') as createdate
,replace(replace(t1.employee_card_no,chr(13),''),chr(10),'') as employee_card_no
,replace(replace(t1.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t1.employee_card_no2,chr(13),''),chr(10),'') as employee_card_no2

from ${iol_schema}.ibms_sumbit_order_employee t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_sumbit_order_employee.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
