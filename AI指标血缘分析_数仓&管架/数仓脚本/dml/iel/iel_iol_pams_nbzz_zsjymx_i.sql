: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_nbzz_zsjymx_i
CreateDate: 20251127
FileName:   ${iel_data_path}/pams_nbzz_zsjymx.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,jxdxdh
,jgkhdxdh
,khdxdh
,replace(replace(t1.jzlsh,chr(13),''),chr(10),'') as jzlsh
,rzrq
,replace(replace(t1.rzkm,chr(13),''),chr(10),'') as rzkm
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
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
,zlbl
,jyje
,fphdyje
,fphljje
,replace(replace(t1.khlx,chr(13),''),chr(10),'') as khlx
,hyyhsje
,hyyshje
,hyjhsje
,hyjshje
,hynhsje
,hynshje
,replace(replace(t1.sfdm,chr(13),''),chr(10),'') as sfdm
,replace(replace(t1.sfmc,chr(13),''),chr(10),'') as sfmc
,replace(replace(t1.ybbz,chr(13),''),chr(10),'') as ybbz
,replace(replace(t1.ypbzjblqj,chr(13),''),chr(10),'') as ypbzjblqj
,replace(replace(t1.jylsh,chr(13),''),chr(10),'') as jylsh
,replace(replace(t1.sxfzqfs,chr(13),''),chr(10),'') as sxfzqfs
,replace(replace(t1.gjywbs,chr(13),''),chr(10),'') as gjywbs
,replace(replace(t1.yxtdm,chr(13),''),chr(10),'') as yxtdm

from ${iol_schema}.pams_nbzz_zsjymx t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_nbzz_zsjymx.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
