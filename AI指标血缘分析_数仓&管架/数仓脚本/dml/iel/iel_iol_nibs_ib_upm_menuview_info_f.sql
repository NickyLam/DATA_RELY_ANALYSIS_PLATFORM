: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nibs_ib_upm_menuview_info_f
CreateDate: 20221020
FileName:   ${iel_data_path}/nibs_ib_upm_menuview_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.appnum,chr(13),''),chr(10),'') as appnum
    ,replace(replace(t.menuviewnum,chr(13),''),chr(10),'') as menuviewnum
    ,replace(replace(t.menuviewname,chr(13),''),chr(10),'') as menuviewname
    ,replace(replace(t.sortnum,chr(13),''),chr(10),'') as sortnum
    ,replace(replace(t.mainbranch,chr(13),''),chr(10),'') as mainbranch
    ,replace(replace(t.mainuser,chr(13),''),chr(10),'') as mainuser
    ,replace(replace(t.maindate,chr(13),''),chr(10),'') as maindate
    ,replace(replace(t.maintime,chr(13),''),chr(10),'') as maintime
    ,replace(replace(t.activerule,chr(13),''),chr(10),'') as activerule
    ,replace(replace(t.entry,chr(13),''),chr(10),'') as entry
    ,replace(replace(t.activityflag,chr(13),''),chr(10),'') as activityflag
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.nibs_ib_upm_menuview_info t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nibs_ib_upm_menuview_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes