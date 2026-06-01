: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxdx_wlck_f
CreateDate: 20260415
FileName:   ${iel_data_path}/pams_jxdx_wlck.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,jxdxdh
,replace(replace(t1.wcbh,chr(13),''),chr(10),'') as wcbh
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,khrq
,dqrq
,zhye
,replace(replace(t1.cpbh,chr(13),''),chr(10),'') as cpbh
,qxrq
,replace(replace(t1.qx,chr(13),''),chr(10),'') as qx
,replace(replace(t1.djbz,chr(13),''),chr(10),'') as djbz
,djje
,replace(replace(t1.dybz,chr(13),''),chr(10),'') as dybz
,dyje
,nll
,dryjlx
,tjrq
,khdxdh
,replace(replace(t1.gxhslx,chr(13),''),chr(10),'') as gxhslx

from ${iol_schema}.pams_jxdx_wlck t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_wlck.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
