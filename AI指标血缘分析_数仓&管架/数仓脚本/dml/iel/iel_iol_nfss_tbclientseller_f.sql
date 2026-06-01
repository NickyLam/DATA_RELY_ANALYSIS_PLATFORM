: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nfss_tbclientseller_f
CreateDate: 20250919
FileName:   ${iel_data_path}/nfss_tbclientseller.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.in_client_no,chr(13),''),chr(10),'') as in_client_no
,replace(replace(t1.bank_no,chr(13),''),chr(10),'') as bank_no
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.seller_code,chr(13),''),chr(10),'') as seller_code
,open_date
,close_date
,replace(replace(t1.ta_client,chr(13),''),chr(10),'') as ta_client
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.reserve1,chr(13),''),chr(10),'') as reserve1
,replace(replace(t1.reserve2,chr(13),''),chr(10),'') as reserve2

from ${iol_schema}.nfss_tbclientseller t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nfss_tbclientseller.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
