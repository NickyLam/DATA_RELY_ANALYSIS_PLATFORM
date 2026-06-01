: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_kub_brch_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_kub_brch.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.brchno,chr(13),''),chr(10),'') as brchno
    ,replace(replace(t.corpno,chr(13),''),chr(10),'') as corpno
    ,replace(replace(t.cityno,chr(13),''),chr(10),'') as cityno
    ,replace(replace(t.sqnopx,chr(13),''),chr(10),'') as sqnopx
    ,replace(replace(t.crcycd,chr(13),''),chr(10),'') as crcycd
    ,replace(replace(t.brchna,chr(13),''),chr(10),'') as brchna
    ,replace(replace(t.brsmna,chr(13),''),chr(10),'') as brsmna
    ,replace(replace(t.brsatg,chr(13),''),chr(10),'') as brsatg
    ,replace(replace(t.nodebr,chr(13),''),chr(10),'') as nodebr
    ,replace(replace(t.telecd,chr(13),''),chr(10),'') as telecd
    ,replace(replace(t.addres,chr(13),''),chr(10),'') as addres
    ,replace(replace(t.locatg,chr(13),''),chr(10),'') as locatg
    ,replace(replace(t.bractg,chr(13),''),chr(10),'') as bractg
    ,replace(replace(t.centtg,chr(13),''),chr(10),'') as centtg
    ,replace(replace(t.brchtp,chr(13),''),chr(10),'') as brchtp
    ,replace(replace(t.brchlv,chr(13),''),chr(10),'') as brchlv
    ,replace(replace(t.otbrtg,chr(13),''),chr(10),'') as otbrtg
    ,replace(replace(t.spclsc,chr(13),''),chr(10),'') as spclsc
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.cbss_kub_brch t 
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_kub_brch.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes