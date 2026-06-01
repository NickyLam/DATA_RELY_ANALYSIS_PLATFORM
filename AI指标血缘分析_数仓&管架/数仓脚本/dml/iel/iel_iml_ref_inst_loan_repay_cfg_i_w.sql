: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_inst_loan_repay_cfg_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_inst_loan_repay_cfg_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.cfg_cd,chr(13),''),chr(10),'') as cfg_cd
,replace(replace(t.cfg_name,chr(13),''),chr(10),'') as cfg_name
,replace(replace(t.amort_mode_cd,chr(13),''),chr(10),'') as amort_mode_cd
,t.repay_intrv_freq as repay_intrv_freq
,replace(replace(t.repay_intrv_freq_coef_cd,chr(13),''),chr(10),'') as repay_intrv_freq_coef_cd
,replace(replace(t.repay_day_type_cd,chr(13),''),chr(10),'') as repay_day_type_cd
,t.spec_repay_day as spec_repay_day
,replace(replace(t.repay_plan_proc_indi_cd,chr(13),''),chr(10),'') as repay_plan_proc_indi_cd
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.ref_inst_loan_repay_cfg t 
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_inst_loan_repay_cfg_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes