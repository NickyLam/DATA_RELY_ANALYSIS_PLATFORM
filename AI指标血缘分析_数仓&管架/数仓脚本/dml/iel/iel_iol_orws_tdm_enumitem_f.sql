: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_orws_tdm_enumitem_f
CreateDate: 20240101
FileName:   ${iel_data_path}/orws_tdm_enumitem.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,enumid
,enumsortid
,superenumid
,replace(replace(t1.enumword,chr(13),''),chr(10),'') as enumword
,replace(replace(t1.code,chr(13),''),chr(10),'') as code
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,seqno
,status
,managetype
,isdefault
,iscanselect
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark

from ${iol_schema}.orws_tdm_enumitem t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/orws_tdm_enumitem.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
