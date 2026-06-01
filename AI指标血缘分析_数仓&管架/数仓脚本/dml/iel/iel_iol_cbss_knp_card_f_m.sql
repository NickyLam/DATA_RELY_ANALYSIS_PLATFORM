: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_knp_card_f_m
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_knp_card_m.f.${batch_date}.dat
IF_mark:    f_m
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.cardbn,chr(13),''),chr(10),'') as cardbn
,replace(replace(t.substp,chr(13),''),chr(10),'') as substp
,replace(replace(t.cardna,chr(13),''),chr(10),'') as cardna
,replace(replace(t.stoptg,chr(13),''),chr(10),'') as stoptg
,replace(replace(t.usedrg,chr(13),''),chr(10),'') as usedrg
,replace(replace(t.cardlv,chr(13),''),chr(10),'') as cardlv
,replace(replace(t.makemd,chr(13),''),chr(10),'') as makemd
,t.sortno as sortno
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.cbss_knp_card t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_knp_card_m.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes