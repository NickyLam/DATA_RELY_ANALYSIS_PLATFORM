: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_cbss_pfb_froz_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_cbss_pfb_froz.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.frozdt
,t1.frozsq
,t1.sortno
,t1.transq
,t1.frsptp
,t1.susbtp
,t1.status
,t1.acctno
,t1.subsac
,t1.acctna
,t1.refram
,t1.cufram
,t1.matudt
,t1.idtftp
,t1.idtfno
,t1.remktx
,t1.exorgn
,t1.exidtp
,t1.exidno
,t1.eidtp2
,t1.eidno2
,t1.exusna
,t1.exuna2
,t1.userid
,t1.brchno
,t1.servtp
from ${idl_schema}.hdws_cbss_pfb_froz t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_cbss_pfb_froz.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes