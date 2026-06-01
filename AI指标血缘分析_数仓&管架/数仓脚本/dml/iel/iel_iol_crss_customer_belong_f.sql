: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_customer_belong_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_customer_belong.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t.orgid,chr(13),''),chr(10),'') as orgid
,replace(replace(t.userid,chr(13),''),chr(10),'') as userid
,replace(replace(t.belongattribute,chr(13),''),chr(10),'') as belongattribute
,replace(replace(t.belongattribute1,chr(13),''),chr(10),'') as belongattribute1
,replace(replace(t.belongattribute2,chr(13),''),chr(10),'') as belongattribute2
,replace(replace(t.belongattribute3,chr(13),''),chr(10),'') as belongattribute3
,replace(replace(t.belongattribute4,chr(13),''),chr(10),'') as belongattribute4
,replace(replace(t.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t.inputdate,chr(13),''),chr(10),'') as inputdate
,replace(replace(t.updatedate,chr(13),''),chr(10),'') as updatedate
,replace(replace(t.applyattribute,chr(13),''),chr(10),'') as applyattribute
,replace(replace(t.applyattribute1,chr(13),''),chr(10),'') as applyattribute1
,replace(replace(t.applyattribute2,chr(13),''),chr(10),'') as applyattribute2
,replace(replace(t.applyattribute3,chr(13),''),chr(10),'') as applyattribute3
,replace(replace(t.applyattribute4,chr(13),''),chr(10),'') as applyattribute4
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t.applystatus,chr(13),''),chr(10),'') as applystatus
,replace(replace(t.applyreason,chr(13),''),chr(10),'') as applyreason
,replace(replace(t.applyright,chr(13),''),chr(10),'') as applyright
,replace(replace(t.applytype,chr(13),''),chr(10),'') as applytype
,replace(replace(t.isinuse,chr(13),''),chr(10),'') as isinuse
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.crss_customer_belong t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_customer_belong.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes