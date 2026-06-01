: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_acct_int_accr_cfg_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_loan_acct_int_accr_cfg_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.int_cls_cd,chr(13),''),chr(10),'') as int_cls_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd
,bank_int_int_rat
,int_rat_float_point
,int_rat_float_ratio
,float_int_rat
,sub_acct_int_rat_float_point
,sub_acct_int_rat_float_ratio
,sub_acct_fix_int_rat
,higt_exec_int_rat
,lowt_exec_int_rat
,replace(replace(t1.accrd_nomal_int_rat_float_flg,chr(13),''),chr(10),'') as accrd_nomal_int_rat_float_flg
,exec_int_rat
,replace(replace(t1.int_set_freq_cd,chr(13),''),chr(10),'') as int_set_freq_cd
,replace(replace(t1.int_set_day,chr(13),''),chr(10),'') as int_set_day
,replace(replace(t1.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd
,replace(replace(t1.year_int_accr_base_cd,chr(13),''),chr(10),'') as year_int_accr_base_cd
,replace(replace(t1.mon_int_accr_base_cd,chr(13),''),chr(10),'') as mon_int_accr_base_cd
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
,replace(replace(t1.int_accr_flg,chr(13),''),chr(10),'') as int_accr_flg
,replace(replace(t1.cap_flg,chr(13),''),chr(10),'') as cap_flg
,replace(replace(t1.int_set_flg,chr(13),''),chr(10),'') as int_set_flg
,replace(replace(t1.acalc_flg,chr(13),''),chr(10),'') as acalc_flg
,replace(replace(t1.int_rat_start_use_way_cd,chr(13),''),chr(10),'') as int_rat_start_use_way_cd
,replace(replace(t1.int_rat_effect_way_cd,chr(13),''),chr(10),'') as int_rat_effect_way_cd
,replace(replace(t1.int_rat_modif_ped_cd,chr(13),''),chr(10),'') as int_rat_modif_ped_cd
,int_rat_chg_dt
,int_rat_modif_day
,next_int_rat_modif_dt
,last_int_rat_modif_dt
,replace(replace(t1.exec_int_rat_chg_flg,chr(13),''),chr(10),'') as exec_int_rat_chg_flg
,replace(replace(t1.tax_category_cd,chr(13),''),chr(10),'') as tax_category_cd
,tax_rat
,replace(replace(t1.pnlt_int_rat_use_way_cd,chr(13),''),chr(10),'') as pnlt_int_rat_use_way_cd
,int_provi_day
,int_provi_ped
,replace(replace(t1.agt_chg_way_cd,chr(13),''),chr(10),'') as agt_chg_way_cd
,agt_fix_int_rat
,agt_float_ratio
,agt_float_point
,sub_acct_fix_tax_rat
,sub_acct_tax_rat_float_point
,sub_acct_tax_rat_float_ratio
,replace(replace(t1.exch_rat_float_cate_cd,chr(13),''),chr(10),'') as exch_rat_float_cate_cd
,replace(replace(t1.int_rat_day_type_cd,chr(13),''),chr(10),'') as int_rat_day_type_cd
,replace(replace(t1.acrs_ped_flg,chr(13),''),chr(10),'') as acrs_ped_flg

from ${iml_schema}.agt_loan_acct_int_accr_cfg_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_acct_int_accr_cfg_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
