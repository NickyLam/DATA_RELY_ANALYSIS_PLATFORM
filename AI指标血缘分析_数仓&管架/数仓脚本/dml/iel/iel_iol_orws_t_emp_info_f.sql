: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_orws_t_emp_info_f
CreateDate: 20240101
FileName:   ${iel_data_path}/orws_t_emp_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,id
,employeeinfo
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,sex
,born_date
,replace(replace(t1.marriage,chr(13),''),chr(10),'') as marriage
,replace(replace(t1.office_call,chr(13),''),chr(10),'') as office_call
,replace(replace(t1.mobile,chr(13),''),chr(10),'') as mobile
,isservice
,to_organ
,replace(replace(t1.emp_no,chr(13),''),chr(10),'') as emp_no
,replace(replace(t1.teller_no,chr(13),''),chr(10),'') as teller_no
,job_date
,become_date
,emptype
,status
,dimission_date
,position
,teller_level
,position_type
,service_date
,replace(replace(t1.workroom,chr(13),''),chr(10),'') as workroom
,replace(replace(t1.speciality,chr(13),''),chr(10),'') as speciality
,create_time
,update_time
,create_emp
,update_emp
,replace(replace(t1.address,chr(13),''),chr(10),'') as address

from ${iol_schema}.orws_t_emp_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/orws_t_emp_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
