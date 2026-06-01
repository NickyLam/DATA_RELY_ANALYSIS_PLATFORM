: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_customer_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_customer_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t.customertype,chr(13),''),chr(10),'') as customertype
,replace(replace(t.certtype,chr(13),''),chr(10),'') as certtype
,replace(replace(t.certid,chr(13),''),chr(10),'') as certid
,replace(replace(t.customerpassword,chr(13),''),chr(10),'') as customerpassword
,replace(replace(t.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t.inputdate,chr(13),''),chr(10),'') as inputdate
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t.mfcustomerid,chr(13),''),chr(10),'') as mfcustomerid
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,replace(replace(t.belonggroupid,chr(13),''),chr(10),'') as belonggroupid
,replace(replace(t.channel,chr(13),''),chr(10),'') as channel
,replace(replace(t.loancardno,chr(13),''),chr(10),'') as loancardno
,replace(replace(t.customerscale,chr(13),''),chr(10),'') as customerscale
,replace(replace(t.yxcustomerid,chr(13),''),chr(10),'') as yxcustomerid
,replace(replace(t.customerclassify,chr(13),''),chr(10),'') as customerclassify
,replace(replace(t.customertype2,chr(13),''),chr(10),'') as customertype2
,replace(replace(t.customertype1,chr(13),''),chr(10),'') as customertype1
,t.masterbalance1 as masterbalance1
,t.masterbalance2 as masterbalance2
,replace(replace(t.isinuse,chr(13),''),chr(10),'') as isinuse
,replace(replace(t.customerownership,chr(13),''),chr(10),'') as customerownership
,replace(replace(t.zrstate,chr(13),''),chr(10),'') as zrstate
,replace(replace(t.isassign,chr(13),''),chr(10),'') as isassign
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.crss_customer_info t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_customer_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes