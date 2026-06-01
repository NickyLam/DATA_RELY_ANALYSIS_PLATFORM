: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_customer_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_customer_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(customerid,chr(10),''),chr(13),'') as customerid
,replace(replace(customername,chr(10),''),chr(13),'') as customername
,replace(replace(customertype,chr(10),''),chr(13),'') as customertype
,replace(replace(certtype,chr(10),''),chr(13),'') as certtype
,replace(replace(certid,chr(10),''),chr(13),'') as certid
,replace(replace(customerpassword,chr(10),''),chr(13),'') as customerpassword
,replace(replace(inputorgid,chr(10),''),chr(13),'') as inputorgid
,replace(replace(inputuserid,chr(10),''),chr(13),'') as inputuserid
,replace(replace(inputdate,chr(10),''),chr(13),'') as inputdate
,replace(replace(remark,chr(10),''),chr(13),'') as remark
,replace(replace(mfcustomerid,chr(10),''),chr(13),'') as mfcustomerid
,replace(replace(status,chr(10),''),chr(13),'') as status
,replace(replace(belonggroupid,chr(10),''),chr(13),'') as belonggroupid
,replace(replace(channel,chr(10),''),chr(13),'') as channel
,replace(replace(loancardno,chr(10),''),chr(13),'') as loancardno
,replace(replace(customerscale,chr(10),''),chr(13),'') as customerscale
,replace(replace(yxcustomerid,chr(10),''),chr(13),'') as yxcustomerid
,replace(replace(customerclassify,chr(10),''),chr(13),'') as customerclassify
,replace(replace(customertype2,chr(10),''),chr(13),'') as customertype2
,replace(replace(customertype1,chr(10),''),chr(13),'') as customertype1
,replace(replace(masterbalance1,chr(10),''),chr(13),'') as masterbalance1
,replace(replace(masterbalance2,chr(10),''),chr(13),'') as masterbalance2
,replace(replace(isinuse,chr(10),''),chr(13),'') as isinuse
,replace(replace(customerownership,chr(10),''),chr(13),'') as customerownership
,replace(replace(zrstate,chr(10),''),chr(13),'') as zrstate
,replace(replace(isassign,chr(10),''),chr(13),'') as isassign
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_customer_info 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_customer_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes