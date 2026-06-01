: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_lsckmx_f
CreateDate: 20260316
FileName:   ${iel_data_path}/pams_jxbb_lsckmx.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.khmc,chr(13),''),chr(10),'') as khmc
,replace(replace(t1.zhdh,chr(13),''),chr(10),'') as zhdh
,replace(replace(t1.zhid,chr(13),''),chr(10),'') as zhid
,replace(replace(t1.zzh,chr(13),''),chr(10),'') as zzh
,replace(replace(t1.fpjs,chr(13),''),chr(10),'') as fpjs
,replace(replace(t1.zzhkhjgh,chr(13),''),chr(10),'') as zzhkhjgh
,replace(replace(t1.zzhkhjgmc,chr(13),''),chr(10),'') as zzhkhjgmc
,khjgkhdxdh
,ghjgkhdxdh
,ggjgkhdxdh
,replace(replace(t1.khqdmc,chr(13),''),chr(10),'') as khqdmc
,replace(replace(t1.hbf,chr(13),''),chr(10),'') as hbf
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,replace(replace(t1.cklx,chr(13),''),chr(10),'') as cklx
,replace(replace(t1.czdm,chr(13),''),chr(10),'') as czdm
,replace(replace(t1.cz,chr(13),''),chr(10),'') as cz
,replace(replace(t1.qx,chr(13),''),chr(10),'') as qx
,replace(replace(t1.czqx,chr(13),''),chr(10),'') as czqx
,ye
,yrj
,jrj
,nrj
,ckrq
,xdrq
,ckll
,replace(replace(t1.sfkh,chr(13),''),chr(10),'') as sfkh
,replace(replace(t1.khjlgh,chr(13),''),chr(10),'') as khjlgh
,replace(replace(t1.khjlmc,chr(13),''),chr(10),'') as khjlmc
,replace(replace(t1.ghjlgh,chr(13),''),chr(10),'') as ghjlgh
,replace(replace(t1.ghjlmc,chr(13),''),chr(10),'') as ghjlmc
,replace(replace(t1.ghjgh,chr(13),''),chr(10),'') as ghjgh
,replace(replace(t1.ghjgmc,chr(13),''),chr(10),'') as ghjgmc
,replace(replace(t1.ggjlgh,chr(13),''),chr(10),'') as ggjlgh
,replace(replace(t1.ggjlmc,chr(13),''),chr(10),'') as ggjlmc
,replace(replace(t1.ggjgh,chr(13),''),chr(10),'') as ggjgh
,replace(replace(t1.ggjgmc,chr(13),''),chr(10),'') as ggjgmc
,fpbl
,fphye
,fphyrj
,fphjrj
,fphnrj
,replace(replace(t1.fptx,chr(13),''),chr(10),'') as fptx
,txfpbl
,replace(replace(t1.cpmc,chr(13),''),chr(10),'') as cpmc
,shll
,shqx
,replace(replace(t1.cph,chr(13),''),chr(10),'') as cph

from ${iol_schema}.pams_jxbb_lsckmx t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_lsckmx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
