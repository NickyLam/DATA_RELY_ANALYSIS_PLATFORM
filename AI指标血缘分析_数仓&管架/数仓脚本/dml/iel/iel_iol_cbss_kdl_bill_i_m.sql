: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_kdl_bill_i_m
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_kdl_bill.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.trandt,chr(13),''),chr(10),'') as trandt
,replace(replace(t.billsq,chr(13),''),chr(10),'') as billsq
,replace(replace(t.transq,chr(13),''),chr(10),'') as transq
,replace(replace(t.acctbr,chr(13),''),chr(10),'') as acctbr
,replace(replace(t.acctid,chr(13),''),chr(10),'') as acctid
,replace(replace(t.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t.subsac,chr(13),''),chr(10),'') as subsac
,replace(replace(t.trantp,chr(13),''),chr(10),'') as trantp
,replace(replace(t.amntcd,chr(13),''),chr(10),'') as amntcd
,replace(replace(t.crcycd,chr(13),''),chr(10),'') as crcycd
,t.tranam as tranam
,t.tranbl as tranbl
,replace(replace(t.tranbr,chr(13),''),chr(10),'') as tranbr
,replace(replace(t.smrycd,chr(13),''),chr(10),'') as smrycd
,replace(replace(t.toacct,chr(13),''),chr(10),'') as toacct
,replace(replace(t.tosbac,chr(13),''),chr(10),'') as tosbac
,replace(replace(t.toacna,chr(13),''),chr(10),'') as toacna
,replace(replace(t.cheqtp,chr(13),''),chr(10),'') as cheqtp
,replace(replace(t.cheqno,chr(13),''),chr(10),'') as cheqno
,replace(replace(t.cqtpid,chr(13),''),chr(10),'') as cqtpid
,replace(replace(t.bkusid,chr(13),''),chr(10),'') as bkusid
,replace(replace(t.ckbkus,chr(13),''),chr(10),'') as ckbkus
,replace(replace(t.corrtg,chr(13),''),chr(10),'') as corrtg
,replace(replace(t.dscrtx,chr(13),''),chr(10),'') as dscrtx
,replace(replace(t.timstp,chr(13),''),chr(10),'') as timstp
,replace(replace(t.tmpflg,chr(13),''),chr(10),'') as tmpflg
,replace(replace(t.servtp,chr(13),''),chr(10),'') as servtp
,replace(replace(t.toacbr,chr(13),''),chr(10),'') as toacbr
,replace(replace(t.tobkna,chr(13),''),chr(10),'') as tobkna
,replace(replace(t.nckpwd,chr(13),''),chr(10),'') as nckpwd
from ${iol_schema}.cbss_kdl_bill t
where t.trandt >= to_char(trunc(to_date('${batch_date}','yyyymmdd'),'month'),'yyyymmdd')
and t.trandt <= to_char(to_date('${batch_date}','yyyymmdd'),'yyyymmdd') and t.etl_dt >= trunc(to_date('${batch_date}','yyyymmdd'),'month')
and t.etl_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_kdl_bill.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes