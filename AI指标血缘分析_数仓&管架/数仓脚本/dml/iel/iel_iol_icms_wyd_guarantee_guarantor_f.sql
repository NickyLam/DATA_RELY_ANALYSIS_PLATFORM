: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_wyd_guarantee_guarantor_f
CreateDate: 20250224
FileName:   ${iel_data_path}/icms_wyd_guarantee_guarantor.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.datadt,chr(13),''),chr(10),'') as datadt
,replace(replace(t1.guarcontractno,chr(13),''),chr(10),'') as guarcontractno
,replace(replace(t1.guarantorcustid,chr(13),''),chr(10),'') as guarantorcustid
,replace(replace(t1.orgid,chr(13),''),chr(10),'') as orgid
,replace(replace(t1.risktype,chr(13),''),chr(10),'') as risktype
,replace(replace(t1.guarantortype,chr(13),''),chr(10),'') as guarantortype
,replace(replace(t1.guarantorname,chr(13),''),chr(10),'') as guarantorname
,replace(replace(t1.guarantoridtype,chr(13),''),chr(10),'') as guarantoridtype
,replace(replace(t1.guarantoridno,chr(13),''),chr(10),'') as guarantoridno
,guarantyvaluelimit
,guarantorasset
,guarantyvalue
,replace(replace(t1.merchantid,chr(13),''),chr(10),'') as merchantid
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.classifyresult,chr(13),''),chr(10),'') as classifyresult

from ${iol_schema}.icms_wyd_guarantee_guarantor t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_wyd_guarantee_guarantor.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
