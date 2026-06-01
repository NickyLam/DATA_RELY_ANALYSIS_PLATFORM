: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_fin_am_subj_info_f
CreateDate: 20221013
FileName:   ${iel_data_path}/fin_am_subj_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.tepla_sob_id,chr(13),''),chr(10),'') as tepla_sob_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.subj_name,chr(13),''),chr(10),'') as subj_name
,replace(replace(t1.super_subj_id,chr(13),''),chr(10),'') as super_subj_id
,replace(replace(t1.bal_dir_cd,chr(13),''),chr(10),'') as bal_dir_cd
,replace(replace(t1.subj_level_cd,chr(13),''),chr(10),'') as subj_level_cd
,replace(replace(t1.accti_qtty_flg,chr(13),''),chr(10),'') as accti_qtty_flg
,replace(replace(t1.int_accr_flg,chr(13),''),chr(10),'') as int_accr_flg
,replace(replace(t1.allow_od_flg,chr(13),''),chr(10),'') as allow_od_flg
,replace(replace(t1.create_level4_subj_flg,chr(13),''),chr(10),'') as create_level4_subj_flg
,replace(replace(t1.subj_acct_type_cd,chr(13),''),chr(10),'') as subj_acct_type_cd
,replace(replace(t1.entry_org_id,chr(13),''),chr(10),'') as entry_org_id
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name

from ${iml_schema}.fin_am_subj_info t1
where 1=1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fin_am_subj_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
