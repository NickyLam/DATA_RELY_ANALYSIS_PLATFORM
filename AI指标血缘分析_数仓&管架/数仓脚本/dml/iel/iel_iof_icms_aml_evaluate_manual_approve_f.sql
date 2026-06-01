: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_aml_evaluate_manual_approve_f
CreateDate: 20240328
FileName:   ${iel_data_path}/icms_aml_evaluate_manual_approve.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.objectno,chr(13),''),chr(10),'') as objectno
,replace(replace(t1.objecttype,chr(13),''),chr(10),'') as objecttype
,replace(replace(t1.flowtaskserialno,chr(13),''),chr(10),'') as flowtaskserialno
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.manualapprovaldescribe,chr(13),''),chr(10),'') as manualapprovaldescribe
,replace(replace(t1.processstatus,chr(13),''),chr(10),'') as processstatus
,replace(replace(t1.processreason,chr(13),''),chr(10),'') as processreason
,replace(replace(t1.addsource,chr(13),''),chr(10),'') as addsource
,replace(replace(t1.completeflag,chr(13),''),chr(10),'') as completeflag
,replace(replace(t1.approvestatus,chr(13),''),chr(10),'') as approvestatus
,replace(replace(t1.operateuserid,chr(13),''),chr(10),'') as operateuserid
,replace(replace(t1.operateorgid,chr(13),''),chr(10),'') as operateorgid
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate

from ${iol_schema}.icms_aml_evaluate_manual_approve t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_aml_evaluate_manual_approve.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
