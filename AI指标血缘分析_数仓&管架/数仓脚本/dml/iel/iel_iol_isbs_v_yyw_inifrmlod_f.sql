: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_isbs_v_yyw_inifrmlod_f
CreateDate: 20250826
FileName:   ${iel_data_path}/isbs_v_yyw_inifrmlod.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.b1,chr(13),''),chr(10),'') as b1
,replace(replace(t1.b2,chr(13),''),chr(10),'') as b2
,replace(replace(t1.b3,chr(13),''),chr(10),'') as b3
,replace(replace(t1.b4,chr(13),''),chr(10),'') as b4
,replace(replace(t1.b5,chr(13),''),chr(10),'') as b5
,replace(replace(t1.b6,chr(13),''),chr(10),'') as b6
,replace(replace(t1.b7,chr(13),''),chr(10),'') as b7
,replace(replace(t1.b8,chr(13),''),chr(10),'') as b8
,replace(replace(t1.b9,chr(13),''),chr(10),'') as b9
,replace(replace(t1.b10,chr(13),''),chr(10),'') as b10
,b11
,b12
,replace(replace(t1.b13,chr(13),''),chr(10),'') as b13
,replace(replace(t1.b14,chr(13),''),chr(10),'') as b14

from ${iol_schema}.isbs_v_yyw_inifrmlod t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/isbs_v_yyw_inifrmlod.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
