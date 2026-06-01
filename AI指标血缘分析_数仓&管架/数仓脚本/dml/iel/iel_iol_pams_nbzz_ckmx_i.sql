: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_nbzz_ckmx_i
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_nbzz_ckmx.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,t.tjrq as tjrq
    ,t.jxdxdh as jxdxdh
    ,t.khdxdh as khdxdh
    ,t.jgkhdxdh as jgkhdxdh
    ,replace(replace(t.kmh,chr(13),''),chr(10),'') as kmh
    ,replace(replace(t.bz,chr(13),''),chr(10),'') as bz
    ,replace(replace(t.fpjs,chr(13),''),chr(10),'') as fpjs
    ,replace(replace(t.sfhx,chr(13),''),chr(10),'') as sfhx
    ,replace(replace(t.sfp2p,chr(13),''),chr(10),'') as sfp2p
    ,replace(replace(t.dbznck,chr(13),''),chr(10),'') as dbznck
    ,t.zhye as zhye
    ,t.zlbl as zlbl
    ,t.hyye as hyye
    ,t.hyylj as hyylj
    ,t.hyjlj as hyjlj
    ,t.hybnlj as hybnlj
    ,t.hynlj as hynlj
    ,t.hyymlj as hyymlj
    ,t.zlblylj as zlblylj
    ,t.zlbljlj as zlbljlj
    ,t.zlblnlj as zlblnlj
    ,t.zlblymlj as zlblymlj
    ,t.gxsj as gxsj
    ,replace(replace(t.khkhbs,chr(13),''),chr(10),'') as khkhbs
    ,t.zhnrjye as zhnrjye
    ,t.zhjrjye as zhjrjye
    ,t.zhyrjye as zhyrjye
    ,t.nll as nll
    ,replace(replace(t.kzhckbz,chr(13),''),chr(10),'') as kzhckbz
from iol.pams_nbzz_ckmx t
where t.tjrq= '${batch_date}'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_nbzz_ckmx.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes