: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_lcps_t_legalaffairs_lawsuit_f
CreateDate: 20240822
FileName:   ${iel_data_path}/lcps_t_legalaffairs_lawsuit.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.involve_code,chr(13),''),chr(10),'') as involve_code
,replace(replace(t1.service_type,chr(13),''),chr(10),'') as service_type
,replace(replace(t1.handling_by,chr(13),''),chr(10),'') as handling_by
,replace(replace(t1.case_type,chr(13),''),chr(10),'') as case_type
,replace(replace(t1.indict_by,chr(13),''),chr(10),'') as indict_by
,replace(replace(t1.opposite_by,chr(13),''),chr(10),'') as opposite_by
,replace(replace(t1.brief,chr(13),''),chr(10),'') as brief
,replace(replace(t1.involve_amount,chr(13),''),chr(10),'') as involve_amount
,replace(replace(t1.judicial_code,chr(13),''),chr(10),'') as judicial_code
,file_date
,replace(replace(t1.case_stage,chr(13),''),chr(10),'') as case_stage
,replace(replace(t1.trial_result,chr(13),''),chr(10),'') as trial_result
,trial_date
,compulsion_date
,execute_date
,replace(replace(t1.execute_result,chr(13),''),chr(10),'') as execute_result
,end_date
,replace(replace(t1.verification,chr(13),''),chr(10),'') as verification
,replace(replace(t1.transfer,chr(13),''),chr(10),'') as transfer
,replace(replace(t1.entrust,chr(13),''),chr(10),'') as entrust
,replace(replace(t1.lawyer_code,chr(13),''),chr(10),'') as lawyer_code
,replace(replace(t1.lawsuit_amount,chr(13),''),chr(10),'') as lawsuit_amount
,replace(replace(t1.withdraw_amount,chr(13),''),chr(10),'') as withdraw_amount
,replace(replace(t1.case_typ,chr(13),''),chr(10),'') as case_typ
,replace(replace(t1.trial_status,chr(13),''),chr(10),'') as trial_status
,replace(replace(t1.case_name,chr(13),''),chr(10),'') as case_name
,replace(replace(t1.case_num,chr(13),''),chr(10),'') as case_num
,replace(replace(t1.case_no,chr(13),''),chr(10),'') as case_no
,replace(replace(t1.case_code,chr(13),''),chr(10),'') as case_code
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.create_by,chr(13),''),chr(10),'') as create_by
,create_date
,replace(replace(t1.update_by,chr(13),''),chr(10),'') as update_by
,update_date
,replace(replace(t1.remarks,chr(13),''),chr(10),'') as remarks
,replace(replace(t1.corp_code,chr(13),''),chr(10),'') as corp_code
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name

from ${iol_schema}.lcps_t_legalaffairs_lawsuit t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/lcps_t_legalaffairs_lawsuit.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
