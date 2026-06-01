: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_s_dic_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_s_dic.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.enname,chr(13),''),chr(10),'') as enname
    ,replace(replace(t.cnname,chr(13),''),chr(10),'') as cnname
    ,replace(replace(t.opttype,chr(13),''),chr(10),'') as opttype
    ,replace(replace(t.memo,chr(13),''),chr(10),'') as memo
    ,replace(replace(t.flag,chr(13),''),chr(10),'') as flag
    ,replace(replace(t.levels,chr(13),''),chr(10),'') as levels
    ,t.orderid as orderid
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcrs_s_dic t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_s_dic.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes