: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_employee_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_employee_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(employeeid,chr(10),''),chr(13),'') as employeeid
,replace(replace(domainid,chr(10),''),chr(13),'') as domainid
,replace(replace(tellerno,chr(10),''),chr(13),'') as tellerno
,replace(replace(givenname,chr(10),''),chr(13),'') as givenname
,replace(replace(surname,chr(10),''),chr(13),'') as surname
,replace(replace(firstname,chr(10),''),chr(13),'') as firstname
,replace(replace(lastname,chr(10),''),chr(13),'') as lastname
,replace(replace(idtype,chr(10),''),chr(13),'') as idtype
,replace(replace(idcode,chr(10),''),chr(13),'') as idcode
,replace(replace(sex,chr(10),''),chr(13),'') as sex
,replace(replace(birthdate,chr(10),''),chr(13),'') as birthdate
,replace(replace(ethnic,chr(10),''),chr(13),'') as ethnic
,replace(replace(politicface,chr(10),''),chr(13),'') as politicface
,replace(replace(marriage,chr(10),''),chr(13),'') as marriage
,replace(replace(education,chr(10),''),chr(13),'') as education
,replace(replace(jobdate,chr(10),''),chr(13),'') as jobdate
,replace(replace(picturepath,chr(10),''),chr(13),'') as picturepath
,replace(replace(emptype,chr(10),''),chr(13),'') as emptype
,replace(replace(organcode,chr(10),''),chr(13),'') as organcode
,replace(replace(titlecode,chr(10),''),chr(13),'') as titlecode
,replace(replace(place,chr(10),''),chr(13),'') as place
,replace(replace(managertype,chr(10),''),chr(13),'') as managertype
,replace(replace(managerlevel,chr(10),''),chr(13),'') as managerlevel
,replace(replace(tellerlevel,chr(10),''),chr(13),'') as tellerlevel
,replace(replace(tellermanagerid,chr(10),''),chr(13),'') as tellermanagerid
,replace(replace(attachorgan,chr(10),''),chr(13),'') as attachorgan
,replace(replace(theentrydate,chr(10),''),chr(13),'') as theentrydate
,replace(replace(leaveofficedate,chr(10),''),chr(13),'') as leaveofficedate
,replace(replace(status,chr(10),''),chr(13),'') as status
,replace(replace(sysstatus,chr(10),''),chr(13),'') as sysstatus
,replace(replace(fixcountrycode,chr(10),''),chr(13),'') as fixcountrycode
,replace(replace(fixareacode,chr(10),''),chr(13),'') as fixareacode
,replace(replace(fixphone,chr(10),''),chr(13),'') as fixphone
,replace(replace(fixsubphone,chr(10),''),chr(13),'') as fixsubphone
,replace(replace(companycountrycode,chr(10),''),chr(13),'') as companycountrycode
,replace(replace(companyareacode,chr(10),''),chr(13),'') as companyareacode
,replace(replace(companyphone,chr(10),''),chr(13),'') as companyphone
,replace(replace(companysubphone,chr(10),''),chr(13),'') as companysubphone
,replace(replace(housecountrycode,chr(10),''),chr(13),'') as housecountrycode
,replace(replace(houseareacode,chr(10),''),chr(13),'') as houseareacode
,replace(replace(homephone,chr(10),''),chr(13),'') as homephone
,replace(replace(housesubphone,chr(10),''),chr(13),'') as housesubphone
,replace(replace(mobile,chr(10),''),chr(13),'') as mobile
,replace(replace(mobile1,chr(10),''),chr(13),'') as mobile1
,replace(replace(mobile2,chr(10),''),chr(13),'') as mobile2
,replace(replace(mobile3,chr(10),''),chr(13),'') as mobile3
,replace(replace(post,chr(10),''),chr(13),'') as post
,replace(replace(country,chr(10),''),chr(13),'') as country
,replace(replace(province,chr(10),''),chr(13),'') as province
,replace(replace(city,chr(10),''),chr(13),'') as city
,replace(replace(county,chr(10),''),chr(13),'') as county
,replace(replace(address,chr(10),''),chr(13),'') as address
,replace(replace(email,chr(10),''),chr(13),'') as email
,replace(replace(sallevel,chr(10),''),chr(13),'') as sallevel
,replace(replace(orderno,chr(10),''),chr(13),'') as orderno
,replace(replace(partorgancode,chr(10),''),chr(13),'') as partorgancode
,replace(replace(partplace,chr(10),''),chr(13),'') as partplace
,replace(replace(parthsorgancode,chr(10),''),chr(13),'') as parthsorgancode
,replace(replace(hsorgancode,chr(10),''),chr(13),'') as hsorgancode
,replace(replace(inputorgid,chr(10),''),chr(13),'') as inputorgid
,replace(replace(inputuserid,chr(10),''),chr(13),'') as inputuserid
,replace(replace(inputdate,chr(10),''),chr(13),'') as inputdate
,replace(replace(updatedate,chr(10),''),chr(13),'') as updatedate
,replace(replace(parttellerno,chr(10),''),chr(13),'') as parttellerno
,replace(replace(parttellerattachorgan,chr(10),''),chr(13),'') as parttellerattachorgan
,replace(replace(subsidydate,chr(10),''),chr(13),'') as subsidydate
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_employee_info 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_employee_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes