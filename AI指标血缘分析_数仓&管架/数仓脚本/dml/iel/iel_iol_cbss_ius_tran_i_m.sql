: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_ius_tran_i_m
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_ius_tran.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.trandt,chr(13),''),chr(10),'') as trandt
,replace(replace(t.transq,chr(13),''),chr(10),'') as transq
,replace(replace(t.systrn,chr(13),''),chr(10),'') as systrn
,replace(replace(t.acptid,chr(13),''),chr(10),'') as acptid
,replace(replace(t.sendid,chr(13),''),chr(10),'') as sendid
,replace(replace(t.tranti,chr(13),''),chr(10),'') as tranti
,replace(replace(t.prcscd,chr(13),''),chr(10),'') as prcscd
,replace(replace(t.servtp,chr(13),''),chr(10),'') as servtp
,replace(replace(t.trantp,chr(13),''),chr(10),'') as trantp
,replace(replace(t.crcycd,chr(13),''),chr(10),'') as crcycd
,replace(replace(t.cardno,chr(13),''),chr(10),'') as cardno
,replace(replace(t.dcmtno,chr(13),''),chr(10),'') as dcmtno
,t.tranam as tranam
,replace(replace(t.tranac,chr(13),''),chr(10),'') as tranac
,replace(replace(t.oppsac,chr(13),''),chr(10),'') as oppsac
,replace(replace(t.stortp,chr(13),''),chr(10),'') as stortp
,replace(replace(t.storcd,chr(13),''),chr(10),'') as storcd
,replace(replace(t.uniodt,chr(13),''),chr(10),'') as uniodt
,replace(replace(t.poscod,chr(13),''),chr(10),'') as poscod
,replace(replace(t.tsbkcd,chr(13),''),chr(10),'') as tsbkcd
,replace(replace(t.untstp,chr(13),''),chr(10),'') as untstp
,replace(replace(t.areatp,chr(13),''),chr(10),'') as areatp
,replace(replace(t.auausq,chr(13),''),chr(10),'') as auausq
,replace(replace(t.userid,chr(13),''),chr(10),'') as userid
,replace(replace(t.remktx,chr(13),''),chr(10),'') as remktx
,replace(replace(t.transt,chr(13),''),chr(10),'') as transt
,replace(replace(t.corrdt,chr(13),''),chr(10),'') as corrdt
,replace(replace(t.cortsq,chr(13),''),chr(10),'') as cortsq
,t.handch as handch
,replace(replace(t.dztrst,chr(13),''),chr(10),'') as dztrst
,replace(replace(t.setldt,chr(13),''),chr(10),'') as setldt
,replace(replace(t.setltg,chr(13),''),chr(10),'') as setltg
,replace(replace(t.frozsq,chr(13),''),chr(10),'') as frozsq
from ${iol_schema}.cbss_ius_tran t
where t.trandt >= to_char(trunc(to_date('${batch_date}','yyyymmdd'),'month'),'yyyymmdd')
and t.trandt <= to_char(to_date('${batch_date}','yyyymmdd'),'yyyymmdd') and t.etl_dt >= trunc(to_date('${batch_date}','yyyymmdd'),'month')
and t.etl_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_ius_tran.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes