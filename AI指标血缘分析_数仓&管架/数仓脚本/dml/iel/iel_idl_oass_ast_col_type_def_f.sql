: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_col_type_def_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ast_col_type_def.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.up_level_node_type_cd as up_level_node_type_cd
,t1.lev as lev
,t1.base_cate_flg as base_cate_flg
,t1.spcl_info_type_cd as spcl_info_type_cd
,t1.keyw_a as keyw_a
,t1.effect_way_cd as effect_way_cd
,t1.col_descb as col_descb
,t1.status_descb as status_descb
,t1.admit_cls as admit_cls
,t1.modif_dt as modif_dt
,t1.modif_org_id as modif_org_id
,t1.data_type_cd as data_type_cd
,t1.guar_admit_cls_cd as guar_admit_cls_cd
,t1.modif_emply_id as modif_emply_id
,t1.reval_freq_cd as reval_freq_cd
,t1.higt_pm_rat as higt_pm_rat
,t1.keyw_b as keyw_b
,t1.gen_cd as gen_cd
,t1.manu_idtfy_flg as manu_idtfy_flg
,t1.tshold as tshold
,t1.strip_line_cd as strip_line_cd
,t1.ab_divd_cd as ab_divd_cd
,t1.keyw_comb_use_flg as keyw_comb_use_flg
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.col_type_cd as col_type_cd
,t1.col_type_name as col_type_name

from ${idl_schema}.oass_ast_col_type_def t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_col_type_def.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
