: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_khfa_level_manage_f
CreateDate: 20250804
FileName:   ${iel_data_path}/pams_khfa_level_manage.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,khnf
,fabh
,replace(replace(t1.jg,chr(13),''),chr(10),'') as jg
,replace(replace(t1.lx,chr(13),''),chr(10),'') as lx
,khzbbh
,replace(replace(t1.khpl,chr(13),''),chr(10),'') as khpl
,replace(replace(t1.dfly,chr(13),''),chr(10),'') as dfly
,xh
,czr
,czsj

from ${iol_schema}.pams_khfa_level_manage t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_khfa_level_manage.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
