: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ecrs_customer_fsrecord_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ecrs_customer_fsrecord_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 customerid
,recordno
,reportdate
,reportscope
,reportperiod
,reportcurrency
,reportunit
,reportstatus
,reportflag
,reportopinion
,auditflag
,auditoffice
,auditopinion
,inputdate
,orgid
,userid
,updatedate
,remark
,modelclass
from idl.ecrs_customer_fsrecord
where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/ecrs_customer_fsrecord_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes