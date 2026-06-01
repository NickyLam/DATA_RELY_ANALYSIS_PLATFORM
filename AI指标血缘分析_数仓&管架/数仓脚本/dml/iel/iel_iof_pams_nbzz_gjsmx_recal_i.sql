: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_nbzz_gjsmx_recal_i
CreateDate: 20251107
FileName:   ${iel_data_path}/pams_nbzz_gjsmx_recal.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,recal_dt
,tjrq
,jxdxdh
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,khdxdh
,jgkhdxdh
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,replace(replace(t1.fpjs,chr(13),''),chr(10),'') as fpjs
,zlbl
,replace(replace(t1.ddh,chr(13),''),chr(10),'') as ddh
,replace(replace(t1.yhlsh,chr(13),''),chr(10),'') as yhlsh
,jyrq
,ddrq
,replace(replace(t1.khmc,chr(13),''),chr(10),'') as khmc
,replace(replace(t1.cph,chr(13),''),chr(10),'') as cph
,replace(replace(t1.cpmc,chr(13),''),chr(10),'') as cpmc
,replace(replace(t1.cpcs,chr(13),''),chr(10),'') as cpcs
,replace(replace(t1.hjl,chr(13),''),chr(10),'') as hjl
,replace(replace(t1.hyl,chr(13),''),chr(10),'') as hyl
,replace(replace(t1.gmsl,chr(13),''),chr(10),'') as gmsl
,replace(replace(t1.gysmc,chr(13),''),chr(10),'') as gysmc
,replace(replace(t1.xsqd,chr(13),''),chr(10),'') as xsqd
,jydj
,zhye
,sxf
,replace(replace(t1.hydh,chr(13),''),chr(10),'') as hydh
,replace(replace(t1.sjly,chr(13),''),chr(10),'') as sjly
,fphzhye
,fphsxf
,replace(replace(t1.cpfldm,chr(13),''),chr(10),'') as cpfldm
,replace(replace(t1.scddh,chr(13),''),chr(10),'') as scddh
,fphzhyeylj
,fphzhyejlj
,fphzhyenlj
,zhyeylj
,zhyejlj
,zhyenlj

from ${iol_schema}.pams_nbzz_gjsmx_recal t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_nbzz_gjsmx_recal.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
