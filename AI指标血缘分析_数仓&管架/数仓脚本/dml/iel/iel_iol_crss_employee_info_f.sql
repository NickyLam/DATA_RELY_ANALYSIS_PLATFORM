: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_employee_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_employee_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.employeeid,chr(13),''),chr(10),'') as employeeid
,replace(replace(t.domainid,chr(13),''),chr(10),'') as domainid
,replace(replace(t.tellerno,chr(13),''),chr(10),'') as tellerno
,replace(replace(t.givenname,chr(13),''),chr(10),'') as givenname
,replace(replace(t.surname,chr(13),''),chr(10),'') as surname
,replace(replace(t.firstname,chr(13),''),chr(10),'') as firstname
,replace(replace(t.lastname,chr(13),''),chr(10),'') as lastname
,replace(replace(t.idtype,chr(13),''),chr(10),'') as idtype
,replace(replace(t.idcode,chr(13),''),chr(10),'') as idcode
,replace(replace(t.sex,chr(13),''),chr(10),'') as sex
,replace(replace(t.birthdate,chr(13),''),chr(10),'') as birthdate
,replace(replace(t.ethnic,chr(13),''),chr(10),'') as ethnic
,replace(replace(t.politicface,chr(13),''),chr(10),'') as politicface
,replace(replace(t.marriage,chr(13),''),chr(10),'') as marriage
,replace(replace(t.education,chr(13),''),chr(10),'') as education
,replace(replace(t.jobdate,chr(13),''),chr(10),'') as jobdate
,replace(replace(t.picturepath,chr(13),''),chr(10),'') as picturepath
,replace(replace(t.emptype,chr(13),''),chr(10),'') as emptype
,replace(replace(t.organcode,chr(13),''),chr(10),'') as organcode
,replace(replace(t.titlecode,chr(13),''),chr(10),'') as titlecode
,replace(replace(t.place,chr(13),''),chr(10),'') as place
,replace(replace(t.managertype,chr(13),''),chr(10),'') as managertype
,replace(replace(t.managerlevel,chr(13),''),chr(10),'') as managerlevel
,replace(replace(t.tellerlevel,chr(13),''),chr(10),'') as tellerlevel
,replace(replace(t.tellermanagerid,chr(13),''),chr(10),'') as tellermanagerid
,replace(replace(t.attachorgan,chr(13),''),chr(10),'') as attachorgan
,replace(replace(t.theentrydate,chr(13),''),chr(10),'') as theentrydate
,replace(replace(t.leaveofficedate,chr(13),''),chr(10),'') as leaveofficedate
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,replace(replace(t.sysstatus,chr(13),''),chr(10),'') as sysstatus
,replace(replace(t.fixcountrycode,chr(13),''),chr(10),'') as fixcountrycode
,replace(replace(t.fixareacode,chr(13),''),chr(10),'') as fixareacode
,replace(replace(t.fixphone,chr(13),''),chr(10),'') as fixphone
,replace(replace(t.fixsubphone,chr(13),''),chr(10),'') as fixsubphone
,replace(replace(t.companycountrycode,chr(13),''),chr(10),'') as companycountrycode
,replace(replace(t.companyareacode,chr(13),''),chr(10),'') as companyareacode
,replace(replace(t.companyphone,chr(13),''),chr(10),'') as companyphone
,replace(replace(t.companysubphone,chr(13),''),chr(10),'') as companysubphone
,replace(replace(t.housecountrycode,chr(13),''),chr(10),'') as housecountrycode
,replace(replace(t.houseareacode,chr(13),''),chr(10),'') as houseareacode
,replace(replace(t.homephone,chr(13),''),chr(10),'') as homephone
,replace(replace(t.housesubphone,chr(13),''),chr(10),'') as housesubphone
,replace(replace(t.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t.mobile1,chr(13),''),chr(10),'') as mobile1
,replace(replace(t.mobile2,chr(13),''),chr(10),'') as mobile2
,replace(replace(t.mobile3,chr(13),''),chr(10),'') as mobile3
,replace(replace(t.post,chr(13),''),chr(10),'') as post
,replace(replace(t.country,chr(13),''),chr(10),'') as country
,replace(replace(t.province,chr(13),''),chr(10),'') as province
,replace(replace(t.city,chr(13),''),chr(10),'') as city
,replace(replace(t.county,chr(13),''),chr(10),'') as county
,replace(replace(t.address,chr(13),''),chr(10),'') as address
,replace(replace(t.email,chr(13),''),chr(10),'') as email
,replace(replace(t.sallevel,chr(13),''),chr(10),'') as sallevel
,replace(replace(t.orderno,chr(13),''),chr(10),'') as orderno
,replace(replace(t.partorgancode,chr(13),''),chr(10),'') as partorgancode
,replace(replace(t.partplace,chr(13),''),chr(10),'') as partplace
,replace(replace(t.parthsorgancode,chr(13),''),chr(10),'') as parthsorgancode
,replace(replace(t.hsorgancode,chr(13),''),chr(10),'') as hsorgancode
,replace(replace(t.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t.inputdate,chr(13),''),chr(10),'') as inputdate
,replace(replace(t.updatedate,chr(13),''),chr(10),'') as updatedate
,replace(replace(t.parttellerno,chr(13),''),chr(10),'') as parttellerno
,replace(replace(t.parttellerattachorgan,chr(13),''),chr(10),'') as parttellerattachorgan
,replace(replace(t.subsidydate,chr(13),''),chr(10),'') as subsidydate
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.crss_employee_info t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_employee_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes