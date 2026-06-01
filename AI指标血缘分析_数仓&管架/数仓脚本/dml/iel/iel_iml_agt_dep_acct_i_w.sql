: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_dep_acct_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_dep_acct_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t.ec_flg,chr(13),''),chr(10),'') as ec_flg
,replace(replace(t.accti_cd,chr(13),''),chr(10),'') as accti_cd
,replace(replace(t.sav_type_cd,chr(13),''),chr(10),'') as sav_type_cd
,replace(replace(t.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
,replace(replace(t.int_accr_flg,chr(13),''),chr(10),'') as int_accr_flg
,replace(replace(t.int_accr_method_cd,chr(13),''),chr(10),'') as int_accr_method_cd
,replace(replace(t.open_acct_chn_cd,chr(13),''),chr(10),'') as open_acct_chn_cd
,replace(replace(t.general_exch_flg_cd,chr(13),''),chr(10),'') as general_exch_flg_cd
,t.open_acct_dt as open_acct_dt
,t.value_dt as value_dt
,t.clos_acct_dt as clos_acct_dt
,t.accum_dt as accum_dt
,replace(replace(t.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t.stop_pay_status_cd,chr(13),''),chr(10),'') as stop_pay_status_cd
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t.lowt_bal as lowt_bal
,t.exec_int_rat as exec_int_rat
,replace(replace(t.sleep_acct_flg,chr(13),''),chr(10),'') as sleep_acct_flg
,replace(replace(t.dormt_acct_flg,chr(13),''),chr(10),'') as dormt_acct_flg
,replace(replace(t.acct_usage_cd,chr(13),''),chr(10),'') as acct_usage_cd
,t.final_activ_dt as final_activ_dt
,t.final_tran_dt as final_tran_dt
,replace(replace(t.final_tran_flow_num,chr(13),''),chr(10),'') as final_tran_flow_num
,replace(replace(t.open_acct_flow_num,chr(13),''),chr(10),'') as open_acct_flow_num
,replace(replace(t.clos_acct_flow_num,chr(13),''),chr(10),'') as clos_acct_flow_num
,replace(replace(t.acct_kind_cd,chr(13),''),chr(10),'') as acct_kind_cd
,replace(replace(t.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,t.expe_higt_yld_rat as expe_higt_yld_rat
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.agt_dep_acct t 
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_dep_acct_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes