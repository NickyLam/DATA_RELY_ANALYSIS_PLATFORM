: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_reval_cfg_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_reval_cfg_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.reval_cd,chr(13),''),chr(10),'') as reval_cd
    ,replace(replace(t.cfg_name,chr(13),''),chr(10),'') as cfg_name
    ,replace(replace(t.reval_way_cd,chr(13),''),chr(10),'') as reval_way_cd
    ,replace(replace(t.reval_ped_cd,chr(13),''),chr(10),'') as reval_ped_cd
    ,replace(replace(t.reval_intrv_type_cd,chr(13),''),chr(10),'') as reval_intrv_type_cd
    ,replace(replace(t.spec_reval_day_cd,chr(13),''),chr(10),'') as spec_reval_day_cd
    ,replace(replace(t.exec_int_rat_check_flg,chr(13),''),chr(10),'') as exec_int_rat_check_flg
    ,t.int_rat_check_precis as int_rat_check_precis
    ,t.comn_loan_reval_intrv_ped as comn_loan_reval_intrv_ped
    ,replace(replace(t.reval_day_type_cd,chr(13),''),chr(10),'') as reval_day_type_cd
    ,t.new_fix_nomal_int_rat as new_fix_nomal_int_rat
    ,t.new_fix_ovdue_int_rat as new_fix_ovdue_int_rat
    ,replace(replace(t.new_nomal_spd_way_cd,chr(13),''),chr(10),'') as new_nomal_spd_way_cd
    ,replace(replace(t.new_ovdue_spd_way_cd,chr(13),''),chr(10),'') as new_ovdue_spd_way_cd
    ,t.new_nomal_flo_val as new_nomal_flo_val
    ,t.new_ovdue_flo_val as new_ovdue_flo_val
    ,replace(replace(t.new_float_ped_cd,chr(13),''),chr(10),'') as new_float_ped_cd
    ,replace(replace(t.new_nomal_int_rat_level_cd,chr(13),''),chr(10),'') as new_nomal_int_rat_level_cd
    ,t.effect_dt as effect_dt
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.ref_reval_cfg_h t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_reval_cfg_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes