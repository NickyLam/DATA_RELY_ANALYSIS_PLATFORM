: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_crss_employee_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_crss_employee_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.employeeid,chr(13),''),chr(10),'') as employeeid
,replace(replace(t1.domainid,chr(13),''),chr(10),'') as domainid
,replace(replace(t1.tellerno,chr(13),''),chr(10),'') as tellerno
,replace(replace(t1.givenname,chr(13),''),chr(10),'') as givenname
,replace(replace(t1.surname,chr(13),''),chr(10),'') as surname
,replace(replace(t1.firstname,chr(13),''),chr(10),'') as firstname
,replace(replace(t1.lastname,chr(13),''),chr(10),'') as lastname
,replace(replace(t1.idtype,chr(13),''),chr(10),'') as idtype
,replace(replace(t1.idcode,chr(13),''),chr(10),'') as idcode
,replace(replace(t1.sex,chr(13),''),chr(10),'') as sex
,replace(replace(t1.birthdate,chr(13),''),chr(10),'') as birthdate
,replace(replace(t1.ethnic,chr(13),''),chr(10),'') as ethnic
,replace(replace(t1.politicface,chr(13),''),chr(10),'') as politicface
,replace(replace(t1.marriage,chr(13),''),chr(10),'') as marriage
,replace(replace(t1.education,chr(13),''),chr(10),'') as education
,replace(replace(t1.jobdate,chr(13),''),chr(10),'') as jobdate
,replace(replace(t1.picturepath,chr(13),''),chr(10),'') as picturepath
,replace(replace(t1.emptype,chr(13),''),chr(10),'') as emptype
,replace(replace(t1.organcode,chr(13),''),chr(10),'') as organcode
,replace(replace(t1.titlecode,chr(13),''),chr(10),'') as titlecode
,replace(replace(t1.place,chr(13),''),chr(10),'') as place
,replace(replace(t1.managertype,chr(13),''),chr(10),'') as managertype
,replace(replace(t1.managerlevel,chr(13),''),chr(10),'') as managerlevel
,replace(replace(t1.tellerlevel,chr(13),''),chr(10),'') as tellerlevel
,replace(replace(t1.tellermanagerid,chr(13),''),chr(10),'') as tellermanagerid
,replace(replace(t1.attachorgan,chr(13),''),chr(10),'') as attachorgan
,replace(replace(t1.theentrydate,chr(13),''),chr(10),'') as theentrydate
,replace(replace(t1.leaveofficedate,chr(13),''),chr(10),'') as leaveofficedate
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.sysstatus,chr(13),''),chr(10),'') as sysstatus
,replace(replace(t1.fixcountrycode,chr(13),''),chr(10),'') as fixcountrycode
,replace(replace(t1.fixareacode,chr(13),''),chr(10),'') as fixareacode
,replace(replace(t1.fixphone,chr(13),''),chr(10),'') as fixphone
,replace(replace(t1.fixsubphone,chr(13),''),chr(10),'') as fixsubphone
,replace(replace(t1.companycountrycode,chr(13),''),chr(10),'') as companycountrycode
,replace(replace(t1.companyareacode,chr(13),''),chr(10),'') as companyareacode
,replace(replace(t1.companyphone,chr(13),''),chr(10),'') as companyphone
,replace(replace(t1.companysubphone,chr(13),''),chr(10),'') as companysubphone
,replace(replace(t1.housecountrycode,chr(13),''),chr(10),'') as housecountrycode
,replace(replace(t1.houseareacode,chr(13),''),chr(10),'') as houseareacode
,replace(replace(t1.homephone,chr(13),''),chr(10),'') as homephone
,replace(replace(t1.housesubphone,chr(13),''),chr(10),'') as housesubphone
,replace(replace(t1.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t1.mobile1,chr(13),''),chr(10),'') as mobile1
,replace(replace(t1.mobile2,chr(13),''),chr(10),'') as mobile2
,replace(replace(t1.mobile3,chr(13),''),chr(10),'') as mobile3
,replace(replace(t1.post,chr(13),''),chr(10),'') as post
,replace(replace(t1.country,chr(13),''),chr(10),'') as country
,replace(replace(t1.province,chr(13),''),chr(10),'') as province
,replace(replace(t1.city,chr(13),''),chr(10),'') as city
,replace(replace(t1.county,chr(13),''),chr(10),'') as county
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,replace(replace(t1.sallevel,chr(13),''),chr(10),'') as sallevel
,replace(replace(t1.orderno,chr(13),''),chr(10),'') as orderno
,replace(replace(t1.partorgancode,chr(13),''),chr(10),'') as partorgancode
,replace(replace(t1.partplace,chr(13),''),chr(10),'') as partplace
,replace(replace(t1.parthsorgancode,chr(13),''),chr(10),'') as parthsorgancode
,replace(replace(t1.hsorgancode,chr(13),''),chr(10),'') as hsorgancode
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputdate,chr(13),''),chr(10),'') as inputdate
,replace(replace(t1.updatedate,chr(13),''),chr(10),'') as updatedate
,replace(replace(t1.parttellerno,chr(13),''),chr(10),'') as parttellerno
,replace(replace(t1.parttellerattachorgan,chr(13),''),chr(10),'') as parttellerattachorgan
,replace(replace(t1.subsidydate,chr(13),''),chr(10),'') as subsidydate
from ${iol_schema}.crss_employee_info t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_crss_employee_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes