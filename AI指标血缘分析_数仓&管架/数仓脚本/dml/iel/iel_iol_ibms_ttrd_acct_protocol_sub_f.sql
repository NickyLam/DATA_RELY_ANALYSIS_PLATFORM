: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_acct_protocol_sub_f
CreateDate: 20240805
FileName:   ${iel_data_path}/ibms_ttrd_acct_protocol_sub.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.masterid,chr(13),''),chr(10),'') as masterid
,replace(replace(t1.start_date,chr(13),''),chr(10),'') as start_date
,replace(replace(t1.end_date,chr(13),''),chr(10),'') as end_date
,amount_rate
,current_rate
,replace(replace(t1.sub_contract_no,chr(13),''),chr(10),'') as sub_contract_no
,usable_flag
,replace(replace(t1.operate,chr(13),''),chr(10),'') as operate

from ${iol_schema}.ibms_ttrd_acct_protocol_sub t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_acct_protocol_sub.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
