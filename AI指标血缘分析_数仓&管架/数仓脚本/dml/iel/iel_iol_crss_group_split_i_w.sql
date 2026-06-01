: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_group_split_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_group_split_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(serialno,chr(10),''),chr(13),'') as serialno
,replace(replace(customerid,chr(10),''),chr(13),'') as customerid
,replace(replace(customername,chr(10),''),chr(13),'') as customername
,replace(replace(businesssum,chr(10),''),chr(13),'') as businesssum
,replace(replace(totalsum,chr(10),''),chr(13),'') as totalsum
,replace(replace(currency,chr(10),''),chr(13),'') as currency
,replace(replace(attribute3,chr(10),''),chr(13),'') as attribute3
,replace(replace(inputuserid,chr(10),''),chr(13),'') as inputuserid
,replace(replace(inputorgid,chr(10),''),chr(13),'') as inputorgid
,replace(replace(inputdate,chr(10),''),chr(13),'') as inputdate
,replace(replace(attribute2,chr(10),''),chr(13),'') as attribute2
,replace(replace(attribute1,chr(10),''),chr(13),'') as attribute1
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_group_split 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_group_split_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes