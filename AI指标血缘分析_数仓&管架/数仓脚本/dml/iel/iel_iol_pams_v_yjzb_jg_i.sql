: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_v_yjzb_jg_i
CreateDate: 20250620
FileName:   ${iel_data_path}/pams_v_yjzb_jg.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,zbdh
,replace(replace(t1.sdbs,chr(13),''),chr(10),'') as sdbs
,replace(replace(t1.tjkj,chr(13),''),chr(10),'') as tjkj
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,khdxdh
,zbz
,replace(replace(t1.zblxbz,chr(13),''),chr(10),'') as zblxbz
,yszbdh

from ${iol_schema}.pams_v_yjzb_jg t1
where t1.tjrq = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_v_yjzb_jg.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
