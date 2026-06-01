: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_stl_method_def_para_f
CreateDate: 20230512
FileName:   ${iel_data_path}/ref_stl_method_def_para.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.stl_method_cd,chr(13),''),chr(10),'') as stl_method_cd
,replace(replace(t1.acpt_pay_idf_cd,chr(13),''),chr(10),'') as acpt_pay_idf_cd
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.stl_method_descb,chr(13),''),chr(10),'') as stl_method_descb
,replace(replace(t1.stl_acct_type_cd,chr(13),''),chr(10),'') as stl_acct_type_cd

from ${iml_schema}.ref_stl_method_def_para t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_stl_method_def_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
