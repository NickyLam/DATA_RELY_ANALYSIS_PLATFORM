: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_wyd_loan_relative_f
CreateDate: 20250224
FileName:   ${iel_data_path}/icms_wyd_loan_relative.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lendingref,chr(13),''),chr(10),'') as lendingref
,replace(replace(t1.relativelendingref,chr(13),''),chr(10),'') as relativelendingref
,replace(replace(t1.businesstype,chr(13),''),chr(10),'') as businesstype
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.classifyresult,chr(13),''),chr(10),'') as classifyresult

from ${iol_schema}.icms_wyd_loan_relative t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_wyd_loan_relative.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
