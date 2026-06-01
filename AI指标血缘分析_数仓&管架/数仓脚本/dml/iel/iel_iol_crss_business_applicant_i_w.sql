: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_business_applicant_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_business_applicant_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(objecttype,chr(10),''),chr(13),'') as objecttype
,replace(replace(objectno,chr(10),''),chr(13),'') as objectno
,replace(replace(serialno,chr(10),''),chr(13),'') as serialno
,replace(replace(applicantid,chr(10),''),chr(13),'') as applicantid
,replace(replace(applicantname,chr(10),''),chr(13),'') as applicantname
,replace(replace(rightprop,chr(10),''),chr(13),'') as rightprop
,replace(replace(debtprop,chr(10),''),chr(13),'') as debtprop
,replace(replace(inputorgid,chr(10),''),chr(13),'') as inputorgid
,replace(replace(inputuserid,chr(10),''),chr(13),'') as inputuserid
,replace(replace(inputdate,chr(10),''),chr(13),'') as inputdate
,replace(replace(updatedate,chr(10),''),chr(13),'') as updatedate
,replace(replace(remark,chr(10),''),chr(13),'') as remark
,replace(replace(applicanttype,chr(10),''),chr(13),'') as applicanttype
,replace(replace(status,chr(10),''),chr(13),'') as status
,replace(replace(otherrelationship,chr(10),''),chr(13),'') as otherrelationship
,replace(replace(incomedebtflag,chr(10),''),chr(13),'') as incomedebtflag
,replace(replace(relationship,chr(10),''),chr(13),'') as relationship
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_business_applicant 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_business_applicant_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes