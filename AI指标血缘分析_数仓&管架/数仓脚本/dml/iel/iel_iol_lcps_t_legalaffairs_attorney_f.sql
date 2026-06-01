: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_lcps_t_legalaffairs_attorney_f
CreateDate: 20240822
FileName:   ${iel_data_path}/lcps_t_legalaffairs_attorney.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.office_code,chr(13),''),chr(10),'') as office_code
,replace(replace(t1.agency,chr(13),''),chr(10),'') as agency
,replace(replace(t1.matters,chr(13),''),chr(10),'') as matters
,replace(replace(t1.firm_name,chr(13),''),chr(10),'') as firm_name
,replace(replace(t1.lawyer_name,chr(13),''),chr(10),'') as lawyer_name
,replace(replace(t1.attorney_code,chr(13),''),chr(10),'') as attorney_code
,replace(replace(t1.case_code,chr(13),''),chr(10),'') as case_code
,replace(replace(t1.case_name,chr(13),''),chr(10),'') as case_name
,signing_date
,start_time
,end_time
,replace(replace(t1.authorization_range,chr(13),''),chr(10),'') as authorization_range
,replace(replace(t1.litigation_amount,chr(13),''),chr(10),'') as litigation_amount
,replace(replace(t1.entrusted_amount,chr(13),''),chr(10),'') as entrusted_amount
,replace(replace(t1.risk_agency,chr(13),''),chr(10),'') as risk_agency
,replace(replace(t1.legal_service,chr(13),''),chr(10),'') as legal_service
,replace(replace(t1.asset_claim,chr(13),''),chr(10),'') as asset_claim
,replace(replace(t1.progress,chr(13),''),chr(10),'') as progress
,replace(replace(t1.agency_results,chr(13),''),chr(10),'') as agency_results
,replace(replace(t1.actual_payment_amount,chr(13),''),chr(10),'') as actual_payment_amount
,replace(replace(t1.end_delegation,chr(13),''),chr(10),'') as end_delegation
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.create_by,chr(13),''),chr(10),'') as create_by
,create_date
,replace(replace(t1.update_by,chr(13),''),chr(10),'') as update_by
,update_date
,replace(replace(t1.remarks,chr(13),''),chr(10),'') as remarks
,replace(replace(t1.corp_code,chr(13),''),chr(10),'') as corp_code
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name

from ${iol_schema}.lcps_t_legalaffairs_attorney t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/lcps_t_legalaffairs_attorney.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
