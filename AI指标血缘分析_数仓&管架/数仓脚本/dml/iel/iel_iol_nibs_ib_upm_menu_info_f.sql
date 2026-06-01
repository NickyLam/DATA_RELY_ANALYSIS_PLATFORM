: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nibs_ib_upm_menu_info_f
CreateDate: 20221020
FileName:   ${iel_data_path}/nibs_ib_upm_menu_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.appnum,chr(13),''),chr(10),'') as appnum
    ,replace(replace(t.menuviewnum,chr(13),''),chr(10),'') as menuviewnum
    ,replace(replace(t.menunum,chr(13),''),chr(10),'') as menunum
    ,replace(replace(t.menuname,chr(13),''),chr(10),'') as menuname
    ,replace(replace(t.menuicon,chr(13),''),chr(10),'') as menuicon
    ,replace(replace(t.menupath,chr(13),''),chr(10),'') as menupath
    ,replace(replace(t.menutype,chr(13),''),chr(10),'') as menutype
    ,replace(replace(t.sortnum,chr(13),''),chr(10),'') as sortnum
    ,replace(replace(t.parentmenunum,chr(13),''),chr(10),'') as parentmenunum
    ,replace(replace(t.isvisible,chr(13),''),chr(10),'') as isvisible
    ,replace(replace(t.mainbranch,chr(13),''),chr(10),'') as mainbranch
    ,replace(replace(t.mainuser,chr(13),''),chr(10),'') as mainuser
    ,replace(replace(t.maindate,chr(13),''),chr(10),'') as maindate
    ,replace(replace(t.maintime,chr(13),''),chr(10),'') as maintime
    ,replace(replace(t.tadpath,chr(13),''),chr(10),'') as tadpath
    ,replace(replace(t.weight,chr(13),''),chr(10),'') as weight
    ,replace(replace(t.tranflag,chr(13),''),chr(10),'') as tranflag
    ,replace(replace(t.rltflag,chr(13),''),chr(10),'') as rltflag
    ,replace(replace(t.iconactive,chr(13),''),chr(10),'') as iconactive
    ,replace(replace(t.bankflag,chr(13),''),chr(10),'') as bankflag
    ,replace(replace(t.recomdeal,chr(13),''),chr(10),'') as recomdeal
    ,replace(replace(t.englishmenuname,chr(13),''),chr(10),'') as englishmenuname
    ,replace(replace(t.navigationmode,chr(13),''),chr(10),'') as navigationmode
    ,replace(replace(t.iscommon,chr(13),''),chr(10),'') as iscommon
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.nibs_ib_upm_menu_info t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nibs_ib_upm_menu_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes