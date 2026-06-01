: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxdx_tyffzck_f
CreateDate: 20240131
FileName:   ${iel_data_path}/pams_jxdx_tyffzck.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,jxdxdh
,replace(replace(t1.ywbh,chr(13),''),chr(10),'') as ywbh
,replace(replace(t1.wbbh,chr(13),''),chr(10),'') as wbbh
,replace(replace(t1.nbbh,chr(13),''),chr(10),'') as nbbh
,replace(replace(t1.zclxbh,chr(13),''),chr(10),'') as zclxbh
,replace(replace(t1.sclxbh,chr(13),''),chr(10),'') as sclxbh
,replace(replace(t1.jrgjdm,chr(13),''),chr(10),'') as jrgjdm
,replace(replace(t1.jrgjmc,chr(13),''),chr(10),'') as jrgjmc
,replace(replace(t1.kjfl,chr(13),''),chr(10),'') as kjfl
,replace(replace(t1.cplx,chr(13),''),chr(10),'') as cplx
,replace(replace(t1.jyssjgdh,chr(13),''),chr(10),'') as jyssjgdh
,jyrq
,replace(replace(t1.jydskhh,chr(13),''),chr(10),'') as jydskhh
,replace(replace(t1.jyds,chr(13),''),chr(10),'') as jyds
,replace(replace(t1.jydslx,chr(13),''),chr(10),'') as jydslx
,replace(replace(t1.sjrzrkhh,chr(13),''),chr(10),'') as sjrzrkhh
,replace(replace(t1.sjrzr,chr(13),''),chr(10),'') as sjrzr
,replace(replace(t1.sjrzrlx,chr(13),''),chr(10),'') as sjrzrlx
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,tzbj
,zxll
,qxr
,dqr
,scfxrq
,replace(replace(t1.fxpl,chr(13),''),chr(10),'') as fxpl
,replace(replace(t1.jxjz,chr(13),''),chr(10),'') as jxjz
,tzye
,zmye
,replace(replace(t1.bjkmh,chr(13),''),chr(10),'') as bjkmh
,ftpll
,replace(replace(t1.gxhslx,chr(13),''),chr(10),'') as gxhslx
,khdxdh
,tjrq
,replace(replace(t1.xplx,chr(13),''),chr(10),'') as xplx
,replace(replace(t1.sjly,chr(13),''),chr(10),'') as sjly
,replace(replace(t1.czcdm,chr(13),''),chr(10),'') as czcdm
,replace(replace(t1.ywlbmc,chr(13),''),chr(10),'') as ywlbmc
,replace(replace(t1.zclbmc,chr(13),''),chr(10),'') as zclbmc
,replace(replace(t1.jjcf,chr(13),''),chr(10),'') as jjcf
,replace(replace(t1.txhy,chr(13),''),chr(10),'') as txhy
,replace(replace(t1.ssdq,chr(13),''),chr(10),'') as ssdq

from ${iol_schema}.pams_jxdx_tyffzck t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_tyffzck.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
