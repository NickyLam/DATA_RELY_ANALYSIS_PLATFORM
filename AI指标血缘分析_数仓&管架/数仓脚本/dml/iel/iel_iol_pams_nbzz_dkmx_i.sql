: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_nbzz_dkmx_i
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_nbzz_dkmx.i.${batch_date}.dat
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
    ,replace(replace(t.cph,chr(13),''),chr(10),'') as cph
    ,replace(replace(t.ywpz,chr(13),''),chr(10),'') as ywpz
    ,replace(replace(t.fpjs,chr(13),''),chr(10),'') as fpjs
    ,replace(replace(t.bz,chr(13),''),chr(10),'') as bz
    ,t.zhye as zhye
    ,t.zlbl as zlbl
    ,t.hyye as hyye
    ,t.hyylj as hyylj
    ,t.hyjlj as hyjlj
    ,t.hybnlj as hybnlj
    ,t.hynlj as hynlj
    ,t.hyymlj as hyymlj
    ,t.hydkje as hydkje
    ,t.zhzlbl as zhzlbl
    ,t.zlblylj as zlblylj
    ,t.zlbljlj as zlbljlj
    ,t.zlblnlj as zlblnlj
    ,t.zlblymlj as zlblymlj
    ,t.khdkje as khdkje
    ,t.khdkye as khdkye
    ,replace(replace(t.khkhbs,chr(13),''),chr(10),'') as khkhbs
    ,t.nll as nll
    ,t.gxsj as gxsj
    ,replace(replace(t.hxbz,chr(13),''),chr(10),'') as hxbz
    ,replace(replace(t.lsdkbs,chr(13),''),chr(10),'') as lsdkbs
    ,replace(replace(t.xwdkbs,chr(13),''),chr(10),'') as xwdkbs
    ,replace(replace(t.sfzydk,chr(13),''),chr(10),'') as sfzydk
    ,replace(replace(t.fdbptdk,chr(13),''),chr(10),'') as fdbptdk
from iol.pams_nbzz_dkmx t
where t.tjrq= '${batch_date}'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_nbzz_dkmx.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes