: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ast_col_type_def_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_col_type_def_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.col_type_cd as col_type_cd
,t.col_type_name as col_type_name
,t.up_level_node_type_cd as up_level_node_type_cd
,t.lev as lev
,t.base_cate_flg as base_cate_flg
,t.spcl_info_type_cd as spcl_info_type_cd
,t.keyw_a as keyw_a
,t.effect_way_cd as effect_way_cd
,t.col_descb as col_descb
,t.status_descb as status_descb
,t.admit_cls as admit_cls
,t.modif_dt as modif_dt
,t.modif_org_id as modif_org_id
,t.data_type_cd as data_type_cd
,t.guar_admit_cls_cd as guar_admit_cls_cd
,t.modif_emply_id as modif_emply_id
,t.reval_freq_cd as reval_freq_cd
,t.higt_pm_rat as higt_pm_rat
,t.keyw_b as keyw_b
,t.gen_cd as gen_cd
,t.manu_idtfy_flg as manu_idtfy_flg
,t.tshold as tshold
,t.strip_line_cd as strip_line_cd
,t.ab_divd_cd as ab_divd_cd
,t.keyw_comb_use_flg as keyw_comb_use_flg
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.ast_col_type_def t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_type_def_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes