: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rsts_rcd_ir_points_pool_input_a
CreateDate: 20240717
FileName:   ${iel_data_path}/rsts_rcd_ir_points_pool_input.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.key_id,chr(13),''),chr(10),'') as key_id
,replace(replace(t1.loan_no,chr(13),''),chr(10),'') as loan_no
,replace(replace(t1.var0001,chr(13),''),chr(10),'') as var0001
,var0308
,replace(replace(t1.a_grade,chr(13),''),chr(10),'') as a_grade
,replace(replace(t1.bc_grade,chr(13),''),chr(10),'') as bc_grade
,replace(replace(t1.overdue_flag,chr(13),''),chr(10),'') as overdue_flag
,var0202
,var0430
,var0407
,replace(replace(t1.valid_gender_cd,chr(13),''),chr(10),'') as valid_gender_cd
,replace(replace(t1.default_flag,chr(13),''),chr(10),'') as default_flag
,var0309
,var0305
,var0002
,age
,replace(replace(t1.ghb_emp_flg,chr(13),''),chr(10),'') as ghb_emp_flg
,replace(replace(t1.grade_key_id,chr(13),''),chr(10),'') as grade_key_id
,replace(replace(t1.data_dt,chr(13),''),chr(10),'') as data_dt
,replace(replace(t1.pool_type,chr(13),''),chr(10),'') as pool_type
,replace(replace(t1.mode_type,chr(13),''),chr(10),'') as mode_type
,loan_total_bal
,pdsum
,replace(replace(t1.loan_biz_type_cd,chr(13),''),chr(10),'') as loan_biz_type_cd
,replace(replace(t1.loan_assis_flag,chr(13),''),chr(10),'') as loan_assis_flag
,replace(replace(t1.distr_dt,chr(13),''),chr(10),'') as distr_dt
,replace(replace(t1.bond_item_status_cd,chr(13),''),chr(10),'') as bond_item_status_cd
,replace(replace(t1.level5_class_cd,chr(13),''),chr(10),'') as level5_class_cd
,replace(replace(t1.ovdue_days,chr(13),''),chr(10),'') as ovdue_days
,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd
,replace(replace(t1.birth_dt,chr(13),''),chr(10),'') as birth_dt
,replace(replace(t1.edu_degree_cd,chr(13),''),chr(10),'') as edu_degree_cd
,replace(replace(t1.corp_char_cd,chr(13),''),chr(10),'') as corp_char_cd
,replace(replace(t1.resdnt_situ_cd,chr(13),''),chr(10),'') as resdnt_situ_cd
,replace(replace(t1.marriage_status_cd,chr(13),''),chr(10),'') as marriage_status_cd
,indv_mon_in
,replace(replace(t1.loan_biz_type,chr(13),''),chr(10),'') as loan_biz_type
,replace(replace(t1.valid_flg,chr(13),''),chr(10),'') as valid_flg
,replace(replace(t1.loan_biz_type_flag,chr(13),''),chr(10),'') as loan_biz_type_flag
,replace(replace(t1.loan_biz_type_name,chr(13),''),chr(10),'') as loan_biz_type_name
,replace(replace(t1.serial_no,chr(13),''),chr(10),'') as serial_no

from ${iol_schema}.rsts_rcd_ir_points_pool_input t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rsts_rcd_ir_points_pool_input.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
