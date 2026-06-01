: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_am_cashflow_calc_rule_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_am_cashflow_calc_rule_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.cashflow_id,chr(13),''),chr(10),'') as cashflow_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,t1.effect_dt as effect_dt 
,replace(replace(t1.accti_type_cd,chr(13),''),chr(10),'') as accti_type_cd 
,replace(replace(t1.base_type_cd,chr(13),''),chr(10),'') as base_type_cd 
,replace(replace(t1.base_dt_type_cd,chr(13),''),chr(10),'') as base_dt_type_cd 
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd 
,t1.int_rat as int_rat 
,replace(replace(t1.init_int_rat_flg,chr(13),''),chr(10),'') as init_int_rat_flg 
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id 
,replace(replace(t1.src_prod_id,chr(13),''),chr(10),'') as src_prod_id 
,t1.brch_seq_num as brch_seq_num 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.prd_am_cashflow_calc_rule_h t1 
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_am_cashflow_calc_rule_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes