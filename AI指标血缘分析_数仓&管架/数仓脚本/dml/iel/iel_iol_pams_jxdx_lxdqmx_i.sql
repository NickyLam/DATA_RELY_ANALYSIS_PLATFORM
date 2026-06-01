: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxdx_lxdqmx_i
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_jxdx_lxdqmx.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,t.jxdxdh as jxdxdh
    ,t.qsrq as qsrq
    ,t.jsrq as jsrq
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
from iol.pams_jxdx_lxdqmx t
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_lxdqmx.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes