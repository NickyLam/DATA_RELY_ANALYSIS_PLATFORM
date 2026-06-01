: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ecrs_lcb_yk_acpt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ecrs_lcb_yk_acpt_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 dataid
,acptno
,acptbr
,pyerac
,crcycd
,bltype
,notetp
,noteam
,handam
,gretno
,grsbac
,graito
,termcd
,issudt
,closdt
,clossq
,acptst
,closst
,pymcdt
,pymcsq
,pymctp
,aclfam
,matudt
,pymcac
,lncfno
from idl.ecrs_lcb_yk_acpt
where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/ecrs_lcb_yk_acpt_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes