: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amis_ac_account_project_f
CreateDate: 20180529
FileName:   ${iel_data_path}/amis_ac_account_project.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.ac_account_project_uuid,chr(13),''),chr(10),'') as ac_account_project_uuid
    ,replace(replace(t.account_type_code,chr(13),''),chr(10),'') as account_type_code
    ,replace(replace(t.account_type_desc,chr(13),''),chr(10),'') as account_type_desc
    ,replace(replace(t.project_name,chr(13),''),chr(10),'') as project_name
    ,replace(replace(t.acc_project_code,chr(13),''),chr(10),'') as acc_project_code
    ,replace(replace(t.account_item,chr(13),''),chr(10),'') as account_item
    ,replace(replace(t.description,chr(13),''),chr(10),'') as description
    ,t.loss_amount as loss_amount
    ,replace(replace(t.remarks,chr(13),''),chr(10),'') as remarks
    ,replace(replace(t.account_imp_dept,chr(13),''),chr(10),'') as account_imp_dept
    ,replace(replace(t.create_person_uuid,chr(13),''),chr(10),'') as create_person_uuid
    ,replace(replace(t.create_person_name,chr(13),''),chr(10),'') as create_person_name
    ,replace(replace(t.create_org_name,chr(13),''),chr(10),'') as create_org_name
    ,t.create_time as create_time
    ,replace(replace(t.create_org_uuid,chr(13),''),chr(10),'') as create_org_uuid
    ,replace(replace(t.create_dept,chr(13),''),chr(10),'') as create_dept
    ,replace(replace(t.create_dept_uuid,chr(13),''),chr(10),'') as create_dept_uuid
    ,t.state as state
    ,t.current_node as current_node
    ,t.deleted as deleted
    ,replace(replace(t.ext1,chr(13),''),chr(10),'') as ext1
    ,replace(replace(t.ext2,chr(13),''),chr(10),'') as ext2
    ,replace(replace(t.ext3,chr(13),''),chr(10),'') as ext3
    ,replace(replace(t.client_code,chr(13),''),chr(10),'') as client_code
    ,replace(replace(t.client_desc,chr(13),''),chr(10),'') as client_desc
    ,t.client_date as client_date
    ,t.project_state as project_state
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.amis_ac_account_project t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amis_ac_account_project.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes