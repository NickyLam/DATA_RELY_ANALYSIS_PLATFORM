: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_fin_subj_info_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_fin_subj_info_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.subj_id as subj_id
,t1.super_subj_id as super_subj_id
,t1.subj_name as subj_name
,t1.subj_level_cd as subj_level_cd
,t1.subj_type_cd as subj_type_cd
,t1.subj_attr_cd as subj_attr_cd
,t1.end_level_subj_flg as end_level_subj_flg
,t1.subj_bal_dir_cd as subj_bal_dir_cd
,t1.subj_status_cd as subj_status_cd
,t1.lmt_subj_flg as lmt_subj_flg
,t1.allow_od_flg as allow_od_flg
,t1.curr_char_proj_cd as curr_char_proj_cd
,t1.setup_acct_type_cd as setup_acct_type_cd
,t1.subj_belong_cd as subj_belong_cd
,t1.in_bs_flg as in_bs_flg
,t1.manual_open_acct_proc_mode_cd as manual_open_acct_proc_mode_cd
,t1.start_use_dt as start_use_dt
,t1.stop_use_dt as stop_use_dt
,t1.subj_use_sys_cd as subj_use_sys_cd
,t1.subj_amt_dir_cd as subj_amt_dir_cd
,t1.price_tax_sept_cd as price_tax_sept_cd
,t1.subj_bal_float_warn_flg as subj_bal_float_warn_flg
,t1.cnter_manual_entry_start_dt as cnter_manual_entry_start_dt
,t1.cnter_manual_entry_end_dt as cnter_manual_entry_end_dt
,t1.accti_midgrod_manual_entry_start_dt as accti_midgrod_manual_entry_start_dt
,t1.accti_midgrod_manual_entry_end_dt as accti_midgrod_manual_entry_end_dt
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.sob_id as sob_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_fin_subj_info_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_fin_subj_info_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
