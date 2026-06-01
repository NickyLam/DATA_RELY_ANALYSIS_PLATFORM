: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_cap_int_rat_makt_i
CreateDate: 20230512
FileName:   ${iel_data_path}/ref_cap_int_rat_makt.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.int_rat_id,chr(13),''),chr(10),'') as int_rat_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,int_rat
,start_dt
,end_dt

from ${iml_schema}.ref_cap_int_rat_makt t1
where start_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_cap_int_rat_makt.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
