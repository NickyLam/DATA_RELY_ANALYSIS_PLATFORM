: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_zfldyw_thb_f
CreateDate: 20250211
FileName:   ${iel_data_path}/pams_jxbb_zfldyw_thb.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.jgmc,chr(13),''),chr(10),'') as jgmc
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.khmc,chr(13),''),chr(10),'') as khmc
,tzsy
,tzsyylj
,tzsyjlj
,tzsynlj
,zhye
,zhnrjye
,replace(replace(t1.ldbm,chr(13),''),chr(10),'') as ldbm
,replace(replace(t1.ldywpz,chr(13),''),chr(10),'') as ldywpz
,replace(replace(t1.zcbh,chr(13),''),chr(10),'') as zcbh
,replace(replace(t1.zcmc,chr(13),''),chr(10),'') as zcmc

from ${iol_schema}.pams_jxbb_zfldyw_thb t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_zfldyw_thb.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
