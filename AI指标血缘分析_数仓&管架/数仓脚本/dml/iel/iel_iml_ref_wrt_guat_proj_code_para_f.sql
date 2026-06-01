: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_wrt_guat_proj_code_para_f
CreateDate: 20230512
FileName:   ${iel_data_path}/ref_wrt_guat_proj_code_para.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.wrt_guat_proj_code,chr(13),''),chr(10),'') as wrt_guat_proj_code
,replace(replace(t1.bal_pay_type_cd,chr(13),''),chr(10),'') as bal_pay_type_cd
,replace(replace(t1.wrt_guat_proj_code_descb,chr(13),''),chr(10),'') as wrt_guat_proj_code_descb

from ${iml_schema}.ref_wrt_guat_proj_code_para t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_wrt_guat_proj_code_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
