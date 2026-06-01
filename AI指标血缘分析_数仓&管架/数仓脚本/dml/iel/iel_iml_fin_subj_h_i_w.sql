: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_fin_subj_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/fin_subj_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.subj_name,chr(13),''),chr(10),'') as subj_name
,t.subj_lev_cd as subj_lev_cd
,replace(replace(t.dtl_subj_flg,chr(13),''),chr(10),'') as dtl_subj_flg
,replace(replace(t.subj_dir_cd,chr(13),''),chr(10),'') as subj_dir_cd
,replace(replace(t.in_out_tab_flg,chr(13),''),chr(10),'') as in_out_tab_flg
,replace(replace(t.allow_od_flg,chr(13),''),chr(10),'') as allow_od_flg
,replace(replace(t.super_subj_id,chr(13),''),chr(10),'') as super_subj_id
,replace(replace(t.subj_char_cd,chr(13),''),chr(10),'') as subj_char_cd
,replace(replace(t.bal_char_cd,chr(13),''),chr(10),'') as bal_char_cd
,replace(replace(t.subj_src_cls_cd,chr(13),''),chr(10),'') as subj_src_cls_cd
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.fin_subj_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fin_subj_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes