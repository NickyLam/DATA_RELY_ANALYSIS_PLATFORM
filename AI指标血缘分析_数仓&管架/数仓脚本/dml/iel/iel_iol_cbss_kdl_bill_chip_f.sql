: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_kdl_bill_chip_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_kdl_bill_chip.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.trandt,chr(13),''),chr(10),'') as trandt
,replace(replace(t.chipsq,chr(13),''),chr(10),'') as chipsq
,replace(replace(t.transq,chr(13),''),chr(10),'') as transq
,replace(replace(t.acctbr,chr(13),''),chr(10),'') as acctbr
,replace(replace(t.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t.cardsq,chr(13),''),chr(10),'') as cardsq
,replace(replace(t.trantp,chr(13),''),chr(10),'') as trantp
,replace(replace(t.amntcd,chr(13),''),chr(10),'') as amntcd
,replace(replace(t.tranbr,chr(13),''),chr(10),'') as tranbr
,replace(replace(t.crcycd,chr(13),''),chr(10),'') as crcycd
,t.tranam as tranam
,t.tranbl as tranbl
,replace(replace(t.smrycd,chr(13),''),chr(10),'') as smrycd
,replace(replace(t.dscrtx,chr(13),''),chr(10),'') as dscrtx
,replace(replace(t.corrtg,chr(13),''),chr(10),'') as corrtg
,replace(replace(t.bkusid,chr(13),''),chr(10),'') as bkusid
,replace(replace(t.timstp,chr(13),''),chr(10),'') as timstp
from ${iol_schema}.cbss_kdl_bill_chip t
where t.etl_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_kdl_bill_chip.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes