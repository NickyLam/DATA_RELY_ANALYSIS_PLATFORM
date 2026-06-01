: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_prd_prod_int_rat_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_prod_int_rat_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.evt_cate_id,chr(13),''),chr(10),'') as evt_cate_id
,replace(replace(t1.int_cls_cd,chr(13),''),chr(10),'') as int_cls_cd
,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd
,replace(replace(t1.tax_category_cd,chr(13),''),chr(10),'') as tax_category_cd
,replace(replace(t1.use_sub_acct_int_rat_flg,chr(13),''),chr(10),'') as use_sub_acct_int_rat_flg
,replace(replace(t1.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd
,replace(replace(t1.int_rat_file_way_cd,chr(13),''),chr(10),'') as int_rat_file_way_cd
,replace(replace(t1.file_amt_type_cd,chr(13),''),chr(10),'') as file_amt_type_cd
,replace(replace(t1.amt_file_dir_cd,chr(13),''),chr(10),'') as amt_file_dir_cd
,replace(replace(t1.amt_file_way_cd,chr(13),''),chr(10),'') as amt_file_way_cd
,replace(replace(t1.days_file_dir_cd,chr(13),''),chr(10),'') as days_file_dir_cd
,replace(replace(t1.days_file_way_cd,chr(13),''),chr(10),'') as days_file_way_cd
,replace(replace(t1.int_calc_amt_type_cd,chr(13),''),chr(10),'') as int_calc_amt_type_cd
,replace(replace(t1.value_day_get_val_way_cd,chr(13),''),chr(10),'') as value_day_get_val_way_cd
,replace(replace(t1.file_days_calc_way_cd,chr(13),''),chr(10),'') as file_days_calc_way_cd
,replace(replace(t1.int_rat_start_use_way_cd,chr(13),''),chr(10),'') as int_rat_start_use_way_cd
,replace(replace(t1.mon_int_accr_base_cd,chr(13),''),chr(10),'') as mon_int_accr_base_cd
,replace(replace(t1.grouping_rule_rela_cd,chr(13),''),chr(10),'') as grouping_rule_rela_cd
,replace(replace(t1.int_dtl_effect_way_cd,chr(13),''),chr(10),'') as int_dtl_effect_way_cd
,replace(replace(t1.int_modif_way_cd,chr(13),''),chr(10),'') as int_modif_way_cd
,t1.min_int_rat as min_int_rat
,t1.max_int_rat as max_int_rat
,t1.int_rat_modif_day as int_rat_modif_day
,replace(replace(t1.int_rat_modif_ped_cd,chr(13),''),chr(10),'') as int_rat_modif_ped_cd
,replace(replace(t1.substr_flg,chr(13),''),chr(10),'') as substr_flg
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.prd_prod_int_rat_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_prod_int_rat_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes