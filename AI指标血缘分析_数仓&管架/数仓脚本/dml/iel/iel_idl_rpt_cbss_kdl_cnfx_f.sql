: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_cbss_kdl_cnfx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_cbss_kdl_cnfx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.trandt,chr(13),''),chr(10),'') as trandt
,replace(replace(t1.transq,chr(13),''),chr(10),'') as transq
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.dcmttp,chr(13),''),chr(10),'') as dcmttp
,replace(replace(t1.dcmtno,chr(13),''),chr(10),'') as dcmtno
,replace(replace(t1.dctpid,chr(13),''),chr(10),'') as dctpid
,replace(replace(t1.frozsq,chr(13),''),chr(10),'') as frozsq
,replace(replace(t1.oddctp,chr(13),''),chr(10),'') as oddctp
,replace(replace(t1.oddcno,chr(13),''),chr(10),'') as oddcno
,replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t1.recvdt,chr(13),''),chr(10),'') as recvdt
,replace(replace(t1.recvsq,chr(13),''),chr(10),'') as recvsq
,replace(replace(t1.oddcid,chr(13),''),chr(10),'') as oddcid
 from iol.cbss_kdl_cnfx T1
where etl_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_cbss_kdl_cnfx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes