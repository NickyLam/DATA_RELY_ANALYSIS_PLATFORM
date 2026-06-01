: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_pcrs_agt_loan_rollover_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_pcrs_agt_loan_rollover_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,t1.etl_dt as etl_dt
,replace(replace(t1.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
,replace(replace(t1.rollover_flg,chr(13),''),chr(10),'') as rollover_flg
,t1.rollover_cnt as rollover_cnt
,t1.rollover_dt as rollover_dt
,t1.rollover_due_dt as rollover_due_dt
,t1.rollover_amt as rollover_amt
,replace(replace(t1.loan_rollover_id,chr(13),''),chr(10),'') as loan_rollover_id
,t1.ori_rate as ori_rate
,t1.rollover_rate as rollover_rate
,replace(replace(t1.ori_contr_num,chr(13),''),chr(10),'') as ori_contr_num
,replace(replace(t1.ori_dbill_num,chr(13),''),chr(10),'') as ori_dbill_num
,replace(replace(t1.oper_emply_id,chr(13),''),chr(10),'') as oper_emply_id
,replace(replace(t1.auth_emply_id,chr(13),''),chr(10),'') as auth_emply_id
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
from ${idl_schema}.hdws_dul_d_pcrs_agt_loan_rollover_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_pcrs_agt_loan_rollover_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes