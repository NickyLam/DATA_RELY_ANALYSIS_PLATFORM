: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_itsm_tbl_itsm_to_orm_case_f
CreateDate: 20240822
FileName:   ${iel_data_path}/itsm_tbl_itsm_to_orm_case.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.business_key,chr(13),''),chr(10),'') as business_key
,case_real_happen
,replace(replace(t1.topicname,chr(13),''),chr(10),'') as topicname
,replace(replace(t1.detail,chr(13),''),chr(10),'') as detail
,replace(replace(t1.reason_ana,chr(13),''),chr(10),'') as reason_ana
,replace(replace(t1.scope_influence,chr(13),''),chr(10),'') as scope_influence
,replace(replace(t1.emergency_solution,chr(13),''),chr(10),'') as emergency_solution
,replace(replace(t1.the_end_rank,chr(13),''),chr(10),'') as the_end_rank
,fault_time

from ${iol_schema}.itsm_tbl_itsm_to_orm_case t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/itsm_tbl_itsm_to_orm_case.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
