: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_cl_credit_relation_f
CreateDate: 20240725
FileName:   ${iel_data_path}/icms_cl_credit_relation.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,actualoccupyexposureamount
,updatedate
,replace(replace(t1.creditno,chr(13),''),chr(10),'') as creditno
,replace(replace(t1.roletype,chr(13),''),chr(10),'') as roletype
,replace(replace(t1.relativecreditno,chr(13),''),chr(10),'') as relativecreditno
,occupyexposureamount
,replace(replace(t1.createdway,chr(13),''),chr(10),'') as createdway
,occupycoefficient
,replace(replace(t1.effect,chr(13),''),chr(10),'') as effect
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.occupycurrency,chr(13),''),chr(10),'') as occupycurrency
,inputdate
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,execslowreleaseexposureamount
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,occupynominalamount
,actualoccupynominalamount
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.relativetype,chr(13),''),chr(10),'') as relativetype

from ${iol_schema}.icms_cl_credit_relation t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_cl_credit_relation.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
