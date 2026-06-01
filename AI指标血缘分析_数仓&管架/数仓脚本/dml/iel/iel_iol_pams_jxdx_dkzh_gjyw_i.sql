: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxdx_dkzh_gjyw_i
CreateDate: 20240722
FileName:   ${iel_data_path}/pams_jxdx_dkzh_gjyw.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,jxdxdh
,replace(replace(t1.zhdh,chr(13),''),chr(10),'') as zhdh
,replace(replace(t1.zzh,chr(13),''),chr(10),'') as zzh
,replace(replace(t1.jjh,chr(13),''),chr(10),'') as jjh
,replace(replace(t1.pjh,chr(13),''),chr(10),'') as pjh
,replace(replace(t1.cph,chr(13),''),chr(10),'') as cph
,replace(replace(t1.xyzbh,chr(13),''),chr(10),'') as xyzbh
,replace(replace(t1.xyzdjbh,chr(13),''),chr(10),'') as xyzdjbh
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,dkje
,zrmbhl
,bzjje
,cdje
,ypbzjbl
,replace(replace(t1.ypbzjblqj,chr(13),''),chr(10),'') as ypbzjblqj
,replace(replace(t1.ypbzjblqj1,chr(13),''),chr(10),'') as ypbzjblqj1
,tjrq

from ${iol_schema}.pams_jxdx_dkzh_gjyw t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_dkzh_gjyw.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
