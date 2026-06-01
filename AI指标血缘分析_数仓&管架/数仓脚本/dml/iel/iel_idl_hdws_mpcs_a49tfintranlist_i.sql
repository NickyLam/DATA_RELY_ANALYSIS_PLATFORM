: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_mpcs_a49tfintranlist_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_mpcs_a49tfintranlist.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.mainseq
,t1.transdt
,t1.sysid
,t1.transtime
,t1.unotnbr
,t1.unotdate
,t1.hosttrcd
,t1.fronttrcd
,t1.magbrn
,t1.userid
,t1.status
,t1.hostdate
,t1.hostnbr
,t1.payacct
,t1.payname
,t1.incoacct
,t1.inconame
,t1.dataid
,t1.errcode
,t1.errms
,t1.colsts
,t1.transamt
,t1.abscde
,t1.colldate
,t1.eaccflg
,t1.transeqno
,t1.globalseqno
from ${idl_schema}.hdws_mpcs_a49tfintranlist t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_mpcs_a49tfintranlist.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes