: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxdx_gskh_f
CreateDate: 20240416
FileName:   ${iel_data_path}/pams_jxdx_gskh.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,jxdxdh
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.khlx,chr(13),''),chr(10),'') as khlx
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.khmc,chr(13),''),chr(10),'') as khmc
,replace(replace(t1.zjlb,chr(13),''),chr(10),'') as zjlb
,replace(replace(t1.zjhm,chr(13),''),chr(10),'') as zjhm
,replace(replace(t1.khjjxz,chr(13),''),chr(10),'') as khjjxz
,replace(replace(t1.khhylb,chr(13),''),chr(10),'') as khhylb
,replace(replace(t1.qygm,chr(13),''),chr(10),'') as qygm
,replace(replace(t1.txdz,chr(13),''),chr(10),'') as txdz
,replace(replace(t1.dwdh,chr(13),''),chr(10),'') as dwdh
,replace(replace(t1.dzyj,chr(13),''),chr(10),'') as dzyj
,replace(replace(t1.lxdh,chr(13),''),chr(10),'') as lxdh
,replace(replace(t1.khzt,chr(13),''),chr(10),'') as khzt
,khrq
,zczb
,replace(replace(t1.khlyxx,chr(13),''),chr(10),'') as khlyxx
,replace(replace(t1.gxhslx,chr(13),''),chr(10),'') as gxhslx
,csrq
,tjrq

from ${iol_schema}.pams_jxdx_gskh t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_gskh.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
