: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_icms_business_info_total_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_icms_business_info_total.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.txndt as txndt
,replace(replace(t1.txntm,chr(13),''),chr(10),'') as txntm
,replace(replace(t1.blngorgid,chr(13),''),chr(10),'') as blngorgid
,replace(replace(t1.opertellerid,chr(13),''),chr(10),'') as opertellerid
,replace(replace(t1.opertellername,chr(13),''),chr(10),'') as opertellername
,replace(replace(t1.authtellerid,chr(13),''),chr(10),'') as authtellerid
,replace(replace(t1.authtellername,chr(13),''),chr(10),'') as authtellername
,replace(replace(t1.txnnum,chr(13),''),chr(10),'') as txnnum
,replace(replace(t1.txndesc,chr(13),''),chr(10),'') as txndesc
,replace(replace(t1.bizsysevtid,chr(13),''),chr(10),'') as bizsysevtid
,replace(replace(t1.bcsevtid,chr(13),''),chr(10),'') as bcsevtid
,replace(replace(t1.datasrccd,chr(13),''),chr(10),'') as datasrccd
,replace(replace(t1.payagtid,chr(13),''),chr(10),'') as payagtid
,replace(replace(t1.rcvagtid,chr(13),''),chr(10),'') as rcvagtid
,t1.txnamt as txnamt
,t1.etldt as etldt
,replace(replace(t1.menuid,chr(13),''),chr(10),'') as menuid
,replace(replace(t1.eftflag,chr(13),''),chr(10),'') as eftflag
,replace(replace(t1.servflag,chr(13),''),chr(10),'') as servflag
,replace(replace(t1.acctflag,chr(13),''),chr(10),'') as acctflag
,replace(replace(t1.caflag,chr(13),''),chr(10),'') as caflag
,replace(replace(t1.bdflag,chr(13),''),chr(10),'') as bdflag
from ${iol_schema}.icms_icms_business_info_total t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_icms_business_info_total.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes