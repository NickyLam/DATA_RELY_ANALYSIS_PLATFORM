: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_addit_prod_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_addit_prod_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.ta_cd,chr(13),''),chr(10),'') as ta_cd
    ,replace(replace(t.main_prod_id,chr(13),''),chr(10),'') as main_prod_id
    ,replace(replace(t.addit_prod_name,chr(13),''),chr(10),'') as addit_prod_name
    ,replace(replace(t.insu_comp_addit_prod_id,chr(13),''),chr(10),'') as insu_comp_addit_prod_id
    ,replace(replace(t.permium_calc_corp_type_cd,chr(13),''),chr(10),'') as permium_calc_corp_type_cd
    ,t.create_dt as create_dt
    ,t.update_dt as update_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.prd_addit_prod_info t
  where t.create_dt <= to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_addit_prod_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes