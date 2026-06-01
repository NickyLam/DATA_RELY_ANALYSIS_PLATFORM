: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_xtb_zhgxjl_kh_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_xtb_zhgxjl_kh.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.jldh as jldh
,replace(replace(t.ggbz,chr(13),''),chr(10),'') as ggbz
,t.khdxdh as khdxdh
,replace(replace(t.fpjs,chr(13),''),chr(10),'') as fpjs
,t.qsrq as qsrq
,t.jsrq as jsrq
,replace(replace(t.gxhslx,chr(13),''),chr(10),'') as gxhslx
,t.clje as clje
,t.clbl as clbl
,t.zlbl as zlbl
from iol.pams_xtb_zhgxjl_kh t
where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_xtb_zhgxjl_kh.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes