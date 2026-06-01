: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_kub_wkst_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_kub_wkst.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.wkstcd,chr(13),''),chr(10),'') as wkstcd
    ,replace(replace(t.wkstna,chr(13),''),chr(10),'') as wkstna
    ,replace(replace(t.csbxno,chr(13),''),chr(10),'') as csbxno
    ,replace(replace(t.brchno,chr(13),''),chr(10),'') as brchno
    ,replace(replace(t.curtus,chr(13),''),chr(10),'') as curtus
    ,replace(replace(t.wktpcd,chr(13),''),chr(10),'') as wktpcd
    ,replace(replace(t.handus,chr(13),''),chr(10),'') as handus
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.cbss_kub_wkst t 
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_kub_wkst.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes