: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ifrs_sf_vouchtype_lgd_f
CreateDate: 20250220
FileName:   ${iel_data_path}/ifrs_sf_vouchtype_lgd.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.v_vouchtype_cd,chr(13),''),chr(10),'') as v_vouchtype_cd
,lgd_basics
,replace(replace(t1.v_vouchtype_id,chr(13),''),chr(10),'') as v_vouchtype_id
,official_trial
,trial_active
,sid
,lgd_discount

from ${iol_schema}.ifrs_sf_vouchtype_lgd t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifrs_sf_vouchtype_lgd.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
