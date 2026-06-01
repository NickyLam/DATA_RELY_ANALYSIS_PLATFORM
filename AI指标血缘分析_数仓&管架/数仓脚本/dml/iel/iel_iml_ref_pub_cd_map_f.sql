: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_pub_cd_map_f
CreateDate: 20221220
FileName:   ${iel_data_path}/ref_pub_cd_map.f.${batch_date}.dat
IF_mark:    f
Logs:
   sundexin
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.sorc_sys_cd,chr(13),''),chr(10),'') as sorc_sys_cd
    ,replace(replace(t.subj,chr(13),''),chr(10),'') as subj
    ,replace(replace(t.src_tab_en_name,chr(13),''),chr(10),'') as src_tab_en_name
    ,replace(replace(t.src_tab_cn_name,chr(13),''),chr(10),'') as src_tab_cn_name
    ,replace(replace(t.src_field_en_name,chr(13),''),chr(10),'') as src_field_en_name
    ,replace(replace(t.src_field_cn_name,chr(13),''),chr(10),'') as src_field_cn_name
    ,replace(replace(t.src_code_val,chr(13),''),chr(10),'') as src_code_val
    ,replace(replace(t.src_code_descb,chr(13),''),chr(10),'') as src_code_descb
    ,replace(replace(t.target_tab_en_name,chr(13),''),chr(10),'') as target_tab_en_name
    ,replace(replace(t.target_tab_cn_name,chr(13),''),chr(10),'') as target_tab_cn_name
    ,replace(replace(t.target_tab_field_en_name,chr(13),''),chr(10),'') as target_tab_field_en_name
    ,replace(replace(t.target_tab_field_cn_name,chr(13),''),chr(10),'') as target_tab_field_cn_name
    ,replace(replace(t.target_cd_tab_en_name,chr(13),''),chr(10),'') as target_cd_tab_en_name
    ,replace(replace(t.target_cd_tab_cn_name,chr(13),''),chr(10),'') as target_cd_tab_cn_name
    ,replace(replace(t.target_cd_val,chr(13),''),chr(10),'') as target_cd_val
    ,replace(replace(t.target_cd_descb,chr(13),''),chr(10),'') as target_cd_descb
    ,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
from iml.ref_pub_cd_map t
  where 1=1 " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_pub_cd_map.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes