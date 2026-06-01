: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_prd_prod_int_rat_info_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_prd_prod_int_rat_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.evt_cate_id as evt_cate_id
,t1.int_cls_cd as int_cls_cd
,t1.int_rat_type_cd as int_rat_type_cd
,t1.tax_category_cd as tax_category_cd
,t1.use_sub_acct_int_rat_flg as use_sub_acct_int_rat_flg
,t1.int_accr_way_cd as int_accr_way_cd
,t1.int_rat_file_way_cd as int_rat_file_way_cd
,t1.file_amt_type_cd as file_amt_type_cd
,t1.amt_file_dir_cd as amt_file_dir_cd
,t1.amt_file_way_cd as amt_file_way_cd
,t1.days_file_dir_cd as days_file_dir_cd
,t1.days_file_way_cd as days_file_way_cd
,t1.int_calc_amt_type_cd as int_calc_amt_type_cd
,t1.value_day_get_val_way_cd as value_day_get_val_way_cd
,t1.file_days_calc_way_cd as file_days_calc_way_cd
,t1.int_rat_start_use_way_cd as int_rat_start_use_way_cd
,t1.mon_int_accr_base_cd as mon_int_accr_base_cd
,t1.grouping_rule_rela_cd as grouping_rule_rela_cd
,t1.int_dtl_effect_way_cd as int_dtl_effect_way_cd
,t1.int_modif_way_cd as int_modif_way_cd
,t1.min_int_rat as min_int_rat
,t1.max_int_rat as max_int_rat
,t1.int_rat_modif_day as int_rat_modif_day
,t1.int_rat_modif_ped_cd as int_rat_modif_ped_cd
,t1.substr_flg as substr_flg
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.lp_id as lp_id
,t1.prod_id as prod_id

from ${idl_schema}.oass_prd_prod_int_rat_info_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_prd_prod_int_rat_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
