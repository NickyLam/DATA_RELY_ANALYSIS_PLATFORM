: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_amt_calc_type_def_para_f
CreateDate: 20230512
FileName:   ${iel_data_path}/ref_amt_calc_type_def_para.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.amt_calc_type_cd,chr(13),''),chr(10),'') as amt_calc_type_cd
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.amt_calc_type_descb,chr(13),''),chr(10),'') as amt_calc_type_descb
,replace(replace(t1.amt_type_cd,chr(13),''),chr(10),'') as amt_type_cd

from ${iml_schema}.ref_amt_calc_type_def_para t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_amt_calc_type_def_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
