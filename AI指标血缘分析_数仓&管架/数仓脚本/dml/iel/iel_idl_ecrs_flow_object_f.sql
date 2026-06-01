: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ecrs_flow_object_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ecrs_flow_object_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 objecttype
,objectno
,phasetype
,applytype
,flowno
,flowname
,phaseno
,phasename
,objdescribe
,objattribute1
,objattribute2
,objattribute3
,objattribute4
,objattribute5
,orgid
,orgname
,userid
,username
,inputdate
,archivetime
from idl.ecrs_flow_object
where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/ecrs_flow_object_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes