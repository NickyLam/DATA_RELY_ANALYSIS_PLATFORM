: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_classify_apply_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_classify_apply_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(serialno,chr(10),''),chr(13),'') as serialno
,replace(replace(customerid,chr(10),''),chr(13),'') as customerid
,replace(replace(customername,chr(10),''),chr(13),'') as customername
,replace(replace(remark,chr(10),''),chr(13),'') as remark
,replace(replace(inputuserid,chr(10),''),chr(13),'') as inputuserid
,replace(replace(inputorgid,chr(10),''),chr(13),'') as inputorgid
,replace(replace(relativeno,chr(10),''),chr(13),'') as relativeno
,replace(replace(inputdate,chr(10),''),chr(13),'') as inputdate
,replace(replace(updatedate,chr(10),''),chr(13),'') as updatedate
,replace(replace(pigeonholedate,chr(10),''),chr(13),'') as pigeonholedate
,replace(replace(flag,chr(10),''),chr(13),'') as flag
,replace(replace(relativeserialno,chr(10),''),chr(13),'') as relativeserialno
,replace(replace(type,chr(10),''),chr(13),'') as type
,replace(replace(objecttype,chr(10),''),chr(13),'') as objecttype
,replace(replace(contractserialno,chr(10),''),chr(13),'') as contractserialno
,replace(replace(creditaggreement,chr(10),''),chr(13),'') as creditaggreement
,replace(replace(businesstype,chr(10),''),chr(13),'') as businesstype
,replace(replace(businesscurrency,chr(10),''),chr(13),'') as businesscurrency
,replace(replace(opensum,chr(10),''),chr(13),'') as opensum
,replace(replace(relativetype,chr(10),''),chr(13),'') as relativetype
,replace(replace(totalsum,chr(10),''),chr(13),'') as totalsum
,replace(replace(maturity,chr(10),''),chr(13),'') as maturity
,replace(replace(licensedate,chr(10),''),chr(13),'') as licensedate
,replace(replace(balance,chr(10),''),chr(13),'') as balance
,replace(replace(vouchtype,chr(10),''),chr(13),'') as vouchtype
,replace(replace(classifyresult,chr(10),''),chr(13),'') as classifyresult
,replace(replace(remark1,chr(10),''),chr(13),'') as remark1
,replace(replace(lastclassifyresult,chr(10),''),chr(13),'') as lastclassifyresult
,replace(replace(approveclassifyresult,chr(10),''),chr(13),'') as approveclassifyresult
,replace(replace(approveclassifytime,chr(10),''),chr(13),'') as approveclassifytime
,replace(replace(lastpolicyresult,chr(10),''),chr(13),'') as lastpolicyresult
,replace(replace(policyresult,chr(10),''),chr(13),'') as policyresult
,replace(replace(customerlevel,chr(10),''),chr(13),'') as customerlevel
,replace(replace(levelclassify,chr(10),''),chr(13),'') as levelclassify
,replace(replace(customerleveltime,chr(10),''),chr(13),'') as customerleveltime
,replace(replace(coverage,chr(10),''),chr(13),'') as coverage
,replace(replace(assurelevel,chr(10),''),chr(13),'') as assurelevel
,replace(replace(guarantysum,chr(10),''),chr(13),'') as guarantysum
,replace(replace(assurecustomerid,chr(10),''),chr(13),'') as assurecustomerid
,replace(replace(accountmonth,chr(10),''),chr(13),'') as accountmonth
,replace(replace(adviseclassifyresult,chr(10),''),chr(13),'') as adviseclassifyresult
,replace(replace(classifymode,chr(10),''),chr(13),'') as classifymode
,replace(replace(lastcustomerlevel,chr(10),''),chr(13),'') as lastcustomerlevel
,replace(replace(finalpolicyresult,chr(10),''),chr(13),'') as finalpolicyresult
,replace(replace(finalcustomerlevel,chr(10),''),chr(13),'') as finalcustomerlevel
,replace(replace(finalclassifyresult,chr(10),''),chr(13),'') as finalclassifyresult
,replace(replace(approveevaluateresult,chr(10),''),chr(13),'') as approveevaluateresult
,replace(replace(adjusttype,chr(10),''),chr(13),'') as adjusttype
,replace(replace(kernaladjustlevel,chr(10),''),chr(13),'') as kernaladjustlevel
,replace(replace(alarmadjustlevel,chr(10),''),chr(13),'') as alarmadjustlevel
,replace(replace(alarminfo,chr(10),''),chr(13),'') as alarminfo
,replace(replace(entrance,chr(10),''),chr(13),'') as entrance
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.crss_classify_apply where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_classify_apply_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes