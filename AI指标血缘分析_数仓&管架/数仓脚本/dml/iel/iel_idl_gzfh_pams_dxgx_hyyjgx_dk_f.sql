: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_gzfh_pams_dxgx_hyyjgx_dk_f
CreateDate: 20260202
FileName:   ${iel_data_path}/gzfh_pams_dxgx_hyyjgx_dk.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.tjrq as tjrq
,t1.jxdxdh as jxdxdh
,t1.khdxdh as khdxdh
,t1.fpjs as fpjs
,t1.gxhslx as gxhslx
,t1.yz as yz
,t1.clbl as clbl
,t1.gxly as gxly
,t1.yylsh as yylsh
,t1.zlbl as zlbl
,t1.gxzt as gxzt
,t1.jgmc as jgmc
,t1.jgdh as jgdh
,t1.zzh as zzh
,t1.jjh as jjh
,t1.hymc as hymc
,t1.hydh as hydh

from ${idl_schema}.gzfh_pams_dxgx_hyyjgx_dk t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/gzfh_pams_dxgx_hyyjgx_dk.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
