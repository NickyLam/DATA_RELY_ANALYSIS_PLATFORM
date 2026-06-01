: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nfss_ca_risk_record_f
CreateDate: 20260123
FileName:   ${iel_data_path}/nfss_ca_risk_record.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.customer_no,chr(13),''),chr(10),'') as customer_no
,replace(replace(t1.customer_name,chr(13),''),chr(10),'') as customer_name
,replace(replace(t1.client_type,chr(13),''),chr(10),'') as client_type
,replace(replace(t1.txn_org_cd,chr(13),''),chr(10),'') as txn_org_cd
,replace(replace(t1.phone,chr(13),''),chr(10),'') as phone
,replace(replace(t1.id_type,chr(13),''),chr(10),'') as id_type
,replace(replace(t1.id_code,chr(13),''),chr(10),'') as id_code
,replace(replace(t1.paper_id,chr(13),''),chr(10),'') as paper_id
,score
,replace(replace(t1.risk_level,chr(13),''),chr(10),'') as risk_level
,replace(replace(t1.risk_time,chr(13),''),chr(10),'') as risk_time
,replace(replace(t1.channel,chr(13),''),chr(10),'') as channel
,effective_date
,replace(replace(t1.blip_platf_file_id,chr(13),''),chr(10),'') as blip_platf_file_id
,replace(replace(t1.risk_months,chr(13),''),chr(10),'') as risk_months

from ${iol_schema}.nfss_ca_risk_record t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nfss_ca_risk_record.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
