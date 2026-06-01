: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_code_library_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_code_library.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.codeno,chr(13),''),chr(10),'') as codeno
,replace(replace(t.itemno,chr(13),''),chr(10),'') as itemno
,replace(replace(t.itemname,chr(13),''),chr(10),'') as itemname
,replace(replace(t.bankno,chr(13),''),chr(10),'') as bankno
,replace(replace(t.sortno,chr(13),''),chr(10),'') as sortno
,replace(replace(t.isinuse,chr(13),''),chr(10),'') as isinuse
,replace(replace(t.itemdescribe,chr(13),''),chr(10),'') as itemdescribe
,replace(replace(t.itemattribute,chr(13),''),chr(10),'') as itemattribute
,replace(replace(t.relativecode,chr(13),''),chr(10),'') as relativecode
,replace(replace(t.attribute1,chr(13),''),chr(10),'') as attribute1
,replace(replace(t.attribute2,chr(13),''),chr(10),'') as attribute2
,replace(replace(t.attribute3,chr(13),''),chr(10),'') as attribute3
,replace(replace(t.attribute4,chr(13),''),chr(10),'') as attribute4
,replace(replace(t.attribute5,chr(13),''),chr(10),'') as attribute5
,replace(replace(t.attribute6,chr(13),''),chr(10),'') as attribute6
,replace(replace(t.attribute7,chr(13),''),chr(10),'') as attribute7
,replace(replace(t.attribute8,chr(13),''),chr(10),'') as attribute8
,replace(replace(t.inputuser,chr(13),''),chr(10),'') as inputuser
,replace(replace(t.inputorg,chr(13),''),chr(10),'') as inputorg
,replace(replace(t.inputtime,chr(13),''),chr(10),'') as inputtime
,replace(replace(t.updateuser,chr(13),''),chr(10),'') as updateuser
,replace(replace(t.updatetime,chr(13),''),chr(10),'') as updatetime
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t.helptext,chr(13),''),chr(10),'') as helptext
,replace(replace(t.guarantyinfo,chr(13),''),chr(10),'') as guarantyinfo
,replace(replace(t.remark2,chr(13),''),chr(10),'') as remark2
,replace(replace(t.dscode,chr(13),''),chr(10),'') as dscode
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.crss_code_library t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_code_library.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes