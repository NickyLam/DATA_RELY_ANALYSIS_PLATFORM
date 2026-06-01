: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_crss_code_library_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_crss_code_library.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.codeno,chr(13),''),chr(10),'') as codeno
,replace(replace(t1.itemno,chr(13),''),chr(10),'') as itemno
,replace(replace(t1.itemname,chr(13),''),chr(10),'') as itemname
,replace(replace(t1.bankno,chr(13),''),chr(10),'') as bankno
,replace(replace(t1.sortno,chr(13),''),chr(10),'') as sortno
,replace(replace(t1.isinuse,chr(13),''),chr(10),'') as isinuse
,replace(replace(t1.itemdescribe,chr(13),''),chr(10),'') as itemdescribe
,replace(replace(t1.itemattribute,chr(13),''),chr(10),'') as itemattribute
,replace(replace(t1.relativecode,chr(13),''),chr(10),'') as relativecode
,replace(replace(t1.attribute1,chr(13),''),chr(10),'') as attribute1
,replace(replace(t1.attribute2,chr(13),''),chr(10),'') as attribute2
,replace(replace(t1.attribute3,chr(13),''),chr(10),'') as attribute3
,replace(replace(t1.attribute4,chr(13),''),chr(10),'') as attribute4
,replace(replace(t1.attribute5,chr(13),''),chr(10),'') as attribute5
,replace(replace(t1.attribute6,chr(13),''),chr(10),'') as attribute6
,replace(replace(t1.attribute7,chr(13),''),chr(10),'') as attribute7
,replace(replace(t1.attribute8,chr(13),''),chr(10),'') as attribute8
,replace(replace(t1.inputuser,chr(13),''),chr(10),'') as inputuser
,replace(replace(t1.inputorg,chr(13),''),chr(10),'') as inputorg
,replace(replace(t1.inputtime,chr(13),''),chr(10),'') as inputtime
,replace(replace(t1.updateuser,chr(13),''),chr(10),'') as updateuser
,replace(replace(t1.updatetime,chr(13),''),chr(10),'') as updatetime
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.helptext,chr(13),''),chr(10),'') as helptext
,replace(replace(t1.guarantyinfo,chr(13),''),chr(10),'') as guarantyinfo
,replace(replace(t1.remark2,chr(13),''),chr(10),'') as remark2
,replace(replace(t1.dscode,chr(13),''),chr(10),'') as dscode
from ${iol_schema}.crss_code_library t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_crss_code_library.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes