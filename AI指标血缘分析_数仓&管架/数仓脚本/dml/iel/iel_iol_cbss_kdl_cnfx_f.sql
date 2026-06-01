: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_kdl_cnfx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_kdl_cnfx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.trandt,chr(13),''),chr(10),'') as trandt
,replace(replace(t.transq,chr(13),''),chr(10),'') as transq
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,replace(replace(t.dcmttp,chr(13),''),chr(10),'') as dcmttp
,replace(replace(t.dcmtno,chr(13),''),chr(10),'') as dcmtno
,replace(replace(t.dctpid,chr(13),''),chr(10),'') as dctpid
,replace(replace(t.frozsq,chr(13),''),chr(10),'') as frozsq
,replace(replace(t.oddctp,chr(13),''),chr(10),'') as oddctp
,replace(replace(t.oddcno,chr(13),''),chr(10),'') as oddcno
,replace(replace(t.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t.recvdt,chr(13),''),chr(10),'') as recvdt
,replace(replace(t.recvsq,chr(13),''),chr(10),'') as recvsq
,replace(replace(t.oddcid,chr(13),''),chr(10),'') as oddcid
from ${iol_schema}.cbss_kdl_cnfx t
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_kdl_cnfx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes