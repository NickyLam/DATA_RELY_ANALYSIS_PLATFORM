: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icms_code_library_f
CreateDate: 20250603
FileName:   ${iel_data_path}/icms_code_library.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.attribute6 as attribute6
,t1.inputuser as inputuser
,t1.attribute8 as attribute8
,t1.updatetime as updatetime
,t1.attribute3 as attribute3
,t1.helptext as helptext
,t1.attribute9 as attribute9
,t1.itemdescribe as itemdescribe
,t1.updatedate as updatedate
,t1.remark as remark
,t1.parentitemno as parentitemno
,t1.inputorg as inputorg
,t1.attribute1 as attribute1
,t1.attribute7 as attribute7
,t1.inputdate as inputdate
,t1.attribute5 as attribute5
,t1.attribute4 as attribute4
,t1.codeno as codeno
,t1.itemno as itemno
,t1.relativecode as relativecode
,t1.sortno as sortno
,t1.isinuse as isinuse
,t1.mappingcode as mappingcode
,t1.updateuser as updateuser
,t1.updateorg as updateorg
,t1.bankno as bankno
,t1.itemattribute as itemattribute
,t1.itemname as itemname
,t1.attribute2 as attribute2
,t1.inputtime as inputtime

from ${idl_schema}.icms_code_library t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_code_library.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
