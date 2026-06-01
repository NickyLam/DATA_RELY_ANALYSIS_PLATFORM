: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_orws_t_emp_edu_resume_f
CreateDate: 20240101
FileName:   ${iel_data_path}/orws_t_emp_edu_resume.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,id
,emp_info
,begin_date
,end_date
,replace(replace(t1.university,chr(13),''),chr(10),'') as university
,replace(replace(t1.profession,chr(13),''),chr(10),'') as profession
,academic
,degree
,is_fulltime
,creator
,editor
,create_time
,edit_time
,is_economics

from ${iol_schema}.orws_t_emp_edu_resume t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/orws_t_emp_edu_resume.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
