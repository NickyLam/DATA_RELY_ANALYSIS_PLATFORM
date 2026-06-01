: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_customer_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_customer_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,t1.certmaturity as certmaturity
,replace(replace(t1.manageuserid,chr(13),''),chr(10),'') as manageuserid
,t1.inputdate as inputdate
,replace(replace(t1.mfcustomerid,chr(13),''),chr(10),'') as mfcustomerid
,replace(replace(t1.completeflag,chr(13),''),chr(10),'') as completeflag
,replace(replace(t1.certcountry,chr(13),''),chr(10),'') as certcountry
,replace(replace(t1.certid,chr(13),''),chr(10),'') as certid
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.isassign,chr(13),''),chr(10),'') as isassign
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,t1.updatedate as updatedate
,replace(replace(t1.yxcustomerid,chr(13),''),chr(10),'') as yxcustomerid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.isselfbizcust,chr(13),''),chr(10),'') as isselfbizcust
,replace(replace(t1.corporgid,chr(13),''),chr(10),'') as corporgid
,replace(replace(t1.custflag,chr(13),''),chr(10),'') as custflag
,replace(replace(t1.certtype,chr(13),''),chr(10),'') as certtype
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.loancardno,chr(13),''),chr(10),'') as loancardno
,replace(replace(t1.manageorgid,chr(13),''),chr(10),'') as manageorgid
,replace(replace(t1.customertype,chr(13),''),chr(10),'') as customertype
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,replace(replace(t1.isimpoversee,chr(13),''),chr(10),'') as isimpoversee
,replace(replace(t1.isalarmsign,chr(13),''),chr(10),'') as isalarmsign
,replace(replace(t1.isrelated,chr(13),''),chr(10),'') as isrelated
,replace(replace(t1.migtoldvalue,chr(13),''),chr(10),'') as migtoldvalue
,replace(replace(t1.customertypelb,chr(13),''),chr(10),'') as customertypelb
from ${iol_schema}.icms_customer_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_customer_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes