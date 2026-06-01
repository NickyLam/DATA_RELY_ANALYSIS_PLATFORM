: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_upl_corpbusiness_type_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_upl_corpbusiness_type_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(typeno,chr(10),''),chr(13),'') as typeno
,replace(replace(sortno,chr(10),''),chr(13),'') as sortno
,replace(replace(typename,chr(10),''),chr(13),'') as typename
,replace(replace(typesortno,chr(10),''),chr(13),'') as typesortno
,replace(replace(subtypecode,chr(10),''),chr(13),'') as subtypecode
,replace(replace(infoset,chr(10),''),chr(13),'') as infoset
,replace(replace(displaytemplet,chr(10),''),chr(13),'') as displaytemplet
,replace(replace(prolimit,chr(10),''),chr(13),'') as prolimit
,replace(replace(coretype,chr(10),''),chr(13),'') as coretype
,replace(replace(startdate,chr(10),''),chr(13),'') as startdate
,replace(replace(enddate,chr(10),''),chr(13),'') as enddate
,replace(replace(attribute5,chr(10),''),chr(13),'') as attribute5
,replace(replace(attribute6,chr(10),''),chr(13),'') as attribute6
,replace(replace(belongorg,chr(10),''),chr(13),'') as belongorg
,replace(replace(customerid,chr(10),''),chr(13),'') as customerid
,replace(replace(customername,chr(10),''),chr(13),'') as customername
,replace(replace(attribute10,chr(10),''),chr(13),'') as attribute10
,replace(replace(remark,chr(10),''),chr(13),'') as remark
,replace(replace(applydetailno,chr(10),''),chr(13),'') as applydetailno
,replace(replace(approvedetailno,chr(10),''),chr(13),'') as approvedetailno
,replace(replace(contractdetailno,chr(10),''),chr(13),'') as contractdetailno
,replace(replace(inputuser,chr(10),''),chr(13),'') as inputuser
,replace(replace(inputorg,chr(10),''),chr(13),'') as inputorg
,replace(replace(inputtime,chr(10),''),chr(13),'') as inputtime
,replace(replace(updateuser,chr(10),''),chr(13),'') as updateuser
,replace(replace(updatetime,chr(10),''),chr(13),'') as updatetime
,replace(replace(attribute11,chr(10),''),chr(13),'') as attribute11
,replace(replace(attribute12,chr(10),''),chr(13),'') as attribute12
,replace(replace(attribute13,chr(10),''),chr(13),'') as attribute13
,replace(replace(attribute14,chr(10),''),chr(13),'') as attribute14
,replace(replace(attribute15,chr(10),''),chr(13),'') as attribute15
,replace(replace(attribute16,chr(10),''),chr(13),'') as attribute16
,replace(replace(attribute17,chr(10),''),chr(13),'') as attribute17
,replace(replace(attribute18,chr(10),''),chr(13),'') as attribute18
,replace(replace(attribute19,chr(10),''),chr(13),'') as attribute19
,replace(replace(attribute20,chr(10),''),chr(13),'') as attribute20
,replace(replace(attribute21,chr(10),''),chr(13),'') as attribute21
,replace(replace(attribute22,chr(10),''),chr(13),'') as attribute22
,replace(replace(attribute23,chr(10),''),chr(13),'') as attribute23
,replace(replace(attribute24,chr(10),''),chr(13),'') as attribute24
,replace(replace(attribute25,chr(10),''),chr(13),'') as attribute25
,replace(replace(isinuse,chr(10),''),chr(13),'') as isinuse
,replace(replace(cklstlist,chr(10),''),chr(13),'') as cklstlist
,replace(replace(isloancontrol,chr(10),''),chr(13),'') as isloancontrol
,replace(replace(trytype,chr(10),''),chr(13),'') as trytype
,replace(replace(rwaattribute,chr(10),''),chr(13),'') as rwaattribute
,replace(replace(productrate,chr(10),''),chr(13),'') as productrate
,replace(replace(bailrate,chr(10),''),chr(13),'') as bailrate
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_upl_corpbusiness_type 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_upl_corpbusiness_type_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes