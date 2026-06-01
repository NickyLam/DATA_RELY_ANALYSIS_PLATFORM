: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_ifs_int_rat_para_f
CreateDate: 20230512
FileName:   ${iel_data_path}/ref_ifs_int_rat_para.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.int_rat_cate_cd,chr(13),''),chr(10),'') as int_rat_cate_cd
,replace(replace(t1.int_rat_tenor_cd,chr(13),''),chr(10),'') as int_rat_tenor_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,effect_dt
,invalid_dt
,replace(replace(t1.int_rat_status_cd,chr(13),''),chr(10),'') as int_rat_status_cd
,base_rat

from ${iml_schema}.ref_ifs_int_rat_para t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_ifs_int_rat_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
