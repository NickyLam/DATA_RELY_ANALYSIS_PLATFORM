: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_dc_subj_map_f
CreateDate: 20230512
FileName:   ${iel_data_path}/ref_dc_subj_map.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.core_bus_id,chr(13),''),chr(10),'') as core_bus_id
,replace(replace(t1.bal_dir_cd,chr(13),''),chr(10),'') as bal_dir_cd
,replace(replace(t1.bal_check_entry_flg,chr(13),''),chr(10),'') as bal_check_entry_flg
,replace(replace(t1.check_entry_flg,chr(13),''),chr(10),'') as check_entry_flg
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.entry_way_name,chr(13),''),chr(10),'') as entry_way_name
,replace(replace(t1.bus_dept_id,chr(13),''),chr(10),'') as bus_dept_id

from ${iml_schema}.ref_dc_subj_map t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_dc_subj_map.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
