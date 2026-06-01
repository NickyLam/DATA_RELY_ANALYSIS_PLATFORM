: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tgls_com_crcy_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tgls_com_crcy.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.crcycd,chr(13),''),chr(10),'') as crcycd
,replace(replace(t1.crcyna,chr(13),''),chr(10),'') as crcyna
,replace(replace(t1.crcyen,chr(13),''),chr(10),'') as crcyen
,replace(replace(t1.crcysg,chr(13),''),chr(10),'') as crcysg
,t1.crcydg as crcydg
,t1.crcycg as crcycg
,replace(replace(t1.dibstg,chr(13),''),chr(10),'') as dibstg
,replace(replace(t1.usabtg,chr(13),''),chr(10),'') as usabtg
,t1.cysgdg as cysgdg
,t1.isfold as isfold
,t1.convmd as convmd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.tgls_com_crcy t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tgls_com_crcy.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes