: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_col_guar_cont_rela_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_col_guar_cont_rela.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.col_id,chr(13),''),chr(10),'') as col_id
,replace(replace(t1.guar_cont_id,chr(13),''),chr(10),'') as guar_cont_id
,replace(replace(t1.col_brwer_pc_flg,chr(13),''),chr(10),'') as col_brwer_pc_flg
,replace(replace(t1.guar_impt_flg,chr(13),''),chr(10),'') as guar_impt_flg
,replace(replace(t1.guar_rela_cd,chr(13),''),chr(10),'') as guar_rela_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.guar_amt as guar_amt
,t1.mtg_rat as mtg_rat
,replace(replace(t1.guar_form_cd,chr(13),''),chr(10),'') as guar_form_cd
,replace(replace(t1.guar_kind_cd,chr(13),''),chr(10),'') as guar_kind_cd
,replace(replace(t1.main_col_flg,chr(13),''),chr(10),'') as main_col_flg
from ${icl_schema}.cmm_col_guar_cont_rela t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_col_guar_cont_rela.f.${batch_date}.dat" \
        charset=utf8
        safe=yes