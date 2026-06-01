: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_customer_belong_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_customer_belong.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.belongorgid,chr(13),''),chr(10),'') as belongorgid
,replace(replace(t1.belonguserid,chr(13),''),chr(10),'') as belonguserid
,replace(replace(t1.manageright,chr(13),''),chr(10),'') as manageright
,replace(replace(t1.editright,chr(13),''),chr(10),'') as editright
,replace(replace(t1.viewright,chr(13),''),chr(10),'') as viewright
,replace(replace(t1.businessright,chr(13),''),chr(10),'') as businessright
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,t1.inputdate as inputdate
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,t1.updatedate as updatedate
,replace(replace(t1.corporgid,chr(13),''),chr(10),'') as corporgid
,replace(replace(t1.businessright1,chr(13),''),chr(10),'') as businessright1
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,replace(replace(t1.migtoldvalue,chr(13),''),chr(10),'') as migtoldvalue
from ${iol_schema}.icms_customer_belong t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_customer_belong.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes