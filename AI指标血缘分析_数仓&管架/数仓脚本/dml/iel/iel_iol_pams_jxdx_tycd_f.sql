: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxdx_tycd_f
CreateDate: 20240131
FileName:   ${iel_data_path}/pams_jxdx_tycd.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,jxdxdh
,replace(replace(t1.wbbh,chr(13),''),chr(10),'') as wbbh
,replace(replace(t1.nbbh,chr(13),''),chr(10),'') as nbbh
,replace(replace(t1.jrgjbh,chr(13),''),chr(10),'') as jrgjbh
,replace(replace(t1.sclxbh,chr(13),''),chr(10),'') as sclxbh
,replace(replace(t1.ywbh,chr(13),''),chr(10),'') as ywbh
,replace(replace(t1.cddm,chr(13),''),chr(10),'') as cddm
,replace(replace(t1.cdjc,chr(13),''),chr(10),'') as cdjc
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,replace(replace(t1.zhmc,chr(13),''),chr(10),'') as zhmc
,fxr
,qxr
,dqr
,dfr
,replace(replace(t1.qx,chr(13),''),chr(10),'') as qx
,jxts
,fxjg
,nll
,fxl
,fxje
,bqye
,replace(replace(t1.sjtzrkhh,chr(13),''),chr(10),'') as sjtzrkhh
,replace(replace(t1.sjtzrqc,chr(13),''),chr(10),'') as sjtzrqc
,replace(replace(t1.sjtzrkhfl,chr(13),''),chr(10),'') as sjtzrkhfl
,replace(replace(t1.sjtzrjglx,chr(13),''),chr(10),'') as sjtzrjglx
,replace(replace(t1.fxjgmc,chr(13),''),chr(10),'') as fxjgmc
,replace(replace(t1.cdgsjgdh,chr(13),''),chr(10),'') as cdgsjgdh
,replace(replace(t1.xsjgmc,chr(13),''),chr(10),'') as xsjgmc
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,cdmz
,tzrtzmz
,khdxdh
,tjrq
,replace(replace(t1.gxhslx,chr(13),''),chr(10),'') as gxhslx
,ftpll
,replace(replace(t1.xsjgmczh,chr(13),''),chr(10),'') as xsjgmczh
,replace(replace(t1.xsjgmczb,chr(13),''),chr(10),'') as xsjgmczb
,replace(replace(t1.gsjgmczh,chr(13),''),chr(10),'') as gsjgmczh
,replace(replace(t1.gsjgmczb,chr(13),''),chr(10),'') as gsjgmczb
,replace(replace(t1.cpdm,chr(13),''),chr(10),'') as cpdm

from ${iol_schema}.pams_jxdx_tycd t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_tycd.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
