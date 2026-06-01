: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_cms_code_library_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_cms_code_library_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
codeno
,itemno
,itemname
,bankno
,sortno
,isinuse
,itemdescribe
,itemattribute
,relativecode
,attribute1
,attribute2
,attribute3
,attribute4
,attribute5
,attribute6
,attribute7
,attribute8
,inputuser
,inputorg
,inputtime
,updateuser
,updatetime
,remark
,helptext
,guarantyinfo
,remark2
from ${idl_schema}.crms_cms_code_library
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_cms_code_library_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes