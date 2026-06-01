: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_khfa_khzbpz_f
CreateDate: 20260316
FileName:   ${iel_data_path}/pams_khfa_khzbpz.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,fabh
,khzbdh
,replace(replace(t1.wdmc,chr(13),''),chr(10),'') as wdmc
,wdqz
,zbqz
,replace(replace(t1.jldw,chr(13),''),chr(10),'') as jldw
,bdz
,fdz
,mbbh
,replace(replace(t1.qjlx,chr(13),''),chr(10),'') as qjlx
,replace(replace(t1.jsfs,chr(13),''),chr(10),'') as jsfs
,xh
,tlbl
,replace(replace(t1.tjcx,chr(13),''),chr(10),'') as tjcx
,replace(replace(t1.xmmc,chr(13),''),chr(10),'') as xmmc
,replace(replace(t1.zswdqz,chr(13),''),chr(10),'') as zswdqz
,replace(replace(t1.zszbqz,chr(13),''),chr(10),'') as zszbqz
,pjbh
,replace(replace(t1.khnr,chr(13),''),chr(10),'') as khnr

from ${iol_schema}.pams_khfa_khzbpz t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_khfa_khzbpz.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
