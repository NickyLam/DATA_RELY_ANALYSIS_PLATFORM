: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_zjywsrmx_recal_a
CreateDate: 20250609
FileName:   ${iel_data_path}/pams_jxbb_zjywsrmx_recal.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,tjrq
,recal_dt
,replace(replace(t1.jzlsh,chr(13),''),chr(10),'') as jzlsh
,rzrq
,tjrzrq
,replace(replace(t1.rzkm,chr(13),''),chr(10),'') as rzkm
,replace(replace(t1.kmmc,chr(13),''),chr(10),'') as kmmc
,replace(replace(t1.jzjgdh,chr(13),''),chr(10),'') as jzjgdh
,replace(replace(t1.jzjgmc,chr(13),''),chr(10),'') as jzjgmc
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,replace(replace(t1.khlx,chr(13),''),chr(10),'') as khlx
,hsje
,shje
,se
,replace(replace(t1.txbz,chr(13),''),chr(10),'') as txbz
,sfrq
,replace(replace(t1.sflsh,chr(13),''),chr(10),'') as sflsh
,sfje
,replace(replace(t1.ywbh,chr(13),''),chr(10),'') as ywbh
,replace(replace(t1.dybwkm,chr(13),''),chr(10),'') as dybwkm
,dybwje
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.khmc,chr(13),''),chr(10),'') as khmc
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.jgmc,chr(13),''),chr(10),'') as jgmc
,replace(replace(t1.hydh,chr(13),''),chr(10),'') as hydh
,replace(replace(t1.hymc,chr(13),''),chr(10),'') as hymc
,zlbl
,jyje
,fphdyje
,fphljje
,replace(replace(t1.ywlx,chr(13),''),chr(10),'') as ywlx
,jgkhdxdh
,jzjgkhdxdh
,jxdxdh
,replace(replace(t1.sfdm,chr(13),''),chr(10),'') as sfdm
,replace(replace(t1.sfmc,chr(13),''),chr(10),'') as sfmc
,replace(replace(t1.ybbz,chr(13),''),chr(10),'') as ybbz
,replace(replace(t1.cpxdl,chr(13),''),chr(10),'') as cpxdl
,replace(replace(t1.sflx,chr(13),''),chr(10),'') as sflx
,replace(replace(t1.sfz,chr(13),''),chr(10),'') as sfz
,replace(replace(t1.jzsf,chr(13),''),chr(10),'') as jzsf
,replace(replace(t1.sfxmc,chr(13),''),chr(10),'') as sfxmc
,replace(replace(t1.fptx,chr(13),''),chr(10),'') as fptx
,txfpbl

from ${iol_schema}.pams_jxbb_zjywsrmx_recal t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_zjywsrmx_recal.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
