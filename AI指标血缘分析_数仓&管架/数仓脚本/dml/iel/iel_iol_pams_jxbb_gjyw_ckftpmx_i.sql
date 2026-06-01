: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_gjyw_ckftpmx_i
CreateDate: 20260311
FileName:   ${iel_data_path}/pams_jxbb_gjyw_ckftpmx.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,replace(replace(t1.zhid,chr(13),''),chr(10),'') as zhid
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.zhm,chr(13),''),chr(10),'') as zhm
,replace(replace(t1.zhh,chr(13),''),chr(10),'') as zhh
,replace(replace(t1.zzh,chr(13),''),chr(10),'') as zzh
,replace(replace(t1.fhjgdh,chr(13),''),chr(10),'') as fhjgdh
,replace(replace(t1.fhjgmc,chr(13),''),chr(10),'') as fhjgmc
,replace(replace(t1.khjgdh,chr(13),''),chr(10),'') as khjgdh
,replace(replace(t1.khjgmc,chr(13),''),chr(10),'') as khjgmc
,replace(replace(t1.ssjgdh,chr(13),''),chr(10),'') as ssjgdh
,replace(replace(t1.ssjgmc,chr(13),''),chr(10),'') as ssjgmc
,replace(replace(t1.hydh,chr(13),''),chr(10),'') as hydh
,replace(replace(t1.hymc,chr(13),''),chr(10),'') as hymc
,fpbl
,replace(replace(t1.fptx,chr(13),''),chr(10),'') as fptx
,txfpbl
,replace(replace(t1.qx,chr(13),''),chr(10),'') as qx
,replace(replace(t1.qxmc,chr(13),''),chr(10),'') as qxmc
,replace(replace(t1.cph,chr(13),''),chr(10),'') as cph
,replace(replace(t1.cpmc,chr(13),''),chr(10),'') as cpmc
,qxrq
,dqrq
,xhrq
,replace(replace(t1.sfzy,chr(13),''),chr(10),'') as sfzy
,replace(replace(t1.bzmc,chr(13),''),chr(10),'') as bzmc
,ckje_yb
,ckje
,ye_yb
,ye
,yrj
,jrj
,nrj
,zhzxll
,ftpjg
,ftpsy
,ftpsyylj
,ftpsyjlj
,ftpsynlj
,ftpsyqlj
,replace(replace(t1.cksrlx,chr(13),''),chr(10),'') as cksrlx
,replace(replace(t1.glckywcp,chr(13),''),chr(10),'') as glckywcp
,replace(replace(t1.whzhxzdm,chr(13),''),chr(10),'') as whzhxzdm
,replace(replace(t1.whzhxzms,chr(13),''),chr(10),'') as whzhxzms

from ${iol_schema}.pams_jxbb_gjyw_ckftpmx t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_gjyw_ckftpmx.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
