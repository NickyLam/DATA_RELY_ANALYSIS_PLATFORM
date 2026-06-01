: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_lsb_khqycpxx_f
CreateDate: 20250211
FileName:   ${iel_data_path}/pams_lsb_khqycpxx.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,jxdxdh
,jgkhdxdh
,replace(replace(t1.kh,chr(13),''),chr(10),'') as kh
,replace(replace(t1.zhdh,chr(13),''),chr(10),'') as zhdh
,replace(replace(t1.zzh,chr(13),''),chr(10),'') as zzh
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.khmc,chr(13),''),chr(10),'') as khmc
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.khlx,chr(13),''),chr(10),'') as khlx
,replace(replace(t1.cplx,chr(13),''),chr(10),'') as cplx
,replace(replace(t1.cplxmc,chr(13),''),chr(10),'') as cplxmc

from ${iol_schema}.pams_lsb_khqycpxx t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_lsb_khqycpxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
