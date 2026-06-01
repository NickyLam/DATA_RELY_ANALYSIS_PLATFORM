: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_city_cd_para_f
CreateDate: 20230512
FileName:   ${iel_data_path}/ref_city_cd_para.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.belong_cty_rg_cd,chr(13),''),chr(10),'') as belong_cty_rg_cd
,replace(replace(t1.belong_prov_cd,chr(13),''),chr(10),'') as belong_prov_cd
,replace(replace(t1.city_cd,chr(13),''),chr(10),'') as city_cd
,replace(replace(t1.city_name,chr(13),''),chr(10),'') as city_name
,replace(replace(t1.super_city_cd,chr(13),''),chr(10),'') as super_city_cd
,replace(replace(t1.tel_zone_cd,chr(13),''),chr(10),'') as tel_zone_cd
,replace(replace(t1.zip_code,chr(13),''),chr(10),'') as zip_code

from ${iml_schema}.ref_city_cd_para t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_city_cd_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
