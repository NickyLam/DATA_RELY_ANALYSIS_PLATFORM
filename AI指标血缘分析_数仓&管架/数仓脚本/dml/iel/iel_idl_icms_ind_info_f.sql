: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icms_ind_info_f
CreateDate: 20250619
FileName:   ${iel_data_path}/icms_ind_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.customerid as customerid
,t1.customerdetail as customerdetail
,t1.newcreditmonthpay as newcreditmonthpay
,t1.empstatus as empstatus
,t1.cpndist as cpndist
,t1.workname as workname
,t1.livingyears as livingyears
,t1.updateorgid as updateorgid
,t1.nativetype as nativetype
,t1.incomesource as incomesource
,t1.oldcreditmonthpay as oldcreditmonthpay
,t1.inputorgid as inputorgid
,t1.corporgid as corporgid
,t1.nation as nation
,t1.updatedate as updatedate
,t1.nationality as nationality
,t1.familymonthincome as familymonthincome
,t1.emergencycontactaddress as emergencycontactaddress
,t1.ishavecar as ishavecar
,t1.homedetails as homedetails
,t1.occupation as occupation
,t1.selfyearincome as selfyearincome
,t1.emergencycontactmobilephone as emergencycontactmobilephone
,t1.sino as sino
,t1.payaccountbank as payaccountbank
,t1.nativeaddress as nativeaddress
,t1.edudegree as edudegree
,t1.homedebtsum as homedebtsum
,t1.evaluatedate as evaluatedate
,t1.residist as residist
,t1.maildist as maildist
,t1.localcontractaddress as localcontractaddress
,t1.livingareapostalcode as livingareapostalcode
,t1.isrelative as isrelative
,t1.entscale as entscale
,t1.healthstatus as healthstatus
,t1.driveryears as driveryears
,t1.industry as industry
,t1.iddist as iddist
,t1.birthday as birthday
,t1.payaccount as payaccount
,t1.nineelements as nineelements
,t1.familystatus as familystatus
,t1.isbankstaff as isbankstaff
,t1.graduateschool as graduateschool
,t1.children as children
,t1.indmonthincome as indmonthincome
,t1.currentworkyears as currentworkyears
,t1.isfarmer as isfarmer
,t1.carprice as carprice
,t1.billstyle as billstyle
,t1.unitphone as unitphone
,t1.indtype as indtype
,t1.usuallivingarea as usuallivingarea
,t1.nativeadd as nativeadd
,t1.eduexperience as eduexperience
,t1.rgstad as rgstad
,t1.graduateyear as graduateyear
,t1.sex as sex
,t1.workbegindate as workbegindate
,t1.housevalue as housevalue
,t1.title as title
,t1.migtflag as migtflag
,t1.localcontract as localcontract
,t1.iscreditlimit as iscreditlimit
,t1.remark as remark
,t1.idorgname as idorgname
,t1.workstartdate as workstartdate
,t1.localcontractmobilephone as localcontractmobilephone
,t1.drivercartype as drivercartype
,t1.taxedannualincome as taxedannualincome
,t1.unitaddress as unitaddress
,t1.homeyearincome as homeyearincome
,t1.headship as headship
,t1.customername as customername
,t1.politicalface as politicalface
,t1.emergencycontact as emergencycontact
,t1.driverlicenseid as driverlicenseid
,t1.ishavework as ishavework
,t1.email as email
,t1.updateuserid as updateuserid
,t1.nativeplace as nativeplace
,t1.nativedetail as nativedetail
,t1.customertype as customertype
,t1.totalsum as totalsum
,t1.city as city
,t1.socialsecyear as socialsecyear
,t1.unitpostcode as unitpostcode
,t1.inputdate as inputdate
,t1.incomeprove as incomeprove
,t1.incomeratio as incomeratio
,t1.creditlevel as creditlevel
,t1.hndist as hndist
,t1.lmcredittype as lmcredittype
,t1.supportpopulations as supportpopulations
,t1.unitkind as unitkind
,t1.unitcountry as unitcountry
,t1.marriage as marriage
,t1.indcharacter as indcharacter
,t1.hobby as hobby
,t1.inputuserid as inputuserid
,t1.houseadd as houseadd
,t1.localcontracttelephone as localcontracttelephone
,t1.migtoldvalue as migtoldvalue
,t1.othercareer as othercareer
,t1.cuscreditscorelevel as cuscreditscorelevel
,t1.migtcustomerid as migtcustomerid
,t1.isfamilyfarm as isfamilyfarm
,t1.islowhouse as islowhouse
,t1.isdisabled as isdisabled
,t1.cuscreditscore as cuscreditscore
,t1.holdratio as holdratio
,t1.incomecurrency as incomecurrency
,t1.formername as formername
,t1.productid as productid
,t1.channel as channel

from ${idl_schema}.icms_ind_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_ind_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
