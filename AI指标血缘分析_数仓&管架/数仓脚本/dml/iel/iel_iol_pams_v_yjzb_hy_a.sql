: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_v_yjzb_hy_a
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_v_yjzb_hy.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date(t1.tjrq,'yyyymmdd') as etl_dt 
,t1.tjrq as tjrq 
,t1.zbdh as zbdh 
,replace(replace(t1.sdbs,chr(13),''),chr(10),'') as sdbs 
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz 
,t1.khdxdh as khdxdh 
,t1.zbz as zbz 
from iol.pams_v_yjzb_hy t1 
where t1.tjrq >= '20201201' and t1.tjrq <= '${batch_date}'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_v_yjzb_hy.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes