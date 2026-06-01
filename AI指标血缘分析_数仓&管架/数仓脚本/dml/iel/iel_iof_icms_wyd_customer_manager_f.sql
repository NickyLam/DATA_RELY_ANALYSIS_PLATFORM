: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_wyd_customer_manager_f
CreateDate: 20250224
FileName:   ${iel_data_path}/icms_wyd_customer_manager.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.positions,chr(13),''),chr(10),'') as positions
,replace(replace(t1.managername,chr(13),''),chr(10),'') as managername
,replace(replace(t1.certtype,chr(13),''),chr(10),'') as certtype
,replace(replace(t1.certid,chr(13),''),chr(10),'') as certid
,replace(replace(t1.sex,chr(13),''),chr(10),'') as sex
,replace(replace(t1.birthday,chr(13),''),chr(10),'') as birthday
,replace(replace(t1.certbegindate,chr(13),''),chr(10),'') as certbegindate
,replace(replace(t1.certenddate,chr(13),''),chr(10),'') as certenddate
,replace(replace(t1.duty,chr(13),''),chr(10),'') as duty
,replace(replace(t1.telephone,chr(13),''),chr(10),'') as telephone
,replace(replace(t1.pcredit,chr(13),''),chr(10),'') as pcredit
,replace(replace(t1.updatedate1,chr(13),''),chr(10),'') as updatedate1
,replace(replace(t1.ratio,chr(13),''),chr(10),'') as ratio
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.position,chr(13),''),chr(10),'') as position
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.classifyresult,chr(13),''),chr(10),'') as classifyresult
,replace(replace(t1.custid,chr(13),''),chr(10),'') as custid

from ${iol_schema}.icms_wyd_customer_manager t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_wyd_customer_manager.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
