: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_one_click_input_f
CreateDate: 20250228
FileName:   ${iel_data_path}/icms_one_click_input.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,occurdate
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.certid,chr(13),''),chr(10),'') as certid
,replace(replace(t1.certstartdate,chr(13),''),chr(10),'') as certstartdate
,replace(replace(t1.certenddate,chr(13),''),chr(10),'') as certenddate
,replace(replace(t1.certtype,chr(13),''),chr(10),'') as certtype
,replace(replace(t1.phone,chr(13),''),chr(10),'') as phone
,replace(replace(t1.city,chr(13),''),chr(10),'') as city
,replace(replace(t1.nativeadd,chr(13),''),chr(10),'') as nativeadd
,replace(replace(t1.occupation,chr(13),''),chr(10),'') as occupation
,replace(replace(t1.occupationshow,chr(13),''),chr(10),'') as occupationshow
,replace(replace(t1.sex,chr(13),''),chr(10),'') as sex
,replace(replace(t1.nation,chr(13),''),chr(10),'') as nation
,replace(replace(t1.birthday,chr(13),''),chr(10),'') as birthday
,replace(replace(t1.userid,chr(13),''),chr(10),'') as userid
,replace(replace(t1.username,chr(13),''),chr(10),'') as username
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.loanapplamt,chr(13),''),chr(10),'') as loanapplamt
,replace(replace(t1.loanapplyterm,chr(13),''),chr(10),'') as loanapplyterm
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.ifcreditfactory,chr(13),''),chr(10),'') as ifcreditfactory
,replace(replace(t1.qryusertype,chr(13),''),chr(10),'') as qryusertype
,replace(replace(t1.qryopertp,chr(13),''),chr(10),'') as qryopertp
,replace(replace(t1.partner,chr(13),''),chr(10),'') as partner
,replace(replace(t1.reportusernm,chr(13),''),chr(10),'') as reportusernm
,replace(replace(t1.reportuseroff,chr(13),''),chr(10),'') as reportuseroff
,replace(replace(t1.authotype,chr(13),''),chr(10),'') as authotype
,replace(replace(t1.biometrics,chr(13),''),chr(10),'') as biometrics
,replace(replace(t1.authotime,chr(13),''),chr(10),'') as authotime
,replace(replace(t1.authostrdate,chr(13),''),chr(10),'') as authostrdate
,replace(replace(t1.authoenddate,chr(13),''),chr(10),'') as authoenddate
,inputdate
,replace(replace(t1.approvestatus,chr(13),''),chr(10),'') as approvestatus
,replace(replace(t1.creditscorelevel,chr(13),''),chr(10),'') as creditscorelevel
,replace(replace(t1.applyno,chr(13),''),chr(10),'') as applyno
,replace(replace(t1.baserialno,chr(13),''),chr(10),'') as baserialno
,replace(replace(t1.baserialno1,chr(13),''),chr(10),'') as baserialno1
,replace(replace(t1.household,chr(13),''),chr(10),'') as household
,replace(replace(t1.autoscore,chr(13),''),chr(10),'') as autoscore
,replace(replace(t1.failreason,chr(13),''),chr(10),'') as failreason
,replace(replace(t1.warninginfo,chr(13),''),chr(10),'') as warninginfo
,replace(replace(t1.channel,chr(13),''),chr(10),'') as channel
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,replace(replace(t1.loantype,chr(13),''),chr(10),'') as loantype
,replace(replace(t1.biztime,chr(13),''),chr(10),'') as biztime
,replace(replace(t1.creditauthotime,chr(13),''),chr(10),'') as creditauthotime
,replace(replace(t1.pfktype,chr(13),''),chr(10),'') as pfktype

from ${iol_schema}.icms_one_click_input t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_one_click_input.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
