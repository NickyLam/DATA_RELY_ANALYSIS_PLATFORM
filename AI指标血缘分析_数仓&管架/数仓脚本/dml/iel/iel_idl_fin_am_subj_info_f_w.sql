: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_fin_am_subj_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/fin_am_subj_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.tepla_sob_id as tepla_sob_id
,t.lp_id as lp_id
,t.subj_id as subj_id
,t.subj_name as subj_name
,t.super_subj_id as super_subj_id
,t.bal_dir_cd as bal_dir_cd
,t.subj_level_cd as subj_level_cd
,t.accti_qtty_flg as accti_qtty_flg
,t.int_accr_flg as int_accr_flg
,t.allow_od_flg as allow_od_flg
,t.create_level4_subj_flg as create_level4_subj_flg
,t.subj_acct_type_cd as subj_acct_type_cd
,t.entry_org_id as entry_org_id
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
from ${idl_schema}.fin_am_subj_info t 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fin_am_subj_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes