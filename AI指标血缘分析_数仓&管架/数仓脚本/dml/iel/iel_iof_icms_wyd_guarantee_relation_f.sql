: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_wyd_guarantee_relation_f
CreateDate: 20250224
FileName:   ${iel_data_path}/icms_wyd_guarantee_relation.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.datadt,chr(13),''),chr(10),'') as datadt
,replace(replace(t1.contractno,chr(13),''),chr(10),'') as contractno
,replace(replace(t1.lendingref,chr(13),''),chr(10),'') as lendingref
,replace(replace(t1.guarcontractno,chr(13),''),chr(10),'') as guarcontractno
,replace(replace(t1.orgid,chr(13),''),chr(10),'') as orgid
,loanbalance
,guarantyamt
,replace(replace(t1.guarantystat,chr(13),''),chr(10),'') as guarantystat
,replace(replace(t1.inputtime,chr(13),''),chr(10),'') as inputtime
,replace(replace(t1.maturitydate,chr(13),''),chr(10),'') as maturitydate
,replace(replace(t1.merchantid,chr(13),''),chr(10),'') as merchantid
,loanquota
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.classifyresult,chr(13),''),chr(10),'') as classifyresult

from ${iol_schema}.icms_wyd_guarantee_relation t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_wyd_guarantee_relation.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
