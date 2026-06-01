: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_wind_asharecompanyholdshares_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_wind_asharecompanyholdshares.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t1.enddate,chr(13),''),chr(10),'') as enddate
,replace(replace(t1.s_capitaloperation_companyname,chr(13),''),chr(10),'') as s_capitaloperation_companyname
,replace(replace(t1.s_capitaloperation_companyid,chr(13),''),chr(10),'') as s_capitaloperation_companyid
,replace(replace(t1.s_capitaloperation_comainbus,chr(13),''),chr(10),'') as s_capitaloperation_comainbus
,replace(replace(t1.relations_code,chr(13),''),chr(10),'') as relations_code
,t1.s_capitaloperation_pct as s_capitaloperation_pct
,t1.voting_rights as voting_rights
,t1.s_capitaloperation_amount as s_capitaloperation_amount
,replace(replace(t1.operationcrncy_code,chr(13),''),chr(10),'') as operationcrncy_code
,t1.s_capitaloperation_coregcap as s_capitaloperation_coregcap
,replace(replace(t1.capitalcrncy_code,chr(13),''),chr(10),'') as capitalcrncy_code
,t1.is_consolidate as is_consolidate
,replace(replace(t1.notconsolidate_reason,chr(13),''),chr(10),'') as notconsolidate_reason
,to_date('${batch_date}','yyyymmdd') as opdate
,'' as opmode
from ${iol_schema}.wind_asharecompanyholdshares t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_wind_asharecompanyholdshares.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes