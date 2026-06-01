: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pcls_byte_vintage_cnt_info_f
CreateDate: 20250709
FileName:   ${iel_data_path}/pcls_byte_vintage_cnt_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.monthcreated2,chr(13),''),chr(10),'') as monthcreated2
,vintage3plus_mob1_cnt
,vintage3plus_mob2_cnt
,vintage3plus_mob3_cnt
,vintage7plus_mob1_cnt
,vintage7plus_mob2_cnt
,vintage7plus_mob3_cnt
,vintage30plus_mob1_cnt
,vintage30plus_mob2_cnt
,vintage30plus_mob3_cnt

from ${iol_schema}.pcls_byte_vintage_cnt_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pcls_byte_vintage_cnt_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
