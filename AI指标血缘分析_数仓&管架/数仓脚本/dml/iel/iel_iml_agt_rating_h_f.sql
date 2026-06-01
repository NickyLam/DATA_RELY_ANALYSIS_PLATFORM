: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_rating_h_f
CreateDate: 20230602
FileName:   ${iel_data_path}/agt_rating_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.rating_type_cd,chr(13),''),chr(10),'') as rating_type_cd
,replace(replace(t1.rating_result_cd,chr(13),''),chr(10),'') as rating_result_cd
,rating_dt

from ${iml_schema}.agt_rating_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd')-1 and end_dt > to_date('${batch_date}','yyyymmdd')-1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_rating_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
