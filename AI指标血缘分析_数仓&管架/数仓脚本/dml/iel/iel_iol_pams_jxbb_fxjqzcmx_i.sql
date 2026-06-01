: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_fxjqzcmx_i
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_jxbb_fxjqzcmx.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
     to_date('${batch_date}','yyyymmdd') as etl_dt
    ,t.tjrq as tjrq
    ,t.khdxdh as khdxdh
    ,replace(replace(t.jgdh,chr(13),''),chr(10),'') as jgdh
    ,replace(replace(t.jgmc,chr(13),''),chr(10),'') as jgmc
    ,replace(replace(t.zbdh,chr(13),''),chr(10),'') as zbdh
    ,replace(replace(t.zbmc,chr(13),''),chr(10),'') as zbmc
    ,t.fxjqzcje as fxjqzcje
 from iol.pams_jxbb_fxjqzcmx t
where tjrq= '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_fxjqzcmx.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes