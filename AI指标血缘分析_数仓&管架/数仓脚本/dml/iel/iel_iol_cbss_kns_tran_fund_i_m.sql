: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_kns_tran_fund_i_m
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_kns_tran_fund_m.i.${batch_date}.dat
IF_mark:    i_m
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.trandt,chr(13),''),chr(10),'') as trandt
,replace(replace(t.transq,chr(13),''),chr(10),'') as transq
,replace(replace(t.crcycd,chr(13),''),chr(10),'') as crcycd
,t.tranam as tranam
,replace(replace(t.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t.subsac,chr(13),''),chr(10),'') as subsac
,replace(replace(t.acctna,chr(13),''),chr(10),'') as acctna
,replace(replace(t.acctbr,chr(13),''),chr(10),'') as acctbr
,replace(replace(t.dcmttp,chr(13),''),chr(10),'') as dcmttp
,replace(replace(t.dcmtno,chr(13),''),chr(10),'') as dcmtno
,replace(replace(t.dctpid,chr(13),''),chr(10),'') as dctpid
,replace(replace(t.cheqtp,chr(13),''),chr(10),'') as cheqtp
,replace(replace(t.cheqno,chr(13),''),chr(10),'') as cheqno
,replace(replace(t.cqtpid,chr(13),''),chr(10),'') as cqtpid
,replace(replace(t.invodt,chr(13),''),chr(10),'') as invodt
,replace(replace(t.toacct,chr(13),''),chr(10),'') as toacct
,replace(replace(t.tosbac,chr(13),''),chr(10),'') as tosbac
,replace(replace(t.toacna,chr(13),''),chr(10),'') as toacna
,replace(replace(t.toacbr,chr(13),''),chr(10),'') as toacbr
from ${iol_schema}.cbss_kns_tran_fund t
where etl_dt >= trunc(to_date('${batch_date}','yyyymmdd'),'month')
and etl_dt <=to_date('${batch_date}','yyyymmdd')
and trandt>=to_char(trunc(to_date('${batch_date}','yyyymmdd'),'month'))
and trandt<='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_kns_tran_fund_m.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes