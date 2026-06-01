: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_loanafteroversee_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_loanafteroversee_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(serialno,chr(10),''),chr(13),'') as serialno
,replace(replace(customerid,chr(10),''),chr(13),'') as customerid
,replace(replace(customername,chr(10),''),chr(13),'') as customername
,replace(replace(overseemonth,chr(10),''),chr(13),'') as overseemonth
,replace(replace(contractserialno,chr(10),''),chr(13),'') as contractserialno
,replace(replace(putoutserialno,chr(10),''),chr(13),'') as putoutserialno
,replace(replace(putoutsum,chr(10),''),chr(13),'') as putoutsum
,replace(replace(putoutdate,chr(10),''),chr(13),'') as putoutdate
,replace(replace(inputuserid,chr(10),''),chr(13),'') as inputuserid
,replace(replace(inputorgid,chr(10),''),chr(13),'') as inputorgid
,replace(replace(finishstatus,chr(10),''),chr(13),'') as finishstatus
,replace(replace(inputdate,chr(10),''),chr(13),'') as inputdate
,replace(replace(updatedate,chr(10),''),chr(13),'') as updatedate
,replace(replace(finishdate,chr(10),''),chr(13),'') as finishdate
,replace(replace(flag,chr(10),''),chr(13),'') as flag
,replace(replace(objecttype,chr(10),''),chr(13),'') as objecttype
,replace(replace(objectno,chr(10),''),chr(13),'') as objectno
,replace(replace(currency,chr(10),''),chr(13),'') as currency
,replace(replace(overseematurity,chr(10),''),chr(13),'') as overseematurity
,replace(replace(submitriskmanager,chr(10),''),chr(13),'') as submitriskmanager
,replace(replace(docid,chr(10),''),chr(13),'') as docid
,replace(replace(inputtype,chr(10),''),chr(13),'') as inputtype
,replace(replace(certtype,chr(10),''),chr(13),'') as certtype
,replace(replace(certid,chr(10),''),chr(13),'') as certid
,replace(replace(inspectbasic,chr(10),''),chr(13),'') as inspectbasic
,replace(replace(manageorgid,chr(10),''),chr(13),'') as manageorgid
,replace(replace(manageuserid,chr(10),''),chr(13),'') as manageuserid
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_loanafteroversee 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_loanafteroversee_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes