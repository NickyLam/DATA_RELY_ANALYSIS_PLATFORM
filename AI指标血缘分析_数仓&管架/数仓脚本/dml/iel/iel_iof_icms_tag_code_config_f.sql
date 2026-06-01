: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_tag_code_config_f
CreateDate: 20241113
FileName:   ${iel_data_path}/icms_tag_code_config.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.tagid,chr(13),''),chr(10),'') as tagid
,replace(replace(t1.sortno,chr(13),''),chr(10),'') as sortno
,replace(replace(t1.itemno,chr(13),''),chr(10),'') as itemno
,replace(replace(t1.itemname,chr(13),''),chr(10),'') as itemname
,replace(replace(t1.isinuse,chr(13),''),chr(10),'') as isinuse
,replace(replace(t1.attribute1,chr(13),''),chr(10),'') as attribute1
,replace(replace(t1.attribute2,chr(13),''),chr(10),'') as attribute2
,replace(replace(t1.attribute3,chr(13),''),chr(10),'') as attribute3
,replace(replace(t1.attribute4,chr(13),''),chr(10),'') as attribute4
,replace(replace(t1.attribute5,chr(13),''),chr(10),'') as attribute5
,replace(replace(t1.attribute6,chr(13),''),chr(10),'') as attribute6
,replace(replace(t1.attribute7,chr(13),''),chr(10),'') as attribute7
,replace(replace(t1.attribute8,chr(13),''),chr(10),'') as attribute8
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate

from ${iol_schema}.icms_tag_code_config t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_tag_code_config.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
