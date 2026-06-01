: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_nbzz_bxmx_i
CreateDate: 20260330
FileName:   ${iel_data_path}/pams_nbzz_bxmx.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,jxdxdh
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,khdxdh
,jgkhdxdh
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,replace(replace(t1.fpjs,chr(13),''),chr(10),'') as fpjs
,zlbl
,bf
,zs
,replace(replace(t1.jyzhdh,chr(13),''),chr(10),'') as jyzhdh
,replace(replace(t1.cph,chr(13),''),chr(10),'') as cph
,replace(replace(t1.bxdbh,chr(13),''),chr(10),'') as bxdbh
,replace(replace(t1.xybh,chr(13),''),chr(10),'') as xybh
,replace(replace(t1.frbh,chr(13),''),chr(10),'') as frbh
,replace(replace(t1.tadm,chr(13),''),chr(10),'') as tadm
,replace(replace(t1.hydh,chr(13),''),chr(10),'') as hydh
,replace(replace(t1.gydh,chr(13),''),chr(10),'') as gydh
,jyrq
,bdrq
,bdsxrq
,bxdqrq
,replace(replace(t1.tbrmc,chr(13),''),chr(10),'') as tbrmc
,replace(replace(t1.tbrzjhm,chr(13),''),chr(10),'') as tbrzjhm
,replace(replace(t1.bxgsmc,chr(13),''),chr(10),'') as bxgsmc
,replace(replace(t1.xzlx,chr(13),''),chr(10),'') as xzlx
,replace(replace(t1.zxmc,chr(13),''),chr(10),'') as zxmc
,replace(replace(t1.tbxz,chr(13),''),chr(10),'') as tbxz
,replace(replace(t1.bbxrmc,chr(13),''),chr(10),'') as bbxrmc
,replace(replace(t1.bbxrzjhm,chr(13),''),chr(10),'') as bbxrzjhm
,replace(replace(t1.jffs,chr(13),''),chr(10),'') as jffs
,replace(replace(t1.jfnqdw,chr(13),''),chr(10),'') as jfnqdw
,replace(replace(t1.bxqxdw,chr(13),''),chr(10),'') as bxqxdw
,replace(replace(t1.jfnq,chr(13),''),chr(10),'') as jfnq
,replace(replace(t1.bxqx,chr(13),''),chr(10),'') as bxqx
,replace(replace(t1.jyqd,chr(13),''),chr(10),'') as jyqd
,replace(replace(t1.bdzt,chr(13),''),chr(10),'') as bdzt
,tbrq
,zhye
,dlsxfl
,dlsxf
,replace(replace(t1.qs,chr(13),''),chr(10),'') as qs
,fphzhye
,fphsxf
,nlj
,jlj
,ylj
,nrj
,jrj
,yrj
,ncye
,jcye
,ycye
,dqye
,sxfnlj
,sxfjlj
,sxfylj
,bxgmbf

from ${iol_schema}.pams_nbzz_bxmx t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_nbzz_bxmx.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
