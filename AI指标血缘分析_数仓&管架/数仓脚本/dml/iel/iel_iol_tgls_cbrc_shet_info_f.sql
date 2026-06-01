: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tgls_cbrc_shet_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tgls_cbrc_shet_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.subsys as subsys
,replace(replace(t1.shetcd,chr(13),''),chr(10),'') as shetcd
,replace(replace(t1.shetna,chr(13),''),chr(10),'') as shetna
,replace(replace(t1.reptfq,chr(13),''),chr(10),'') as reptfq
,replace(replace(t1.reptut,chr(13),''),chr(10),'') as reptut
,replace(replace(t1.reptfg,chr(13),''),chr(10),'') as reptfg
,t1.begndt as begndt
,t1.overdt as overdt
,replace(replace(t1.shetmp,chr(13),''),chr(10),'') as shetmp
,replace(replace(t1.shetsp,chr(13),''),chr(10),'') as shetsp
,replace(replace(t1.procna,chr(13),''),chr(10),'') as procna
,replace(replace(t1.inptfg,chr(13),''),chr(10),'') as inptfg
,replace(replace(t1.tabtor,chr(13),''),chr(10),'') as tabtor
,replace(replace(t1.revwer,chr(13),''),chr(10),'') as revwer
,replace(replace(t1.resper,chr(13),''),chr(10),'') as resper
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.rpftch,chr(13),''),chr(10),'') as rpftch
,t1.scheid as scheid
,replace(replace(t1.ftitle,chr(13),''),chr(10),'') as ftitle
,replace(replace(t1.stitle,chr(13),''),chr(10),'') as stitle
,replace(replace(t1.crcycd,chr(13),''),chr(10),'') as crcycd
,replace(replace(t1.shetsn,chr(13),''),chr(10),'') as shetsn
,replace(replace(t1.curent,chr(13),''),chr(10),'') as curent
,t1.stacid as stacid
,replace(replace(t1.isbala,chr(13),''),chr(10),'') as isbala
,replace(replace(t1.isused,chr(13),''),chr(10),'') as isused
,replace(replace(t1.shettp,chr(13),''),chr(10),'') as shettp
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.tgls_cbrc_shet_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tgls_cbrc_shet_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes