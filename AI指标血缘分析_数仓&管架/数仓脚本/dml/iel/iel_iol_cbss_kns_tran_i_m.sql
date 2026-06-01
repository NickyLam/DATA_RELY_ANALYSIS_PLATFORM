: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_kns_tran_i_m
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_kns_tran_m.i.${batch_date}.dat
IF_mark:    i_m
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.trandt,chr(13),''),chr(10),'') as trandt
,replace(replace(t.transq,chr(13),''),chr(10),'') as transq
,replace(replace(t.tranti,chr(13),''),chr(10),'') as tranti
,replace(replace(t.trantp,chr(13),''),chr(10),'') as trantp
,replace(replace(t.prcscd,chr(13),''),chr(10),'') as prcscd
,replace(replace(t.servtp,chr(13),''),chr(10),'') as servtp
,replace(replace(t.tranbr,chr(13),''),chr(10),'') as tranbr
,replace(replace(t.pckgsq,chr(13),''),chr(10),'') as pckgsq
,replace(replace(t.csbxno,chr(13),''),chr(10),'') as csbxno
,replace(replace(t.menuid,chr(13),''),chr(10),'') as menuid
,replace(replace(t.tmnlid,chr(13),''),chr(10),'') as tmnlid
,replace(replace(t.tranus,chr(13),''),chr(10),'') as tranus
,replace(replace(t.ckbkus,chr(13),''),chr(10),'') as ckbkus
,replace(replace(t.authus,chr(13),''),chr(10),'') as authus
,replace(replace(t.cktrtg,chr(13),''),chr(10),'') as cktrtg
,replace(replace(t.transt,chr(13),''),chr(10),'') as transt
from ${iol_schema}.cbss_kns_tran t
where etl_dt >= trunc(to_date('${batch_date}','yyyymmdd'),'month')
and etl_dt <=to_date('${batch_date}','yyyymmdd')
and trandt>=to_char(trunc(to_date('${batch_date}','yyyymmdd'),'month'))
and trandt<='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_kns_tran_m.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes