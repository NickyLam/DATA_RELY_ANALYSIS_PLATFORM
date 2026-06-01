: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_bdms_buy_source_info_f
CreateDate: 20230925
FileName:   ${iel_data_path}/bdms_buy_source_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.draftid,chr(13),''),chr(10),'') as draftid
,replace(replace(t1.draftnumber,chr(13),''),chr(10),'') as draftnumber
,replace(replace(t1.cdrange,chr(13),''),chr(10),'') as cdrange
,replace(replace(t1.srctype,chr(13),''),chr(10),'') as srctype
,replace(replace(t1.contractid,chr(13),''),chr(10),'') as contractid
,replace(replace(t1.productno,chr(13),''),chr(10),'') as productno
,replace(replace(t1.busidate,chr(13),''),chr(10),'') as busidate
,replace(replace(t1.innerflag,chr(13),''),chr(10),'') as innerflag
,rate
,replace(replace(t1.firstsource,chr(13),''),chr(10),'') as firstsource
,remainterest
,replace(replace(t1.acctbranchno,chr(13),''),chr(10),'') as acctbranchno
,replace(replace(t1.dealid,chr(13),''),chr(10),'') as dealid
,replace(replace(t1.seq,chr(13),''),chr(10),'') as seq

from ${iol_schema}.bdms_buy_source_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_buy_source_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
