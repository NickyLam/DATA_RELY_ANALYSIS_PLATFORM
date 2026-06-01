: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_kns_trcm_csio_i
CreateDate: 20220819
FileName:   ${iel_data_path}/cbss_kns_trcm_csio.i.${batch_date}.dat
IF_mark:    i
Logs:
       sundexin
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.trandt,chr(13),''),chr(10),'') as trandt
    ,replace(replace(t.csiosq,chr(13),''),chr(10),'') as csiosq
    ,replace(replace(t.transq,chr(13),''),chr(10),'') as transq
    ,replace(replace(t.tranbr,chr(13),''),chr(10),'') as tranbr
    ,replace(replace(t.acctid,chr(13),''),chr(10),'') as acctid
    ,replace(replace(t.acctno,chr(13),''),chr(10),'') as acctno
    ,replace(replace(t.subsac,chr(13),''),chr(10),'') as subsac
    ,replace(replace(t.csbxno,chr(13),''),chr(10),'') as csbxno
    ,replace(replace(t.crcycd,chr(13),''),chr(10),'') as crcycd
    ,t.tranam as tranam
    ,replace(replace(t.smrycd,chr(13),''),chr(10),'') as smrycd
    ,replace(replace(t.bookus,chr(13),''),chr(10),'') as bookus
    ,replace(replace(t.ckbkus,chr(13),''),chr(10),'') as ckbkus
    ,replace(replace(t.setltg,chr(13),''),chr(10),'') as setltg
    ,replace(replace(t.corrtg,chr(13),''),chr(10),'') as corrtg
    ,replace(replace(t.csancd,chr(13),''),chr(10),'') as csancd
    ,replace(replace(t.toacct,chr(13),''),chr(10),'') as toacct
    ,replace(replace(t.toacna,chr(13),''),chr(10),'') as toacna
    ,replace(replace(t.tosbac,chr(13),''),chr(10),'') as tosbac
    ,replace(replace(t.favltg,chr(13),''),chr(10),'') as favltg
    ,replace(replace(t.prodcd,chr(13),''),chr(10),'') as prodcd
    ,replace(replace(t.amntcd,chr(13),''),chr(10),'') as amntcd
from iol.cbss_kns_trcm_csio t
where to_char(trandt)= '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_kns_trcm_csio.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes