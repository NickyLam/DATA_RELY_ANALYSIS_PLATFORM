: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_dep_prod_acct_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_dep_prod_acct_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_sign_id,chr(13),''),chr(10),'') as acct_sign_id
,replace(replace(t1.acct_dtl_id,chr(13),''),chr(10),'') as acct_dtl_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.fin_acct_id,chr(13),''),chr(10),'') as fin_acct_id
,replace(replace(t1.prod_acct_id,chr(13),''),chr(10),'') as prod_acct_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.pay_id,chr(13),''),chr(10),'') as pay_id
,replace(replace(t1.tran_chn_id,chr(13),''),chr(10),'') as tran_chn_id
,replace(replace(t1.call_sys_id,chr(13),''),chr(10),'') as call_sys_id
,replace(replace(t1.init_tran_dtl_id,chr(13),''),chr(10),'') as init_tran_dtl_id
,t1.dep_term as dep_term
,t1.exec_int_rat as exec_int_rat
,t1.tran_amt as tran_amt
,replace(replace(t1.acct_tran_type_cd,chr(13),''),chr(10),'') as acct_tran_type_cd
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,t1.tran_dt as tran_dt
,t1.acct_dt as acct_dt
,t1.effect_dt as effect_dt
,t1.invalid_dt as invalid_dt
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
from iml.agt_dep_prod_acct_dtl t1
where t1.etl_dt > add_months(to_date('${batch_date}','yyyymmdd') ,-3) and t1.etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_dep_prod_acct_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes