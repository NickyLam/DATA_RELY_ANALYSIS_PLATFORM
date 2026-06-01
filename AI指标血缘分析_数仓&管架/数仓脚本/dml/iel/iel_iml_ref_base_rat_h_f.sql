: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_base_rat_h_f
CreateDate: 20240127
FileName:   ${iel_data_path}/ref_base_rat_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.base_rat_id,chr(13),''),chr(10),'') as base_rat_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,effect_dt
,base_rat

from ${iml_schema}.ref_base_rat_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_base_rat_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
