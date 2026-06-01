: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_subj_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_subj_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.subj_name,chr(13),''),chr(10),'') as subj_name
,replace(replace(t1.super_subj_id,chr(13),''),chr(10),'') as super_subj_id
,replace(replace(t1.super_subj_name,chr(13),''),chr(10),'') as super_subj_name
,replace(replace(t1.subj_lev_cd,chr(13),''),chr(10),'') as subj_lev_cd
,replace(replace(t1.subj_char_cd,chr(13),''),chr(10),'') as subj_char_cd
,replace(replace(t1.subj_bal_dir_cd,chr(13),''),chr(10),'') as subj_bal_dir_cd
,replace(replace(t1.subj_src_cls_cd,chr(13),''),chr(10),'') as subj_src_cls_cd
,replace(replace(t1.trdpty_ctrl_acct_type_cd,chr(13),''),chr(10),'') as trdpty_ctrl_acct_type_cd
,replace(replace(t1.dtl_subj_flg,chr(13),''),chr(10),'') as dtl_subj_flg
,replace(replace(t1.in_out_tab_flg,chr(13),''),chr(10),'') as in_out_tab_flg
,replace(replace(t1.allow_od_flg,chr(13),''),chr(10),'') as allow_od_flg
,replace(replace(t1.allow_budget_flg,chr(13),''),chr(10),'') as allow_budget_flg
,replace(replace(t1.allow_post_flg,chr(13),''),chr(10),'') as allow_post_flg
,replace(replace(t1.adj_flg,chr(13),''),chr(10),'') as adj_flg
,replace(replace(t1.subj_status_cd,chr(13),''),chr(10),'') as subj_status_cd
,t1.effect_dt as effect_dt
,t1.invalid_dt as invalid_dt
from ${icl_schema}.cmm_subj_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_subj_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes