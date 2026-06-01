: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_dxgx_hyyjgx_kh_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_dxgx_hyyjgx_kh.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.jxdxdh as jxdxdh
,t.khdxdh as khdxdh
,replace(replace(t.fpjs,chr(13),''),chr(10),'') as fpjs
,t.qsrq as qsrq
,t.jsrq as jsrq
,replace(replace(t.gxhslx,chr(13),''),chr(10),'') as gxhslx
,t.yz as yz
,t.clbl as clbl
,t.zlbl as zlbl
,replace(replace(t.gxly,chr(13),''),chr(10),'') as gxly
,t.yylsh as yylsh
,replace(replace(t.gxzt,chr(13),''),chr(10),'') as gxzt
from iol.pams_dxgx_hyyjgx_kh t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_dxgx_hyyjgx_kh.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes