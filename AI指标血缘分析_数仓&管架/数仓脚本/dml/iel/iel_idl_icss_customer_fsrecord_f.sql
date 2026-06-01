: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icss_customer_fsrecord_f
CreateDate: 20180529
FileName:   ${iel_data_path}/CUSTOMER_FSRECORD_${batch_date}_ALL.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select customerid
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
,modelclass from idl.icss_customer_fsrecord where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/CUSTOMER_FSRECORD_${batch_date}_ALL.dat" \
        charset=zhs16gbk
        safe=yes