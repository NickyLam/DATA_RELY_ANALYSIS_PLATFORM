: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_kub_user_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_kub_user.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.userid,chr(13),''),chr(10),'') as userid
    ,replace(replace(t.userna,chr(13),''),chr(10),'') as userna
    ,replace(replace(t.brchno,chr(13),''),chr(10),'') as brchno
    ,replace(replace(t.userst,chr(13),''),chr(10),'') as userst
    ,replace(replace(t.ussatg,chr(13),''),chr(10),'') as ussatg
    ,replace(replace(t.lastlg,chr(13),''),chr(10),'') as lastlg
    ,replace(replace(t.usertp,chr(13),''),chr(10),'') as usertp
    ,replace(replace(t.lstrdt,chr(13),''),chr(10),'') as lstrdt
    ,replace(replace(t.menugp,chr(13),''),chr(10),'') as menugp
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.cbss_kub_user t 
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_kub_user.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes