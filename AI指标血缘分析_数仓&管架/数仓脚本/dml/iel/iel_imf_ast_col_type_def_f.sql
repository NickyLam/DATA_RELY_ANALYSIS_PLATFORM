: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_ast_col_type_def_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_col_type_def.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.col_type_cd,chr(13),''),chr(10),'') as col_type_cd
,replace(replace(t1.col_type_name,chr(13),''),chr(10),'') as col_type_name
,replace(replace(t1.up_level_node_type_cd,chr(13),''),chr(10),'') as up_level_node_type_cd
,t1.lev as lev
,replace(replace(t1.base_cate_flg,chr(13),''),chr(10),'') as base_cate_flg
,replace(replace(t1.spcl_info_type_cd,chr(13),''),chr(10),'') as spcl_info_type_cd
,replace(replace(t1.keyw_a,chr(13),''),chr(10),'') as keyw_a
,replace(replace(t1.effect_way_cd,chr(13),''),chr(10),'') as effect_way_cd
,replace(replace(t1.col_descb,chr(13),''),chr(10),'') as col_descb
,replace(replace(t1.status_descb,chr(13),''),chr(10),'') as status_descb
,replace(replace(t1.admit_cls,chr(13),''),chr(10),'') as admit_cls
,t1.modif_dt as modif_dt
,replace(replace(t1.modif_org_id,chr(13),''),chr(10),'') as modif_org_id
,replace(replace(t1.data_type_cd,chr(13),''),chr(10),'') as data_type_cd
,replace(replace(t1.guar_admit_cls_cd,chr(13),''),chr(10),'') as guar_admit_cls_cd
,replace(replace(t1.modif_emply_id,chr(13),''),chr(10),'') as modif_emply_id
,replace(replace(t1.reval_freq_cd,chr(13),''),chr(10),'') as reval_freq_cd
,t1.higt_pm_rat as higt_pm_rat
,replace(replace(t1.keyw_b,chr(13),''),chr(10),'') as keyw_b
,replace(replace(t1.gen_cd,chr(13),''),chr(10),'') as gen_cd
,replace(replace(t1.manu_idtfy_flg,chr(13),''),chr(10),'') as manu_idtfy_flg
,t1.tshold as tshold
,replace(replace(t1.strip_line_cd,chr(13),''),chr(10),'') as strip_line_cd
,replace(replace(t1.ab_divd_cd,chr(13),''),chr(10),'') as ab_divd_cd
,replace(replace(t1.keyw_comb_use_flg,chr(13),''),chr(10),'') as keyw_comb_use_flg
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.ast_col_type_def t1
where create_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_type_def.f.${batch_date}.dat" \
        charset=utf8
        safe=yes