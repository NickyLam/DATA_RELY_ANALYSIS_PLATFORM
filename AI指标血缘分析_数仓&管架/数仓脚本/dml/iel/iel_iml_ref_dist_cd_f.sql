: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_dist_cd_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_dist_cd.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.rg_cd,chr(13),''),chr(10),'') as rg_cd
,replace(replace(t1.rg_name,chr(13),''),chr(10),'') as rg_name
,replace(replace(t1.city_cd,chr(13),''),chr(10),'') as city_cd
,replace(replace(t1.city_name,chr(13),''),chr(10),'') as city_name
,replace(replace(t1.prov_cd,chr(13),''),chr(10),'') as prov_cd
,replace(replace(t1.prov_name,chr(13),''),chr(10),'') as prov_name
,replace(replace(t1.base_std_flg,chr(13),''),chr(10),'') as base_std_flg
,replace(replace(t1.std_id,chr(13),''),chr(10),'') as std_id
,replace(replace(t1.four_rg_cd,chr(13),''),chr(10),'') as four_rg_cd
,replace(replace(t1.pbc_rg_cd,chr(13),''),chr(10),'') as pbc_rg_cd
,replace(replace(t1.valid_flg,chr(13),''),chr(10),'') as valid_flg
,t1.invalid_dt as invalid_dt
from ${iml_schema}.ref_dist_cd t1
where 1=1;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_dist_cd.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes