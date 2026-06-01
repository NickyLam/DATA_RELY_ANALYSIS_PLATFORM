: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ifrs_sf_one_year_parameter_f
CreateDate: 20250220
FileName:   ${iel_data_path}/ifrs_sf_one_year_parameter.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.v_i9_mod_grouping,chr(13),''),chr(10),'') as v_i9_mod_grouping
,replace(replace(t1.v_internal_rating,chr(13),''),chr(10),'') as v_internal_rating
,v_pessimism
,v_standard
,v_optimistic
,replace(replace(t1.v_year_parameter_id,chr(13),''),chr(10),'') as v_year_parameter_id
,official_trial
,trial_active
,sid
,addweightpd

from ${iol_schema}.ifrs_sf_one_year_parameter t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifrs_sf_one_year_parameter.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
