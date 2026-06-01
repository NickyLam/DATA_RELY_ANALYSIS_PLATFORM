: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_crss_customer_belong_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_crss_customer_belong.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.orgid,chr(13),''),chr(10),'') as orgid
,replace(replace(t1.userid,chr(13),''),chr(10),'') as userid
,replace(replace(t1.belongattribute,chr(13),''),chr(10),'') as belongattribute
,replace(replace(t1.belongattribute1,chr(13),''),chr(10),'') as belongattribute1
,replace(replace(t1.belongattribute2,chr(13),''),chr(10),'') as belongattribute2
,replace(replace(t1.belongattribute3,chr(13),''),chr(10),'') as belongattribute3
,replace(replace(t1.belongattribute4,chr(13),''),chr(10),'') as belongattribute4
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.inputdate,chr(13),''),chr(10),'') as inputdate
,replace(replace(t1.updatedate,chr(13),''),chr(10),'') as updatedate
,replace(replace(t1.applyattribute,chr(13),''),chr(10),'') as applyattribute
,replace(replace(t1.applyattribute1,chr(13),''),chr(10),'') as applyattribute1
,replace(replace(t1.applyattribute2,chr(13),''),chr(10),'') as applyattribute2
,replace(replace(t1.applyattribute3,chr(13),''),chr(10),'') as applyattribute3
,replace(replace(t1.applyattribute4,chr(13),''),chr(10),'') as applyattribute4
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.applystatus,chr(13),''),chr(10),'') as applystatus
,replace(replace(t1.applyreason,chr(13),''),chr(10),'') as applyreason
,replace(replace(t1.applyright,chr(13),''),chr(10),'') as applyright
,replace(replace(t1.applytype,chr(13),''),chr(10),'') as applytype
,replace(replace(t1.isinuse,chr(13),''),chr(10),'') as isinuse
from ${iol_schema}.crss_customer_belong t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_crss_customer_belong.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes