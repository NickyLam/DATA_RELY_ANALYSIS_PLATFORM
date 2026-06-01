: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_loan_acct_int_rat_modif_dtl_i
CreateDate: 20250102
FileName:   ${iel_data_path}/evt_loan_acct_int_rat_modif_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.int_cls_cd,chr(13),''),chr(10),'') as int_cls_cd
,effect_dt
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.new_int_rat_type_cd,chr(13),''),chr(10),'') as new_int_rat_type_cd
,new_int_rat_float_point
,new_exec_int_rat
,new_int_rat_float_ratio
,replace(replace(t1.new_int_rat_start_use_way_cd,chr(13),''),chr(10),'') as new_int_rat_start_use_way_cd
,replace(replace(t1.new_int_rat_effect_way_cd,chr(13),''),chr(10),'') as new_int_rat_effect_way_cd
,new_int_rat_modif_dt
,replace(replace(t1.new_int_rat_modif_ped,chr(13),''),chr(10),'') as new_int_rat_modif_ped
,replace(replace(t1.acct_aldy_check_flg,chr(13),''),chr(10),'') as acct_aldy_check_flg
,tran_dt
,replace(replace(t1.effect_flg,chr(13),''),chr(10),'') as effect_flg
,replace(replace(t1.acalc_flg,chr(13),''),chr(10),'') as acalc_flg
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.accrd_nomal_int_rat_float_flg,chr(13),''),chr(10),'') as accrd_nomal_int_rat_float_flg
,replace(replace(t1.precon_id,chr(13),''),chr(10),'') as precon_id
,new_exec_tax_rat
,tax_rat_float_point
,tax_rat_float_ratio
,replace(replace(t1.tax_info_flg,chr(13),''),chr(10),'') as tax_info_flg
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,tran_tm
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num

from ${iml_schema}.evt_loan_acct_int_rat_modif_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_loan_acct_int_rat_modif_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
