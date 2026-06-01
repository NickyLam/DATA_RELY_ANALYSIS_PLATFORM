: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_customer_belong_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_customer_belong_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(customerid,chr(10),''),chr(13),'') as customerid
,replace(replace(orgid,chr(10),''),chr(13),'') as orgid
,replace(replace(userid,chr(10),''),chr(13),'') as userid
,replace(replace(belongattribute,chr(10),''),chr(13),'') as belongattribute
,replace(replace(belongattribute1,chr(10),''),chr(13),'') as belongattribute1
,replace(replace(belongattribute2,chr(10),''),chr(13),'') as belongattribute2
,replace(replace(belongattribute3,chr(10),''),chr(13),'') as belongattribute3
,replace(replace(belongattribute4,chr(10),''),chr(13),'') as belongattribute4
,replace(replace(inputuserid,chr(10),''),chr(13),'') as inputuserid
,replace(replace(inputorgid,chr(10),''),chr(13),'') as inputorgid
,replace(replace(inputdate,chr(10),''),chr(13),'') as inputdate
,replace(replace(updatedate,chr(10),''),chr(13),'') as updatedate
,replace(replace(applyattribute,chr(10),''),chr(13),'') as applyattribute
,replace(replace(applyattribute1,chr(10),''),chr(13),'') as applyattribute1
,replace(replace(applyattribute2,chr(10),''),chr(13),'') as applyattribute2
,replace(replace(applyattribute3,chr(10),''),chr(13),'') as applyattribute3
,replace(replace(applyattribute4,chr(10),''),chr(13),'') as applyattribute4
,replace(replace(remark,chr(10),''),chr(13),'') as remark
,replace(replace(applystatus,chr(10),''),chr(13),'') as applystatus
,replace(replace(applyreason,chr(10),''),chr(13),'') as applyreason
,replace(replace(applyright,chr(10),''),chr(13),'') as applyright
,replace(replace(applytype,chr(10),''),chr(13),'') as applytype
,replace(replace(isinuse,chr(10),''),chr(13),'') as isinuse
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_customer_belong 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_customer_belong_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes