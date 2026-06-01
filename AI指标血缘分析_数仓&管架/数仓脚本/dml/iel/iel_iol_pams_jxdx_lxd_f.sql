: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxdx_lxd_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_jxdx_lxd.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,t.jxdxdh as jxdxdh
    ,replace(replace(t.ywbh,chr(13),''),chr(10),'') as ywbh
    ,replace(replace(t.wbzjzhbh,chr(13),''),chr(10),'') as wbzjzhbh
    ,replace(replace(t.nbzjzhbh,chr(13),''),chr(10),'') as nbzjzhbh
    ,replace(replace(t.jrgjbh,chr(13),''),chr(10),'') as jrgjbh
    ,replace(replace(t.zclxbh,chr(13),''),chr(10),'') as zclxbh
    ,replace(replace(t.sclxbh,chr(13),''),chr(10),'') as sclxbh
    ,replace(replace(t.khh,chr(13),''),chr(10),'') as khh
    ,replace(replace(t.khmc,chr(13),''),chr(10),'') as khmc
    ,replace(replace(t.jydf,chr(13),''),chr(10),'') as jydf
    ,t.jyr as jyr
    ,t.dqr as dqr
    ,replace(replace(t.bz,chr(13),''),chr(10),'') as bz
    ,t.tzje as tzje
    ,t.qmye as qmye
    ,t.ylj as ylj
    ,t.nlj as nlj
    ,t.yqsyl as yqsyl
    ,replace(replace(t.jxfs,chr(13),''),chr(10),'') as jxfs
    ,replace(replace(t.tzlx,chr(13),''),chr(10),'') as tzlx
    ,replace(replace(t.khjg,chr(13),''),chr(10),'') as khjg
    ,replace(replace(t.ssfhhh,chr(13),''),chr(10),'') as ssfhhh
    ,replace(replace(t.ssfh,chr(13),''),chr(10),'') as ssfh
    ,t.tjrq as tjrq
    ,replace(replace(t.gxhslx,chr(13),''),chr(10),'') as gxhslx
    ,t.khdxdh as khdxdh
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.pams_jxdx_lxd t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_lxd.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes