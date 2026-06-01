: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_orws_temp_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_temp_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.id as id 
,replace(replace(t1.name,chr(13),''),chr(10),'') as name 
,replace(replace(t1.employee_no,chr(13),''),chr(10),'') as employee_no 
,t1.sex as sex 
,t1.folk as folk 
,replace(replace(t1.native_place,chr(13),''),chr(10),'') as native_place 
,t1.born_date as born_date 
,replace(replace(t1.address,chr(13),''),chr(10),'') as address 
,t1.edu_degree as edu_degree 
,t1.is_fulltime as is_fulltime 
,t1.employeement_type as employeement_type 
,replace(replace(t1.clerk_level,chr(13),''),chr(10),'') as clerk_level 
,t1.status as status 
,replace(replace(t1.mobile,chr(13),''),chr(10),'') as mobile 
,t1.organ_id as organ_id 
,replace(replace(t1.organ_name,chr(13),''),chr(10),'') as organ_name 
,replace(replace(t1.organ_number,chr(13),''),chr(10),'') as organ_number 
,t1.to_organ as to_organ 
,t1.to_group as to_group 
,t1.employee_id as employee_id 
,t1.become_date as become_date 
,t1.create_time as create_time 
,t1.update_time as update_time 
,t1.create_user_id as create_user_id 
,t1.update_user_id as update_user_id 
,replace(replace(t1.email,chr(13),''),chr(10),'') as email 
,replace(replace(t1.office_call,chr(13),''),chr(10),'') as office_call 
,replace(replace(t1.emp_no,chr(13),''),chr(10),'') as emp_no 
,t1.ismain as ismain 
,replace(replace(t1.belong_emp_no,chr(13),''),chr(10),'') as belong_emp_no 
,t1.external_status as external_status 
,replace(replace(t1.domainid,chr(13),''),chr(10),'') as domainid 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.orws_temp_info t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/orws_temp_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes