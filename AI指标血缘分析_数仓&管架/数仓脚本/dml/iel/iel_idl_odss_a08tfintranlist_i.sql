: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_a08tfintranlist_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_a08tfintranlist_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
mainseq
,sysid
,transdt
,transtime
,businesstrace
,businessno
,cmtno
,hosttrcd
,fronttrcd
,magebrn
,userid
,status
,hostdate
,hostnbr
,payacct
,payname
,incoacct
,inconame
,dataid
,errcode
,errms
,colsts
,transamt
,abscde
,colldt
from ${idl_schema}.odss_a08tfintranlist
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_a08tfintranlist_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes