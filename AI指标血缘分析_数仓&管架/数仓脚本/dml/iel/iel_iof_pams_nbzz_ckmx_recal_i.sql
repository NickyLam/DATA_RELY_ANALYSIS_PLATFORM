: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_nbzz_ckmx_recal_i
CreateDate: 20250711
FileName:   ${iel_data_path}/pams_nbzz_ckmx_recal.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,jxdxdh
,khdxdh
,jgkhdxdh
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,replace(replace(t1.fpjs,chr(13),''),chr(10),'') as fpjs
,replace(replace(t1.sfhx,chr(13),''),chr(10),'') as sfhx
,replace(replace(t1.sfp2p,chr(13),''),chr(10),'') as sfp2p
,replace(replace(t1.dbznck,chr(13),''),chr(10),'') as dbznck
,zhye
,zlbl
,hyye
,hyylj
,hyjlj
,hybnlj
,hynlj
,hyymlj
,zlblylj
,zlbljlj
,zlblnlj
,zlblymlj
,gxsj
,replace(replace(t1.khkhbs,chr(13),''),chr(10),'') as khkhbs
,zhnrjye
,zhjrjye
,zhyrjye
,nll
,replace(replace(t1.kzhckbz,chr(13),''),chr(10),'') as kzhckbz
,replace(replace(t1.czdm,chr(13),''),chr(10),'') as czdm
,replace(replace(t1.cph,chr(13),''),chr(10),'') as cph
,recal_dt

from ${iol_schema}.pams_nbzz_ckmx_recal t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_nbzz_ckmx_recal.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
