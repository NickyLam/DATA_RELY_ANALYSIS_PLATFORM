: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_uuss_uus_employee_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_uuss_uus_employee.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.tellerno as tellerno
,t1.givenname as givenname
,t1.surname as surname
,t1.firstname as firstname
,t1.lastname as lastname
,t1.idtype as idtype
,t1.idcode as idcode
,t1.sex as sex
,t1.birthdate as birthdate
,t1.ethnic as ethnic
,t1.politicface as politicface
,t1.marriage as marriage
,t1.education as education
,t1.jobdate as jobdate
,t1.picturepath as picturepath
,t1.emptype as emptype
,t1.organcode as organcode
,t1.titlecode as titlecode
,t1.place as place
,t1.managertype as managertype
,t1.managerlevel as managerlevel
,t1.tellerlevel as tellerlevel
,t1.tellermanagerid as tellermanagerid
,t1.attachorgan as attachorgan
,t1.theentrydate as theentrydate
,t1.leaveofficedate as leaveofficedate
,t1.status as status
,t1.sysstatus as sysstatus
,t1.fixcountrycode as fixcountrycode
,t1.fixareacode as fixareacode
,t1.fixphone as fixphone
,t1.fixsubphone as fixsubphone
,t1.companycountrycode as companycountrycode
,t1.companyareacode as companyareacode
,t1.companyphone as companyphone
,t1.companysubphone as companysubphone
,t1.housecountrycode as housecountrycode
,t1.houseareacode as houseareacode
,t1.homephone as homephone
,t1.housesubphone as housesubphone
,t1.mobile as mobile
,t1.mobile1 as mobile1
,t1.mobile2 as mobile2
,t1.mobile3 as mobile3
,t1.post as post
,t1.country as country
,t1.province as province
,t1.city as city
,t1.county as county
,t1.address as address
,t1.email as email
,t1.sallevel as sallevel
,t1.orderno as orderno
,t1.hsorgancode as hsorgancode
,t1.updatedate as updatedate
,t1.subsidydate as subsidydate
,t1.userid as userid
,t1.placehr as placehr
,t1.jobcategory as jobcategory
,t1.tellerstatus as tellerstatus
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.employeeid as employeeid
,t1.domainid as domainid

from ${idl_schema}.oass_uuss_uus_employee t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_uuss_uus_employee.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
