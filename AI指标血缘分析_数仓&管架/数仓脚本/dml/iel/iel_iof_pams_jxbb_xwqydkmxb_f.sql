: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_jxbb_xwqydkmxb_f
CreateDate: 20250212
FileName:   ${iel_data_path}/pams_jxbb_xwqydkmxb.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,jxdxdh
,jgkhdxdh
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.jgmc,chr(13),''),chr(10),'') as jgmc
,replace(replace(t1.jjh,chr(13),''),chr(10),'') as jjh
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.khmc,chr(13),''),chr(10),'') as khmc
,replace(replace(t1.dklx,chr(13),''),chr(10),'') as dklx
,replace(replace(t1.sfxw,chr(13),''),chr(10),'') as sfxw
,replace(replace(t1.ywpz,chr(13),''),chr(10),'') as ywpz
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,replace(replace(t1.kmmc,chr(13),''),chr(10),'') as kmmc
,ffrq
,dqrq
,replace(replace(t1.bzzwmc,chr(13),''),chr(10),'') as bzzwmc
,dkje
,zcye
,zcyrj
,zcjrj
,zcnrj
,yqye
,yqyrj
,yqjrj
,yqnrj
,nll
,jzll
,khdxdh
,replace(replace(t1.hydh,chr(13),''),chr(10),'') as hydh
,replace(replace(t1.hymc,chr(13),''),chr(10),'') as hymc
,ssjgkhdxdh
,replace(replace(t1.ssjgdh,chr(13),''),chr(10),'') as ssjgdh
,replace(replace(t1.ssjgmc,chr(13),''),chr(10),'') as ssjgmc
,fpje
,zlbl
,fphzcye
,fphzcyrj
,fphzcjrj
,fphzcnrj
,fphyqye
,fphyqyrj
,fphyqjrj
,fphyqnrj
,replace(replace(t1.gyljrywbz,chr(13),''),chr(10),'') as gyljrywbz

from ${iol_schema}.pams_jxbb_xwqydkmxb t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_xwqydkmxb.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
