: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_xtb_zhgxrz_kh_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_xtb_zhgxrz_kh.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.jldh as jldh
,t.jlsj as jlsj
,replace(replace(t.czlx,chr(13),''),chr(10),'') as czlx
,t.xgrdh as xgrdh
,t.jxdxdh as jxdxdh
from iol.pams_xtb_zhgxrz_kh t
where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_xtb_zhgxrz_kh.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes