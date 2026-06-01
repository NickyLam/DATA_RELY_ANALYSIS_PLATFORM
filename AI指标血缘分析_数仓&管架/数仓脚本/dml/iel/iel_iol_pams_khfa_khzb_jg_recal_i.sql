: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_khfa_khzb_jg_recal_i
CreateDate: 20250822
FileName:   ${iel_data_path}/pams_khfa_khzb_jg_recal.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,khzbdh
,replace(replace(t1.khzbmc,chr(13),''),chr(10),'') as khzbmc
,zbdh
,replace(replace(t1.sdbs,chr(13),''),chr(10),'') as sdbs
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,replace(replace(t1.tjkj,chr(13),''),chr(10),'') as tjkj
,zbpx
,replace(replace(t1.ydsfzs,chr(13),''),chr(10),'') as ydsfzs
,replace(replace(t1.ydbm,chr(13),''),chr(10),'') as ydbm
,recal_dt

from ${iol_schema}.pams_khfa_khzb_jg_recal t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_khfa_khzb_jg_recal.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
