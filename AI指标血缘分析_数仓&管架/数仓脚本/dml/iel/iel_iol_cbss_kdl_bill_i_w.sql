: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_kdl_bill_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_kdl_bill_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.trandt,chr(13),''),chr(10),'') as trandt 
,replace(replace(t1.billsq,chr(13),''),chr(10),'') as billsq 
,replace(replace(t1.transq,chr(13),''),chr(10),'') as transq 
,replace(replace(t1.acctbr,chr(13),''),chr(10),'') as acctbr 
,replace(replace(t1.acctid,chr(13),''),chr(10),'') as acctid 
,replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno 
,replace(replace(t1.subsac,chr(13),''),chr(10),'') as subsac 
,replace(replace(t1.trantp,chr(13),''),chr(10),'') as trantp 
,replace(replace(t1.amntcd,chr(13),''),chr(10),'') as amntcd 
,replace(replace(t1.crcycd,chr(13),''),chr(10),'') as crcycd 
,t1.tranam as tranam 
,t1.tranbl as tranbl 
,replace(replace(t1.tranbr,chr(13),''),chr(10),'') as tranbr 
,replace(replace(t1.smrycd,chr(13),''),chr(10),'') as smrycd 
,replace(replace(t1.toacct,chr(13),''),chr(10),'') as toacct 
,replace(replace(t1.tosbac,chr(13),''),chr(10),'') as tosbac 
,replace(replace(t1.toacna,chr(13),''),chr(10),'') as toacna 
,replace(replace(t1.cheqtp,chr(13),''),chr(10),'') as cheqtp 
,replace(replace(t1.cheqno,chr(13),''),chr(10),'') as cheqno 
,replace(replace(t1.cqtpid,chr(13),''),chr(10),'') as cqtpid 
,replace(replace(t1.bkusid,chr(13),''),chr(10),'') as bkusid 
,replace(replace(t1.ckbkus,chr(13),''),chr(10),'') as ckbkus 
,replace(replace(t1.corrtg,chr(13),''),chr(10),'') as corrtg 
,replace(replace(t1.dscrtx,chr(13),''),chr(10),'') as dscrtx 
,replace(replace(t1.timstp,chr(13),''),chr(10),'') as timstp 
,replace(replace(t1.tmpflg,chr(13),''),chr(10),'') as tmpflg 
,replace(replace(t1.servtp,chr(13),''),chr(10),'') as servtp 
,replace(replace(t1.toacbr,chr(13),''),chr(10),'') as toacbr 
,replace(replace(t1.tobkna,chr(13),''),chr(10),'') as tobkna 
,replace(replace(t1.nckpwd,chr(13),''),chr(10),'') as nckpwd 
from ${iol_schema}.cbss_kdl_bill t1 
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_kdl_bill_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes