: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_a02tcontractacctinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_a02tcontractacctinfo_${batch_date}_f.dat
IF_mark:    F
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
MAINCONTRACTNO
,CONTRACTNO
,CUSTNO
,ACCTNO
,SIGNDT
,SIGNBRCNO
,SIGNTLRNO
,SIGNSEQNO
,UNSIGNDT
,UNSIGNBRCNO
,UNSIGNTLRNO
,UNSIGNSEQNO
,CONTRACTSTAT
,MEMO
from ${idl_schema}.ODSS_A02TCONTRACTACCTINFO
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_a02tcontractacctinfo_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes