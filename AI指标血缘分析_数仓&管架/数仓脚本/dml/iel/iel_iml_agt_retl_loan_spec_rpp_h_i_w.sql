: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_retl_loan_spec_rpp_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_retl_loan_spec_rpp_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,t.perds as perds
,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t.customz_repay_kind_cd,chr(13),''),chr(10),'') as customz_repay_kind_cd
,t.repay_dt as repay_dt
,replace(replace(t.full_amt_adv_repay_flg,chr(13),''),chr(10),'') as full_amt_adv_repay_flg
,t.rpp_amt as rpp_amt
,replace(replace(t.acct_num_type_cd,chr(13),''),chr(10),'') as acct_num_type_cd
,replace(replace(t.repay_acct_id,chr(13),''),chr(10),'') as repay_acct_id
,replace(replace(t.proc_status_cd,chr(13),''),chr(10),'') as proc_status_cd
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.agt_retl_loan_spec_rpp_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_retl_loan_spec_rpp_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes