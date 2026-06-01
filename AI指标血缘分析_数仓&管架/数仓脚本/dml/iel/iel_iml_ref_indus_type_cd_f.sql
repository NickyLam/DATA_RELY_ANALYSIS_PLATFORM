: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_indus_type_cd_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_indus_type_cd.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.indus_type_cd,chr(13),''),chr(10),'') as indus_type_cd
,replace(replace(t1.indus_type_name,chr(13),''),chr(10),'') as indus_type_name
,replace(replace(t1.indus_cate_cd,chr(13),''),chr(10),'') as indus_cate_cd
,replace(replace(t1.indus_cate_name,chr(13),''),chr(10),'') as indus_cate_name
,replace(replace(t1.indus_gen_cd,chr(13),''),chr(10),'') as indus_gen_cd
,replace(replace(t1.indus_gen_name,chr(13),''),chr(10),'') as indus_gen_name
,replace(replace(t1.indus_categy_cd,chr(13),''),chr(10),'') as indus_categy_cd
,replace(replace(t1.indus_categy_name,chr(13),''),chr(10),'') as indus_categy_name
,replace(replace(t1.valid_flg,chr(13),''),chr(10),'') as valid_flg
,t1.invalid_dt as invalid_dt
from ${iml_schema}.ref_indus_type_cd t1
where 1=1;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_indus_type_cd.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes