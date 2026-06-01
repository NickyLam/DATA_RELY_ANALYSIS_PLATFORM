: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_ref_rg_holiday_para_f
CreateDate: 20231109
FileName:   ${iel_data_path}/ref_rg_holiday_para.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.holiday_type_cd,chr(13),''),chr(10),'') as holiday_type_cd
,replace(replace(t1.local_cty_rg_cd,chr(13),''),chr(10),'') as local_cty_rg_cd
,replace(replace(t1.local_prov_cd,chr(13),''),chr(10),'') as local_prov_cd
,holiday_dt
,replace(replace(t1.holiday_type_descb,chr(13),''),chr(10),'') as holiday_type_descb
,replace(replace(t1.wd_flg,chr(13),''),chr(10),'') as wd_flg
,replace(replace(t1.fit_range_cd,chr(13),''),chr(10),'') as fit_range_cd

from ${iml_schema}.ref_rg_holiday_para t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_rg_holiday_para.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
