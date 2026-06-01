: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_zjbzqtzsy_f
CreateDate: 20250529
FileName:   ${iel_data_path}/pams_jxbb_zjbzqtzsy.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,replace(replace(t1.zqdm,chr(13),''),chr(10),'') as zqdm
,jxdxdh
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.jgmc,chr(13),''),chr(10),'') as jgmc
,replace(replace(t1.ldpz,chr(13),''),chr(10),'') as ldpz
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.khmc,chr(13),''),chr(10),'') as khmc
,tzsy
,tzsyylj
,tzsyjlj
,tzsynlj
,replace(replace(t1.khjlgh,chr(13),''),chr(10),'') as khjlgh

from ${iol_schema}.pams_jxbb_zjbzqtzsy t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_zjbzqtzsy.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
