: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_noas_oa_regime_f
CreateDate: 20180529
FileName:   ${iel_data_path}/noas_oa_regime.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.regime_id,chr(13),''),chr(10),'') as regime_id
,replace(replace(t.flow_type_id,chr(13),''),chr(10),'') as flow_type_id
,replace(replace(t.regime_name,chr(13),''),chr(10),'') as regime_name
,replace(replace(t.data_type,chr(13),''),chr(10),'') as data_type
,replace(replace(t.character_num,chr(13),''),chr(10),'') as character_num
,replace(replace(t.version_num,chr(13),''),chr(10),'') as version_num
,replace(replace(t.regime_type,chr(13),''),chr(10),'') as regime_type
,replace(replace(t.attachment_id,chr(13),''),chr(10),'') as attachment_id
,t.formulate_date as formulate_date
,replace(replace(t.validity_date,chr(13),''),chr(10),'') as validity_date
,replace(replace(t.regime_status,chr(13),''),chr(10),'') as regime_status
,replace(replace(t.formulate_dept,chr(13),''),chr(10),'') as formulate_dept
,replace(replace(t.release_person,chr(13),''),chr(10),'') as release_person
,replace(replace(t.release_dept,chr(13),''),chr(10),'') as release_dept
,replace(replace(t.release_status,chr(13),''),chr(10),'') as release_status
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t.detail,chr(13),''),chr(10),'') as detail
,replace(replace(t.allow_reader,chr(13),''),chr(10),'') as allow_reader
,t.release_date as release_date
,t.last_updated_stamp as last_updated_stamp
,t.last_updated_tx_stamp as last_updated_tx_stamp
,t.created_stamp as created_stamp
,t.created_tx_stamp as created_tx_stamp
,replace(replace(t.process_ins_id,chr(13),''),chr(10),'') as process_ins_id
,replace(replace(t.useful_time,chr(13),''),chr(10),'') as useful_time
,replace(replace(t.sign_leader,chr(13),''),chr(10),'') as sign_leader
,replace(replace(t.writter,chr(13),''),chr(10),'') as writter
,t.abolish_date as abolish_date
,replace(replace(t.business_dimension,chr(13),''),chr(10),'') as business_dimension
,replace(replace(t.abolish_person,chr(13),''),chr(10),'') as abolish_person
,replace(replace(t.security_level,chr(13),''),chr(10),'') as security_level
,replace(replace(t.abolish_type,chr(13),''),chr(10),'') as abolish_type
,t.abolish_oper_time as abolish_oper_time
,replace(replace(t.abolish_source,chr(13),''),chr(10),'') as abolish_source
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.noas_oa_regime t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/noas_oa_regime.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes