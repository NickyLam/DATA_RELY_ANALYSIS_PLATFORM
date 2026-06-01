: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_yqzlqykhmx_i
CreateDate: 20251127
FileName:   ${iel_data_path}/pams_jxbb_yqzlqykhmx.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.qyqdmc,chr(13),''),chr(10),'') as qyqdmc
,replace(replace(t1.qyzh,chr(13),''),chr(10),'') as qyzh
,qyrq
,replace(replace(t1.qyjg,chr(13),''),chr(10),'') as qyjg
,replace(replace(t1.qygy,chr(13),''),chr(10),'') as qygy
,replace(replace(t1.qyzt,chr(13),''),chr(10),'') as qyzt

from ${iol_schema}.pams_jxbb_yqzlqykhmx t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_yqzlqykhmx.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
