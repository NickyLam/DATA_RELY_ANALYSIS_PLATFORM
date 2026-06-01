: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_gh_apply_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_gh_apply.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.apply_time,chr(13),''),chr(10),'') as apply_time
,replace(replace(t.product_id,chr(13),''),chr(10),'') as product_id
,replace(replace(t.request_id,chr(13),''),chr(10),'') as request_id
,replace(replace(t.tax_id,chr(13),''),chr(10),'') as tax_id
,replace(replace(t.device_id,chr(13),''),chr(10),'') as device_id
,replace(replace(t.decision_sn,chr(13),''),chr(10),'') as decision_sn
,replace(replace(t.ideffstart,chr(13),''),chr(10),'') as ideffstart
,replace(replace(t.ideffend,chr(13),''),chr(10),'') as ideffend
,replace(replace(t.idagency,chr(13),''),chr(10),'') as idagency
,replace(replace(t.censusaddress,chr(13),''),chr(10),'') as censusaddress
,t.age as age
,replace(replace(t.nation,chr(13),''),chr(10),'') as nation
,replace(replace(t.education,chr(13),''),chr(10),'') as education
,replace(replace(t.politicalstatus,chr(13),''),chr(10),'') as politicalstatus
,replace(replace(t.registeredresidence,chr(13),''),chr(10),'') as registeredresidence
,replace(replace(t.household,chr(13),''),chr(10),'') as household
,t.housefee as housefee
,replace(replace(t.iscountryregistered,chr(13),''),chr(10),'') as iscountryregistered
,t.yearswork as yearswork
,t.homenumbers as homenumbers
,replace(replace(t.children,chr(13),''),chr(10),'') as children
,t.homryearprofit as homryearprofit
,t.monthprofit as monthprofit
,replace(replace(t.homedesc,chr(13),''),chr(10),'') as homedesc
,replace(replace(t.carno,chr(13),''),chr(10),'') as carno
,t.driveage as driveage
,replace(replace(t.drivetype,chr(13),''),chr(10),'') as drivetype
,replace(replace(t.companyname,chr(13),''),chr(10),'') as companyname
,replace(replace(t.companytype,chr(13),''),chr(10),'') as companytype
,replace(replace(t.companyscale,chr(13),''),chr(10),'') as companyscale
,replace(replace(t.companyindustry,chr(13),''),chr(10),'') as companyindustry
,replace(replace(t.companyaddress,chr(13),''),chr(10),'') as companyaddress
,replace(replace(t.companyphone,chr(13),''),chr(10),'') as companyphone
,t.companyworkyears as companyworkyears
,replace(replace(t.companyentrydate,chr(13),''),chr(10),'') as companyentrydate
,replace(replace(t.companyposition,chr(13),''),chr(10),'') as companyposition
,replace(replace(t.companylevel,chr(13),''),chr(10),'') as companylevel
,replace(replace(t.companydepart,chr(13),''),chr(10),'') as companydepart
,replace(replace(t.salarytype,chr(13),''),chr(10),'') as salarytype
,t.salarymonth as salarymonth
,t.createuser as createuser
,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
,t.updateuser as updateuser
,replace(replace(t.occupation,chr(13),''),chr(10),'') as occupation
,replace(replace(t.companyzipcode,chr(13),''),chr(10),'') as companyzipcode
,replace(replace(t.persontitle,chr(13),''),chr(10),'') as persontitle
,t.personyearprofit as personyearprofit
,replace(replace(t.salaryaccount,chr(13),''),chr(10),'') as salaryaccount
,replace(replace(t.accountbank,chr(13),''),chr(10),'') as accountbank
,replace(replace(t.taxcode,chr(13),''),chr(10),'') as taxcode
,replace(replace(t.email,chr(13),''),chr(10),'') as email
,replace(replace(t.commaddress,chr(13),''),chr(10),'') as commaddress
,replace(replace(t.commzipcode,chr(13),''),chr(10),'') as commzipcode
,replace(replace(t.innercardno,chr(13),''),chr(10),'') as innercardno
,replace(replace(t.checkresult,chr(13),''),chr(10),'') as checkresult
,replace(replace(t.checkchnl,chr(13),''),chr(10),'') as checkchnl
,replace(replace(t.degree,chr(13),''),chr(10),'') as degree
,replace(replace(t.birth,chr(13),''),chr(10),'') as birth
,replace(replace(t.createtime,chr(13),''),chr(10),'') as createtime
,replace(replace(t.customerno,chr(13),''),chr(10),'') as customerno
,t.id as id
,replace(replace(t.idno,chr(13),''),chr(10),'') as idno
,replace(replace(t.idtype,chr(13),''),chr(10),'') as idtype
,replace(replace(t.marriage,chr(13),''),chr(10),'') as marriage
,replace(replace(t.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t.name,chr(13),''),chr(10),'') as name
,replace(replace(t.sex,chr(13),''),chr(10),'') as sex
,replace(replace(t.updatetime,chr(13),''),chr(10),'') as updatetime
,replace(replace(t.customer_cert_id,chr(13),''),chr(10),'') as customer_cert_id
,replace(replace(t.customer_name,chr(13),''),chr(10),'') as customer_name
,replace(replace(t.listtype,chr(13),''),chr(10),'') as listtype
,t.precreditquota as precreditquota
,replace(replace(t.srcprod,chr(13),''),chr(10),'') as srcprod
,replace(replace(t.srcchannel,chr(13),''),chr(10),'') as srcchannel
,replace(replace(t.srcprodcate,chr(13),''),chr(10),'') as srcprodcate
,replace(replace(t.srcproject,chr(13),''),chr(10),'') as srcproject
,replace(replace(t.srcmerchant,chr(13),''),chr(10),'') as srcmerchant
,replace(replace(t.customer_id,chr(13),''),chr(10),'') as customer_id
,t.flg as flg
,t.annualrate as annualrate
,t.applylimit as applylimit
,replace(replace(t.bankbindphone,chr(13),''),chr(10),'') as bankbindphone
,replace(replace(t.bankcardclient,chr(13),''),chr(10),'') as bankcardclient
,replace(replace(t.bankcardno,chr(13),''),chr(10),'') as bankcardno
,replace(replace(t.bankname,chr(13),''),chr(10),'') as bankname
,replace(replace(t.channel,chr(13),''),chr(10),'') as channel
,replace(replace(t.loanfoward,chr(13),''),chr(10),'') as loanfoward
,t.loanterm as loanterm
,replace(replace(t.repayday,chr(13),''),chr(10),'') as repayday
,replace(replace(t.repaymethod,chr(13),''),chr(10),'') as repaymethod
,t.requireddelaydays as requireddelaydays
,replace(replace(t.categoryname,chr(13),''),chr(10),'') as categoryname
,replace(replace(t.creditscore,chr(13),''),chr(10),'') as creditscore
,replace(replace(t.instfeerate,chr(13),''),chr(10),'') as instfeerate
,replace(replace(t.isgetdelayfee,chr(13),''),chr(10),'') as isgetdelayfee
,t.loantermday as loantermday
,t.loginuserorgid as loginuserorgid
,replace(replace(t.loginuserorgname,chr(13),''),chr(10),'') as loginuserorgname
,replace(replace(t.orgname,chr(13),''),chr(10),'') as orgname
,replace(replace(t.productname,chr(13),''),chr(10),'') as productname
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
,t.scrambleorderuserid as scrambleorderuserid
,t.servicefee as servicefee
,t.status as status
,replace(replace(t.cashtype,chr(13),''),chr(10),'') as cashtype
,replace(replace(t.auth_info,chr(13),''),chr(10),'') as auth_info
,replace(replace(t.riskparam1,chr(13),''),chr(10),'') as riskparam1
,replace(replace(t.riskparam2,chr(13),''),chr(10),'') as riskparam2
,replace(replace(t.riskparam3,chr(13),''),chr(10),'') as riskparam3
,replace(replace(t.riskparam4,chr(13),''),chr(10),'') as riskparam4
,replace(replace(t.riskparam5,chr(13),''),chr(10),'') as riskparam5
,t.depositbal as depositbal
,t.financialbal as financialbal
,t.premiumamt as premiumamt
,t.fundamt as fundamt
,replace(replace(t.purposeno,chr(13),''),chr(10),'') as purposeno
,t.homrmonthprofit as homrmonthprofit
,replace(replace(t.regioncd,chr(13),''),chr(10),'') as regioncd
,replace(replace(t.workstatus,chr(13),''),chr(10),'') as workstatus
,replace(replace(t.etprlocregion,chr(13),''),chr(10),'') as etprlocregion
,t.taxyearin as taxyearin
,replace(replace(t.certrelavalidflg,chr(13),''),chr(10),'') as certrelavalidflg
from iol.ilss_gh_apply t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_gh_apply.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes