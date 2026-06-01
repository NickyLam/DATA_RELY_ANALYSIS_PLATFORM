: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nfss_ca_risk_record_item_f
CreateDate: 20260123
FileName:   ${iel_data_path}/nfss_ca_risk_record_item.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.risk_record_id,chr(13),''),chr(10),'') as risk_record_id
,replace(replace(t1.paper_id,chr(13),''),chr(10),'') as paper_id
,replace(replace(t1.question_id,chr(13),''),chr(10),'') as question_id
,replace(replace(t1.paper_no,chr(13),''),chr(10),'') as paper_no
,replace(replace(t1.version,chr(13),''),chr(10),'') as version
,replace(replace(t1.question_no,chr(13),''),chr(10),'') as question_no
,replace(replace(t1.question_type,chr(13),''),chr(10),'') as question_type
,replace(replace(t1.risk_option,chr(13),''),chr(10),'') as risk_option
,replace(replace(t1.question,chr(13),''),chr(10),'') as question
,replace(replace(t1.subject,chr(13),''),chr(10),'') as subject
,score
,replace(replace(t1.mut_risk_option,chr(13),''),chr(10),'') as mut_risk_option

from ${iol_schema}.nfss_ca_risk_record_item t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nfss_ca_risk_record_item.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
