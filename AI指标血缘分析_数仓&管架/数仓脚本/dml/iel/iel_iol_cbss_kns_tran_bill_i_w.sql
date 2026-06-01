: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_kns_tran_bill_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_kns_tran_bill_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.trandt,chr(13),''),chr(10),'') as trandt 
,replace(replace(t1.transq,chr(13),''),chr(10),'') as transq 
,t1.billsq as billsq 
,replace(replace(t1.billtp,chr(13),''),chr(10),'') as billtp 
,replace(replace(t1.prcscd,chr(13),''),chr(10),'') as prcscd 
,replace(replace(t1.servtp,chr(13),''),chr(10),'') as servtp 
,replace(replace(t1.crcycd,chr(13),''),chr(10),'') as crcycd 
,t1.tranam as tranam 
,replace(replace(t1.tranbr,chr(13),''),chr(10),'') as tranbr 
,replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno 
,replace(replace(t1.acctna,chr(13),''),chr(10),'') as acctna 
,replace(replace(t1.acctbr,chr(13),''),chr(10),'') as acctbr 
,replace(replace(t1.acbkna,chr(13),''),chr(10),'') as acbkna 
,replace(replace(t1.toacct,chr(13),''),chr(10),'') as toacct 
,replace(replace(t1.toacna,chr(13),''),chr(10),'') as toacna 
,replace(replace(t1.toacbr,chr(13),''),chr(10),'') as toacbr 
,replace(replace(t1.tobkna,chr(13),''),chr(10),'') as tobkna 
,replace(replace(t1.dscrtx,chr(13),''),chr(10),'') as dscrtx 
,replace(replace(t1.dscrty,chr(13),''),chr(10),'') as dscrty 
,replace(replace(t1.dscrtz,chr(13),''),chr(10),'') as dscrtz 
,replace(replace(t1.amntcd,chr(13),''),chr(10),'') as amntcd 
,replace(replace(t1.prcsna,chr(13),''),chr(10),'') as prcsna 
,replace(replace(t1.lastus,chr(13),''),chr(10),'') as lastus 
,t1.pritct as pritct 
,replace(replace(t1.billno,chr(13),''),chr(10),'') as billno 
,replace(replace(t1.custtp,chr(13),''),chr(10),'') as custtp 
,replace(replace(t1.trantp,chr(13),''),chr(10),'') as trantp 
,replace(replace(t1.csextg,chr(13),''),chr(10),'') as csextg 
,replace(replace(t1.tranus,chr(13),''),chr(10),'') as tranus 
,replace(replace(t1.ckbkus,chr(13),''),chr(10),'') as ckbkus 
,replace(replace(t1.tranti,chr(13),''),chr(10),'') as tranti 
from ${iol_schema}.cbss_kns_tran_bill t1 
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_kns_tran_bill_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes