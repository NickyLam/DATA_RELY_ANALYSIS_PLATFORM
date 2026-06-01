: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_yjzb_jg_recal_i
CreateDate: 20250711
FileName:   ${iel_data_path}/pams_yjzb_jg_recal.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,recal_dt
,zbdh
,replace(replace(t1.sdbs,chr(13),''),chr(10),'') as sdbs
,replace(replace(t1.tjkj,chr(13),''),chr(10),'') as tjkj
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,khdxdh
,zbz

from ${iol_schema}.pams_yjzb_jg_recal t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_yjzb_jg_recal.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
