: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_curr_para_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_curr_para.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd 
,replace(replace(t1.curr_name,chr(13),''),chr(10),'') as curr_name 
,replace(replace(t1.curr_en_abbr,chr(13),''),chr(10),'') as curr_en_abbr 
,replace(replace(t1.curr_sign_cd,chr(13),''),chr(10),'') as curr_sign_cd 
,replace(replace(t1.start_use_flg,chr(13),''),chr(10),'') as start_use_flg 
,t1.create_dt as create_dt 
,t1.update_dt as update_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.ref_curr_para t1 
where create_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_curr_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes