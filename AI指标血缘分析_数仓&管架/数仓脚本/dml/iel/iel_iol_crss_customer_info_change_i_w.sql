: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_customer_info_change_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_customer_info_change_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(serialno,chr(10),''),chr(13),'') as serialno
,replace(replace(customerid,chr(10),''),chr(13),'') as customerid
,replace(replace(oldcustomername,chr(10),''),chr(13),'') as oldcustomername
,replace(replace(newcustomername,chr(10),''),chr(13),'') as newcustomername
,replace(replace(customertype,chr(10),''),chr(13),'') as customertype
,replace(replace(oldcerttype,chr(10),''),chr(13),'') as oldcerttype
,replace(replace(newcerttype,chr(10),''),chr(13),'') as newcerttype
,replace(replace(oldcertid,chr(10),''),chr(13),'') as oldcertid
,replace(replace(newcertid,chr(10),''),chr(13),'') as newcertid
,replace(replace(oldloancardno,chr(10),''),chr(13),'') as oldloancardno
,replace(replace(newloancardno,chr(10),''),chr(13),'') as newloancardno
,replace(replace(inputorgid,chr(10),''),chr(13),'') as inputorgid
,replace(replace(inputuserid,chr(10),''),chr(13),'') as inputuserid
,replace(replace(inputdate,chr(10),''),chr(13),'') as inputdate
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_customer_info_change 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_customer_info_change_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes