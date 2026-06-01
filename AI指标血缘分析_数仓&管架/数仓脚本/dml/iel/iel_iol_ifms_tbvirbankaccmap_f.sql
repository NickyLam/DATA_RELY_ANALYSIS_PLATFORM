: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ifms_tbvirbankaccmap_f
CreateDate: 20260318
FileName:   ${iel_data_path}/ifms_tbvirbankaccmap.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.vir_bank_acc,chr(13),''),chr(10),'') as vir_bank_acc
,replace(replace(t1.bank_no,chr(13),''),chr(10),'') as bank_no
,replace(replace(t1.bank_acc,chr(13),''),chr(10),'') as bank_acc
,replace(replace(t1.in_client_no,chr(13),''),chr(10),'') as in_client_no
,replace(replace(t1.open_branch,chr(13),''),chr(10),'') as open_branch
,open_date
,replace(replace(t1.channel,chr(13),''),chr(10),'') as channel
,replace(replace(t1.vir_type,chr(13),''),chr(10),'') as vir_type
,amt1
,amt2
,replace(replace(t1.reserve1,chr(13),''),chr(10),'') as reserve1
,replace(replace(t1.reserve2,chr(13),''),chr(10),'') as reserve2
,replace(replace(t1.reserve3,chr(13),''),chr(10),'') as reserve3

from ${iol_schema}.ifms_tbvirbankaccmap t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifms_tbvirbankaccmap.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
