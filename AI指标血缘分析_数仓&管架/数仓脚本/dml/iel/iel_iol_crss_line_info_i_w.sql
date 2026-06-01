: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_line_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_line_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(serialno,chr(10),''),chr(13),'') as serialno
,replace(replace(parentserialno,chr(10),''),chr(13),'') as parentserialno
,replace(replace(businesstype,chr(10),''),chr(13),'') as businesstype
,replace(replace(relobjecttype,chr(10),''),chr(13),'') as relobjecttype
,replace(replace(relobjectno,chr(10),''),chr(13),'') as relobjectno
,replace(replace(customerid,chr(10),''),chr(13),'') as customerid
,replace(replace(customername,chr(10),''),chr(13),'') as customername
,replace(replace(businesscurrency,chr(10),''),chr(13),'') as businesscurrency
,replace(replace(businesssum,chr(10),''),chr(13),'') as businesssum
,replace(replace(totalsum,chr(10),''),chr(13),'') as totalsum
,replace(replace(isexclusive,chr(10),''),chr(13),'') as isexclusive
,replace(replace(iscycled,chr(10),''),chr(13),'') as iscycled
,replace(replace(bailrate,chr(10),''),chr(13),'') as bailrate
,replace(replace(operatemode,chr(10),''),chr(13),'') as operatemode
,replace(replace(termmonth,chr(10),''),chr(13),'') as termmonth
,replace(replace(termtype,chr(10),''),chr(13),'') as termtype
,replace(replace(termvalue,chr(10),''),chr(13),'') as termvalue
,replace(replace(begindate,chr(10),''),chr(13),'') as begindate
,replace(replace(enddate,chr(10),''),chr(13),'') as enddate
,replace(replace(inputuser,chr(10),''),chr(13),'') as inputuser
,replace(replace(inputorg,chr(10),''),chr(13),'') as inputorg
,replace(replace(inputtime,chr(10),''),chr(13),'') as inputtime
,replace(replace(updatetime,chr(10),''),chr(13),'') as updatetime
,replace(replace(remark,chr(10),''),chr(13),'') as remark
,replace(replace(investway,chr(10),''),chr(13),'') as investway
,replace(replace(onlineamount,chr(10),''),chr(13),'') as onlineamount
,replace(replace(ischuanyong,chr(10),''),chr(13),'') as ischuanyong
,replace(replace(lastbusinesssum,chr(10),''),chr(13),'') as lastbusinesssum
,replace(replace(lasttotalsum,chr(10),''),chr(13),'') as lasttotalsum
,replace(replace(lastonlineamount,chr(10),''),chr(13),'') as lastonlineamount
,replace(replace(businesssumentpart,chr(10),''),chr(13),'') as businesssumentpart
,replace(replace(totalsumentpart,chr(10),''),chr(13),'') as totalsumentpart
,replace(replace(businesssumtypart,chr(10),''),chr(13),'') as businesssumtypart
,replace(replace(totalsumtypart,chr(10),''),chr(13),'') as totalsumtypart
,replace(replace(lastbusinesssumentpart,chr(10),''),chr(13),'') as lastbusinesssumentpart
,replace(replace(lasttotalsumentpart,chr(10),''),chr(13),'') as lasttotalsumentpart
,replace(replace(lastbusinesssumtypart,chr(10),''),chr(13),'') as lastbusinesssumtypart
,replace(replace(lasttotalsumtypart,chr(10),''),chr(13),'') as lasttotalsumtypart
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_line_info 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_line_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes