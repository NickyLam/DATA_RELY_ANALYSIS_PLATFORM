: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_rg_cd_para_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_rg_cd_para.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.rg_cd,chr(13),''),chr(10),'') as rg_cd
,replace(replace(t1.rg_cd_type,chr(13),''),chr(10),'') as rg_cd_type
,replace(replace(t1.prov,chr(13),''),chr(10),'') as prov
,replace(replace(t1.city,chr(13),''),chr(10),'') as city
,replace(replace(t1.county,chr(13),''),chr(10),'') as county
,replace(replace(t1.addr,chr(13),''),chr(10),'') as addr
,replace(replace(t1.rela_rg_cd_1,chr(13),''),chr(10),'') as rela_rg_cd_1
,replace(replace(t1.rela_rg_cd_type_1,chr(13),''),chr(10),'') as rela_rg_cd_type_1
,replace(replace(t1.rela_rg_cd_2,chr(13),''),chr(10),'') as rela_rg_cd_2
,replace(replace(t1.rela_rg_cd_type_2,chr(13),''),chr(10),'') as rela_rg_cd_type_2
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.ref_rg_cd_para t1
where create_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_rg_cd_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes