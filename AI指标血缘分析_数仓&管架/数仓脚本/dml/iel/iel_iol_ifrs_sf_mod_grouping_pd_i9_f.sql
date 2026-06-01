: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ifrs_sf_mod_grouping_pd_i9_f
CreateDate: 20230904
FileName:   ${iel_data_path}/ifrs_sf_mod_grouping_pd_i9.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.pd_internal_review,chr(13),''),chr(10),'') as pd_internal_review
,replace(replace(t1.pd_internal_review_code,chr(13),''),chr(10),'') as pd_internal_review_code
,replace(replace(t1.i9_mod_grouping,chr(13),''),chr(10),'') as i9_mod_grouping
,status
,replace(replace(t1.pd_internal_review_id,chr(13),''),chr(10),'') as pd_internal_review_id

from ${iol_schema}.ifrs_sf_mod_grouping_pd_i9 t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifrs_sf_mod_grouping_pd_i9.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
