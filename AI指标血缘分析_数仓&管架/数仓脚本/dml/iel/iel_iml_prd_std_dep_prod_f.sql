: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_std_dep_prod_f
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_std_dep_prod.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name 
,replace(replace(t1.prod_route,chr(13),''),chr(10),'') as prod_route 
,replace(replace(t1.level1_cls_id,chr(13),''),chr(10),'') as level1_cls_id 
,replace(replace(t1.level2_cls_id,chr(13),''),chr(10),'') as level2_cls_id 
,replace(replace(t1.level3_cls_id,chr(13),''),chr(10),'') as level3_cls_id 
,replace(replace(t1.level4_cls_id,chr(13),''),chr(10),'') as level4_cls_id 
,replace(replace(t1.issue_status_cd,chr(13),''),chr(10),'') as issue_status_cd 
,replace(replace(t1.prod_sum,chr(13),''),chr(10),'') as prod_sum 
,replace(replace(t1.prod_status_cd,chr(13),''),chr(10),'') as prod_status_cd 
,t1.effect_dt as effect_dt 
,t1.invalid_dt as invalid_dt 
,replace(replace(t1.dep_tenor,chr(13),''),chr(10),'') as dep_tenor 
,replace(replace(t1.curr_cd_descb,chr(13),''),chr(10),'') as curr_cd_descb 
,replace(replace(t1.init_amt,chr(13),''),chr(10),'') as init_amt 
,replace(replace(t1.lowt_drawdown_amt,chr(13),''),chr(10),'') as lowt_drawdown_amt 
,replace(replace(t1.int_rat_is_fix_flg,chr(13),''),chr(10),'') as int_rat_is_fix_flg 
,replace(replace(t1.dep_int_rat_descb,chr(13),''),chr(10),'') as dep_int_rat_descb 
,replace(replace(t1.dep_int_accr_tenor_descb,chr(13),''),chr(10),'') as dep_int_accr_tenor_descb 
,replace(replace(t1.dep_int_accr_way_descb,chr(13),''),chr(10),'') as dep_int_accr_way_descb 
,replace(replace(t1.dep_int_set_way_descb,chr(13),''),chr(10),'') as dep_int_set_way_descb 
,replace(replace(t1.part_unexp_draw_flg,chr(13),''),chr(10),'') as part_unexp_draw_flg 
,replace(replace(t1.rc_flg,chr(13),''),chr(10),'') as rc_flg 
,replace(replace(t1.general_storage_flg,chr(13),''),chr(10),'') as general_storage_flg 
,replace(replace(t1.general_exch_flg,chr(13),''),chr(10),'') as general_exch_flg 
,t1.issue_dt as issue_dt 
,replace(replace(t1.mgmt_dept_name,chr(13),''),chr(10),'') as mgmt_dept_name 
,replace(replace(t1.map_rule,chr(13),''),chr(10),'') as map_rule 
,t1.create_dt as create_dt 
,t1.update_dt as update_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.prd_std_dep_prod t1 
where create_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_std_dep_prod.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes