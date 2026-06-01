: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_nbzz_ckmx_a
CreateDate: 20241127
FileName:   ${iel_data_path}/pams_nbzz_ckmx.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
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

from ${iol_schema}.pams_nbzz_ckmx t1
where t1.tjrq <= '${batch_date}'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_nbzz_ckmx.a.${batch_date}.dat" \
        charset=utf8
        safe=yes
