: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_guar_qual_idtfy_f
CreateDate: 20230525
FileName:   ${iel_data_path}/ast_guar_qual_idtfy.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.guar_cont_id,chr(13),''),chr(10),'') as guar_cont_id
,replace(replace(t1.asset_and_brwer_pc_flg,chr(13),''),chr(10),'') as asset_and_brwer_pc_flg
,replace(replace(t1.guar_impt_flg,chr(13),''),chr(10),'') as guar_impt_flg
,replace(replace(t1.guar_rela_cd,chr(13),''),chr(10),'') as guar_rela_cd
,replace(replace(t1.guar_rela_rest_cd,chr(13),''),chr(10),'') as guar_rela_rest_cd
,replace(replace(t1.wt_md_guar_cls_qual_flg,chr(13),''),chr(10),'') as wt_md_guar_cls_qual_flg
,replace(replace(t1.wt_md_dr_tool_qual_flg,chr(13),''),chr(10),'') as wt_md_dr_tool_qual_flg
,replace(replace(t1.wt_md_qual_dr_tool_cate_cd,chr(13),''),chr(10),'') as wt_md_qual_dr_tool_cate_cd
,replace(replace(t1.np_guar_cls_qual_flg,chr(13),''),chr(10),'') as np_guar_cls_qual_flg
,replace(replace(t1.np_qual_dr_tool_flg,chr(13),''),chr(10),'') as np_qual_dr_tool_flg
,replace(replace(t1.np_qual_dr_tool_cate_cd,chr(13),''),chr(10),'') as np_qual_dr_tool_cate_cd
,guar_amt
,mtg_rat
,replace(replace(t1.guar_guar_form_cd,chr(13),''),chr(10),'') as guar_guar_form_cd
,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,create_dt
,update_dt

from ${iml_schema}.ast_guar_qual_idtfy t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_guar_qual_idtfy.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
