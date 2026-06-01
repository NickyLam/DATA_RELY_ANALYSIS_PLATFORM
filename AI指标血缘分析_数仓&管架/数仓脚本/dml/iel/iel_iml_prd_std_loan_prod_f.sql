: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_std_loan_prod_f
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_std_loan_prod.f.${batch_date}.dat
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
,replace(replace(t1.seltbl_guar_way_descb,chr(13),''),chr(10),'') as seltbl_guar_way_descb 
,replace(replace(t1.seltbl_curr_cd_descb,chr(13),''),chr(10),'') as seltbl_curr_cd_descb 
,replace(replace(t1.is_circl_loan_flg,chr(13),''),chr(10),'') as is_circl_loan_flg 
,replace(replace(t1.is_allow_loan_renew_flg,chr(13),''),chr(10),'') as is_allow_loan_renew_flg 
,t1.renew_max_cnt as renew_max_cnt 
,replace(replace(t1.min_distr_amt,chr(13),''),chr(10),'') as min_distr_amt 
,replace(replace(t1.max_distr_amt,chr(13),''),chr(10),'') as max_distr_amt 
,replace(replace(t1.tenor_corp_descb,chr(13),''),chr(10),'') as tenor_corp_descb 
,replace(replace(t1.shortest_loan_tenor_descb,chr(13),''),chr(10),'') as shortest_loan_tenor_descb 
,replace(replace(t1.lont_loan_tenor_descb,chr(13),''),chr(10),'') as lont_loan_tenor_descb 
,replace(replace(t1.int_rat_adj_way_descb,chr(13),''),chr(10),'') as int_rat_adj_way_descb 
,replace(replace(t1.seltbl_repay_way_descb,chr(13),''),chr(10),'') as seltbl_repay_way_descb 
,replace(replace(t1.int_rat,chr(13),''),chr(10),'') as int_rat 
,replace(replace(t1.grace_period,chr(13),''),chr(10),'') as grace_period 
,replace(replace(t1.nomal_int_rat_float_way,chr(13),''),chr(10),'') as nomal_int_rat_float_way 
,replace(replace(t1.nomal_int_rat_fl_rt,chr(13),''),chr(10),'') as nomal_int_rat_fl_rt 
,replace(replace(t1.ovdue_int_rat_float_way,chr(13),''),chr(10),'') as ovdue_int_rat_float_way 
,replace(replace(t1.ovdue_int_rat_fl_rt,chr(13),''),chr(10),'') as ovdue_int_rat_fl_rt 
,replace(replace(t1.loan_usage_descb,chr(13),''),chr(10),'') as loan_usage_descb 
,replace(replace(t1.mgmt_dept_name,chr(13),''),chr(10),'') as mgmt_dept_name 
,replace(replace(t1.map_rule,chr(13),''),chr(10),'') as map_rule 
,t1.create_dt as create_dt 
,t1.update_dt as update_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.prd_std_loan_prod t1 
where create_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_std_loan_prod.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes