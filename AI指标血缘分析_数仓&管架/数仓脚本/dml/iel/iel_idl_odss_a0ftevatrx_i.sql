: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_a0ftevatrx_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_a0ftevatrx_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
brchno
,brchnm
,jdgrslt
,trantlr
,trantrx
,trannm
,trandt
,fronttrcd
,jdgdttm
,srcsysid
,srctrndt
,srcseqno
,trancode
,jdgdt
from ${idl_schema}.odss_a0ftevatrx
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_a0ftevatrx_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes