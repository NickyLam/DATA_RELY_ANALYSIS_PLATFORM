: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_classify_record_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_classify_record_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(objecttype,chr(10),''),chr(13),'') as objecttype
,replace(replace(objectno,chr(10),''),chr(13),'') as objectno
,replace(replace(serialno,chr(10),''),chr(13),'') as serialno
,replace(replace(modelno,chr(10),''),chr(13),'') as modelno
,replace(replace(firstresult,chr(10),''),chr(13),'') as firstresult
,replace(replace(secondresult,chr(10),''),chr(13),'') as secondresult
,replace(replace(result1,chr(10),''),chr(13),'') as result1
,replace(replace(resultopinion1,chr(10),''),chr(13),'') as resultopinion1
,replace(replace(result2,chr(10),''),chr(13),'') as result2
,replace(replace(resultopinion2,chr(10),''),chr(13),'') as resultopinion2
,replace(replace(result3,chr(10),''),chr(13),'') as result3
,replace(replace(resultopinion3,chr(10),''),chr(13),'') as resultopinion3
,replace(replace(result4,chr(10),''),chr(13),'') as result4
,replace(replace(resultopinion4,chr(10),''),chr(13),'') as resultopinion4
,replace(replace(finallyresult,chr(10),''),chr(13),'') as finallyresult
,replace(replace(sum1,chr(10),''),chr(13),'') as sum1
,replace(replace(sum2,chr(10),''),chr(13),'') as sum2
,replace(replace(sum3,chr(10),''),chr(13),'') as sum3
,replace(replace(sum4,chr(10),''),chr(13),'') as sum4
,replace(replace(sum5,chr(10),''),chr(13),'') as sum5
,replace(replace(expectlosssum,chr(10),''),chr(13),'') as expectlosssum
,replace(replace(reservesum,chr(10),''),chr(13),'') as reservesum
,replace(replace(classifyuserid,chr(10),''),chr(13),'') as classifyuserid
,replace(replace(classifyorgid,chr(10),''),chr(13),'') as classifyorgid
,replace(replace(classifydate,chr(10),''),chr(13),'') as classifydate
,replace(replace(finishdate,chr(10),''),chr(13),'') as finishdate
,replace(replace(inputdate,chr(10),''),chr(13),'') as inputdate
,replace(replace(updatedate,chr(10),''),chr(13),'') as updatedate
,replace(replace(remark,chr(10),''),chr(13),'') as remark
,replace(replace(businessbalance,chr(10),''),chr(13),'') as businessbalance
,replace(replace(orgid,chr(10),''),chr(13),'') as orgid
,replace(replace(userid,chr(10),''),chr(13),'') as userid
,replace(replace(accountmonth,chr(10),''),chr(13),'') as accountmonth
,replace(replace(result5,chr(10),''),chr(13),'') as result5
,replace(replace(resultopinion5,chr(10),''),chr(13),'') as resultopinion5
,replace(replace(resultusername5,chr(10),''),chr(13),'') as resultusername5
,replace(replace(resultusername4,chr(10),''),chr(13),'') as resultusername4
,replace(replace(resultusername3,chr(10),''),chr(13),'') as resultusername3
,replace(replace(resultusername2,chr(10),''),chr(13),'') as resultusername2
,replace(replace(resultusername1,chr(10),''),chr(13),'') as resultusername1
,replace(replace(classifylevel,chr(10),''),chr(13),'') as classifylevel
,replace(replace(resultuserid2,chr(10),''),chr(13),'') as resultuserid2
,replace(replace(resultuserid3,chr(10),''),chr(13),'') as resultuserid3
,replace(replace(resultuserid4,chr(10),''),chr(13),'') as resultuserid4
,replace(replace(resultuserid5,chr(10),''),chr(13),'') as resultuserid5
,replace(replace(finishdate2,chr(10),''),chr(13),'') as finishdate2
,replace(replace(finishdate3,chr(10),''),chr(13),'') as finishdate3
,replace(replace(finishdate4,chr(10),''),chr(13),'') as finishdate4
,replace(replace(finishdate5,chr(10),''),chr(13),'') as finishdate5
,replace(replace(originalputoutdate,chr(10),''),chr(13),'') as originalputoutdate
,replace(replace(lastresult,chr(10),''),chr(13),'') as lastresult
,replace(replace(customerid,chr(10),''),chr(13),'') as customerid
,replace(replace(contractserialno,chr(10),''),chr(13),'') as contractserialno
,replace(replace(flag,chr(10),''),chr(13),'') as flag
,replace(replace(isinuse,chr(10),''),chr(13),'') as isinuse
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_classify_record 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_classify_record_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes