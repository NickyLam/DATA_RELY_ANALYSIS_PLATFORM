: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uuss_uus_employee_f
CreateDate: 20221021
FileName:   ${iel_data_path}/uuss_uus_employee.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(employeeid,chr(13),''),chr(10),'')
,replace(replace(domainid,chr(13),''),chr(10),'')
,replace(replace(tellerno,chr(13),''),chr(10),'')
,replace(replace(givenname,chr(13),''),chr(10),'')
,replace(replace(surname,chr(13),''),chr(10),'')
,replace(replace(firstname,chr(13),''),chr(10),'')
,replace(replace(lastname,chr(13),''),chr(10),'')
,replace(replace(idtype,chr(13),''),chr(10),'')
,replace(replace(idcode,chr(13),''),chr(10),'')
,replace(replace(sex,chr(13),''),chr(10),'')
,replace(replace(birthdate,chr(13),''),chr(10),'')
,replace(replace(ethnic,chr(13),''),chr(10),'')
,replace(replace(politicface,chr(13),''),chr(10),'')
,replace(replace(marriage,chr(13),''),chr(10),'')
,replace(replace(education,chr(13),''),chr(10),'')
,replace(replace(jobdate,chr(13),''),chr(10),'')
,replace(replace(picturepath,chr(13),''),chr(10),'')
,replace(replace(emptype,chr(13),''),chr(10),'')
,replace(replace(organcode,chr(13),''),chr(10),'')
,replace(replace(titlecode,chr(13),''),chr(10),'')
,replace(replace(place,chr(13),''),chr(10),'')
,replace(replace(managertype,chr(13),''),chr(10),'')
,replace(replace(managerlevel,chr(13),''),chr(10),'')
,replace(replace(tellerlevel,chr(13),''),chr(10),'')
,replace(replace(tellermanagerid,chr(13),''),chr(10),'')
,replace(replace(attachorgan,chr(13),''),chr(10),'')
,replace(replace(theentrydate,chr(13),''),chr(10),'')
,replace(replace(leaveofficedate,chr(13),''),chr(10),'')
,replace(replace(status,chr(13),''),chr(10),'')
,replace(replace(sysstatus,chr(13),''),chr(10),'')
,replace(replace(fixcountrycode,chr(13),''),chr(10),'')
,replace(replace(fixareacode,chr(13),''),chr(10),'')
,replace(replace(fixphone,chr(13),''),chr(10),'')
,replace(replace(fixsubphone,chr(13),''),chr(10),'')
,replace(replace(companycountrycode,chr(13),''),chr(10),'')
,replace(replace(companyareacode,chr(13),''),chr(10),'')
,replace(replace(companyphone,chr(13),''),chr(10),'')
,replace(replace(companysubphone,chr(13),''),chr(10),'')
,replace(replace(housecountrycode,chr(13),''),chr(10),'')
,replace(replace(houseareacode,chr(13),''),chr(10),'')
,replace(replace(homephone,chr(13),''),chr(10),'')
,replace(replace(housesubphone,chr(13),''),chr(10),'')
,replace(replace(mobile,chr(13),''),chr(10),'')
,replace(replace(mobile1,chr(13),''),chr(10),'')
,replace(replace(mobile2,chr(13),''),chr(10),'')
,replace(replace(mobile3,chr(13),''),chr(10),'')
,replace(replace(post,chr(13),''),chr(10),'')
,replace(replace(country,chr(13),''),chr(10),'')
,replace(replace(province,chr(13),''),chr(10),'')
,replace(replace(city,chr(13),''),chr(10),'')
,replace(replace(county,chr(13),''),chr(10),'')
,replace(replace(address,chr(13),''),chr(10),'')
,replace(replace(email,chr(13),''),chr(10),'')
,replace(replace(sallevel,chr(13),''),chr(10),'')
,replace(replace(orderno,chr(13),''),chr(10),'')
,replace(replace(hsorgancode,chr(13),''),chr(10),'')
,replace(replace(updatedate,chr(13),''),chr(10),'')
,replace(replace(subsidydate,chr(13),''),chr(10),'')
,replace(replace(userid,chr(13),''),chr(10),'')
,replace(replace(placehr,chr(13),''),chr(10),'')
,replace(replace(jobcategory,chr(13),''),chr(10),'')
,replace(replace(tellerstatus,chr(13),''),chr(10),'')

from ${iol_schema}.uuss_uus_employee t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uuss_uus_employee.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
