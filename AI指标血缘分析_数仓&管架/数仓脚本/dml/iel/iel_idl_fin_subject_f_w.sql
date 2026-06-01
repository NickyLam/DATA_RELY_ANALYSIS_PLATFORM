: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_fin_subject_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/fin_subject_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.subject_id as subject_id
,t.lp_id as lp_id
,t.subj_name as subj_name
,t.super_subject_id as super_subject_id
,t.subj_type_cd as subj_type_cd
,t.subj_lev_cd as subj_lev_cd
,t.subj_char_cd as subj_char_cd
,t.effect_flg as effect_flg
,t.dtl_subj_flg as dtl_subj_flg
,t.subj_dir_cd as subj_dir_cd
,t.in_out_tab_flg as in_out_tab_flg
,t.allow_od_flg as allow_od_flg
,t.bal_char_cd as bal_char_cd
,t.subj_src_cls_cd as subj_src_cls_cd
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
from ${idl_schema}.fin_subject t 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fin_subject_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes