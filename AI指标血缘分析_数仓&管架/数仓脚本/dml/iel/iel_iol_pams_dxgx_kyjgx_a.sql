: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_dxgx_kyjgx_a
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_dxgx_kyjgx.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.jxdxdh as jxdxdh
,t.khdxdh as khdxdh
,t.qsrq as qsrq
,t.jsrq as jsrq
,t.zlbl as zlbl
,replace(replace(t.gxly,chr(13),''),chr(10),'') as gxly
,t.yylsh as yylsh
,replace(replace(t.fpjs,chr(13),''),chr(10),'') as fpjs
from iol.pams_dxgx_kyjgx t
where 1=1 " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_dxgx_kyjgx.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes