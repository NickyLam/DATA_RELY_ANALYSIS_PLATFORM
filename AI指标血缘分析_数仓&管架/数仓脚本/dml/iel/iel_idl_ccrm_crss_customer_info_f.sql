: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_crss_customer_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_crss_customer_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.customertype,chr(13),''),chr(10),'') as customertype
,replace(replace(t1.certtype,chr(13),''),chr(10),'') as certtype
,replace(replace(t1.certid,chr(13),''),chr(10),'') as certid
,replace(replace(t1.customerpassword,chr(13),''),chr(10),'') as customerpassword
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputdate,chr(13),''),chr(10),'') as inputdate
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.mfcustomerid,chr(13),''),chr(10),'') as mfcustomerid
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.belonggroupid,chr(13),''),chr(10),'') as belonggroupid
,replace(replace(t1.channel,chr(13),''),chr(10),'') as channel
,replace(replace(t1.loancardno,chr(13),''),chr(10),'') as loancardno
,replace(replace(t1.customerscale,chr(13),''),chr(10),'') as customerscale
,replace(replace(t1.yxcustomerid,chr(13),''),chr(10),'') as yxcustomerid
,replace(replace(t1.customerclassify,chr(13),''),chr(10),'') as customerclassify
,replace(replace(t1.customertype2,chr(13),''),chr(10),'') as customertype2
,replace(replace(t1.customertype1,chr(13),''),chr(10),'') as customertype1
,t1.masterbalance1 as masterbalance1
,t1.masterbalance2 as masterbalance2
,replace(replace(t1.isinuse,chr(13),''),chr(10),'') as isinuse
,replace(replace(t1.customerownership,chr(13),''),chr(10),'') as customerownership
from ${iol_schema}.crss_customer_info t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_crss_customer_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes