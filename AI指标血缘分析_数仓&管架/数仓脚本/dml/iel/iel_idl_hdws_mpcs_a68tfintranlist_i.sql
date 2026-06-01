: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_mpcs_a68tfintranlist_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_mpcs_a68tfintranlist.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.mainseq
,t1.transdt
,t1.transtime
,t1.businesstrace
,t1.transamt
,t1.pckno
,t1.hosttrcd
,t1.fronttrcd
,t1.magebrn
,t1.userid
,t1.status
,t1.hostdate
,t1.hostnbr
,t1.payacct
,t1.payname
,t1.rcvacct
,t1.rcvname
,t1.dataid
,t1.errcode
,t1.errms
,t1.colsts
,t1.abscde
,t1.colldt
,t1.upporderid
from ${idl_schema}.hdws_mpcs_a68tfintranlist t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_mpcs_a68tfintranlist.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes